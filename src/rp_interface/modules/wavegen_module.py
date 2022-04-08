from typing import Union

from rp_interface.modules.gain_module import GainModule
from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaModule


class WavegenModule(RedPitayaModule):
    '''
    Defines an interface to fine and coarse gain registers. The fine gain
    multiplies a signal by a range of -1 to 1 while the coarse gain bitshifts the
    output signal to multiply by powers of 2.
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 frequency_register: Union[Register, MuxedRegister],
                 fine_gain_register: Union[Register, MuxedRegister],
                 coarse_gain_register: Union[Register, MuxedRegister],
                 fs: float,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
            'frequency': 100e3,
            'amplitude': 0.1
        }

        self.fs = fs
        self._frequency_register = frequency_register
        self._fine_gain_register = fine_gain_register
        self._coarse_gain_register = coarse_gain_register

        self._frequency_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._frequency_register,
            name='Frequency',
            dtype=DataType.SIGNED_INT,
            in_range=lambda val: (-self.fs/2 <= val <= self.fs/2),
            write_data=lambda val: int(2**(self._frequency_register.n_bits-1) * val * 2 / self.fs - 1e-9),
            read_data=lambda reg: reg/2**(self._frequency_register.n_bits-1) * self.fs / 2
        )

        self._gain_module = GainModule(
            red_pitaya=self.rp,
            fine_gain_register=self._fine_gain_register,
            coarse_gain_register=self._coarse_gain_register
        )

        if apply_defaults:
            self.apply_defaults()

    @property
    def frequency(self):
        return self._frequency_control.value

    @frequency.setter
    def frequency(self, value):
        self._frequency_control.value = value

    @property
    def amplitude(self):
        return self._gain_module.gain / 2

    @amplitude.setter
    def amplitude(self, value):
        self._gain_module.gain = 2 * value
