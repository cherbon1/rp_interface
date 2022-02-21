import enum
import logging
from dataclasses import dataclass
from typing import Union

import numpy as np
import scipy.signal as signal

from rp_interface.modules import red_pitaya_module
from rp_interface import red_pitaya_comms

log = logging.getLogger(__name__)


@dataclass
class BiquadFilterRegisters:
    a1: red_pitaya_comms.MuxedRegister
    a2: red_pitaya_comms.MuxedRegister
    b0: red_pitaya_comms.MuxedRegister
    b1: red_pitaya_comms.MuxedRegister
    b2: red_pitaya_comms.MuxedRegister

    def __init__(self, gpio_write_address, gpio_read_address, b0_address, b1_address, b2_address,
                 a1_address, a2_address, n_bits=26):

        self.a1 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a1_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.a2 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a2_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b0 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b0_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b1 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b1_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b2 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b2_address,
            n_bits=n_bits,
            signed_data=True
        )


@dataclass
class BiquadFilterCoefficients:
    '''
    stores biquad filter coefficients as numbers
    '''
    b0: float
    b1: float
    b2: float
    a1: float
    a2: float

    def get_bitshifted_coefficients(self, bitshift=24):
        '''
        Rescales by 2**bitshift and casts to int.
        Useful for writing values to registers
        Returns a new instance of BiquadFilterCoefficients
        '''
        factor = 2**bitshift
        return BiquadFilterCoefficients(int(self.b0*factor),
                                        int(self.b1*factor),
                                        int(self.b2*factor),
                                        int(self.a1*factor),
                                        int(self.a2*factor))

    def get_quantized_coefficients(self, bitshift=24):
        '''
        Returns a quantized copy of the coefficients. Useful to check for rounding errors.
        Coefficients are quantized by bitshifting by specified amount, casting to int and bitshifting back
        Returns a new instance of BiquadFilterCoefficients
        '''
        factor = 2**bitshift
        return BiquadFilterCoefficients(int(self.b0*factor) / bitshift,
                                        int(self.b1*factor) / bitshift,
                                        int(self.b2*factor) / bitshift,
                                        int(self.a1*factor) / bitshift,
                                        int(self.a2*factor) / bitshift)

    @property
    def normalized_transfer_function(self):
        return signal.freqz((self.b0, self.b1, self.b2), (1, self.a1, self.a2))


class Filter(enum.Enum):
    UNKNOWN = enum.auto()
    SINGLE_POLE_LOWPASS = enum.auto()
    DOUBLE_POLE_LOWPASS = enum.auto()
    SINGLE_POLE_HIGHPASS = enum.auto()
    DOUBLE_POLE_HIGHPASS = enum.auto()
    BANDPASS = enum.auto()
    NOTCH = enum.auto()


