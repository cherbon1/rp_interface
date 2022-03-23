from typing import Union

from rp_interface.modules.pll_module import PLLModule
from rp_interface.modules.sum_module import SumModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaTopLevelModule
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.utils import DataType


class PLLController(RedPitayaTopLevelModule):
    '''
    Defines the top level interface with a red pitaya running pll_controller.bit

    This interface is composed of the following modules:
        - Four pll_modules
        - Two summing_stage_modules

    and top-level controls:
        - two output_selects to select one of 8 outputs, described below


    output select options:
        - 0 -> input 0
        - 1 -> input 1
        - 2 -> pll 0
        - 3 -> pll 1
        - 4 -> pll 2
        - 5 -> pll 3
        - 6 -> sum 0
        - 7 -> sum 1
    '''
    # Bitfile is a class attribute that will override the abstract class bitfile property
    bitfile = Bitfile('pll_controller.bit')

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, load_bitfile=load_bitfile, apply_defaults=False)

        self.default_values = {
            'output0_select': 0,
            'output1_select': 1,
        }

        # gpio addresses
        self._top_module_gpio_write_address = '0x41200000'
        self._top_module_gpio_read_address = '0x41200008'
        self._pll0_gpio_write_address = '0x41210000'
        self._pll0_gpio_read_address = '0x41210008'
        self._pll1_gpio_write_address = '0x41220000'
        self._pll1_gpio_read_address = '0x41220008'
        self._pll2_gpio_write_address = '0x41230000'
        self._pll2_gpio_read_address = '0x41230008'
        self._pll3_gpio_write_address = '0x41240000'
        self._pll3_gpio_read_address = '0x41240008'

        self.fs = 31.25e6

        self._define_register_locations()
        self._define_controls()
        self._define_modules(apply_defaults=apply_defaults)

        # define top level properties
        property_definitions = {
            'output0_select': ('_output0_select_control', 'value'),
            'output1_select': ('_output1_select_control', 'value'),
        }
        self._define_properties(property_definitions)

        if apply_defaults:
            self.apply_defaults()

    def _define_register_locations(self):
        '''
        A method that defines all register addresses needed here.
        Called in __init__, but separated out for readability
        '''
        # =======================================
        # ====== DEFINE REGISTER LOCATIONS ======
        # =======================================
        self._output0_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=0,
            n_bits=3
        )

        self._output1_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=1,
            n_bits=3
        )

        self._sum0_add_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=2,
            n_bits=8
        )

        self._sum1_add_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=3,
            n_bits=8
        )

        self._sum0_divide_by_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=4,
            n_bits=3
        )

        self._sum1_divide_by_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=5,
            n_bits=3
        )

    def _define_controls(self):
        '''
        A method that defines all controls required here
        Called in __init__, but separated out for readability
        '''
        self.output_select_names = {
            0: 'In 0',
            1: 'In 1',
            2: 'PLL 0',
            3: 'PLL 1',
            4: 'PLL 2',
            5: 'PLL 3',
            6: 'Sum 0',
            7: 'SUm 1'
        }
        self._output0_select_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._output0_select_register,
            name='Output 0 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

        self._output1_select_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._output1_select_register,
            name='Output 1 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

    def _define_modules(self, apply_defaults=False):
        sum_input_names = {
            0: 'In0',
            1: 'In1',
            2: 'PLL0',
            3: 'PLL1',
            4: 'PLL2',
            5: 'PLL3',
        }
        self.sum0 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum0_add_select_register,
            divide_by_register=self._sum0_divide_by_register,
            apply_defaults=apply_defaults,
            adder_width=6,
            input_names=sum_input_names
        )

        self.sum1 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum1_add_select_register,
            divide_by_register=self._sum1_divide_by_register,
            apply_defaults=apply_defaults,
            adder_width=6,
            input_names=sum_input_names
        )

        self.pll0 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll0_gpio_write_address,
            gpio_read_address=self._pll0_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.pll1 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll1_gpio_write_address,
            gpio_read_address=self._pll1_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.pll2 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll2_gpio_write_address,
            gpio_read_address=self._pll2_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.pll3 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll3_gpio_write_address,
            gpio_read_address=self._pll3_gpio_read_address,
            apply_defaults=apply_defaults
        )

    def __str__(self):
        output_sel_no0 = self._output0_select_control.value
        output_sel_no1 = self._output1_select_control.value
        # Define strings
        return ("PLL controller\n"
                "  Output 0: {output0_select_name} ({output0_select_number})\n"
                "  Output 1: {output1_select_name} ({output1_select_number})\n"
                "  4x pll, 2x sum").format(
            output0_select_name=self.output_select_names[output_sel_no0],
            output0_select_number=output_sel_no0,
            output1_select_name=self.output_select_names[output_sel_no1],
            output1_select_number=output_sel_no1
        )

    def __repr__(self):
        return self.__str__()


if __name__ == "__main__":
    pc = PLLController('red-pitaya-21.ee.ethz.ch', load_bitfile=True, apply_defaults=False)
    print(pc)
    pc.pll0.kp = 1
    pc.pll0.ki = -0.5
    pc.pll0.a = 1
    pc.pll0.phi = -180
    pc.pll0.demodulator_bandwidth = 10e3
    pc.pll0.PID_bandwidth = 10e3
    print(pc.pll0.demodulator_bandwidth)
    print(pc.pll0._amplitude_phase_module)
    print(pc.pll0)

    pc.sum0.add0 = True
    pc.sum0.add2 = True
    pc.sum0.divide_by = 2
    print(pc.sum0)
