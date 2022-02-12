from abc import ABC, abstractmethod
from dataclasses import dataclass

from rp_interface import utils

import paramiko
import os
import time
import logging

log = logging.getLogger(__name__)

@dataclass
class MuxedRegister:
    gpio_write_address: str
    gpio_read_address: str
    register_address: int
    n_bits: int
    signed_data: bool

    def build_query(self, write=False, data=0):
        # Build write string: write_enable, address bits, data_bits
        write_bit = '1' if self.write else '0'
        address_bits = utils.unsigned_int2bits(self.register_address, n_bits=5)
        data_bits = utils.signed_int2bits(data, 26) if self.signed_data else utils.unsigned_int2bits(data, 26)
        return write_bit + address_bits + data_bits

    def interpret_data(self, gpio_bits):
        data_bits = gpio_bits[-self.n_bits:]

        if self.signed_data:
            return utils.bits2signed_int(data_bits)
        return int(data_bits, 2)



class RedPitaya(ABC):
    '''
    Connects to a Red Pitaya using paramiko.
    Subclasses must provide a bitfile in the bitfiles directory,
    and provide an interface for communicating with the relevant registers
    '''

    def __init__(self, host='red-pitaya-18.ee.ethz.ch', username='root', password='root',
                 load_bitfile=False, apply_defaults=False):

        self.username = username
        self.host = host
        self.password = password

        # SSH setup
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.client.load_system_host_keys()
        self.client.connect(self.host, username=self.username, password=self.password)
        log.info('Connecting to {}@{}'.format(self.username, self.host))

        self.bitfiles_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'bitfiles')

        if load_bitfile:
            self.load_bitfile()

        if apply_defaults:
            self.defaults()

    def __del__(self):
        self.client.close()
        log.info('Closing SSH client for {}@{}'.format(self.username, self.host))

    @property
    @abstractmethod
    def bitfile(self):
        ...

    @property
    @abstractmethod
    def fs(self):
        ...

    @abstractmethod
    def defaults(self):
        ...

    @property
    def bitfile_path(self):
        return os.path.join(self.bitfiles_directory, self.bitfile)

    def exec_command(self, command):
        std_in, std_out, std_err = self.client.exec_command(command)
        std_err = std_err.read()
        if std_err:
            log.error(std_err)
        output = std_out.read().decode().strip()
        log.debug(f'ran command {command}, return value {output}')
        return output

    def read_register(self, address):
        '''
        Reads from a register of the red pitaya
        '''
        return self.exec_command('/opt/redpitaya/bin/monitor {}'.format(address))

    def read_register_bits(self, address, n_bits=32, lsb_location=0):
        '''
        address should be a string, e.g. 0x41200000
        returns a string of bits, of n_bits length
        set n_bits to None to get a string whose length corresponds to hex value length
        n_bits specifies how many bits (starting from lsb_location) should be considered in the
        returned value, defaults to 32 (full width of register)
        '''
        if not 1 <= n_bits <= 32:
            raise ValueError(f'Invalid value {n_bits}. n_bits must be in range 1 to 32')
        if not 0 <= lsb_location <= 31:
            raise ValueError(f'Invalid value {lsb_location}. lsb_location must be in range 0 to 31')
        if n_bits + lsb_location > 32:
            raise ValueError(f'n_bits {n_bits} too large for lsb_location {lsb_location}')

        hex_value = self.read_register(address)
        bin_value = utils.hex2bits(hex_value, 32)
        return bin_value[32 - n_bits - lsb_location:32 - lsb_location]

    def read_register_decimal(self, address, n_bits=32, lsb_location=0):
        '''
        address should be a string, e.g. 0x41200000
        returns a decimal value
        n_bits specifies how many bits (starting from lsb_location) should be considered in the
        returned value, defaults to 32 (full width of register)
        '''
        reg_val = self.read_register_bits(address, n_bits, lsb_location)
        return int(reg_val, 2)

    def write_register(self, address, value):
        '''
        Writes to a register of the red pitaya. This will fully replace the contents of the register.
        If you'd like to only write to a subset of the register, use write_register_bits instead
        address should be a string, e.g. 0x41200000
        '''
        _ = self.exec_command('/opt/redpitaya/bin/monitor {} {}'.format(address, value))

    def write_register_bits(self, address, bits, n_bits=32, lsb_location=0):
        '''
        write a sequence of bits to a register, specify the location of the LSB.
        e.g. write_register_bits(address, '1001', lsb_location=1) will overwrite
        the register bits in locations 4, 3, 2 and 1 with 1, 0, 0 and 1 respectively.
        If e.g. the register contains 10100000, this will be replaced by 10110010
        '''
        # Check inputs
        if not 1 <= n_bits <= 32:
            raise ValueError(f'Invalid value {n_bits}. n_bits must be in range 1 to 32')
        if not 0 <= lsb_location <= 31:
            raise ValueError(f'Invalid value {lsb_location}. lsb_location must be in range 0 to 31')
        if n_bits + lsb_location > 32:
            raise ValueError(f'n_bits {n_bits} too large for lsb_location {lsb_location}')

        # Prepare inputs
        if isinstance(bits, int):
            bits = str(bits)
        bits = bits.split('b')[-1]  # drop '0b' if applicable (don't use rstrip for this, it will drop leading 0s)
        if len(bits) > n_bits:
            log.warning(f'Value {bits} is larger than {n_bits} and will be trimmed')
            bits = bits[-n_bits:]
        if len(bits) < n_bits:
            bits = bits.zfill(n_bits)

        # If writing to a entire register
        if n_bits == 32 and lsb_location == 0:
            self.write_register(address, int(bits, 2))
            return

        # If writing to a sub-section of register, assemble the output based on current values
        full_reg = self.read_register_bits(address)
        new_reg = full_reg[:32 - n_bits - lsb_location] + bits + full_reg[32 - lsb_location:]
        self.write_register(address, int(new_reg, 2))

    def write_register_decimal(self, address, value, n_bits=32, lsb_location=0):
        '''
        Write value to a register.
        n_bits and lsb_location can be specified to choose where value should be
        written in register
        '''
        self.write_register_bits(address, bin(value), n_bits, lsb_location)

    def write_muxed_register_decimal(self, register: MuxedRegister, data: int):
        '''
        Write to a multiplexed GPIO register (via GPIO_mux and GPIO_super_mux instances)
        This build the appropriate 32-bit word from address and data.
        GPIO_address: address of gpio, e.g. 0x41200000
        register_address: address of the sub-register in decimal, can be between 0 and 31
        data: the data to write (in decimal). Must fit in 26 bits
        signed_data: whether the data is signed or not
        '''
        # Build write string
        bits = register.build_query(write=True, data=data)

        # Write to GPIO_address
        self.write_register_bits(register.gpio_write_address, bits, n_bits=32, lsb_location=0)

    def read_muxed_register_decimal(self, register: MuxedRegister):
        '''
        Read from a multiplexed GPIO register (via GPIO_mux and GPIO_super_mux instances)
        '''
        # Build write string and write to write_gpio
        bits = register.build_query(write=False)
        self.write_register_bits(register.gpio_write_address, bits, n_bits=32, lsb_location=0)

        # read result from read_gpio
        bits = self.read_register_bits(register.gpio_read_address, n_bits=32, lsb_location=0)
        return register.interpret_data(bits)

    def load_bitfile(self):
        with self.client.open_sftp() as ftp_client:
            # copy bitfile to /root directory of red pitaya
            ftp_client.put(self.bitfile_path, '/{}/{}'.format(self.username, self.bitfile))

        time.sleep(0.5)
        _ = self.exec_command('cat ./{} > /dev/xdevcfg'.format(self.bitfile))
        time.sleep(0.2)
        log.info('Bitfile loaded')