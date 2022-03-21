import enum
import logging
from dataclasses import dataclass
from typing import Union

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
    LOWPASS = 'lowpass'
    SECOND_ORDER_LOWPASS = 'llowpass'
    HIGHPASS = 'highpass'
    SECOND_ORDER_HIGHPASS = 'hhighpass'
    BANDPASS = 'bandpass'
    NOTCH = 'notch'
    ALLPASS = 'allpass'

    def __eq__(self, other):
        '''
        Override equality operator such that == value also returns true
        Example:
            FilterType.LOWPASS == 'lowpass' --> True
            FilterType.LOWPASS == FilterType.LOWPASS --> True
            'lowpass' == FilterType.LOWPASS --> True
        '''
        if isinstance(other, str):
            return self.value == other
        return super().__eq__(other)

    @classmethod
    def all_filter_types_string(cls):
        return ', '.join("'" + a.value + "'" for a in cls if a != 'unknown')


class BiquadFilterModule(RedPitayaModule):
    '''
    Implements an interface to a biquad filter module
    '''

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 biquad_registers: BiquadFilterRegisters = None,
                 fs: float = 125e6 / 2 ** 3,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
            'filter_type': FilterType.ALLPASS
        }

        if biquad_registers is None:
            raise KeyError('Need to define addresses to communicate with biquad filter')
        self.biquad_registers = biquad_registers

        # Define values for coefficient manipulation
        self._fs = fs
        self._n_bits = self.biquad_registers.b0.n_bits
        self._bitshift = self._n_bits - 2

        # Define parameters
        self._filter_type = FilterType.UNKNOWN
        self._frequency = None
        self._q_factor = None

        if apply_defaults:
            self.apply_defaults()

    @property
    def filter_type(self):
        return self._filter_type

    @filter_type.setter
    def filter_type(self, value: FilterType):
        # raise RuntimeError("Can't set filter type directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=value,
                                   frequency=self.frequency,
                                   q_factor=self.q_factor)

    @property
    def frequency(self):
        return self._frequency

    @frequency.setter
    def frequency(self, value: float):
        # raise RuntimeError("Can't set frequency directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=self.filter_type,
                                   frequency=value,
                                   q_factor=self.q_factor)

    @property
    def q_factor(self):
        return self._q_factor

    @q_factor.setter
    def q_factor(self, value: float):
        # raise RuntimeError("Can't set q_factor directly, use BiquadFilter.apply_filter_settings() instead")
        self.apply_filter_settings(filter_type=self.filter_type,
                                   frequency=self.frequency,
                                   q_factor=value)

    @property
    def biquad_coefficients(self):
        factor = 2 ** self._bitshift
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
        scaled_coeffs = coefficients.get_bitshifted_coefficients(self._bitshift)
        self.rp.write_register(self.biquad_registers.b0, scaled_coeffs.b0, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.b1, scaled_coeffs.b1, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.b2, scaled_coeffs.b2, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.a1, scaled_coeffs.a1, dtype=DataType.SIGNED_INT)
        self.rp.write_register(self.biquad_registers.a2, scaled_coeffs.a2, dtype=DataType.SIGNED_INT)

    # Supress inspection b.c. it's wrong about scipy.butter
    # noinspection PyTupleAssignmentBalance
    def calculate_biquad_coefficients(self,
                                      filter_type: FilterType,
                                      frequency: float = None,
                                      q_factor: float = None):
        '''
        Calculate filter parameters based on type, frequency and q_factor
        This is copied from the cryolev calcBiquad function, which itself is copied from
        http://www.earlevel.com/scripts/widgets/20131013/biquads2.js
        Note that the labels for b and a were swapped to match literature

        However, the lowpass and highpass filters seem to be implemented incorrectly, so I replaced them
        with functions from scipy. I'm only keeping the notch and bandpass implementations
        from that file, because they seem to work, and I don't want to deal with them right now
        '''
        if frequency is not None:
            if frequency <= 0:
                raise ValueError('Frequency should be positive')
            elif frequency >= self._fs / 2:
                raise ValueError('Frequency {:.2f}MHz is above Nyquist '
                                 'frequency {:.2f}MHz'.format(frequency * 1e-6, self._fs / 2 * 1e-6))

        if filter_type == FilterType.LOWPASS:
            if frequency is None:
                raise KeyError('Must specify cutoff frequency of first order lowpass filter')
            b, a = signal.butter(1, frequency, btype='lowpass', fs=self._fs, output='ba')
            b = (b[0], b[1], 0)
            a = (a[0], a[1], 0)

        elif filter_type == FilterType.HIGHPASS:
            if frequency is None:
                raise KeyError('Must specify cutoff frequency of first order highpass filter')
            b, a = signal.butter(1, frequency, btype='highpass', fs=self._fs, output='ba')
            b = (b[0], b[1], 0)
            a = (a[0], a[1], 0)

        elif filter_type == FilterType.SECOND_ORDER_LOWPASS:
            if frequency is None:
                raise KeyError('Must specify cutoff frequency of second order lowpass filter')
            b, a = signal.butter(2, frequency, btype='lowpass', fs=self._fs, output='ba')

        elif filter_type == FilterType.SECOND_ORDER_HIGHPASS:
            if frequency is None:
                raise KeyError('Must specify cutoff frequency of second order highpass filter')
            b, a = signal.butter(2, frequency, btype='highpass', fs=self._fs, output='ba')

        elif filter_type == FilterType.BANDPASS:
            if frequency is None:
                raise KeyError('Must specify center frequency of bandpass filter')
            if q_factor is None:
                raise KeyError('Must specify Q-factor of bandpass filter')
            k = np.tan(np.pi * frequency / self._fs)
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = k / q_factor * norm
            a1 = 2 * (k ** 2 - 1) * norm
            a2 = (1 - k / q_factor + k ** 2) * norm
            b = (b0, 0, -b0)
            a = (1, a1, a2)

        elif filter_type == FilterType.NOTCH:
            if frequency is None:
                raise KeyError('Must specify center frequency of notch filter')
            if q_factor is None:
                raise KeyError('Must specify Q-factor of notch filter')
            k = np.tan(np.pi * frequency / self._fs)
            norm = 1 / (1 + k / q_factor + k ** 2)
            b0 = (1 + k ** 2) * norm
            b1 = 2 * (k ** 2 - 1) * norm
            b2 = b0
            a1 = b1
            a2 = (1 - k / q_factor + k ** 2) * norm
            b = (b0, b1, b2)
            a = (1, a1, a2)

        elif filter_type == FilterType.ALLPASS:
            b = (1, 0, 0)
            a = (1, 0, 0)

        else:
            raise KeyError("Unknown filter type {}. Options are : {}".format(
                filter_type,
                FilterType.all_filter_types_string()
            ))

        return BiquadFilterCoefficients(b[0], b[1], b[2], a[1], a[2])

    def apply_filter_settings(self,
                              filter_type: FilterType,
                              frequency: float = None,
                              q_factor: float = None
                              ):
        '''
        Computes and applies filter settings
        '''
        # Calculate coeffs
        biquad_coeffs = self.calculate_biquad_coefficients(filter_type, frequency, q_factor)

        # Once coeffs are successful, store values
        if isinstance(filter_type, str):
            self._filter_type = FilterType(filter_type)
        else:
            self._filter_type = filter_type
        self._frequency = frequency
        self._q_factor = q_factor

        # Apply settings and refresh filter
        self.write_biquad_coefficients(biquad_coeffs)
        self.refresh_filter()

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
        return normalized_freqs[1:] * self._fs / (2 * np.pi), \
               np.abs(complex_amplitudes[1:]), \
               np.angle(complex_amplitudes[1:])

    def __str__(self):
        if self.filter_type in [FilterType.UNKNOWN, FilterType.ALLPASS]:
            return f"{self.filter_type.value}"
        elif self.filter_type not in [FilterType.BANDPASS, FilterType.NOTCH]:
            return f"{self.filter_type.value}, freq: {self.frequency * 1e-3:.2f}kHz"
        return f"{self.filter_type.value}, freq: {self.frequency * 1e-3:.2f}kHz, Q: {self.q_factor:.1f}"

    def __repr__(self):
        return self.__str__()


if __name__ == "__main__":
    print(FilterType.all_filter_types_string())
    print('lowpass' in [FilterType.LOWPASS])
