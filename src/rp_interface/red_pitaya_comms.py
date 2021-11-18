from abc import ABC, abstractmethod
from rp_interface import utils

import paramiko
import os
import time
import logging

log = logging.getLogger(__name__)


class RedPitaya(ABC):
    '''
    Connects to a Red Pitaya using paramiko.
    Subclasses should provide a bitfile in the bitfiles directory,
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
        bin_value = utils.hex2bits(hex_value, n_bits)
        return bin_value[32 - n_bits:32 - lsb_location]

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

        # If writing to a entire register
        if n_bits == 32 and lsb_location == 0:
            self.write_register(address, int(bits, 2))
            return

        # If writing to a sub-section of register, assemble the output based on current values
        full_reg = self.read_register_bits(address)
        new_reg = '0b' + full_reg[:32 - n_bits - lsb_location] + bits + full_reg[32 - lsb_location:]
        self.write_register(address, new_reg)

    def write_register_decimal(self, address, value, n_bits=32, lsb_location=0):
        '''
        Write value to a register.
        n_bits and lsb_location can be specified to choose where value should be
        written in register
        '''
        self.write_register_bits(address, bin(value), n_bits, lsb_location)

    def load_bitfile(self):
        with self.client.open_sftp() as ftp_client:
            # copy bitfile to /root directory of red pitaya
            ftp_client.put(self.bitfile_path, '/{}/{}'.format(self.username, self.bitfile))

        time.sleep(0.5)
        _ = self.exec_command('cat ./{} > /dev/xdevcfg'.format(self.bitfile))
        time.sleep(0.2)
        log.info('Bitfile loaded')
