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
                 apply_defaults: bool = False
                 ):
        if isinstance(red_pitaya, str):
            red_pitaya = RedPitaya(host=red_pitaya)
        if not isinstance(red_pitaya, RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya
        self.default_values = None

        self._define_properties({})

        if apply_defaults:
            self.apply_defaults()

    def apply_defaults(self):
        if self.default_values is None:
            log.warning('No default values specified')
            return
        for name, value in self.default_values.items():
            if hasattr(self, name):
                setattr(self, name, value)
            else:
                raise KeyError(f'Unknown attribute {name} for {self.__class__.__name__}')

    def _define_properties(self, property_definitions: Dict) -> None:
        '''
        property_definitions is a dict of the form {'prop_name': ('object_name', 'obj_prop_name')}
            e.g. {'input_mux': ('input_mux_control', 'value')}.
        This will make Module.input_mux = 4 behave the same as Module.input_mux_control.value = 4
        '''
        def make_property(obj_name: str, key: str):
            '''
            This function returns a property for accessing self.obj_name.key (since obj_name is a string, it's
            referred to as getattr(self, obj_name) in code)

            In practice, use this to make RedPitayaControls into top level properties:
            e.g. make_property('input_mux_control', 'value') is a property instance for getting and setting
            self.input_mux_control.value.
            '''
            # Watch out for closures... https://stackoverflow.com/questions/9551082/create-properties-with-loop
            # Also, read this: https://stackoverflow.com/questions/1325673/how-to-add-property-to-a-class-dynamically
            get_func = lambda self: getattr(getattr(self, obj_name), key)
            set_func = lambda self, value: setattr(getattr(self, obj_name), key, value)
            return property(lambda self, f=get_func: f(self),
                            lambda self, value, f=set_func: f(self, value))

        for prop_name, prop_definition in property_definitions.items():
            setattr(self.__class__, prop_name, make_property(*prop_definition))


class RedPitayaTopLevelModule(RedPitayaModule, ABC):
    '''
    Same as a RedPitayaModule, but it's subclasses must additionally define a bitfile.
    bitfile must be an instance of red_pitaya_bitfile.Bitfile
    '''
    def __init__(self,
                 red_pitaya: Union[RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False
                 ):
        super().__init__(red_pitaya=red_pitaya, apply_defaults=False)

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
