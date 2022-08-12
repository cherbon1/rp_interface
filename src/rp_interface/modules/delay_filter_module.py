from typing import Union
import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaModule
from rp_interface.modules.gain_module import GainModule
from rp_interface.modules.biquad_filter_module import BiquadFilterRegisters, BiquadFilterModule


class DelayFilterModule(RedPitayaModule):
    '''
    Implements an interface to an entire delay + filter module.

    A delay + filter module is composed of:
        - An input select (select red pitaya input channel: 0 or 1)
        - AC/DC coupling (Bypass a single pole high-pass filter, fc<1Hz)
        - A delay line (8ns resolution, up to 1.048568e-3 seconds)
        - 4 biquad filters:
            biquad0, biquad1, biquad2, biquad3
        - An output select (select one of 8 outputs, described below)
        - An output gain module
        - A triggered gate for fast toggling of filter output, composed of:
            Delay time, Toggle time (8ns resolution, up to 0.5368709 seconds)
        - A constant output (in range -1 to 1)

    output select options:
        - 0 -> 0 filters (output of DC/AC coupling)
        - 1 -> 1 filters (output of biquad0)
        - 2 -> 2 filters (output of biquad1)
        - 3 -> 3 filters (output of biquad2)
        - 4 -> 4 filters (output of biquad3)
        - 5 -> delay_output
        - 6 -> coarse_delay_output
        - 7 -> constant

    '''
    _parameters = {
            'input_select': '_input_select_parameter.value',
            'ac_coupling': '_ac_coupling_parameter.value',
            'delay': '_delay_parameter.value',
            'output_select': '_output_select_parameter.value',
            'gain': '_gain_module.gain',
            'preamp_gain': '_preamp_gain_parameter.value',
            'toggle_delay': '_toggle_delay_parameter.value',
            'toggle_time': '_toggle_time_parameter.value',
            'constant': '_constant_parameter.value',
        }
    _submodules = [
        'biquad0',
        'biquad1',
        'biquad2',
        'biquad3',
    ]

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 gpio_write_address: str,
                 gpio_read_address: str,
                 ):
        super().__init__(red_pitaya=red_pitaya)

        self._gpio_write_address = gpio_write_address
        self._gpio_read_address = gpio_read_address

        self.fs_delay = 125e6
        self.fs_biquad = 125e6 / 2**3

        self._define_register_locations()
        self._define_biquad_register_locations()
        self._define_parameters()
        self._define_biquads()

    def _define_register_locations(self):
        '''
        A method that defines all register addresses of a filter block (except for biquad filter addresses)
        Called in __init__, but separated out for readability
        '''
        # =======================================
        # ====== DEFINE REGISTER LOCATIONS ======
        # =======================================
        self._input_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=0,
            n_bits=1,
            is_shared=False
        )

        self._preamp_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=1,
            n_bits=4,
            is_shared=False
        )

        self._ac_coupling_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=2,
            n_bits=1,
            is_shared=False
        )

        self._delay_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=3,
            n_bits=17,
            is_shared=False
        )

        self._output_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=24,
            n_bits=3,
            is_shared=False
        )

        self._fine_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=25,
            n_bits=25,
            is_shared=False
        )

        self._coarse_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=26,
            n_bits=5,
            is_shared=False
        )

        self._toggle_delay_cycles_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=27,
            n_bits=26,
            is_shared=False
        )

        self._toggle_cycles_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=28,
            n_bits=26,
            is_shared=False
        )

        self._reinit_dc_block = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=29,
            n_bits=1,
            lsb_location=4
        )

        self._constant_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=30,
            n_bits=26,
            is_shared=False
        )

    def _define_biquad_register_locations(self):
        '''
        A method that defines all biquad register addresses of a filter block
        Called in __init__, but separated out for readability
        '''
        # ========================================
        # === DEFINE BIQUAD REGISTER LOCATIONS ===
        # ========================================
        self._biquad0_registers = BiquadFilterRegisters(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            a1_address=4,
            a2_address=5,
            b0_address=6,
            b1_address=7,
            b2_address=8,
            reinit_address=29,
            reinit_lsb_location=0,
            n_bits=25
        )

        self._biquad1_registers = BiquadFilterRegisters(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            a1_address=9,
            a2_address=10,
            b0_address=11,
            b1_address=12,
            b2_address=13,
            reinit_address=29,
            reinit_lsb_location=1,
            n_bits=25
        )

        self._biquad2_registers = BiquadFilterRegisters(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            a1_address=14,
            a2_address=15,
            b0_address=16,
            b1_address=17,
            b2_address=18,
            reinit_address=29,
            reinit_lsb_location=2,
            n_bits=25
        )

        self._biquad3_registers = BiquadFilterRegisters(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            a1_address=19,
            a2_address=20,
            b0_address=21,
            b1_address=22,
            b2_address=23,
            reinit_address=29,
            reinit_lsb_location=3,
            n_bits=25
        )

    def _define_parameters(self):
        '''
        A method that defines all controls of a filter block (except for biquad filter modules)
        Called in __init__, but separated out for readability
        '''
        self.input_select_names = {0: 'In 0', 1: 'In 1'}
        self._input_select_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._input_select_register,
            name='Input select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1),
        )

        # Corresponds to 2**(largest bitshift that can be specified in n_bits).
        # Will often be larger than what's required
        max_preamp_gain = int(2 ** (2**self._preamp_gain_register.n_bits - 1))

        self._preamp_gain_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._preamp_gain_register,
            name='Preamp gain',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (1 <= val <= max_preamp_gain),
            write_data=lambda val: int(np.log2(val)),
            read_data=lambda reg: 2**reg
        )

        self._ac_coupling_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._ac_coupling_register,
            name='AC coupling',
            dtype=DataType.BOOL,
        )

        self._delay_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._delay_register,
            name='Delay',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1.048568e-3),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self.output_select_names = {
            0: 'No filters',
            1: '1 filter',
            2: '2 filters',
            3: '3 filters',
            4: '4 filters',
            5: '5 filters',
            6: '6 filters',
            7: 'Constant'
        }
        self._output_select_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._output_select_register,
            name='Output select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 7),
        )

        self._gain_module = GainModule(
            red_pitaya=self.rp,
            fine_gain_register=self._fine_gain_register,
            coarse_gain_register=self._coarse_gain_register,
        )

        self._toggle_delay_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._toggle_delay_cycles_register,
            name='Toggle delay',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 0.5368709),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self._toggle_time_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._toggle_cycles_register,
            name='Toggle time',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 0.5368709),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self._constant_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._constant_register,
            name='Constant',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(val * 2**(self._constant_register.n_bits-1) - 1e-9),  # offset avoids overflow
            read_data=lambda reg: reg / 2**(self._constant_register.n_bits-1),
        )

    def _define_biquads(self):
        '''
        A method that defines all biquad filter modules of a filter block
        Called in __init__, but separated out for readability
        '''
        self.biquad0 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad0_registers,
            fs=self.fs_biquad,
        )

        self.biquad1 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad1_registers,
            fs=self.fs_biquad,
        )

        self.biquad2 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad2_registers,
            fs=self.fs_biquad,
        )

        self.biquad3 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad3_registers,
            fs=self.fs_biquad,
        )

    def refresh_dc_block(self):
        '''
        Clears out contents of shift register in case filter gets stuck in weird mode
        by toggling reinit high
        '''
        self.rp.write_register(self._reinit_dc_block, True, dtype=DataType.BOOL)
        self.rp.write_register(self._reinit_dc_block, False, dtype=DataType.BOOL)

    def data_path(self):
        '''
        Describes the data path of the current output
        Example output:
        # Input 0, ac coupled -> preamp gain 1x -> 2ms delay -> bandpass filter 20kHz,
        #   q: 1.2 -> bandpass filter 20kHz, q: 1.2 -> gain 15
        '''

        # self.output_select_names = {
        #     0: 'No filters',
        #     1: '1 filter',
        #     2: '2 filters',
        #     3: '3 filters',
        #     4: '4 filters',
        #     5: '5 filters',
        #     6: '6 filters',
        #     7: 'Constant'
        # }
        output_no = self._output_select_parameter.value
        if output_no == 7:
            return 'Constant: {}V'.format(self._constant_parameter.value)

        biquads = [self.biquad0, self.biquad1, self.biquad2, self.biquad3, self.biquad2, self.biquad3]
        biquad_string = ' -> '.join([biquads[i].__str__() for i in range(output_no)])

        return ('Input {input_no}, {ac_coupling}-coupled -> preamp gain {preamp_gain}x -> {delay:.1f}us delay '
                '({freq:.2f}kHz) -> {biquad_string} -> gain {gain:.2f}x').format(
            input_no=self._input_select_parameter.value,
            ac_coupling='ac' if self._ac_coupling_parameter.value else 'dc',
            preamp_gain=self._preamp_gain_parameter.value,
            delay=self._delay_parameter.value * 1e6,
            freq=0 if self._delay_parameter.value == 0 else 1/4/self._delay_parameter.value*1e-3,
            biquad_string=biquad_string if biquad_string else 'no filter',
            gain=self._gain_module.gain,
        )

    def __str__(self):
        biquad0_str = "    biquad0: " + self.biquad0.__str__()
        biquad1_str = "    biquad1: " + self.biquad1.__str__()
        biquad2_str = "    biquad2: " + self.biquad2.__str__()
        biquad3_str = "    biquad3: " + self.biquad3.__str__()
        main_body_str = ("Delay filter:\n"
                         "  Input: {input_select_name} ({input_sel_number}), {ac_coupling}-coupled,"
                         "  Output: {output_select_name} ({output_sel_number})\n"
                         "  Preamp gain: {preamp_gain}, Gain: {gain:.2f}\n"
                         "  Delay: {delay:.2f}us (freq: {frequency:.2f}kHz)\n"
                         "  Output toggle: {toggle_time:.2f}us (delay {delay_time:.2f}us)").format(
            input_select_name=self.input_select_names[self._input_select_parameter.value],
            input_sel_number=self._input_select_parameter.value,
            output_select_name=self.output_select_names[self._output_select_parameter.value],
            output_sel_number=self._output_select_parameter.value,
            ac_coupling='AC' if self._ac_coupling_parameter.value else 'DC',
            delay=self._delay_parameter.value*1e6,
            frequency=0 if self._delay_parameter.value == 0 else 1/4/self._delay_parameter.value*1e-3,
            preamp_gain=self._preamp_gain_parameter.value,
            gain=self._gain_module.gain,
            toggle_time=self._toggle_time_parameter.value*1e6,
            delay_time=self._toggle_delay_parameter.value*1e6,
        )
        return "\n".join([main_body_str, biquad0_str, biquad1_str, biquad2_str, biquad3_str])

    def __repr__(self):
        return self.__str__()
