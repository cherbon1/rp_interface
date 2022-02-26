from typing import Union, Dict

import numpy as np

from rp_interface.utils import DataType
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_register import Register, MuxedRegister
from rp_interface.red_pitaya_control import RedPitayaControl
from rp_interface.red_pitaya_module import RedPitayaModule


class SumModule(RedPitayaModule):
    '''
    Defines an interface to a conditional adder stage and the following coarse_gain_and_limiter
    Sums inputs 3 down to 0 based on the status of their corresponding bits. The result can then be divided by
    up to a factor of 8. If the summed outputs exceed the allowed range, it will saturate.
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 add_select_register: Union[Register, MuxedRegister],
                 divide_by_register: Union[Register, MuxedRegister],
                 default_values: Dict = None,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, default_values=default_values, apply_defaults=False)
        if default_values is None:
            default_values = {}
        default_values.update({
            'add0': True,  # The rest of the adder should in principle start out false
            'divide_by': 1.
        })

        self._add_select_register = add_select_register
        self._divide_by_register = divide_by_register

        self._define_add_select_register_locations()
        self._define_add_select_controls()

        width_adder = int(np.log2(self._add_select_register.n_bits))
        max_divide_by = 2**width_adder

        self._divide_by_control = RedPitayaControl(
            red_pitaya=self.rp,
            register=self._divide_by_register,
            name='Divide by',
            dtype=DataType.UNSIGNED_INT,
            in_range=lambda val: (1 <= val <= max_divide_by),
            write_data=lambda val: int(width_adder-np.log2(val)),
            read_data=lambda reg: 2**(width_adder-reg)
        )

        property_definitions = {
            'divide_by': ('_divide_by_control', 'value')
        }
        # add elements of the form {'add0': (self.add0_control, 'value')} to property_definitions
        for i in range(self._add_select_register.n_bits):
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
        for i in range(self._add_select_register.n_bits):
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
        for i in range(self._add_select_register.n_bits):
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

    def __str__(self):
        add_select_string = self.rp.read_register(self._add_select_register, dtype='bits')[::-1]
        added_inputs = [f'In{i}' for i, val in enumerate(add_select_string) if bool(int(val))]
        return ("({add_string})/{divide_by}").format(
            add_string=' + '.join(added_inputs),
            divide_by=self._divide_by_control.value
        )