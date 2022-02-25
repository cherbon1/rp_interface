from enum import Enum
import logging

log = logging.getLogger(__name__)


class DataType(Enum):
    '''
    An Enum class to keep track of the different data types implemented here.
    bin and bits differ slightly
    bin is the output of `bin(number)`, e.g. bin(5) would be '0b101'
    bits is a string of 0s and 1s (i.e. the same thing without th leading '0b')

    Check for the data type with e.g.
    DataType.SIGNED_INT.equals(value)
    '''
    SIGNED_INT = 'signed int'
    UNSIGNED_INT = 'unsigned int'
    HEX = 'hex'
    BIN = 'bin'
    BITS = 'bits'
    BOOL = 'bool'

    def __eq__(self, other):
        '''
        Override equality operator such that == value also returns true
        Example:
            DataType.SIGNED_INT == 'signed int' --> True
            DataType.SIGNED_INT == DataType.SIGNED_INT --> True
            'signed int' == DataType.SIGNED_INT --> True
        '''
        return self.value == other or self == other


def bin2hex(bin_value):
    '''
    takes a binary value (e.g. '0b10011010' or '10011010')
    and converts it to hex (e.g. '0x9a')
    '''
    return hex(int(bin_value, 2))


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


def hex2bin(hex_value, n_bits=None):
    '''
    takes a hex value (e.g. '0x9a')
    and converts it to a sequence of bits (e.g. '0b10011010')

    keeps only the n_bits LSBs.
    If n_bits is larger than the corresponding input hex value, pads with zeros instead
    '''
    return '0b' + hex2bits(hex_value, n_bits)


def signed_int2bits(value, n_bits=32):
    '''
    Convert a signed int to a two's complement representation signed bit-string
    '''
    if value < -2 ** (n_bits - 1) or value > 2 ** (n_bits - 1) - 1:
        raise ValueError('Value {} doesnt fit in a signed {}-bit number'.format(value, n_bits))

    bits = bin((1 << n_bits) + value).split('b')[-1]
    return bits[-n_bits:]


def unsigned_int2bits(value, n_bits=32):
    '''
    Convert an unsigned int to an unsigned bit-string
    '''
    if value < 0 or value > 2 ** n_bits - 1:
        raise ValueError('Value {} doesnt fit in an unsigned {}-bit number'.format(value, n_bits))

    return bin(value).split('b')[-1].zfill(n_bits)


def bits2signed_int(bits):
    # prepare inputs
    if isinstance(bits, int):
        bits = str(bits)
    bits = bits.split('b')[-1]  # drop '0b' if applicable (don't use rstrip for this, it will drop leading 0s)
    if bits.startswith('0'):
        return int(bits, 2)
    return int(bits, 2) - (1 << len(bits))


def any2bits(data, dtype, n_bits):
    '''
    Convert data of format dtype into bits representation
    assumes that input data is in the proper format, may fail if that's not the case
    '''
    if dtype == DataType.UNSIGNED_INT:
        bits = unsigned_int2bits(data, n_bits=n_bits)
    elif dtype == DataType.SIGNED_INT:
        bits = signed_int2bits(data, n_bits=n_bits)
    elif dtype == DataType.HEX:
        bits = hex2bits(data, n_bits=n_bits)
    elif dtype == DataType.BOOL:
        bits = '1' if data else '0'
    elif dtype == DataType.BIN or dtype == DataType.BITS:
        if isinstance(data, int):
            bits = str(data)
        else:
            bits = data
        bits = bits.split('b')[-1]  # drop '0b' if applicable (don't use rstrip for this, it will drop leading 0s)
        if len(bits) > n_bits:
            log.warning(f'Value {bits} is larger than {n_bits} and will be trimmed')
            bits = bits[-n_bits:]
        if len(bits) < n_bits:
            bits = bits.zfill(n_bits)
    else:
        raise ValueError(f'Unknown data type {dtype}')


def bits2any(bits, dtype):
    '''
    Convert string of bits to any other datatype
    '''
    if dtype == DataType.SIGNED_INT:
        return bits2signed_int(bits)
    elif dtype == DataType.BOOL:
        if len(bits) != 1:
            log.warning('Boolean data of length different from 1 may lead to unexpected results')
        return bool(int(bits))
    elif dtype == DataType.UNSIGNED_INT:
        return int(bits, 2)
    elif dtype == DataType.BITS:
        return bits
    elif dtype == DataType.BIN:
        return '0b' + bits
    elif dtype == DataType.HEX:
        return bin2hex(bits)
    else:
        raise ValueError(f'Unknown data type {dtype}')
