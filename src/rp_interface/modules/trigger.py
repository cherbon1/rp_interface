
from rp_interface.modules import red_pitaya_module
from rp_interface import red_pitaya_comms
import logging

log = logging.getLogger(__name__)


class Trigger(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a trigger
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

    def trigger_now(self):
        self.rp.write_muxed_register_decimal(self.register, 0)
        self.rp.write_muxed_register_decimal(self.register, 1)
        self.rp.write_muxed_register_decimal(self.register, 0)
