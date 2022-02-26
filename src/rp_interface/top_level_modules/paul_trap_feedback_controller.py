from typing import Union, Dict

from rp_interface.modules.aom_control_module import AOMControlModule
from rp_interface.modules.delay_filter_module import DelayFilterModule
from rp_interface.modules.sum_module import SumModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaTopLevelModule
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.utils import DataType


class PaulTrapFeedbackController(RedPitayaTopLevelModule):
    '''
    Defines the top level interface with a red pitaya running paul_trap_feedback_controller.bit

    This interface is composed of the following modules:
        - An aom_control_module
        - Four delay_filter_modules
        - Two summing_stage_modules

    and top-level controls:
        - trigger_now() to launch a toggling sequence
        - trigger_delay to control the delay between trigger command and GPIO trigger pulse
        - two output_mux's to select one of 8 outputs, described below
        - A constant output (in range -1 to 1)


    output mux options:
        - 0 -> input 0
        - 1 -> input 1
        - 2 -> aom_control_output
        - 3 -> sum_stage_0 output
        - 4 -> sum_stage_1 output
        - 5 -> filter_0 output
        - 6 -> GPIO trigger pulse
        - 7 -> constant
    '''
    bitfile = Bitfile('paul_trap_feedback_controller.bit')

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 default_values: Dict = None,
                 apply_defaults: bool = False,
                 load_bitfile: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, default_values=default_values, apply_defaults=False)

        if default_values is None:
            default_values = {}
        default_values.update({
            'feedback_gain': 0.1,
            'trap_enable': False,
            'feedback_enable': False
        })

        # gpio addresses
        self._top_module_gpio_write_address = '0x41200000'
        self._top_module_gpio_read_address = '0x41200008'
        self._aom_control_gpio_write_address = '0x41200000'
        self._aom_control_gpio_read_address = '0x41200008'
        self._delay_filter0_gpio_write_address = '0x41210000'
        self._delay_filter0_gpio_read_address = '0x41210008'
        self._delay_filter1_gpio_write_address = '0x41220000'
        self._delay_filter1_gpio_read_address = '0x41220008'
        self._delay_filter2_gpio_write_address = '0x41200000' # '0x41230000'
        self._delay_filter2_gpio_read_address = '0x41200008' # '0x41230008'
        self._delay_filter3_gpio_write_address = '0x41210000' # '0x41240000'
        self._delay_filter3_gpio_read_address = '0x41210008' # '0x41240008'

        self.fs = 125e6

        self._define_register_locations()
        self._define_controls()

        # define top level properties
        property_definitions = {
            'trigger_delay': ('_trigger_delay_control', 'value'),
            'output0_mux': ('_output0_mux_control', 'value'),
            'output1_mux': ('_output1_mux_control', 'value'),
            'constant': ('_constant_control', 'value'),
        }
        self._define_properties(property_definitions)

        # define rest of modules
        self._define_sum_modules()
        self.aom_control = AOMControlModule(
            red_pitaya=self.rp,
            gpio_write_address=self._aom_control_gpio_write_address,
            gpio_read_address=self._aom_control_gpio_read_address,
        )
        self.delay_filter0 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter0_gpio_write_address,
            gpio_read_address=self._delay_filter0_gpio_read_address,
        )
        self.delay_filter1 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter1_gpio_write_address,
            gpio_read_address=self._delay_filter1_gpio_read_address,
        )
        self.delay_filter2 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter2_gpio_write_address,
            gpio_read_address=self._delay_filter2_gpio_read_address,
        )
        self.delay_filter3 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter3_gpio_write_address,
            gpio_read_address=self._delay_filter3_gpio_read_address,
        )

        if load_bitfile:
            self.load_bitfile()

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
        self._trigger_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=20,
            n_bits=1
        )

        self._trigger_delay_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=19,
            n_bits=26
        )

        self._output0_mux_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=17,
            n_bits=3
        )

        self._output1_mux_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=18,
            n_bits=3
        )

        self._constant_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=12,
            n_bits=14
        )

        self._sum0_add_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=13,
            n_bits=4
        )

        self._sum1_add_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=14,
            n_bits=4
        )

        self._sum0_divide_by_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=15,
            n_bits=2
        )

        self._sum1_divide_by_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=16,
            n_bits=2
        )

    def _define_controls(self):
        '''
        A method that defines all controls required here
        Called in __init__, but separated out for readability
        '''
        self._trigger_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._trigger_register,
            name='Trigger control',
            dtype=DataType.BOOL,
        )

        self._trigger_delay_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._trigger_delay_register,
            name='Trigger delay',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 0.5368709),
            write_data=lambda val: int(val * self.fs),
            read_data=lambda reg: reg / self.fs,
        )

        self._output0_mux_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._output0_mux_register,
            name='Output 0 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

        self._output1_mux_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._output1_mux_register,
            name='Output 1 select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7)
        )

        self._constant_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._constant_register,
            name='Constant',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2 ** (self._constant_register.n_bits - 1) - 1e-4),  # offset avoids overfl.
            read_data=lambda reg: reg / 2 ** (self._constant_register.n_bits - 1),
        )

    def _define_sum_modules(self):
        self.sum_module_0 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum0_add_select_register,
            divide_by_register=self._sum0_divide_by_register,
        )

        self.sum_module_1 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum1_add_select_register,
            divide_by_register=self._sum1_divide_by_register,
        )

    def trigger_now(self):
        self._trigger_control.value = False
        self._trigger_control.value = True
        self._trigger_control.value = False

    def __str__(self):
        # Define strings
        ptfb_str = "Output mux 0: {output_mux_0}, Output mux 1: {output_mux_1}".format(
            output_mux_0=self._output0_mux_control.value,
            output_mux_1=self._output1_mux_control.value
        )
        aom_control_str = "AOM Control:\n" + self.aom_control.__str__()
        delay_filter_0_str = "Delay filter 0:\n" + self.delay_filter0.__str__()
        delay_filter_1_str = "Delay filter 1:\n" + self.delay_filter1.__str__()
        delay_filter_2_str = "Delay filter 2:\n" + self.delay_filter2.__str__()
        delay_filter_3_str = "Delay filter 3:\n" + self.delay_filter3.__str__()
        sum_0_str = "Sum 0: " + self.sum_module_0.__str__()
        sum_1_str = "Sum 1: " + self.sum_module_1.__str__()

        # Indent relevant strings
        indent = '  '
        aom_control_str = aom_control_str.replace('\n', '\n' + indent)
        delay_filter_0_str = delay_filter_0_str.replace('\n', '\n' + indent)
        delay_filter_1_str = delay_filter_1_str.replace('\n', '\n' + indent)
        delay_filter_2_str = delay_filter_2_str.replace('\n', '\n' + indent)
        delay_filter_3_str = delay_filter_3_str.replace('\n', '\n' + indent)

        # return output separated by newlines:
        return "\n".join([
            ptfb_str,
            aom_control_str,
            delay_filter_0_str,
            # delay_filter_1_str,
            # delay_filter_2_str,
            # delay_filter_3_str,
            sum_0_str,
            sum_1_str
        ])


if __name__ == "__main__":
    ptfb = PaulTrapFeedbackController('red-pitaya-18.ee.ethz.ch')
    ptfb.delay_filter0.input_mux = 1
    print(ptfb)

