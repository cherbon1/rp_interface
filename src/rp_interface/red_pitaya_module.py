from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from typing import Union, List, Dict
import yaml

from rp_interface import utils
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile

log = logging.getLogger(__name__)


class RedPitayaModule(ABC):
    '''
    Defines a combination of controls and modules that are considered one entity on
    the red pitaya image.

    default_values is a dict of the form: {'name': value}
    e.g. {'gain': 1, 'channel': 0}

    This is an abstract base class, and defines the following abstract properties:
    - self._properties: A dict of controls that should be registered as properties
        (dict of the form {'name': 'submodule_name.control_name.value'}).
        These will be registered as properties with getters and setters to directly access these objects.
    - self._submodules: A list of submodules (string of submodule instance name)
        These should already be instance attributes, and this list is only used to keep track of them.
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

        self._attach_properties()

        if apply_defaults:
            self.apply_defaults()

    @property
    @abstractmethod
    def _properties(self) -> Dict[str, str]:
        ...

    @property
    @abstractmethod
    def _submodules(self) -> List[str]:
        ...

    def get_settings_dict(self) -> Dict:
        return {
            'properties': {property_name: getattr(self, property_name) for property_name in self._properties},
            'submodules': {submodule: getattr(self, submodule).get_settings_dict() for submodule in self._submodules}
        }

    def set_settings_dict(self, input_dict: Dict) -> None:
        for property_name, property_value in input_dict['properties'].items():
            setattr(self, property_name, property_value)
        for module_name, module_dict in input_dict['submodules'].items():
            getattr(self, module_name).set_settings_dict(module_dict)

    def apply_defaults(self):
        if self.default_values is None:
            log.warning('No default values specified')
            return
        for name, value in self.default_values.items():
            if hasattr(self, name):
                setattr(self, name, value)
            else:
                raise KeyError(f'Unknown attribute {name} for {self.__class__.__name__}')

    def _attach_properties(self) -> None:
        '''
        attach every property in self._properties to its class
        This will make e.g. Module.input_mux = 4 behave the same as Module.input_mux_control.value = 4
        '''
        # _properties is e.g. {'input_mux': '_input_mux_control.value'}
        # since a property gets attached to the class and not the instance, this is the only way I could come up with
        # to avoid talking to an object of another instance of the class, but is slightly less elegant because
        # a RedPitayaControl object is not enough to define it's 'value' attribute as a property.
        for property_name, property_path in self._properties.items():
            setattr(self.__class__, property_name, utils.define_property(property_path))

    def copy_settings(self, other):
        # Copies all defined properties from one red pitaya module instance to another
        if not isinstance(other, self.__class__):
            raise RuntimeError('copy_settings: other instance must also be of type: {}'.format(self.__class__.__name__))
        for property_name in self._properties.keys():
            setattr(self, property_name, utils.rgetattr(other, property_name))
        for submodule in self._submodules:
            getattr(self, submodule).copy_settings(getattr(other, submodule))

    def save_settings(self, filepath, overwrite=False):
        '''
        Implemented with yaml.safe_dump to avoid saving python objects by accident (can happen e.g. with numpy.float64)
        A yaml.representer.RepresenterError will be raised if an invalid object is saved. If that's the case, consider
        replacing `safe_dump` with `dump` for debugging purposes (the output file will make it clear where the error is)
        '''
        mode = 'w' if overwrite else 'x'
        try:
            with open(filepath, mode) as f:
                yaml.safe_dump(self.get_settings_dict(), f)
        except FileExistsError as e:
            log.warning('File {} already exists. Set overwrite=True and try again'.format(filepath))
            raise e

    def load_settings(self, filepath):
        with open(filepath, 'r') as f:
            settings_dict = yaml.load(f, yaml.FullLoader)
        self.set_settings_dict(settings_dict)


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