class BiquadFilter(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a biquad filter module
    '''
    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 registers: BiquadFilterRegisters = None,
                 fs: float = 125e6/1024,
                 n_bits: float = 26
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        if registers is None:
            raise KeyError('Need to define addresses to communicate with biquad filter')
        self.registers = registers

        self.fs = fs
        self.n_bits = n_bits
        self.bitshift = n_bits - 2

        self._filter_type = Filter.UNKNOWN
        self._center_frequency = 0
        self._q_factor = 0

    def defaults(self):
        pass

    @property
    def filter_type(self):
        return self._filter_type

    @filter_type.setter
    def filter_type(self, value: Filter):
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
        factor = 2**self.bitshift
        b0 = self.rp.read_muxed_register_decimal(self.registers.b0)
        b1 = self.rp.read_muxed_register_decimal(self.registers.b1)
        b2 = self.rp.read_muxed_register_decimal(self.registers.b2)
        a1 = self.rp.read_muxed_register_decimal(self.registers.a1)
        a2 = self.rp.read_muxed_register_decimal(self.registers.a2)
        return BiquadFilterCoefficients(b0/factor,
                                        b1/factor,
                                        b2/factor,
                                        a1/factor,
                                        a2/factor)

    def write_biquad_coefficients(self, coefficients: BiquadFilterCoefficients):
        '''
        Writes the contents of BiquadFilterCoefficients to self.registers
        Coefficients should not be rescaled yet
        '''
        scaled_coeffs = coefficients.get_bitshifted_coefficients(self.bitshift)
        self.rp.write_muxed_register_decimal(self.registers.b0, scaled_coeffs.b0)
        self.rp.write_muxed_register_decimal(self.registers.b1, scaled_coeffs.b1)
        self.rp.write_muxed_register_decimal(self.registers.b2, scaled_coeffs.b2)
        self.rp.write_muxed_register_decimal(self.registers.a1, scaled_coeffs.a1)
        self.rp.write_muxed_register_decimal(self.registers.a2, scaled_coeffs.a2)

    def calculate_biquad_coefficients(self, filter_type: Filter, center_frequency: float, q_factor: float):
        '''
        Calculate filter parameters based on type, center_frequency and q_factor
        '''
        if not(0 < center_frequency < self.fs):
            raise ValueError('Center frequency {:.2f} is out of range (0, {:.2f})'.format(center_frequency, self.fs))
        k = np.tan(np.pi * center_frequency / self.fs)
        if filter_type == Filter.SINGLE_POLE_LOWPASS:
            a1 = np.exp(-2.0 * np.pi * (center_frequency / self.fs))
            b0 = 1.0 - a1
            a1 = -a1
            b1 = b2 = a2 = 0

        elif filter_type == Filter.SINGLE_POLE_HIGHPASS:
            a1 = -np.exp(-2.0 * np.pi * (0.5 - center_frequency / self.fs))
            b0 = 1.0 + a1
            a1 = -a1
            b1 = b2 = a2 = 0

        elif filter_type == Filter.DOUBLE_POLE_LOWPASS:
            norm = 1 / (1 + k / q_factor + k**2)
            b0 = k**2 * norm
            b1 = 2 * b0
            b2 = b0
            a1 = 2 * (k**2 - 1) * norm
            a2 = (1 - k / q_factor + k**2) * norm

        elif filter_type == Filter.DOUBLE_POLE_HIGHPASS:
            norm = 1 / (1 + k / q_factor + k**2)
            b0 = 1 * norm
            b1 = -2 * b0
            b2 = b0
            a1 = 2 * (k**2 - 1) * norm
            a2 = (1 - k / q_factor + k**2) * norm

        elif filter_type == Filter.BANDPASS:
            norm = 1 / (1 + k / q_factor + k**2)
            b0 = k / q_factor * norm
            b1 = 0
            b2 = -b0
            a1 = 2 * (k**2 - 1) * norm
            a2 = (1 - k / q_factor + k**2) * norm

        elif filter_type == Filter.NOTCH:
            norm = 1 / (1 + k / q_factor + k**2)
            b0 = (1 + k**2) * norm
            b1 = 2 * (k**2 - 1) * norm
            b2 = b0
            a1 = b1
            a2 = (1 - k / q_factor + k**2) * norm

        else:
            raise KeyError("Unknown filter type {}".format(filter_type))

        return BiquadFilterCoefficients(b0, b1, b2, a1, a2)

    def apply_filter_settings(self, filter_type: Filter, center_frequency: float, q_factor: float):
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

    @property
    def transfer_function(self):
        '''
        Returns the transfer function of the current parameters
        returns frequencies, amplitudes and phases
        e.g. freq, amp, phase = BiquadFilter.transfer_function
        '''
        normalized_freqs, complex_amplitudes = self.biquad_coefficients.normalized_transfer_function

        # drop DC sample
        return normalized_freqs[1:] * self.fs / (2*np.pi), \
               np.abs(complex_amplitudes[1:]), \
               np.angle(complex_amplitudes[1:])
