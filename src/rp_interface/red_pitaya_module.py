from abc import ABC, abstractmethod
from typing import Dict, Union

import logging

from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile

log = logging.getLogger(__name__)


class RedPitayaModule(ABC):
    '''
    Defines a combination of controls and modules that are considered one entity on
    the red pitaya image.

    default_values is a dict of the form: {'name': value}
    e.g. {'gain': 1, 'channel': 0}

    This is an abstract base class, but it defines no abstract methods.
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 default_values: Dict = None,
                 apply_defaults: bool = False
                 ):
        if isinstance(red_pitaya, str):
            red_pitaya = RedPitaya(host=red_pitaya)
        if not isinstance(red_pitaya, RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya
        self.default_values = default_values

        self._define_properties({})

        if apply_defaults:
            self.apply_defaults()

    def apply_defaults(self):
        if self.default_values is None:
            raise ValueError('default_values must be specified')
        for name, value in self.default_values:
            setattr(self, name, value)

    def _define_properties(self, property_definitions: Dict) -> None:
        '''
        property_definitions is a dict of the for {'prop_name': (object, 'obj_prop_name')}
            e.g. {'input_mux': (self.input_mux_control, 'value')}.
        This will make Module.input_mux = 4 behave the same as Module.input_mux_control.value = 4
        '''
        def make_property(obj: object, key: str):
            '''
            Returns a property object
            e.g. make_property(self.input_mux_control, value)
            returns a property instance that can get and set value.

            Use this property instance to define an attribute of self, e.g.
            setattr(self, 'input_mux', make_property(self.input_mux_control, 'value'))
            will allow self.input_mux to read/write directly to input_mux_control.value
            '''
            # Watch out for closures... https://stackoverflow.com/questions/9551082/create-properties-with-loop
            get_func = lambda: getattr(obj, key)
            set_func = lambda value: setattr(obj, key, value)
            return property(lambda _, f=get_func: f(),
                            lambda _, value, f=set_func: f(value))

        for prop_name, prop_definition in property_definitions.items():
            setattr(self, prop_name, make_property(*prop_definition))


class RedPitayaTopLevelModule(RedPitayaModule, ABC):
    '''
    Same as a RedPitayaModule, but it's subclasses must additionally define a bitfile.
    bitfile must be an instance of red_pitaya_bitfile.Bitfile
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 default_values: Dict = None,
                 apply_defaults: bool = False,
                 load_bitfile: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, default_values=default_values, apply_defaults=False)

        if load_bitfile:
            self.load_bitfile()

        if apply_defaults:
            self.apply_defaults()

    @property
    @abstractmethod
    def bitfile(self) -> Bitfile:
        ...

    def load_bitfile(self):
        self.rp.load_bitfile(self.bitfile.full_path)
