from typing import Union

from rp_interface.modules.pll_module import PLLModule
from rp_interface.modules.sum_module import SumModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile
from rp_interface.red_pitaya_parameter import RedPitayaParameter
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
    _parameters = {
            'output0_select': '_output0_select_parameter.value',
            'output1_select': '_output1_select_parameter.value',
            'constant0': '_constant0_parameter.value',
            'constant1': '_constant1_parameter.value',
        }
    _submodules = [
        'sum0',
        'sum1',
        'pll0',
        'pll1',
        'pll2',
        'pll3',
    ]

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False,
                 make_gui: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, load_bitfile=load_bitfile, apply_defaults=False)

        self.fs = 31.25e6

        self._define_register_locations()
        self._define_parameters()
        self._define_modules()

        self.defaults_file = 'pll_controller_defaults.yaml'
        if apply_defaults:
            self.apply_defaults()

        self.gui_config_file = 'pll_controller_gui_config.yaml'
        if make_gui:
            self._make_gui()

    def _define_register_locations(self):
        '''
        A method that defines all register addresses needed here.
        Called in __init__, but separated out for readability
        '''
        # =======================================
        # ========== DEFINE ADDRESSES ===========
        # =======================================
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

        self._constant0_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=6,
            n_bits=14
        )

        self._constant1_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=7,
            n_bits=14
        )

    def _define_parameters(self):
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
            7: 'Sum 1'
        }
        self._output0_select_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._output0_select_register,
            name='Output 0 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

        self._output1_select_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._output1_select_register,
            name='Output 1 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

        self._constant0_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._constant0_register,
            name='Constant 0',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2**(self._constant0_register.n_bits-1) - 1e-9),  # offset avoids overflow
            read_data=lambda reg: reg / 2**(self._constant0_register.n_bits-1),
        )

        self._constant1_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._constant1_register,
            name='Constant 1',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2**(self._constant1_register.n_bits-1) - 1e-9),  # offset avoids overflow
            read_data=lambda reg: reg / 2**(self._constant1_register.n_bits-1),
        )

    def _define_modules(self):
        sum_input_names = {
            0: 'In0',
            1: 'In1',
            2: 'PLL0',
            3: 'PLL1',
            4: 'PLL2',
            5: 'PLL3',
            6: 'constant0',
            7: 'constant1',
        }
        self.sum0 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum0_add_select_register,
            divide_by_register=self._sum0_divide_by_register,
            adder_width=8,
            input_names=sum_input_names
        )

        self.sum1 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum1_add_select_register,
            divide_by_register=self._sum1_divide_by_register,
            adder_width=8,
            input_names=sum_input_names
        )

        self.pll0 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll0_gpio_write_address,
            gpio_read_address=self._pll0_gpio_read_address,
        )

        self.pll1 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll1_gpio_write_address,
            gpio_read_address=self._pll1_gpio_read_address,
        )

        self.pll2 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll2_gpio_write_address,
            gpio_read_address=self._pll2_gpio_read_address,
        )

        self.pll3 = PLLModule(
            red_pitaya=self.rp,
            gpio_write_address=self._pll3_gpio_write_address,
            gpio_read_address=self._pll3_gpio_read_address,
        )

    def __str__(self):
        output_sel_no0 = self._output0_select_parameter.value
        output_sel_no1 = self._output1_select_parameter.value
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
    pc = PLLController('red-pitaya-00.ee.ethz.ch',
                       load_bitfile=False,
                       apply_defaults=False,
                       make_gui=True)

    pc.show_gui()


    # print(pc)
    # pc.pll0.kp = 1
    # pc.pll0.ki = -0.5
    # pc.pll0.a = 1
    # pc.pll0.phi = -180
    # pc.pll0.demodulator_bandwidth = 10e3
    # pc.pll0.PID_bandwidth = 10e3
    #
    # print(pc.pll0)
    # print(pc.pll1)
    #
    # pc.pll1.copy_settings(pc.pll0)
    #
    # print(pc.pll0)
    # print(pc.pll1)
    #
    # pc.sum0.add0 = True
    # pc.sum0.add2 = True
    # pc.sum0.divide_by = 2
    # print(pc.sum0)
