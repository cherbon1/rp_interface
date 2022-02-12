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

    return bin((1 << n_bits) + value).split('b')[-1].zfill(n_bits)


def bits2signed_int(bits):
    # prepare inputs
    if isinstance(bits, int):
        bits = str(bits)
    bits = bits.split('b')[-1]  # drop '0b' if applicable (don't use rstrip for this, it will drop leading 0s)
    if bits.startswith('0'):
        return int(bits, 2)
    return int(bits, 2) - (1 << len(bits))