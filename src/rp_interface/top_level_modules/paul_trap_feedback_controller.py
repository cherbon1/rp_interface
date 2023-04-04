from typing import Union

from rp_interface.modules.aom_control_module import AOMControlModule
from rp_interface.modules.delay_filter_module import DelayFilterModule
from rp_interface.modules.sum_module import SumModule
from rp_interface.modules.wavegen_module import WavegenModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaTopLevelModule
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.utils import DataType


# TODO: define blank fields that will be overwritten at runtime to allow for tab completion
# TODO: prevent attrs/controls/modules from being overwritten (can this be combined with the item above, e.g. by
# defining it as a property with no setter?)

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
    _parameters = {
        'trigger_delay': '_trigger_delay_parameter.value',
        'output0_select': '_output0_select_parameter.value',
        'output1_select': '_output1_select_parameter.value',
        'constant': '_constant_parameter.value',
        'trigger_mode': '_trigger_mode_parameter.value',
    }
    _submodules = [
        'sum0',
        'sum1',
        'aom_control',
        'delay_filter0',
        'delay_filter1',
        'delay_filter2',
        'delay_filter3',
        'wavegen',
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
        self._define_parameter()
        self._define_modules()

        self.defaults_file = 'paul_trap_feedback_controller_defaults.yaml'
        if apply_defaults:
            self.apply_defaults()

        self.gui_config_file = 'paul_trap_feedback_controller_gui_config.yaml'
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
            n_bits=8
        )

        self._sum1_add_select_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=14,
            n_bits=8
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

        self._wavegen_frequency_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=24,
            n_bits=26
        )

        self._wavegen_fine_gain_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=25,
            n_bits=25
        )

        self._wavegen_coarse_gain_register = MuxedRegister(
            gpio_write_address=self._top_module_gpio_write_address,
            gpio_read_address=self._top_module_gpio_read_address,
            register_address=26,
            n_bits=2
        )

    def _define_parameter(self):
        '''
        A method that defines all controls required here
        Called in __init__, but separated out for readability
        '''
        self._trigger_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._trigger_register,
            name='Trigger control',
            dtype=DataType.BOOL,
        )

        # 0 for local, 1 for external
        self._trigger_mode_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._trigger_mode_register,
            name='Trigger mode',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1)
        )

        self._trigger_delay_parameter = RedPitayaParameter(
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

        self._constant_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._constant_register,
            name='Constant',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2 ** (self._constant_register.n_bits - 1) - 1e-9),  # offset avoids overfl.
            read_data=lambda reg: reg / 2 ** (self._constant_register.n_bits - 1),
        )

    def _define_modules(self):
        sum_input_names = {
            0: 'In0',
            1: 'In1',
            2: 'delay_filter0',
            3: 'delay_filter1',
            4: 'delay_filter2',
            5: 'delay_filter3',
            6: 'wavegen',
            7: 'constant'
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

        self.wavegen = WavegenModule(
            red_pitaya=self.rp,
            frequency_register=self._wavegen_frequency_register,
            fine_gain_register=self._wavegen_fine_gain_register,
            coarse_gain_register=self._wavegen_coarse_gain_register,
            fs=self.fs,
        )

    def trigger_now(self):
        self._trigger_parameter.value = False
        self._trigger_parameter.value = True
        self._trigger_parameter.value = False

    def data_path(self, channel):
        '''
        Describes the data path that generates `channel` output
        '''
        # Work your way backwards.
        # self.output_select_names = {
        #     0: 'In 0',
        #     1: 'In 1',
        #     2: 'AOM control',
        #     3: 'Sum 0',
        #     4: 'Sum 1',
        #     5: 'Filter 0',
        #     6: 'Trigger out',
        #     7: 'Constant'
        # }
        # Examples of what this function should produce:
        # Sum of 2 delay_filter_outputs:
        #   - Input 0, ac coupled -> preamp gain 4x -> 2ms delay -> bandpass filter 20kHz, q: 1.2 -> gain 15x
        #   - Constant 0.1V
        #
        # Output of delay_filter0:
        #   - Input 0, ac coupled -> preamp gain 1x -> 2ms delay -> bandpass filter 20kHz,
        #     q: 1.2 -> bandpass filter 20kHz, q: 1.2 -> gain 15
        #
        # AOM Control signal, feedback from In0, gain 0.1x
        #
        # Where's the output coming from?
        if channel == 0:
            prev_stage = self._output0_select_parameter.value
        elif channel == 1:
            prev_stage = self._output1_select_parameter.value
        else:
            raise KeyError('Unknown channel {} for data path'.format(channel))

        if prev_stage == 0:  # In0
            return 'In0'
        elif prev_stage == 1:  # In1
            return 'In1'
        elif prev_stage == 2:  # AOM Control
            return ('AOM Control signal, trap is {trap_enable}, feedback from {aom_control_input} is {fb_enable}, '
                    'gain {aom_control_gain:.2g}').format(
                trap_enable='ON' if self.aom_control._trap_enable_parameter.value else 'OFF',
                aom_control_input=self.aom_control.input_select_names[self.aom_control._input_select_parameter.value],
                fb_enable='ON' if self.aom_control._feedback_enable_parameter.value else 'OFF',
                aom_control_gain=self.aom_control._feedback_gain_parameter.value
            )
        elif prev_stage == 3 or prev_stage == 4:
            if prev_stage == 3:
                sum_enables = self.sum0.add_select_list
            elif prev_stage == 4:
                sum_enables = self.sum1.add_select_list
            else:
                raise RuntimeError('Wait, whaaaat???!')

            # Monkey patch objects for non delay-line filter objects (quite messy...)
            class DummyBlock:
                def __init__(self, data_path_output=None):
                    self.data_path = lambda: data_path_output

            in0 = DummyBlock('In0')
            in1 = DummyBlock('In1')
            wavegen = DummyBlock()
            wavegen.data_path = lambda: f'{self.wavegen.frequency * 1e-3:.2f}kHz'
            constant = DummyBlock('constant')
            delay_filters = {
                'in0': in0,
                'in1': in1,
                'delay_filter0': self.delay_filter0,
                'delay_filter1': self.delay_filter1,
                'delay_filter2': self.delay_filter2,
                'delay_filter3': self.delay_filter3,
                'wavegen': wavegen,
                'constant': constant
            }
            filters_string = '\n - '.join([f'{df_name}: {df.data_path()}' for (df_name, df), enable in
                                           zip(delay_filters.items(), sum_enables) if enable])
            return ('Sum of {n_stages} signals:\n'
                    ' - {filters}').format(
                n_stages=sum(sum_enables),
                filters=filters_string if filters_string else 'No output',
            )
        elif prev_stage == 5:  # delay_filter0
            return 'delay_filter0: {}'.format(self.delay_filter0.data_path())
        elif prev_stage == 6:  # Trigger out
            return 'Trigger output (source: {})'.format(
                'LOCAL' if self._trigger_mode_parameter.value == 0 else 'EXTERNAL'
            )
        elif prev_stage == 7:  # Constant
            return 'Constant: {}V'.format(self._constant_parameter.value)

    def __str__(self):
        output_sel_no0 = self._output0_select_parameter.value
        output_sel_no1 = self._output1_select_parameter.value
        # Define strings
        return ("Paul trap feedback controller\n"
                "  Output 0: {output0_select_name} ({output0_select_number})\n"
                "    {datapath0}\n"
                "  Output 1: {output1_select_name} ({output1_select_number})\n"
                "    {datapath1}\n"
                "  Trigger mode: {trig_mode} ({trig_mode_number})").format(
            output0_select_name=self.output_select_names[output_sel_no0],
            output0_select_number=output_sel_no0,
            datapath0=self.data_path(0).replace('\n', '\n    '),
            output1_select_name=self.output_select_names[output_sel_no1],
            output1_select_number=output_sel_no1,
            datapath1=self.data_path(1).replace('\n', '\n    '),
            trig_mode='EXTERNAL' if self._trigger_mode_parameter.value else 'LOCAL',
            trig_mode_number=self._trigger_mode_parameter.value
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
    ptfb = PaulTrapFeedbackController('red-pitaya-00.ee.ethz.ch',
                                      load_bitfile=False,
                                      apply_defaults=False,
                                      make_gui=False)


    # ptfb.wavegen.frequency = 120e3
    # ptfb.wavegen.amplitude = 0.5
    # ptfb.output0_select = 3  # sum0
    # ptfb.sum0.add0 = False
    # ptfb.sum0.add1 = False
    # ptfb.sum0.add2 = False
    # ptfb.sum0.add3 = False
    # ptfb.sum0.add4 = False
    # ptfb.sum0.add5 = False
    # ptfb.sum0.add6 = True
    # ptfb.sum0.add7 = False

    print(ptfb.sum0)
    print(ptfb)

    # ptfb.output1_select = 4
    # print(ptfb)
    # ptfb.sum0.add0 = True
    # ptfb.sum0.add1 = False
    # print(ptfb.sum0)
    # print(ptfb.sum1)
    #
    # print('COPYING SETTINGS')
    # ptfb.sum1.copy_settings(ptfb.sum0)
    #
    # print(ptfb.sum0)
    # print(ptfb.sum1)

    # ptfb.delay_filter0.delay = 100e-6
    # ptfb.delay_filter0.biquad0.apply_filter_settings('bandpass', 10e3, 1.0)
    # ptfb.delay_filter0.output0_select = 1
    # ptfb.delay_filter0.gain = 8.2
    # ptfb.delay_filter0.preamp_gain = 2
    #
    # print(ptfb.delay_filter0)
    # print(ptfb.delay_filter1)
    #
    # print('COPYING SETTINGS')
    # ptfb.delay_filter1.copy_settings(ptfb.delay_filter0)
    #
    # print(ptfb.delay_filter0)
    # print(ptfb.delay_filter1)

    # print(ptfb.aom_control)
    # print(ptfb.delay_filter0)
    # print(ptfb.sum0)
    # print('=============================')
    # print(ptfb.description())
    pass
