from __future__ import annotations

from typing import Dict, Any
import types

import yaml
from pyqtgraph.parametertree import Parameter

from rp_interface import utils
# from rp_interface.red_pitaya_module import RedPitayaModule
from rp_interface.red_pitaya_parameter import RedPitayaParameter

import logging
log = logging.getLogger(__name__)


def make_gui_item(parent_object, config_dict):
    '''
    Makes a parameter object (works both on groups and single parameters)
    '''
    # Most options from config dict can be passed on to Parameter.create() as is, but
    # some need special attention. Treat those here.
    refresh_children = None
    if 'children' in config_dict:  # Object has children
        this_object = getattr(parent_object, config_dict['name'])
        config_dict['children'] = [make_gui_item(this_object, subdict) for subdict in config_dict['children']]
        config_dict['expanded'] = False  # Collapse groups by default

        # make the object into a string, so that the GUI elements can be given a name
        # This is only for convenience at runtime, the text value appears nowhere else
        config_dict['type'] = 'str'
        config_dict['value'] = config_dict['name']

    # If there's a path, compute a value and store path separately from dict
    # because the callback needs to be handled separately after param creation
    # and Parameter.create won't recognize the 'path' keyword
    path = None
    if 'path' in config_dict:  # Object is a parameter
        path = config_dict['path']
        del config_dict['path']
        config_dict['value'] = utils.rgetattr(parent_object, path)

    # Create the parameter object
    param = Parameter.create(**config_dict)

    if 'children' in config_dict:
        def refresh_children(self):
            for child in config_dict['children']:
                if child.children():
                    child.refresh_children()
                elif child.type() == 'action':
                    pass  # a button needs no refreshing
                else:
                    child.refresh_value()

        param.refresh_children = types.MethodType(refresh_children, param)

    if path:
        # Connect button change to value change
        def callback(param: Parameter, value: Any):
            # print('set {} to {} (from {})'.format(path, value,  parent_object.__class__))
            utils.rsetattr(parent_object, path, value)
            param.refresh_value()

        def refresh_value(self):
            value = utils.rgetattr(parent_object, path)
            param.setValue(value=value, blockSignal=callback)  # Coerces the value if necessary
        param.refresh_value = types.MethodType(refresh_value, param)

        param.sigValueChanged.connect(callback)

    return param


# rp_module type should be RedPitayaModule, but it causes circular import
def generate_rp_module_gui_config_dict(name: str, rp_module: Any) -> Dict:
    '''
    Outputs a dict with options for defining a pyqtgraph.Parameter for the given RedPitayaModule.
    This function only spits out a best-guess. The precise implementation
    can and should be tweaked

    name is the top level name of the param tree
    rp_module is the RedPitayaModule instance to be used
    '''
    children = []
    for param_name, param_path in rp_module._parameters.items():
        # If the property is implemented by a single RedPitayaParameter, try to guess its type
        # Otherwise, assume the parameter is a float
        param_type = 'float'
        if param_path.endswith('.value') and isinstance(getattr(rp_module, param_path[:-6]), RedPitayaParameter):
            rp_parameter = getattr(rp_module, param_path[:-6])
            param_type = 'bool' if rp_parameter.dtype == utils.DataType.BOOL else 'float'
        opts = {
            'name': param_name,
            'path': param_path,
            'type': param_type
        }
        children.append(opts)
    for submodule in rp_module._submodules:
        opts = generate_rp_module_gui_config_dict(submodule, utils.rgetattr(rp_module, submodule))
        children.append(opts)

    opts = {
        'name': name,
        'type': 'group',
        'children': children
    }

    with open('test_config.yaml', 'w') as f:
        yaml.dump(opts, f)
    return opts


def generate_rp_module_gui_config_file(filepath: str, name: str, rp_module: Any, overwrite=False):
    mode = 'w' if overwrite else 'x'
    try:
        with open(filepath, mode) as f:
            yaml.safe_dump(generate_rp_module_gui_config_dict(name, rp_module), f, sort_keys=False)
    except FileExistsError as e:
        log.warning('File {} already exists. Set overwrite=True and try again'.format(filepath))
        raise e
