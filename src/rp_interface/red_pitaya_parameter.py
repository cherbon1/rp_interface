from typing import Union, Callable

from rp_interface import utils
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister

import logging

log = logging.getLogger(__name__)


class RedPitayaParameter:
    '''
    A RedPitayaParameter exposes the interface to a single register on the RedPitaya
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
                 read_data: Callable = None):
        if isinstance(red_pitaya, str):
            red_pitaya = RedPitaya(host=red_pitaya)
        if not isinstance(red_pitaya, RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya
        self.register = register
        self.name = name
        self.dtype = dtype

        if not in_range:
            in_range = lambda x: True
        if not write_data:
            write_data = lambda x: x
        if not read_data:
            read_data = lambda x: x

        self.in_range = in_range
        self.write_data = write_data
        self.read_data = read_data

    @property
    def value(self):
        reg_val = self.rp.read_register(register=self.register, dtype=self.dtype)
        log.debug(f'Read {reg_val} from {self.register}')
        return self.read_data(reg_val)

    @value.setter
    def value(self, value):
        if not self.in_range(value):
            raise ValueError(f'Value {value} not in range for RedPitayaParameter {self.name}')
        reg_val = self.write_data(value)
        log.debug(f'Writing {reg_val} to {self.register}')
        self.rp.write_register(register=self.register, data=reg_val, dtype=self.dtype)

    # def print_val_change(param: Parameter, val):
    #     print(val)
    #     print(param.setValue(value=param.value() + '1', blockSignal=print_val_change))
    #
    #
    # def param_from_dict(param_dict):
    #     param = Parameter.create(
    #         name=param_dict['name'],
    #         type=param_dict['type'],
    #         children=[param_from_dict(subdict) for subdict in param_dict.get('children', tuple())],
    #         value=param_dict.get('value', None)
    #     )
    #     param.sigValueChanged.connect(print_val_change)
    #     return param

    def __str__(self):
        return '{}: {}'.format(self.name, self.value)
