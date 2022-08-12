from typing import Union, List, Dict

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_parameter import RedPitayaParameter
from rp_interface.red_pitaya_module import RedPitayaModule


class SumModule(RedPitayaModule):
    '''
    Defines an interface to a conditional adder stage and the following coarse_gain_and_limiter
    Sums inputs adder_width based on the status of their corresponding bits. The result can then be divided by
    up to a factor 2**adder_width (to avoid saturation). If the summed outputs exceed the allowed range,
    it will saturate.

    This module defines the following controls:
        - add0
        - add1
        - ...
        - add{adder_width}
        - divide_by
    '''
    # This one's slightly awkward because not all sum modules will be identical
    # Instead, grow the controls dict as much as necessary at every init
    # and overload get_settings_dict() to only read as far as necessary
    _parameters = {
        'divide_by': '_divide_by_parameter.value'
    }
    _submodules = []

    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 add_select_register: Union[Register, MuxedRegister],
                 divide_by_register: Union[Register, MuxedRegister],
                 adder_width: int = None,
                 input_names: List = None
                 ):
        super().__init__(red_pitaya=red_pitaya)

        self._add_select_register = add_select_register
        self._divide_by_register = divide_by_register

        if adder_width is None:
            adder_width = self._add_select_register.n_bits
        self.adder_width = adder_width
        divide_by_width = int(np.ceil((np.log2(self.adder_width))))
        max_divide_by = 2**divide_by_width

        if input_names is None:
            input_names = {i: f'In{i}' for i in range(self.adder_width)}
        self.input_names = input_names

        if len(input_names) != self.adder_width:
            raise RuntimeError('Incorrect length {} for input names. Expected {}'.format(
                    len(self.input_names),
                    self.adder_width
                )
            )

        if self.adder_width > self._add_select_register.n_bits:
            raise RuntimeError('Register is too small for adder_width {}'.format(self.adder_width))

        self._define_add_select_register_locations()
        self._define_add_select_parameters()

        self._divide_by_parameter = RedPitayaParameter(
            red_pitaya=self.rp,
            register=self._divide_by_register,
            name='Divide by',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (1 <= val <= max_divide_by),
            write_data=lambda val: int(divide_by_width-np.log2(val)),
            read_data=lambda reg: 2**(divide_by_width-reg)
        )

        # grow the controls dict as required:
        # add elements of the form  {'add0': '_add0_parameter.value'}
        for i in range(self.adder_width):
            property_name = 'add{}'.format(i)
            property_path = '_add{}_parameter.value'.format(i)
            if property_name not in self._parameters:
                self._parameters[property_name] = property_path
        self._attach_properties()  # redefine controls

    def _define_add_select_register_locations(self):
        '''
        Breaks apart self._add_select_register into individual controls
        '''
        for i in range(self.adder_width):
            attr_name = '_add{}_register'.format(i)
            reg = MuxedRegister(
                gpio_write_address=self._add_select_register.gpio_write_address,
                gpio_read_address=self._add_select_register.gpio_read_address,
                register_address=self._add_select_register.register_address,
                n_bits=1,
                lsb_location=self._add_select_register.lsb_location + i
            )
            setattr(self, attr_name, reg)

    def _define_add_select_parameters(self):
        '''
        Defines controls
        '''
        for i in range(self.adder_width):
            control_attr_name = '_add{}_parameter'.format(i)
            register_attr_name = '_add{}_register'.format(i)
            register = getattr(self, register_attr_name)
            control = RedPitayaParameter(
                red_pitaya=self.rp,
                register=register,
                name='Add {} enable'.format(i),
                dtype=DataType.BOOL,
            )
            setattr(self, control_attr_name, control)

    def get_settings_dict(self) -> Dict:
        properties_dict = {'divide_by': getattr(self, 'divide_by')}

        # add elements of the form  {'add0': '_add0_parameter.value'}
        for i in range(self.adder_width):
            property_name = 'add{}'.format(i)
            properties_dict[property_name] = getattr(self, property_name)

        return {
            'properties': properties_dict,
            'submodules': {}
        }

    @property
    def add_select_list(self):
        '''
        Returns a list of booleans, stating whether input n is summed or not
        '''
        # Invert order of string, and select adder_width first values
        add_select_string = self.rp.read_register(self._add_select_register, dtype='bits')[::-1][:self.adder_width]
        return [bool(int(enable)) for enable in add_select_string]

    def __str__(self):
        # Build addition string
        added_inputs = [name for name, enable in zip(self.input_names.values(), self.add_select_list) if enable]
        if len(added_inputs) == 0:
            return "no output"
        if self._divide_by_parameter.value == 1:
            return ' + '.join(added_inputs)
        return "({add_string})/{divide_by}".format(
            add_string=' + '.join(added_inputs),
            divide_by=self._divide_by_parameter.value
        )

    def __repr__(self):
        return self.__str__()
