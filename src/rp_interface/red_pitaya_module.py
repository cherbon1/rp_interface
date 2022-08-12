from __future__ import annotations

import logging
import os
from abc import ABC, abstractmethod
from typing import Union, List, Dict

import yaml
import pyqtgraph as pg
from pyqtgraph.Qt import QtWidgets
from pyqtgraph.parametertree import ParameterTree, Parameter

from rp_interface import utils, gui_utils
from rp_interface.red_pitaya import RedPitaya
from rp_interface.red_pitaya_bitfile import Bitfile

log = logging.getLogger(__name__)


class RedPitayaModule(ABC):
    '''
    Defines a combination of parameters and modules that are considered one entity on
    the red pitaya image.

    This is an abstract base class, and defines the following abstract properties:
    - self._parameters: A dict of parameters that should be registered as properties
        (dict of the form {'name': 'submodule_name.parameter_name.value'}).
        These will be registered as properties with getters and setters to directly access these objects.
    - self._submodules: A list of submodules (string of submodule instance name)
        These should already be instance attributes, and this list is only used to keep track of them.
    '''
    def __init__(self, red_pitaya: Union[RedPitaya, str]):
        if isinstance(red_pitaya, str):
            red_pitaya = RedPitaya(host=red_pitaya)
        if not isinstance(red_pitaya, RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya

        self._attach_properties()

    @property
    @abstractmethod
    def _parameters(self) -> Dict[str, str]:
        '''
        Dictionary of parameters that will be exposed for this module. Dict is of the form:
        {'parameter_name': 'parameter_path'}
        '''
        ...

    @property
    @abstractmethod
    def _submodules(self) -> List[str]:
        '''
        List of submodules that will be exposed for this module.
        Of the form: ['submodule_name']
        '''
        ...

    def get_settings_dict(self) -> Dict:
        return {
            'properties': {property_name: getattr(self, property_name) for property_name in self._parameters},
            'submodules': {submodule: getattr(self, submodule).get_settings_dict() for submodule in self._submodules}
        }

    def set_settings_dict(self, input_dict: Dict) -> None:
        for property_name, property_value in input_dict['properties'].items():
            setattr(self, property_name, property_value)
        for module_name, module_dict in input_dict['submodules'].items():
            getattr(self, module_name).set_settings_dict(module_dict)

    def get_settings_string(self) -> str:
        return yaml.dump(self.get_settings_dict(), default_flow_style=True)

    def set_settings_string(self, input_string: str) -> None:
        self.set_settings_dict(yaml.safe_load(input_string))

    def _attach_properties(self) -> None:
        '''
        attach every property in self._parameters to its class
        This will make e.g. Module.input_mux = 4 behave the same as Module.input_mux_control.value = 4
        '''
        # _parameters is e.g. {'input_mux': '_input_mux_control.value'}
        # since a property gets attached to the class and not the instance, this is the only way I could come up with
        # to avoid talking to an object of another instance of the class, but is slightly less elegant because
        # a RedPitayaParameter object is not enough to define it's 'value' attribute as a property.
        for property_name, property_path in self._parameters.items():
            setattr(self.__class__, property_name, utils.define_property(property_path))

    def copy_settings(self, other):
        # Copies all defined properties from one red pitaya module instance to another
        if not isinstance(other, self.__class__):
            raise RuntimeError('copy_settings: other instance must also be of type: {}'.format(self.__class__.__name__))
        for property_name in self._parameters.keys():
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
                 apply_defaults: bool = False,
                 make_gui: bool = False
                 ):
        '''
        load_bitfile: Whether the bitfile should be flashed to the red pitaya. This will interrupt the current
            output of the red pitaya board and reset its configuration
        apply_defaults: Whether the settings of the red pitaya board should be changed to match the defaults config file
        make_gui: Whether the GUI elements should be generated or not. If you plan to interact with this red pitaya via
            the GUI, set this to "true" and call show_gui() to display it. If you only plan to use the API, set to
            "false" to save some memory
        '''
        super().__init__(red_pitaya=red_pitaya)

        if load_bitfile:
            self.load_bitfile()

        self.defaults_file = ''
        if apply_defaults:
            self.apply_defaults()

        self.gui_config_file = ''
        if make_gui:
            self._make_gui()

    @property
    @abstractmethod
    def bitfile(self) -> Bitfile:
        ...

    def load_bitfile(self):
        self.rp.load_bitfile(self.bitfile.full_path)

    def apply_defaults(self):
        # defaults live in config directory
        self.defaults_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'config')
        if not hasattr(self, 'defaults_file'):
            raise RuntimeError("Can't apply defaults, no defaults_file defined")

        defaults_full_path = os.path.join(self.defaults_directory, self.defaults_file)

        if not os.path.isfile(defaults_full_path):
            raise RuntimeError("Can't apply defaults, file {} doesn't exist".format(defaults_full_path))

        self.load_settings(defaults_full_path)

    # ==============================
    # ==== GUI-related methods =====
    # ==============================
    def show_gui(self):
        if not hasattr(self, 'win'):
            raise RuntimeError("GUI hasn't been created, call self._make_gui() first")
        self.win.show()
        self.win.activateWindow()
        # pg.exec()
        # self.win.setWindowState(window.windowState() & ~QtCore.Qt.WindowMinimized | QtCore.Qt.WindowActive)

    def _make_gui(self):
        '''
        Reads in a gui config file (that should be generated via _generate_rp_module_gui_config_file and modified
        by user if necessary) and makes a parameter tree
        '''
        # Get GUI settings file full path (in bitfile directory)
        self.gui_config_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'config')
        if not hasattr(self, 'defaults_file'):
            raise RuntimeError("Can't apply defaults, no defaults_file defined")

        gui_config_full_path = os.path.join(self.gui_config_directory, self.gui_config_file)

        if not os.path.isfile(gui_config_full_path):
            raise RuntimeError("Can't apply defaults, file {} doesn't exist".format(gui_config_full_path))

        #
        # Make the pyqtgraph app and load settings
        app = pg.mkQApp(self.__class__.__name__ + ' GUI')

        with open(gui_config_full_path, 'r') as f:
            config_dict = yaml.load(f, Loader=yaml.FullLoader)
        # my_params = gui_utils.make_gui_item(self, config_dict)

        # Top level must be a group, with children
        if 'children' not in config_dict or config_dict['type'] != 'group':
            raise ValueError('Top level item must be a group')
        config_dict['children'] = [gui_utils.make_gui_item(self, subdict) for subdict in config_dict['children']]

        # Add a button to refresh the values of every element
        refresh_button = Parameter.create(name='Refresh buttons', type='action')
        config_dict['children'].insert(0, refresh_button)

        def refresh_children(param: Parameter):
            for child in config_dict['children']:
                if child.children():
                    child.refresh_children()
                elif child.type() == 'action':
                    pass  # a button needs no refreshing
                else:
                    child.refresh_value()

        refresh_button.sigActivated.connect(refresh_children)

        self.params = Parameter.create(**config_dict)

        self.param_tree = ParameterTree()
        self.param_tree.setParameters(self.params, showTop=True)
        self.param_tree.setWindowTitle(config_dict['name'])

        self.win = QtWidgets.QWidget()
        layout = QtWidgets.QGridLayout()
        self.win.setLayout(layout)

        layout.addWidget(self.param_tree, 0, 0, 1, 1)

        self.win.show()

        # enable ipython QtGui in python if available
        try:
            from IPython import get_ipython
            IPYTHON = get_ipython()
            IPYTHON.magic("gui qt")
            GUI_INITIALIZED = True
        except BaseException as e:
            log.warning('Could not enable IPython gui support: %s.' % e)

