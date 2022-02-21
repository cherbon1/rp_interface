
from rp_interface.modules import red_pitaya_module
from rp_interface import red_pitaya_comms
import logging

log = logging.getLogger(__name__)


class Mux(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a multiplexer
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
        self.max_val = int(2**self.register.n_bits - 1)

    def defaults(self):
        pass

    @property
    def select(self):
        return self.rp.read_muxed_register_decimal(self.register)

    @select.setter
    def select(self, value):
        if not (0 <= value <= self.max_val):
            raise ValueError('Multiplexer value {} is out of range [0, {}]'.format(value, self.max_val))
        self.rp.write_muxed_register_decimal(self.register, int(value))


class BooleanMux(Mux):
    '''
    Interface with 1-bit mux with a boolean value instead
    '''
    @property
    def select(self):
        return bool(self.rp.read_muxed_register_decimal(self.register))

    @select.setter
    def select(self, value):
        self.rp.write_muxed_register_decimal(self.register, int(bool(value)))
