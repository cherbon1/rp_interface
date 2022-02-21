from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module


class TriggeredToggle(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a triggered toggle
    '''

    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 delay_register: red_pitaya_comms.MuxedRegister = None,
                 active_register: red_pitaya_comms.MuxedRegister = None,
                 fs: float = 125e6
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        if delay_register is None:
            raise KeyError('Need to define delay_register to communicate with {}'.format(self.__class__.__name__))
        self.delay_register = delay_register
        self.max_delay_cycles = int(2**self.delay_register.n_bits - 1)

        if active_register is None:
            raise KeyError('Need to define active_register to communicate with {}'.format(self.__class__.__name__))
        self.active_register = active_register
        self.max_active_cycles = int(2**self.active_register.n_bits - 1)

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
    def toggle_time(self):
        return self.active_cycles / self.fs

    @toggle_time.setter
    def toggle_time(self, value):
        self.active_cycles = int(value * self.fs)

    @property
    def delay_cycles(self):
        return self.rp.read_muxed_register_decimal(self.delay_register)

    @delay_cycles.setter
    def delay_cycles(self, value):
        if not (0 <= value <= self.max_delay_cycles):
            raise ValueError('Delay cycles {} not in range [0, {}]'.format(value, self.max_delay_cycles))
        self.rp.write_muxed_register_decimal(self.delay_register, value)

    @property
    def active_cycles(self):
        return self.rp.read_muxed_register_decimal(self.active_register)

    @active_cycles.setter
    def active_cycles(self, value):
        if not (0 <= value <= self.max_active_cycles):
            raise ValueError('Active cycles {} not in range [0, {}]'.format(value, self.max_active_cycles))
        self.rp.write_muxed_register_decimal(self.active_register, value)
