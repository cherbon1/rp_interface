from typing import Union, List

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
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
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 add_select_register: Union[Register, MuxedRegister],
                 divide_by_register: Union[Register, MuxedRegister],
                 apply_defaults: bool = False,
                 adder_width: int = None,
                 input_names: List = None
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

        self.default_values = {
            'add0': True,  # The rest of the adder should in principle start out false
            'divide_by': 1.
        }

        self._add_select_register = add_select_register
        self._divide_by_register = divide_by_register

        self._define_add_select_register_locations()
        self._define_add_select_controls()

        if adder_width is None:
            adder_width = self._add_select_register.n_bits
        self.adder_width = adder_width
        max_divide_by = 2**int(np.ceil((np.log2(self.adder_width))))

        if input_names is None:
            input_names = [f'In{i}' for i in range(self.adder_width)]
        self.input_names = input_names

        if len(input_names) != self.adder_width:
            raise RuntimeError('Incorrect length {} for input names. Expected {}'.format(
                    len(self.input_names),
                    self.adder_width
                )
            )

        if self.adder_width > self._add_select_register.n_bits:
            raise RuntimeError('Register is too small for adder_width {}'.format(self.adder_width))

        self._divide_by_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._divide_by_register,
            name='Divide by',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (1 <= val <= max_divide_by),
            write_data=lambda val: int(self.adder_width-np.log2(val)),
            read_data=lambda reg: 2**(self.adder_width-reg)
        )

        property_definitions = {
            'divide_by': ('_divide_by_control', 'value')
        }
        # add elements of the form {'add0': (self.add0_control, 'value')} to property_definitions
        for i in range(self.adder_width):
            prop_name = 'add{}'.format(i)
            control_attr_name = '_add{}_control'.format(i)
            property_definitions[prop_name] = (control_attr_name, 'value')
        self._define_properties(property_definitions)

        if apply_defaults:
            self.apply_defaults()

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

    def _define_add_select_controls(self):
        '''
        Defines controls
        '''
        for i in range(self.adder_width):
            control_attr_name = '_add{}_control'.format(i)
            register_attr_name = '_add{}_register'.format(i)
            register = getattr(self, register_attr_name)
            control = RedPitayaControl(
                red_pitaya=self.rp,
                register=register,
                name='Add {} enable'.format(i),
                dtype=DataType.BOOL,
            )
            setattr(self, control_attr_name, control)

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
        added_inputs = [name for name, enable in zip(self.input_names, self.add_select_list) if enable]
        if len(added_inputs) == 0:
            return "no output"
        if self._divide_by_control.value == 1:
            return ' + '.join(added_inputs)
        return "({add_string})/{divide_by}".format(
            add_string=' + '.join(added_inputs),
            divide_by=self._divide_by_control.value
        )

    def __repr__(self):
        return self.__str__()
