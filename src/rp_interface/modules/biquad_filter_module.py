import enum
import logging
from dataclasses import dataclass
from typing import Union, Dict

import numpy as np
import scipy.signal as signal

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import MuxedRegister
from rp_interface.red_pitaya_module import RedPitayaModule

log = logging.getLogger(__name__)


@dataclass
class BiquadFilterRegisters:
    '''
    Defines a container for 5 biquad coefficient register and one reinit register
    '''
    a1: MuxedRegister
    a2: MuxedRegister
    b0: MuxedRegister
    b1: MuxedRegister
    b2: MuxedRegister
    reinit: MuxedRegister

    def __init__(self, gpio_write_address, gpio_read_address, b0_address, b1_address, b2_address,
                 a1_address, a2_address, reinit_address, reinit_lsb_location, n_bits=26):
        self.a1 = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a1_address,
            n_bits=n_bits
        )

        self.a2 = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a2_address,
            n_bits=n_bits
        )

        self.b0 = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b0_address,
            n_bits=n_bits
        )

        self.b1 = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b1_address,
            n_bits=n_bits
        )

        self.b2 = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b2_address,
            n_bits=n_bits
        )

        self.reinit = MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=reinit_address,
            n_bits=1,
            lsb_location=reinit_lsb_location
        )


@dataclass
class BiquadFilterCoefficients:
    '''
    stores biquad filter coefficients as floating point numbers
    defines a few conversion functions that return BiquadFilterCoefficients instances with
    '''
    b0: float
    b1: float
    b2: float
    a1: float
    a2: float

    def get_bitshifted_coefficients(self, bitshift=24):
        '''
        Rescales by 2**bitshift and casts to int.
        Useful for writing values to a register
        Returns a new instance of BiquadFilterCoefficients
        '''
        factor = 2 ** bitshift
        return BiquadFilterCoefficients(int(self.b0 * factor),
                                        int(self.b1 * factor),
                                        int(self.b2 * factor),
                                        int(self.a1 * factor),
                                        int(self.a2 * factor))

    def get_quantized_coefficients(self, bitshift=24):
        '''
        Returns a quantized copy of the coefficients. Useful to check for rounding errors.
        Coefficients are quantized by bitshifting by specified amount, casting to int and bitshifting back
        Returns a new instance of BiquadFilterCoefficients
        '''
        factor = 2 ** bitshift
        return BiquadFilterCoefficients(int(self.b0 * factor) / factor,
                                        int(self.b1 * factor) / factor,
                                        int(self.b2 * factor) / factor,
                                        int(self.a1 * factor) / factor,
                                        int(self.a2 * factor) / factor)

    @property
    def normalized_transfer_function(self):
        return signal.freqz((self.b0, self.b1, self.b2), (1, self.a1, self.a2))


class FilterType(enum.Enum):
    UNKNOWN = 'unknown'
    SINGLE_POLE_LOWPASS = 'lowpass'
    DOUBLE_POLE_LOWPASS = 'llowpass'
    SINGLE_POLE_HIGHPASS = 'highpass'
    DOUBLE_POLE_HIGHPASS = 'hhighpass'
    BANDPASS = 'bandpass'
    NOTCH = 'notch'

    def __eq__(self, other):
        '''
        Override equality operator such that == value also returns true
        Example:
            FilterType.SINGLE_POLE_LOWPASS == 'lowpass' --> True
            FilterType.SINGLE_POLE_LOWPASS == FilterType.SINGLE_POLE_LOWPASS --> True
            'lowpass' == FilterType.SINGLE_POLE_LOWPASS --> True
        '''
        if isinstance(other, str):
            return self.value == other
        return super().__eq__(other)


