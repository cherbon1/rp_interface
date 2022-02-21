from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module


class FineGain(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a fine gain module
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

    def defaults(self):
        pass

    @property
    def gain(self):
        val = self.rp.read_muxed_register_decimal(self.register)
        return val / 2**self.register.n_bits

    @gain.setter
    def gain(self, value):
        if not (-0.5 <= value < 0.5):
            raise ValueError('gain {} is out of range [-0.5, 0.5)'.format(value))
        self.rp.write_muxed_register_decimal(self.register, int(2**self.register.n_bits * value))