import functools
from typing import Union, Callable, Any

from rp_interface import utils
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister


class RedPitayaControl:
    '''
    A RedPitayaControl exposes the interface to a single register on the RedPitaya
    dtype refers to the data written to the register (i.e. how the binary should be interpreted)

    in_range is a function that checks that the write_value is in the right
        range, returns a bool. It gets applied before write_data
    write_data converts the input data to a register value
    read_data converts the register value to output data
    '''

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 register: Union[Register, MuxedRegister],
                 name: str,
                 dtype: utils.DataType = utils.DataType.UNSIGNED_INT,
                 in_range: Callable = None,
                 write_data: Callable = None,
                 read_data: Callable = None,
                 default_value: Any = None,
                 apply_default: bool = False):
        if isinstance(red_pitaya, str):
            red_pitaya = RedPitaya(host=red_pitaya)
        if not isinstance(red_pitaya, RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya
        self.register = register
        self.name = name
        self.dtype = dtype
        self.default_value = default_value

        if not in_range:
            in_range = lambda x: True
        if not write_data:
            write_data = lambda x: x
        if not read_data:
            read_data = lambda x: x

        self.in_range = in_range
        self.write_data = write_data
        self.read_data = read_data

        if apply_default:
            self.apply_default()

    @property
    def value(self):
        reg_val = self.rp.read_register(register=self.register, dtype=self.dtype)
        return self.read_data(reg_val)

    @value.setter
    def value(self, value):
        if not self.in_range(value):
            raise ValueError(f'Value {value} not in range for RedPitayaControl {self.name}')
        reg_val = self.write_data(value)
        self.rp.write_register(register=self.register, data=reg_val, dtype=self.dtype)

    def apply_default(self):
        if self.default_value is None:
            raise ValueError('A default_value must be specified')
        self.value = self.default_value


    def __str__(self):
        return '{}: {}'.format(self.name, self.value)