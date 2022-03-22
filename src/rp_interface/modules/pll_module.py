from typing import Union

import numpy as np

from rp_interface.modules.amplitude_phase_module import AmplitudePhaseModule
from rp_interface.modules.gain_module import GainModule
from rp_interface.red_pitaya_module import RedPitayaModule
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.utils import DataType


class PLLModule(RedPitayaModule):
    '''
    Implements an interface to a pll module

    A pll control module is composed of:
        - An input select (0 or 1, designating the input channel of the red pitaya)
        - A second harmonic enable (True or False, whether output freq should be doubled)
        - A PID enable (True or False, whether to enable PID of PLL)
        - An a and phi parameter via and AmplitudePhaseModule (implements w_a and w_b)
        - A kp proportional constant for the PID loop
        - A ki integral constant for the PID loop
        - A reference frequency f0
        - A bandwidth for the PID
        - An filter_bandwidth, low pass filter bandwidth for the demodulators (implements alpha)
        - An order parameter, that sets the order of the low pass
        - An output select (select one of 8 outputs, described below)
        - An output gain module

    output select options:
        - 0 -> PLL output
        - 1 -> x of demodulator
        - 2 -> y of demodulator
        - 3 -> r of demodulator
        - 4 -> theta of demodulator
        - 5 -> N.C.
        - 6 -> N.C.
        - 7 -> N.C.
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 gpio_write_address: str,
                 gpio_read_address: str,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
                'input_select': 0,
                'second_harmonic': True,
                'pid_enable': False,
                'a': 1,
                'phi': 0,
                'order': 1,
                'gain': 1.,
                'demodulator_bandwidth': 1e3
            }

        self._gpio_write_address = gpio_write_address
        self._gpio_read_address = gpio_read_address

        self.fs = 31.25e6

        self._define_register_locations()
        self._define_controls()

        property_definitions = {
            'input_select': ('_input_select_control', 'value'),
            'second_harmonic': ('_second_harmonic_control', 'value'),
            'frequency': ('_frequency_control', 'value'),
            'a': ('_amplitude_phase_module', 'a'),
            'phi': ('_amplitude_phase_module', 'phi'),
            'demodulator_bandwidth': ('_demodulator_bandwidth_control', 'value'),
            'order': ('_order_control', 'value'),
            'pid_enable': ('_pid_enable_control', 'value'),
            'pid_bandwidth': ('_pid_bandwidth_control', 'value'),
            'kp': ('_kp_control', 'value'),
            'ki': ('_ki_control', 'value'),
            'output_select': ('_output_select_control', 'value'),
            'gain': ('_gain_module', 'gain'),
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

        self._second_harmonic_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=1,
            n_bits=1
        )

        self._pid_enable_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=2,
            n_bits=1
        )

        self._wa_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=3,
            n_bits=8
        )

        self._wb_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=4,
            n_bits=8
        )

        self._kp_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=5,
            n_bits=26
        )

        self._ki_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=6,
            n_bits=26
        )

        self._frequency_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=7,
            n_bits=26
        )

        self._pid_bandwidth_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=8,
            n_bits=26
        )

        self._alpha_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=9,
            n_bits=17
        )

        self._order_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=10,
            n_bits=3
        )

        self._output_select_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=11,
            n_bits=3
        )

        self._fine_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=12,
            n_bits=18
        )

        self._coarse_gain_register = MuxedRegister(
            gpio_write_address=self._gpio_write_address,
            gpio_read_address=self._gpio_read_address,
            register_address=13,
            n_bits=5
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

        self._second_harmonic_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._second_harmonic_register,
            name='Second harmonic',
            dtype=DataType.BOOL,
        )

        self._pid_enable_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._pid_enable_register,
            name='PID enable',
            dtype=DataType.BOOL,
        )

        self._amplitude_phase_module = AmplitudePhaseModule(
            red_pitaya=self.rp,
            wa_register=self._wa_register,
            wb_register=self._wb_register
        )

        self._kp_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._kp_register,
            name='k_p',
            dtype=DataType.SIGNED_INT,
            write_data=lambda val: int(val * 2**10),
            read_data=lambda reg: reg/2**10
        )

        self._ki_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._ki_register,
            name='k_i',
            dtype=DataType.SIGNED_INT,
            write_data=lambda val: int(val * 2**10),
            read_data=lambda reg: reg/2**10
        )

        self._frequency_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._frequency_register,
            name='frequency',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: val >= 0,  # Data is handled as a signed int, but should be positive
            write_data=lambda val: int(val * 2**26 / self.fs),
            read_data=lambda reg: reg / 2**26 * self.fs
        )

        self._pid_bandwidth_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._pid_bandwidth_register,
            name='PID bandwidth',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: val >= 0,  # Data is handled as a signed int, but should be positive
            write_data=lambda val: int(val * 2**26 / self.fs),
            read_data=lambda reg: reg / 2**26 * self.fs
        )

        # alpha = exp(-2*np.pi*demodulator_bandwidth/sample_freq) with sample_freq = 125e6/2**10 = 122.07 kHz
        self._demodulator_bandwidth_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._alpha_register,
            name='demodulator bandwidth',
            dtype=DataType.UNSIGNED_INT,
            write_data=lambda val: int(np.exp(-2*np.pi*val / (125e6/1024)) * 2**17 - 1e-9),
            read_data=lambda reg: 0 if reg == 0 else -(125e6/1024) * np.log(reg / 2**17) / (2*np.pi)
        )

        self._order_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._order_register,
            name='Order',
            dtype=DataType.UNSIGNED_INT,
            write_data=lambda val: val - 1,  # order 1 is written with register value 000
            read_data=lambda reg: reg + 1

        )

        self.output_select_names = {
            0: 'PLL out',
            1: 'demod x',
            2: 'demod y',
            3: 'demod r',
            4: 'demod theta',
            5: 'N.C.',
            6: 'N.C.',
            7: 'N.C.'
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

    def __str__(self):
        input_sel_no = self._input_select_control.value
        output_sel_no = self._output_select_control.value
        return ("PLL module:\n"
                "  Input: {input_select_name} ({input_sel_number}), 2nd harm.: {sec_harm}\n"
                "  Demod: freq {freq:.2f}kHz, phase {phase:.1f}deg, bandwidth {demod_bw:.2f}kHz, order {order}\n"
                "  PID {pid_on}: kp {kp:.2f}, ki {ki:.2f}, bandwidth {pid_bw}kHz\n"
                "  Output: {output_sel_name} ({output_sel_number}), gain {gain:.2f}").format(
            input_select_name=self.input_select_names[input_sel_no],
            input_sel_number=input_sel_no,
            sec_harm=self._second_harmonic_control.value,
            freq=self._frequency_control.value * 1e-3,
            phase=self._amplitude_phase_module.phi,
            demod_bw=self._demodulator_bandwidth_control.value * 1e-3,
            order=self._order_control.value,
            pid_on='ON' if self._pid_enable_control.value else 'OFF',
            kp=self._kp_control.value,
            ki=self._ki_control.value,
            pid_bw=self._pid_bandwidth_control.value * 1e-3,
            output_sel_name=self.output_select_names[output_sel_no],
            output_sel_number=output_sel_no,
            gain=self._gain_module.gain,
        )

    def __repr__(self):
        return self.__str__()
