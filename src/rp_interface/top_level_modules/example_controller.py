from typing import Union

from rp_interface.modules.gain_module import GainModule
from rp_interface.modules.sum_module import SumModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaTopLevelModule
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.utils import DataType


class ExampleController(RedPitayaTopLevelModule):
    '''
    Defines the top level interface with a red pitaya running example_project.bit

    This interface is composed of the following modules:
        - Two summing modules

    And the following top level controls
        - One input mux
        - One gain block
        - An output multiplexer


    output select options:
        - 0 -> input 0
        - 1 -> input 1
        - 2 -> sum 0
        - 3 -> sum 1
        - 4 -> n.c.
        - 5 -> n.c.
        - 6 -> n.c.
        - 7 -> n.c.

    sum input options:
        - 0 -> input 0
        - 1 -> input 1
        - 2 -> gain block output
    '''
    # Bitfile is a class attribute that will override the abstract class bitfile property
    bitfile = Bitfile('example_project.bit')
    _parameters = {
            'output0_select': '_output0_select_parameter.value',
            'output1_select': '_output1_select_parameter.value',
            'input_select': '_input_select_parameter.value',
            'gain': '_gain_module.gain',
        }
    _submodules = [
        'sum0',
        'sum1',
    ]

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False,
                 make_gui: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, load_bitfile=load_bitfile, apply_defaults=False)

        self.fs = 125e6

        self._define_register_locations()
        self._define_parameters()
        self._define_modules()

        self.defaults_file = 'example_controller_defaults.yaml'
        if apply_defaults:
            self.apply_defaults()

        self.gui_config_file = 'example_controller_gui_config.yaml'
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
        self._gpio_write_address = '0x41200000'
        self._gpio_read_address = '0x41200008'

        # =======================================
        # ====== DEFINE REGISTER LOCATIONS ======
        # =======================================
        self._input_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=0,
            n_bits=1
        )

        self._output0_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=1,
            n_bits=3
        )

        self._output1_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=2,
            n_bits=3
        )

        self._sum0_add_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=3,
            n_bits=8
        )

        self._sum1_add_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=4,
            n_bits=8
        )

        self._sum0_divide_by_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=5,
            n_bits=3
        )

        self._sum1_divide_by_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=6,
            n_bits=3
        )

        self._fine_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=7,
            n_bits=25
        )

        self._coarse_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=8,
            n_bits=4
        )

    def _define_parameters(self):
        '''
        A method that defines all controls required here
        Called in __init__, but separated out for readability
        '''
        self.input_select_names = {
            0: 'In 0',
            1: 'In 1',
        }
        self._input_select_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._input_select_register,
            name='Input select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1)
        )

        self.output_select_names = {
            0: 'In 0',
            1: 'In 1',
            2: 'Sum 0',
            3: 'Sum 1',
            4: 'N.C.',
            5: 'N.C.',
            6: 'N.C.',
            7: 'N.C.'
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

    def _define_modules(self):
        sum_input_names = {
            0: 'In0',
            1: 'In1',
            2: 'Gain block output',
            3: 'N.C.',
            4: 'N.C.',
            5: 'N.C.',
            6: 'N.C.',
            7: 'N.C.',
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

        self._gain_module = GainModule(
            red_pitaya=self.rp,
            fine_gain_register=self._fine_gain_register,
            coarse_gain_register=self._coarse_gain_register
        )


if __name__ == "__main__":
    pass
    # example = ExampleController(
    #     'red-pitaya-00.ee.ethz.ch',
    #     load_bitfile=True,
    #     apply_defaults=True,
    #     make_gui=True
    # )
    # example.show_gui()
    #
    # # Uncomment to define fresh defaults and configuration files
    # example.save_settings('../config/example_controller_defaults.yaml')
    # from rp_interface.gui_utils import generate_rp_module_gui_config_file
    # generate_rp_module_gui_config_file('../config/example_controller_gui_config.yaml', 'Example Red Pitaya', example)