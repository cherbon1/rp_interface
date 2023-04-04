from typing import Union, Any, List

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
    e.g. RedPitaya(host='red-pitaya-00.ee.ethz.ch')

    Handles communication with the red pitaya via ssh and reading and writing to registers
    '''

    def __init__(self, host: str = 'red-pitaya-00.ee.ethz.ch', username: str = 'root', password: str = 'root'):

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
        # Read old register if data on it is shared
        old_register = self.read_register_bits(register) if register.is_shared else 32 * '0'
        if isinstance(register, Register):
            bits = register.build_data_bus_bits(data=data, dtype=dtype, old_register=old_register)
            self._write_register_bits(register.gpio_address, bits)
            return
        elif isinstance(register, MuxedRegister):
            old_register = old_register[-26:]  # Trim down old_register to data_bits only
            buffer_bits = register.build_data_bus_bits(write=False, data=data, dtype=dtype, old_register=old_register)
            write_bits = register.build_data_bus_bits(write=True, data=data, dtype=dtype, old_register=old_register)
            # Write to bus by toggling write_bit high
            self._write_muxed_register_bits(register.gpio_write_address, buffer_bits, write_bits)
            # self._write_register_bits(register.gpio_write_address, buffer_bits)
            # self._write_register_bits(register.gpio_write_address, write_bits)
            # self._write_register_bits(register.gpio_write_address, buffer_bits)
            return
        else:
            raise ValueError(f'Invalid register {register}')

    def read_register_bits(self, register: Union[Register, MuxedRegister]) -> str:
        if isinstance(register, Register):
            return self._read_register_bits(register.gpio_address)
        elif isinstance(register, MuxedRegister):
            return self._read_muxed_register_bits(
                register.gpio_write_address,
                register.gpio_read_address,
                register.read_query_bits()
            )
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

    def _write_register_bits(self, address: str, bits: str):
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

    # ===============================================
    # =========  LOW-LEVEL GROUPED WRITING ==========
    # = (for speeding up writes to muxed registers) =
    # ===============================================
    def exec_multiple_commands(self, commands: List[str]) -> List[str]:
        '''
        Writes multiple commands, separated by &&
        The return values will be stored in a list. The return list will not necessarily have
        the same number of items as commands. This is because commands with no return value do not produce
        an output, and it seems tricky to figure out which commands will and won't produce an output.

        Only use this method if you know what you're doing.
        '''
        command_str = ' && '.join(commands)
        return_str = self.exec_command(command_str)

        return return_str.split('\n')

    def _write_muxed_register_bits(self, address: str, buffer_bits: str, write_bits: str):
        '''
        write sequence for a muxed register. In principle, buffer_bits and write_bits should be identical except
        for the write bit
        address should be a string, e.g. 0x41200000
        '''
        commands = [
            '/opt/redpitaya/bin/monitor {} {}'.format(address, int(buffer_bits, 2)),
            '/opt/redpitaya/bin/monitor {} {}'.format(address, int(write_bits, 2)),
            '/opt/redpitaya/bin/monitor {} {}'.format(address, int(buffer_bits, 2))
        ]
        self.exec_multiple_commands(commands)

    def _read_muxed_register_bits(self, write_address: str, read_address: str, read_query_bits: str):
        '''
        read sequence for a muxed register. The sequence writes the requested address to the write_address
        and reads in the returned value from read_address
        address should be a string, e.g. 0x41200000
        '''
        commands = [
            '/opt/redpitaya/bin/monitor {} {}'.format(write_address, int(read_query_bits, 2)),
            '/opt/redpitaya/bin/monitor {}'.format(read_address)
        ]
        hex_value = self.exec_multiple_commands(commands)[0]
        return utils.hex2bits(hex_value, 32)
