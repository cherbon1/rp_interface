from dataclasses import dataclass
from rp_interface import utils

import logging

log = logging.getLogger(__name__)


@dataclass(frozen=True)
class Register:
    '''
    Describes a location of a regular register of an AXI-GPIO block.
    '''
    gpio_address: str
    n_bits: int = 32
    lsb_location: int = 0
    is_shared: bool = True  # States whether there's other data on this same register. If not, read/write can be sped up

    def __post_init__(self):
        # Check register size
        if not 1 <= self.n_bits <= 32:
            raise ValueError(f'Invalid value {self.n_bits}. Register.n_bits must be in range 1 to 32')
        if not 0 <= self.lsb_location <= 31:
            raise ValueError(f'Invalid value {self.lsb_location}. Register.lsb_location must be in range 0 to 31')
        if self.n_bits + self.lsb_location > 32:
            raise ValueError(f'n_bits {self.n_bits} too large for lsb_location {self.lsb_location}')

    def build_data_bus_bits(self, data=0, dtype=utils.DataType.UNSIGNED_INT, old_register=None):
        '''
        Convert data to bits according to dtype, and prepare the value for writing to a Register
        By default, will write data to the n_bits starting at lsb_location and set the rest to 0.
        However, if data is present in the register that shouldn't be changed, the full register contents
        can be passed to old_register in bits form.
        '''
        bits = utils.any2bits(data, dtype, self.n_bits)

        # If writing to an entire register
        if self.n_bits == 32 and self.lsb_location == 0:
            return bits

        # If writing to a subsection of register, assemble the output based on current values
        if not old_register:
            old_register = 32 * '0'
        if len(old_register) != 32:
            raise ValueError(f'Invalid old_register length {len(old_register)}, should be 32')
        new_reg = old_register[:32 - self.n_bits - self.lsb_location] + bits + old_register[32 - self.lsb_location:]
        return new_reg

    def interpret_data(self, gpio_bus_bits, dtype=utils.DataType.UNSIGNED_INT):
        '''
        Picks out the relevant bits from gpio_bus_bits and interprets them as is relevant.
        Returns int or bool
        '''
        if len(gpio_bus_bits) != 32:
            raise ValueError(f'Invalid gpio_bus_bits length {len(gpio_bus_bits)}, should be 32')
        bits = gpio_bus_bits[32 - self.n_bits - self.lsb_location:32 - self.lsb_location]

        return utils.bits2any(bits, dtype)


@dataclass(frozen=True)
class MuxedRegister:
    '''
    Describes the contents of a multiplexed register where a single GPIO block
    can be used to write many parameters to the configuration
    '''
    gpio_write_address: str
    gpio_read_address: str
    register_address: int
    n_bits: int = 26
    lsb_location: int = 0
    is_shared: bool = True

    def __post_init__(self):
        # Check register size
        if not 1 <= self.n_bits <= 26:
            raise ValueError(f'Invalid value {self.n_bits}. Register.n_bits must be in range 1 to 26')
        if not 0 <= self.lsb_location <= 25:
            raise ValueError(f'Invalid value {self.lsb_location}. Register.lsb_location must be in range 0 to 25')
        if self.n_bits + self.lsb_location > 26:
            raise ValueError(f'n_bits {self.n_bits} too large for lsb_location {self.lsb_location}')

    @property
    def address_bits(self):
        return utils.unsigned_int2bits(self.register_address, n_bits=5)

    def read_query_bits(self):
        '''
        Build a data bus with write_bit low and data bits set to 0
        '''
        write_bit = '0'
        address_bits = utils.unsigned_int2bits(self.register_address, n_bits=5)
        data_bits = 26 * '0'
        return write_bit + address_bits + data_bits

    def build_data_bus_bits(self, write=False, data=0, dtype=utils.DataType.UNSIGNED_INT, old_register=None):
        '''
        Convert data to bits according to dtype, and prepare the value for writing to a MuxedRegister
        By default, will write data to the n_bits starting at lsb_location and set the rest to 0.
        However, if data is present in the register that shouldn't be changed, the full register contents
        can be passed to old_register in bits form.
        '''
        bits = utils.any2bits(data, dtype, self.n_bits)

        # If writing to an entire register
        if self.n_bits == 26 and self.lsb_location == 0:
            write_bit = '1' if write else '0'
            return write_bit + self.address_bits + bits

        # If writing to a subsection of register, assemble the output based on current values
        if not old_register:
            old_register = 26 * '0'
        if len(old_register) != 26:
            raise ValueError(f'Invalid old_register length {len(old_register)}, should be 26')
        new_reg = old_register[:26 - self.n_bits - self.lsb_location] + bits + old_register[26 - self.lsb_location:]

        write_bit = '1' if write else '0'
        return write_bit + self.address_bits + new_reg

    def interpret_data(self, gpio_bus_bits, dtype=utils.DataType.UNSIGNED_INT):
        '''
        Picks out the relevant bits from gpio_bus_bits and interprets them as is relevant.
        Returns int or bool
        '''
        if len(gpio_bus_bits) != 32:
            raise ValueError(f'Invalid gpio_bus_bits length {len(gpio_bus_bits)}, should be 32')
        bits = gpio_bus_bits[32 - self.n_bits - self.lsb_location:32 - self.lsb_location]

        return utils.bits2any(bits, dtype)
