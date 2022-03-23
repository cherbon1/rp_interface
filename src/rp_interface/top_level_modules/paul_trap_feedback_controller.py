from typing import Union

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
        - two output_selects to select one of 8 outputs, described below
        - A constant output (in range -1 to 1)


    output select options:
        - 0 -> input 0
        - 1 -> input 1
        - 2 -> aom_control_output
        - 3 -> sum_stage_0 output
        - 4 -> sum_stage_1 output
        - 5 -> filter_0 output
        - 6 -> GPIO trigger pulse
        - 7 -> constant
    '''
    # Bitfile is a class attribute that will override the abstract class bitfile property
    bitfile = Bitfile('paul_trap_feedback_controller.bit')

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, load_bitfile=load_bitfile, apply_defaults=False)

        self.default_values = {
            'output0_select': 0,
            'output1_select': 1,
            'trigger_mode': 0  # default to local trigger
        }

        # gpio addresses
        self._top_module_gpio_write_address = '0x41200000'
        self._top_module_gpio_read_address = '0x41200008'
        self._aom_control_gpio_write_address = '0x41200000'
        self._aom_control_gpio_read_address = '0x41200008'
        self._delay_filter0_gpio_write_address = '0x41210000'
        self._delay_filter0_gpio_read_address = '0x41210008'
        self._delay_filter1_gpio_write_address = '0x41220000'
        self._delay_filter1_gpio_read_address = '0x41220008'
        self._delay_filter2_gpio_write_address = '0x41230000'
        self._delay_filter2_gpio_read_address = '0x41230008'
        self._delay_filter3_gpio_write_address = '0x41240000'
        self._delay_filter3_gpio_read_address = '0x41240008'

        self.fs = 125e6

        self._define_register_locations()
        self._define_controls()
        self._define_modules(apply_defaults=apply_defaults)

        # define top level properties
        property_definitions = {
            'trigger_delay': ('_trigger_delay_control', 'value'),
            'output0_select': ('_output0_select_control', 'value'),
            'output1_select': ('_output1_select_control', 'value'),
            'constant': ('_constant_control', 'value'),
            'trigger_mode': ('_trigger_mode_control', 'value')
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
        self._trigger_mode_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=21,
            n_bits=1
        )

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

        self._output0_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=17,
            n_bits=3
        )

        self._output1_select_register = MuxedRegister(
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

        # 0 for local, 1 for external
        self._trigger_mode_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._trigger_mode_register,
            name='Trigger mode',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1)
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

        self.output_select_names = {
            0: 'In 0',
            1: 'In 1',
            2: 'AOM control',
            3: 'Sum 0',
            4: 'Sum 1',
            5: 'Filter 0',
            6: 'Trigger out',
            7: 'Constant'
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

        self._constant_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._constant_register,
            name='Constant',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2 ** (self._constant_register.n_bits - 1) - 1e-9),  # offset avoids overfl.
            read_data=lambda reg: reg / 2 ** (self._constant_register.n_bits - 1),
        )

    def _define_modules(self, apply_defaults=False):
        sum_input_names = {0: f'delay_filter{i}' for i in range(4)}
        self.sum0 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum0_add_select_register,
            divide_by_register=self._sum0_divide_by_register,
            apply_defaults=apply_defaults,
            adder_width=4,
            input_names=sum_input_names
        )

        self.sum1 = SumModule(
            red_pitaya=self.rp,
            add_select_register=self._sum1_add_select_register,
            divide_by_register=self._sum1_divide_by_register,
            apply_defaults=apply_defaults,
            adder_width=4,
            input_names=sum_input_names
        )

        self.aom_control = AOMControlModule(
            red_pitaya=self.rp,
            gpio_write_address=self._aom_control_gpio_write_address,
            gpio_read_address=self._aom_control_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.delay_filter0 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter0_gpio_write_address,
            gpio_read_address=self._delay_filter0_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.delay_filter1 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter1_gpio_write_address,
            gpio_read_address=self._delay_filter1_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.delay_filter2 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter2_gpio_write_address,
            gpio_read_address=self._delay_filter2_gpio_read_address,
            apply_defaults=apply_defaults
        )

        self.delay_filter3 = DelayFilterModule(
            red_pitaya=self.rp,
            gpio_write_address=self._delay_filter3_gpio_write_address,
            gpio_read_address=self._delay_filter3_gpio_read_address,
            apply_defaults=apply_defaults
        )

    def trigger_now(self):
        self._trigger_control.value = False
        self._trigger_control.value = True
        self._trigger_control.value = False

    def __str__(self):
        output_sel_no0 = self._output0_select_control.value
        output_sel_no1 = self._output1_select_control.value
        # Define strings
        return ("Paul trap feedback controller\n"
                "  Output 0: {output0_select_name} ({output0_select_number})\n"
                "  Output 1: {output1_select_name} ({output1_select_number})\n"
                "  Trigger mode: {trig_mode} ({trig_mode_number})\n"
                "  1x aom control, 4x filter, 2x sum").format(
            output0_select_name=self.output_select_names[output_sel_no0],
            output0_select_number=output_sel_no0,
            output1_select_name=self.output_select_names[output_sel_no1],
            output1_select_number=output_sel_no1,
            trig_mode='EXTERNAL' if self._trigger_control.value else 'LOCAL',
            trig_mode_number=self._trigger_control.value
        )

    def __repr__(self):
        return self.__str__()

    def description(self):
        ptfb_str = '\n'.join(self.__str__().split('\n')[:-1])  # Drop last line

        aom_control_str = self.aom_control.__str__()
        delay_filter_0_str = self.delay_filter0.__str__()
        delay_filter_1_str = self.delay_filter1.__str__()
        delay_filter_2_str = self.delay_filter2.__str__()
        delay_filter_3_str = self.delay_filter3.__str__()
        sum_0_str = "Sum 0: " + self.sum0.__str__()
        sum_1_str = "Sum 1: " + self.sum1.__str__()

        # return output separated by newlines:
        return "\n".join([
            ptfb_str,
            aom_control_str,
            delay_filter_0_str,
            delay_filter_1_str,
            delay_filter_2_str,
            delay_filter_3_str,
            sum_0_str,
            sum_1_str
        ])


if __name__ == "__main__":
    # ptfb = PaulTrapFeedbackController('red-pitaya-18.ee.ethz.ch', load_bitfile=False, apply_defaults=True)
    # print(ptfb)
    # print(ptfb.aom_control)
    # print(ptfb.delay_filter0)
    # print(ptfb.sum0)
    # print('=============================')
    # print(ptfb.description())
    pass