class BiquadFilterModule(RedPitayaModule):
    '''
    Implements an interface to a biquad filter module
    '''

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 biquad_registers: BiquadFilterRegisters = None,
                 fs: float = 125e6 / 2 ** 3,
                 default_values: Dict = None,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, default_values=default_values, apply_defaults=False)

        if biquad_registers is None:
            raise KeyError('Need to define addresses to communicate with biquad filter')
        self.biquad_registers = biquad_registers

        # Define values for coefficient manipulation
        self.fs = fs
        self.n_bits = self.biquad_registers.b0.n_bits
        self.bitshift = self.n_bits - 2

        # Define parameters
        self._filter_type = FilterType.UNKNOWN
        self._center_frequency = 1e3
        self._q_factor = 1

        if apply_defaults:
            self.apply_defaults()

    @property
    def filter_type(self):
        return self._filter_type

    @filter_type.setter
    def filter_type(self, value: FilterType):
        # raise RuntimeError("Can't set filter type directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=value,
                                   center_frequency=self.center_frequency,
                                   q_factor=self.q_factor)

    @property
    def center_frequency(self):
        return self._center_frequency

    @center_frequency.setter
    def center_frequency(self, value: float):
        # raise RuntimeError("Can't set center_frequency directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=self.filter_type,
                                   center_frequency=value,
                                   q_factor=self.q_factor)

    @property
    def q_factor(self):
        return self._q_factor

    @q_factor.setter
    def q_factor(self, value: float):
        # raise RuntimeError("Can't set q_factor directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=self.filter_type,
                                   center_frequency=self.center_frequency,
                                   q_factor=value)

    @property
    def biquad_coefficients(self):
        factor = 2 ** self.bitshift
        b0 = self.rp.read_register(register=self.biquad_registers.b0, dtype=DataType.SIGNED_INT)
        b1 = self.rp.read_register(register=self.biquad_registers.b1, dtype=DataType.SIGNED_INT)
        b2 = self.rp.read_register(register=self.biquad_registers.b2, dtype=DataType.SIGNED_INT)
        a1 = self.rp.read_register(register=self.biquad_registers.a1, dtype=DataType.SIGNED_INT)
        a2 = self.rp.read_register(register=self.biquad_registers.a2, dtype=DataType.SIGNED_INT)
        return BiquadFilterCoefficients(b0 / factor,
                                        b1 / factor,
                                        b2 / factor,
                                        a1 / factor,
                                        a2 / factor)

    def write_biquad_coefficients(self, coefficients: BiquadFilterCoefficients):
        '''
        Writes the contents of BiquadFilterCoefficients to self.biquad_registers
        Coefficients should not be rescaled yet
        '''
        scaled_coeffs = coefficients.get_bitshifted_coefficients(self.bitshift)
        self.rp.write_register(self.biquad_registers.b0, scaled_coeffs.b0, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.b1, scaled_coeffs.b1, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.b2, scaled_coeffs.b2, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.a1, scaled_coeffs.a1, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.a2, scaled_coeffs.a2, dtype=DataType.SIGNED_INT)

    def calculate_biquad_coefficients(self, filter_type: FilterType, center_frequency: float, q_factor: float):
        '''
        Calculate filter parameters based on type, center_frequency and q_factor
        '''
        if not (0 < center_frequency < self.fs):
            raise ValueError('Center frequency {:.2f} is out of range (0, {:.2f})'.format(center_frequency, self.fs))
        k = np.tan(np.pi * center_frequency / self.fs)
        if filter_type == FilterType.SINGLE_POLE_LOWPASS:
            a1 = np.exp(-2.0 * np.pi * (center_frequency / self.fs))
            b0 = 1.0 - a1
            a1 = -a1
            b1 = b2 = a2 = 0

        elif filter_type == FilterType.SINGLE_POLE_HIGHPASS:
            a1 = -np.exp(-2.0 * np.pi * (0.5 - center_frequency / self.fs))
            b0 = 1.0 + a1
            a1 = -a1
            b1 = b2 = a2 = 0

        elif filter_type == FilterType.DOUBLE_POLE_LOWPASS:
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = k ** 2 * norm
            b1 = 2 * b0
            b2 = b0
            a1 = 2 * (k ** 2 - 1) * norm
            a2 = (1 - k / q_factor + k ** 2) * norm

        elif filter_type == FilterType.DOUBLE_POLE_HIGHPASS:
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = 1 * norm
            b1 = -2 * b0
            b2 = b0
            a1 = 2 * (k ** 2 - 1) * norm
            a2 = (1 - k / q_factor + k ** 2) * norm

        elif filter_type == FilterType.BANDPASS:
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = k / q_factor * norm
            b1 = 0
            b2 = -b0
            a1 = 2 * (k ** 2 - 1) * norm
            a2 = (1 - k / q_factor + k ** 2) * norm

        elif filter_type == FilterType.NOTCH:
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = (1 + k ** 2) * norm
            b1 = 2 * (k ** 2 - 1) * norm
            b2 = b0
            a1 = b1
            a2 = (1 - k / q_factor + k ** 2) * norm

        else:
            raise KeyError(("Unknown filter type {}. Options are : 'lowpass', "
                            "'llowpass', 'highpass', 'hhighpass', 'bandpass', 'notch'").format(filter_type))

        return BiquadFilterCoefficients(b0, b1, b2, a1, a2)

    def apply_filter_settings(self, filter_type: FilterType, center_frequency: float, q_factor: float):
        '''
        Computes and applies filter settings
        '''
        # Calculate coeffs
        biquad_coeffs = self.calculate_biquad_coefficients(filter_type, center_frequency, q_factor)

        # Store values
        self._filter_type = filter_type
        self._center_frequency = center_frequency
        self._q_factor = q_factor

        # Apply settings
        self.write_biquad_coefficients(biquad_coeffs)

    def refresh_filter(self):
        '''
        Clears out contents of shift register in case filter gets stuck in weird mode
        by toggling reinit high
        '''
        self.rp.write_register(self.biquad_registers.reinit, True, dtype=DataType.BOOL)
        self.rp.write_register(self.biquad_registers.reinit, False, dtype=DataType.BOOL)

    @property
    def transfer_function(self):
        '''
        Returns the transfer function of the current parameters
        returns frequencies, amplitudes and phases
        e.g. freq, amp, phase = BiquadFilter.transfer_function
        '''
        normalized_freqs, complex_amplitudes = self.biquad_coefficients.normalized_transfer_function

        # drop DC sample
        return normalized_freqs[1:] * self.fs / (2 * np.pi), \
               np.abs(complex_amplitudes[1:]), \
               np.angle(complex_amplitudes[1:])

    def __str__(self):
        return "{filter_type} filter, freq: {center_freq:.2}kHz, q_factor: {q_factor:.1f}".format(
            filter_type=self.filter_type.value,
            center_freq=self.center_frequency * 1e-3,
            q_factor=self.q_factor
        )
