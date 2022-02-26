from typing import Union

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
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
        - An output gain module (up to 64x)
        - A triggered gate for fast toggling of filter output, composed of:
            Delay time, Toggle time (8ns resolution, up to 0.5368709 seconds)
        - A constant output (in range -1 to 1)

    output select options:
        - 0 -> 4 filters (output of biquad3)
        - 1 -> 3 filters (output of biquad2)
        - 2 -> 2 filters (output of biquad1)
        - 3 -> 1 filters (output of biquad0)
        - 4 -> output of DC/AC coupling
        - 5 -> delay_output
        - 6 -> coarse_delay_output
        - 7 -> constant

    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 gpio_write_address: str,
                 gpio_read_address: str,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
            'gain': 1.,
            'ac_coupling': True,
            'delay': 0,
            'output_select': 3,  # default to output of 1st filter
            'toggle_delay': 1e-3,
            'toggle_time': 0
        }

        self._gpio_write_address = gpio_write_address
        self._gpio_read_address = gpio_read_address

        self.fs_delay = 125e6
        self.fs_biquad = 125e6 / 2**3

        self._define_register_locations()
        self._define_biquad_register_locations()
        self._define_controls()
        self._define_biquads()

        property_definitions = {
            'input_select': ('_input_select_control', 'value'),
            'ac_coupling': ('_ac_coupling_control', 'value'),
            'delay': ('_delay_control', 'value'),
            'output_select': ('_output_select_control', 'value'),
            'gain': ('_gain_module', 'gain'),
            'toggle_delay': ('_toggle_delay_control', 'value'),
            'toggle_time': ('_toggle_time_control', 'value'),
            'constant': ('_constant_control', 'value'),
        }
        self._define_properties(property_definitions)

        if apply_defaults:
            self.apply_defaults()

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
            n_bits=1
        )

        self._ac_coupling_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=2,
            n_bits=1
        )

        self._delay_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=3,
            n_bits=17
        )

        self._output_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=24,
            n_bits=3
        )

        self._fine_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=25,
            n_bits=24
        )

        self._coarse_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=26,
            n_bits=3
        )

        self._toggle_delay_cycles_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=27,
            n_bits=26
        )

        self._toggle_cycles_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=28,
            n_bits=26
        )

        self._constant_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=30,
            n_bits=17
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
            n_bits=26
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
            n_bits=26
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
            n_bits=26
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
            n_bits=26
        )

    def _define_controls(self):
        '''
        A method that defines all controls of a filter block (except for biquad filter modules)
        Called in __init__, but separated out for readability
        '''
        self.input_select_names = {0: 'In 0', 1: 'In 1'}
        self._input_select_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._input_select_register,
            name='Input select',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1),
        )

        self._ac_coupling_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._ac_coupling_register,
            name='AC coupling',
            dtype=DataType.BOOL,
        )

        self._delay_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._delay_register,
            name='Delay',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 1.048568e-3),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self.output_select_names = {
            0: '4 filters',
            1: '3 filters',
            2: '2 filters',
            3: '1 filter',
            4: 'No filters',
            5: 'Reserved (troubleshooting)',
            6: 'Reserved (troubleshooting)',
            7: 'Constant'
        }
        self._output_select_control = RedPitayaControl(
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

        self._toggle_delay_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._toggle_delay_cycles_register,
            name='Toggle delay',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 0.5368709),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self._toggle_time_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._toggle_cycles_register,
            name='Toggle time',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (0 <= val <= 0.5368709),
            write_data=lambda val: int(val * self.fs_delay),
            read_data=lambda reg: reg / self.fs_delay,
        )

        self._constant_control = RedPitayaControl(
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
            fs=self.fs_biquad
        )

        self.biquad1 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad1_registers,
            fs=self.fs_biquad
        )

        self.biquad2 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad2_registers,
            fs=self.fs_biquad
        )

        self.biquad3 = BiquadFilterModule(
            red_pitaya=self.rp,
            biquad_registers=self._biquad3_registers,
            fs=self.fs_biquad
        )

    def __str__(self):
        biquad0_str = "    biquad0: " + self.biquad0.__str__()
        biquad1_str = "    biquad1: " + self.biquad1.__str__()
        biquad2_str = "    biquad2: " + self.biquad2.__str__()
        biquad3_str = "    biquad3: " + self.biquad3.__str__()
        main_body_str = ("Delay filter:\n"
                         "  Input: {input_select_name} ({input_sel_number}), {ac_coupling}-coupled,"
                         "  Output: {output_select_name} ({output_sel_number})\n"
                         "  Delay: {delay}us (freq: {frequency:.2f}kHz), Gain: {gain}\n"
                         "  Output toggle: {toggle_time}us (delay {delay_time}us)").format(
            input_select_name=self.input_select_names[self._input_select_control.value],
            input_sel_number=self._input_select_control.value,
            output_select_name=self.output_select_names[self._output_select_control.value],
            output_sel_number=self._output_select_control.value,
            ac_coupling='AC' if self._ac_coupling_control.value else 'DC',
            delay=self._delay_control.value*1e6,
            frequency=0 if self._delay_control.value == 0 else 1/4/self._delay_control.value*1e-3,
            gain=self._gain_module.gain,
            toggle_time=self._toggle_time_control.value*1e6,
            delay_time=self._delay_control.value*1e6,
        )
        return "\n".join([main_body_str, biquad0_str, biquad1_str, biquad2_str, biquad3_str])

    def __repr__(self):
        return self.__str__()
