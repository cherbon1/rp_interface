from typing import Union

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaModule


class GainModule(RedPitayaModule):
    '''
    Defines an interface to fine and coarse gain registers. The fine gain
    multiplies a signal by a range of -0.5 to 0.5 while the coarse gain bitshifts the
    output signal to multiply by powers of 2.
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 fine_gain_register: Union[Register, MuxedRegister],
                 coarse_gain_register: Union[Register, MuxedRegister],
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)\

        self.default_values = {'gain': 1.}

        self._fine_gain_register = fine_gain_register
        self._coarse_gain_register = coarse_gain_register

        self._fine_gain_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._fine_gain_register,
            name='Fine gain',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-0.5 <= val < 0.5),
            write_data=lambda val: int(2**self._fine_gain_register.n_bits * val),
            read_data=lambda reg: reg/2**self._fine_gain_register.n_bits
        )

        max_coarse_gain = int(2 ** (2**self._coarse_gain_register.n_bits - 1))

        self._coarse_gain_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._coarse_gain_register,
            name='Coarse gain',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (1 <= val <= max_coarse_gain),
            write_data=lambda val: int(np.log2(val)),
            read_data=lambda reg: 2**reg
        )

        if apply_defaults:
            self.apply_defaults()

    @property
    def gain(self):
        return self._fine_gain_control.value * self._coarse_gain_control.value

    @gain.setter
    def gain(self, value):
        divider = 1
        while not (-0.5 <= value < 0.5):
            value /= 2.
            divider *= 2
        self._fine_gain_control.value = value
        self._coarse_gain_control.value = divider
