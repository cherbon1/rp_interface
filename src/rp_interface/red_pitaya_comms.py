from abc import ABC, abstractmethod

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
        return std_out.read().decode().strip()

    @staticmethod
    def bin2hex(bin_value):
        '''
        takes a binary value (e.g. '0b10011010' or '10011010')
        and converts it to hex (e.g. '0x9a')
        '''
        if bin_value.starswith('0b'):
            return int(bin_value, 2)
        return hex(int('0b{}'.format(bin_value), 2))

    @staticmethod
    def hex2bits(hex_value, n_bits=None):
        '''
        takes a hex value (e.g. '0x9a')
        and converts it to a sequence of bits (e.g. '10011010')

        keeps only the n_bits LSBs.
        If n_bits is larger than the corresponding input hex value, pads with zeros instead
        '''
        len_hex_value = 4 * len(hex_value.split('x')[-1])
        if not n_bits:
            n_bits = len_hex_value
        if n_bits > len_hex_value:
            len_hex_value = n_bits
        return bin(int(hex_value, 16)).split('b')[-1].zfill(len_hex_value)[len_hex_value - n_bits:]

    @staticmethod
    def hex2bin(hex_value, n_bits=None):
        '''
        takes a hex value (e.g. '0x9a')
        and converts it to a sequence of bits (e.g. '0b10011010')

        keeps only the n_bits LSBs.
        If n_bits is larger than the corresponding input hex value, pads with zeros instead
        '''
        len_hex_value = 4 * len(hex_value.split('x')[-1])
        if not n_bits:
            n_bits = len_hex_value
        if n_bits > len_hex_value:
            len_hex_value = n_bits
        return '0b' + bin(int(hex_value, 16)).split('b')[-1].zfill(len_hex_value)[len_hex_value - n_bits:]

    def read_register_decimal(self, address, n_bits=32):
        '''
        address should be a string, e.g. 0x41200000
        returns a decimal value
        n_bits specifies how many bits (starting from LSB) should be considered in the
        returned value, defaults to 32 (full width of register)
        '''
        hex_value = self.exec_command('/opt/redpitaya/bin/monitor {}'.format(address))
        if n_bits >= 32:
            return int(hex_value, 16)
        bin_value = self.hex2bits(hex_value, n_bits=32)
        return int(bin_value[32 - n_bits:], 2)

    def read_register_bits(self, address, n_bits=32):
        '''
        address should be a string, e.g. 0x41200000
        returns a string of bits, of n_bits length
        set n_bits to None to get a string whose length corresponds to hex value length
        n_bits specifies how many bits (starting from LSB) should be considered in the
        returned value, defaults to 32 (full width of register)
        '''
        hex_value = self.exec_command('/opt/redpitaya/bin/monitor {}'.format(address))
        return self.hex2bits(hex_value, n_bits)

    def write_register(self, address, value):
        '''address should be a string, e.g. 0x41200000'''
        _ = self.exec_command('/opt/redpitaya/bin/monitor {} {}'.format(address, value))

    def write_register_bits(self, address, bits, lsb_location=0):
        '''
        write a sequence of bits to a register, specify the location of the LSB.
        e.g. write_register_bits(address, '1001', lsb_location=1) will overwrite
        the register bits in locations 4, 3, 2 and 1 with 1, 0, 0 and 1 respectively.
        If e.g. the register contains 10100000, this will be replaced by 10110010
        '''
        full_reg = self.read_register_bits(address)
        if isinstance(bits, int):
            bits = str(bits)
        bits = bits.split('b')[-1]  # drop '0b' if applicable (don't use rstrip for this, it will drop leading 0s)
        if len(bits) + lsb_location > len(full_reg):
            raise ValueError(f'Bits {bits} too long to fit in register {full_reg} at LSB location {lsb_location}')
        new_reg = '0b' + full_reg[:32 - len(bits) - lsb_location] + bits + full_reg[32 - lsb_location:]
        self.write_register(address, new_reg)

    def load_bitfile(self):
        with self.client.open_sftp() as ftp_client:
            ftp_client.put(self.bitfile_path, '/{}/{}'.format(self.username, self.bitfile))
            # copy bitfile to /root directory of red pitaya

        time.sleep(0.5)
        _ = self.exec_command('cat ./{} > /dev/xdevcfg'.format(self.bitfile))
        time.sleep(0.2)
        log.info('Bitfile loaded')
