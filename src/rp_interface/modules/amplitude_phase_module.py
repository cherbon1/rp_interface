from typing import Union

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaModule


class AmplitudePhaseModule(RedPitayaModule):
    '''
    Defines an interface to wa and wb registers (think x and y), and exposes a and phi parameters, the amplitude
    and phase of the reference signal
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 wa_register: Union[Register, MuxedRegister],
                 wb_register: Union[Register, MuxedRegister],
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
            'a': 1.,
            'phi': 0.
        }

        self._wa_register = wa_register
        self._wb_register = wb_register

        self._wa_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._wa_register,
            name='w_a',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(2**(self._wa_register.n_bits-1) * val - 1e-9),
            read_data=lambda reg: reg/2**(self._wa_register.n_bits-1)
        )

        self._wb_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._wb_register,
            name='w_b',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-1 <= val <= 1),
            write_data=lambda val: int(2**(self._wb_register.n_bits-1) * val - 1e-9),
            read_data=lambda reg: reg/2**(self._wb_register.n_bits-1)
        )

        if apply_defaults:
            self.apply_defaults()

    @property
    def a(self):
        return np.sqrt(self._wb_control.value ** 2 + self._wa_control.value ** 2)

    @property
    def phi(self):
        # In degrees
        return np.arctan2(self._wb_control.value, self._wa_control.value) / np.pi * 180

    @a.setter
    def a(self, value):
        a = value
        phi = self.phi / 180 * np.pi
        self._wa_control.value = a * np.cos(phi)
        self._wb_control.value = a * np.sin(phi)

    @phi.setter
    def phi(self, value):
        a = self.a
        phi = value / 180 * np.pi
        self._wa_control.value = a * np.cos(phi)
        self._wb_control.value = a * np.sin(phi)

    def __str__(self):
        return ("Amplitude-phase module:\n"
                "  a: {:.2f}, phi: {:.1f}deg").format(
            self.a,
            self.phi
        )

    def __repr__(self):
        return self.__str__()