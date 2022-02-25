from typing import Union, Any

from rp_interface import utils

import paramiko
import os
import time
import logging

from rp_interface.red_pitaya_register import Register, MuxedRegister

log = logging.getLogger(__name__)

class RedPitaya:
    '''
    Connects to a Red Pitaya using paramiko
    e.g. RedPitaya(host='red-pitaya-18.ee.ethz.ch')

    Handles communication with the red pitaya via ssh and reading and writing to registers
    '''

    def __init__(self, host: str = 'red-pitaya-18.ee.ethz.ch', username: str = 'root', password: str = 'root'):

        self.username = username
        self.host = host
        self.password = password

        # SSH setup
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.client.load_system_host_keys()
        self.client.connect(self.host, username=self.username, password=self.password)
        log.info('Connecting to {}@{}'.format(self.username, self.host))

    def __del__(self):
        self.client.close()
        log.info('Closing SSH client for {}@{}'.format(self.username, self.host))

    # =======================================
    # ==========  BITFILE RELATED  ==========
    # =======================================

    def load_bitfile(self, bitfile_path):
        bitfile = os.path.basename(bitfile_path)
        with self.client.open_sftp() as ftp_client:
            # copy bitfile to /root directory of red pitaya
            ftp_client.put(bitfile_path, '/{}/{}'.format(self.username, bitfile))

        time.sleep(0.5)
        _ = self.exec_command('cat ./{} > /dev/xdevcfg'.format(bitfile))
        time.sleep(0.2)
        log.info('Bitfile loaded')

    # ========================================
    # ==  HIGH-LEVEL READ/WRITE OPERATIONS  ==
    # ========================================
    def write_register(self,
                       register: Union[Register, MuxedRegister],
                       data: Any,
                       dtype: utils.DataType = utils.DataType.UNSIGNED_INT):
        # Read old register
        old_register = self.read_register_bits(register)
        if isinstance(register, Register):
            bits = register.build_data_bus_bits(data=data, dtype=dtype, old_register=old_register)
            self._write_register_bits(register.gpio_address, bits)
            return
        elif isinstance(register, MuxedRegister):
            old_register = old_register[-26:]  # Trim down old_register to data_bits only
            buffer_bits = register.build_data_bus_bits(write=False, data=data, dtype=dtype, old_register=old_register)
            write_bits = register.build_data_bus_bits(write=True, data=data, dtype=dtype, old_register=old_register)
            # Write to bus by toggling write_bit high
            self._write_register_bits(register.gpio_write_address, buffer_bits)
            self._write_register_bits(register.gpio_write_address, write_bits)
            self._write_register_bits(register.gpio_write_address, buffer_bits)
            return
        else:
            raise ValueError(f'Invalid register {register}')

    def read_register_bits(self, register: Union[Register, MuxedRegister]) -> str:
        if isinstance(register, Register):
            return self._read_register_bits(register.gpio_address)
        elif isinstance(register, MuxedRegister):
            self._write_register_bits(register.gpio_write_address, register.read_query_bits())
            return self._read_register_bits(register.gpio_read_address)
        else:
            raise ValueError(f'Invalid register {register}')

    def read_register(self, register: Union[Register, MuxedRegister],
                      dtype: utils.DataType = utils.DataType.UNSIGNED_INT) -> Union[str, int]:
        return register.interpret_data(gpio_bus_bits=self.read_register_bits(register), dtype=dtype)

    # =======================================
    # ==========  LOW LEVEL COMMS  ==========
    # =======================================
    def exec_command(self, command):
        std_in, std_out, std_err = self.client.exec_command(command)
        std_err = std_err.read()
        if std_err:
            log.error(std_err)
        output = std_out.read().decode().strip()
        log.debug(f'ran command {command}, return value {output}')
        return output

    # =======================================
    # ===  LOW-LEVEL READ FROM REGISTERS  ===
    # =======================================
    def _read_register(self, address):
        '''
        Reads from a register of the red pitaya
        address should be a string, e.g. 0x41200000
        '''
        return self.exec_command('/opt/redpitaya/bin/monitor {}'.format(address))

    def _read_register_bits(self, address):
        '''
        Reads from a register of the red pitaya
        address should be a string, e.g. 0x41200000
        returns full register as string of bits
        e.g. '00011000100110000000100011000010'
        '''
        hex_value = self._read_register(address)
        return utils.hex2bits(hex_value, 32)

    def _read_register_decimal(self, address, n_bits=32, lsb_location=0):
        '''
        Reads from a register of the red pitaya
        address should be a string, e.g. 0x41200000
        returns full register interpreted as unsigned decimal
        '''
        return int(self._read_register_bits(address), 2)

    # =======================================
    # ====  LOW-LEVEL WRITE TO REGISTERS ====
    # =======================================
    def _write_register(self, address, value):
        '''
        Writes to a register of the red pitaya. This will fully replace
        the contents of the register
        address should be a string, e.g. 0x41200000
        '''
        _ = self.exec_command('/opt/redpitaya/bin/monitor {} {}'.format(address, value))

    def _write_register_bits(self, address, bits):
        '''
        write a sequence of bits to a register
        address should be a string, e.g. 0x41200000
        '''
        self._write_register(address, int(bits, 2))

    def _write_register_decimal(self, address, value):
        '''
        Write a decimal value to a register.
        decimal value is converted to binary as an unsigned int
        '''
        self._write_register_bits(address, bin(value))
