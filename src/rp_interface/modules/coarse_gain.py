import numpy as np

from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module


class CoarseGain(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a coarse gain module
    '''

    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 register: red_pitaya_comms.MuxedRegister = None
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        if register is None:
            raise KeyError('Need to define register to communicate with {}'.format(self.__class__.__name__))
        self.register = register
        self.max_gain = int(2 ** (2**self.register.n_bits - 1))

    def defaults(self):
        pass

    @property
    def gain(self):
        val = self.rp.read_muxed_register_decimal(self.register)
        return 2**val

    @gain.setter
    def gain(self, value):
        if not (1 <= value <= self.max_gain):
            raise ValueError('gain {} is out of range [1, {}]'.format(value, self.max_gain))
        # round down to nearest power of two (bitshift amount)
        self.rp.write_muxed_register_decimal(self.register, int(np.log2(value)))
