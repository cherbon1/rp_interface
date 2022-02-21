from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module


class Delay(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a delay line
    '''

    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 register: red_pitaya_comms.MuxedRegister = None,
                 fs: float = 125e6
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        if register is None:
            raise KeyError('Need to define register to communicate with {}'.format(self.__class__.__name__))
        self.register = register
        self.max_cycles = int(2**self.register.n_bits - 1)

        self.fs = fs

    def defaults(self):
        pass

    @property
    def delay(self):
        return self.delay_cycles / self.fs

    @delay.setter
    def delay(self, value):
        self.delay_cycles = int(value * self.fs)

    @property
    def delay_cycles(self):
        return self.rp.read_muxed_register_decimal(self.register)

    @delay_cycles.setter
    def delay_cycles(self, value):
        if not (0 <= value <= self.max_cycles):
            raise ValueError('Delay cycles {} not in range [0, {}]'.format(value, self.register))
        self.rp.write_muxed_register_decimal(self.register, value)