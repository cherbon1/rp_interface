from typing import Union

from rp_interface.modules.gain_module import GainModule
from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaModule


class WavegenModule(RedPitayaModule):
    '''
    Defines an interface to a wavegen module (a dds compiler and a gain module)
    '''
    _parameters = {
        'frequency': '_frequency_parameter.value',
        'amplitude': '_raw_amplitude',
    }
    _submodules = []

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 frequency_register: Union[Register, MuxedRegister],
                 fine_gain_register: Union[Register, MuxedRegister],
                 coarse_gain_register: Union[Register, MuxedRegister],
                 fs: float
                 ):
        super().__init__(red_pitaya=red_pitaya)

        self.fs = fs
        self._frequency_register = frequency_register
        self._fine_gain_register = fine_gain_register
        self._coarse_gain_register = coarse_gain_register

        self._frequency_parameter = RedPitayaParameter(
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

    @property
    def _raw_amplitude(self):
        return self._gain_module.gain / 2

    @_raw_amplitude.setter
    def _raw_amplitude(self, value):
        self._gain_module.gain = 2 * value
