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
