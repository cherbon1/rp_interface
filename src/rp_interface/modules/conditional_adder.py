from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module


class ConditionalAdder(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to a conditional adder
    This is a very bad interface that doesn't scale, consider rewriting it
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
        self.n_inputs = self.register.n_bits

    def defaults(self):
        pass

    @property
    def add0(self):
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        return bool(int(bits[-1-0]))

    @property
    def add1(self):
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        return bool(int(bits[-1-1]))

    @property
    def add2(self):
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        return bool(int(bits[-1-2]))

    @property
    def add3(self):
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        return bool(int(bits[-1-3]))

    @add0.setter
    def add0(self, value):
        write_bit = '1' if value else '0'
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        write_bits = bits[:-1-0] + write_bit
        self.rp.write_muxed_register_decimal(self.register, int(write_bits, 2))

    @add1.setter
    def add1(self, value):
        write_bit = '1' if value else '0'
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        write_bits = bits[:-1-1] + write_bit + bits[-1-0:]
        self.rp.write_muxed_register_decimal(self.register, int(write_bits, 2))

    @add2.setter
    def add2(self, value):
        write_bit = '1' if value else '0'
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        write_bits = bits[:-1-2] + write_bit + bits[-1-1:]
        self.rp.write_muxed_register_decimal(self.register, int(write_bits, 2))

    @add3.setter
    def add3(self, value):
        write_bit = '1' if value else '0'
        bits = bin(self.rp.read_muxed_register_decimal(self.register)).split('b')[-1]
        write_bits = write_bit + bits[-1-2:]
        self.rp.write_muxed_register_decimal(self.register, int(write_bits, 2))