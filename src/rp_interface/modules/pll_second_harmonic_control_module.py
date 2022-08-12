from typing import Union

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaModule


class PLLSecondHarmonicControlModule(RedPitayaModule):
    '''
    In the hardware implementation of the PLL module, the PLL frequency, demodulator_bandwidth and second_harmonic are
    closely interconnected. This module handles the interaction between those controls.
    The demodulator_bandwidth control is set via the alpha register
    '''
    _parameters = {}  # Don't define any properties for this module, this will be handled by its parent module
    _submodules = []
    
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 second_harmonic_register: Union[Register, MuxedRegister],
                 alpha_register: Union[Register, MuxedRegister],
                 frequency_register: Union[Register, MuxedRegister],
                 fs: float
                 ):
        super().__init__(red_pitaya=red_pitaya)

        self.fs = fs
        self._second_harmonic_register = second_harmonic_register
        self._alpha_register = alpha_register
        self._frequency_register = frequency_register

        self._second_harmonic_control = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._second_harmonic_register,
            name='Second harmonic',
            dtype=DataType.BOOL,
        )

        self._frequency_control = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._frequency_register,
            name='frequency',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: val >= 0,  # Data is handled as a signed int, but should be positive
            write_data=lambda val: int(val * 2**26 / self.fs),
            read_data=lambda reg: reg / 2**26 * self.fs
        )

        # alpha = exp(-2*np.pi*demodulator_bandwidth/sample_freq) with sample_freq = 125e6/2**10 = 122.07 kHz
        self._demodulator_bandwidth_control = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._alpha_register,
            name='demodulator bandwidth',
            dtype=DataType.UNSIGNED_INT,
            write_data=lambda val: int(np.exp(-2*np.pi*val / (125e6/1024)) * 2**17 - 1e-9),
            read_data=lambda reg: 0 if reg == 0 else -(125e6/1024) * np.log(reg / 2**17) / (2*np.pi)
        )

    @property
    def second_harmonic(self):
        return self._second_harmonic_control.value

    @second_harmonic.setter
    def second_harmonic(self, value):
        # cast value to bool, compare to current second harmonic
        # If unchanged, do nothing
        value = bool(value)
        if value == self.second_harmonic:
            return

        # Store current bandwidth and frequency values
        temp_demodulator_bandwidth = self.demodulator_bandwidth
        temp_frequency = self.frequency

        # Update second harmonic
        self._second_harmonic_control.value = value

        # Re-write temp values
        self.demodulator_bandwidth = temp_demodulator_bandwidth
        self.frequency = temp_frequency

    @property
    def demodulator_bandwidth(self):
        divide_by = 2 if self.second_harmonic else 1
        return float(self._demodulator_bandwidth_control.value / divide_by)

    @demodulator_bandwidth.setter
    def demodulator_bandwidth(self, value):
        multiply_by = 2 if self.second_harmonic else 1
        self._demodulator_bandwidth_control.value = value * multiply_by

    @property
    def frequency(self):
        divide_by = 2 if self.second_harmonic else 1
        return self._frequency_control.value / divide_by

    @frequency.setter
    def frequency(self, value):
        multiply_by = 2 if self.second_harmonic else 1
        self._frequency_control.value = value * multiply_by
