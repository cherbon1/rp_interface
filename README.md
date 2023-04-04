# Red Pitaya Interface 


## Disclaimer
This software was developed to perform a few specific tasks in the lab. The software has a fair amount of quirks, that are known but we don't have the patience to solve. Here's a non-exhaustive list:
- Communication to the red pitaya is slow
- The GUI was added as an afterthought and not planned from the start, and therefore doesn't update when API calls change a parameter
- On the FPGA side: communication via these self-made GPIO multiplexers is clunky. I've since learned how to make proper interfaces between PS and PL, but this works for now
- The Vivado projects are large and the block diagrams are full of RTL blocks. Because of this, the interface is slow and building takes longer than it should. Again, I've since learned that there's a better way, but this'll do for now.

## Red Pitaya Interface 

A central repository for containing red pitaya bitfiles and python interfaces commonly used by our lab.

List of bitfiles and interfaces:
- [Example project](docs/example_project.md)
- [Paul trap feedback controller](docs/paul_trap_feedback_controller.md)
- [PLL controller](docs/pll_controller.md)

### Installation
Install repository with
```shell
pip install git+https://github.com/cherbon1/rp_interface.git
```

For upgrading, use the following options `--force-reinstall --no-deps`. Simply using `--upgrade` won't work because this option only compares the version number, and version numbers aren't automatically bumped here.

The package also depends on `pyqtgraph` and requires a version of `Qt` to be installed. Install both with e.g.:
```shell
pip install pyqtgraph PyQt5
```

### Adding a new interface
Add your bitfile to the `bitfiles` directory. Create a new class in the `top_level_modules` directory that inherits from `rp_interface.red_pitaya_module.RedPitayaTopLevelModule`.

For more details on how to build the class, go through the [Code Structure](#code-structure) section below

### Example

```python3
from rp_interface.top_level_modules import PaulTrapFeedbackController

ptfb = PaulTrapFeedbackController(
    red_pitaya='red-pitaya-01.ee.ethz.ch',
    load_bitfile=True,
    apply_defaults=True
)

ptfb.aom_control.trap_enable = True

ptfb.output_select = 4
ptfb.delay_filter0.output_select = 3
ptfb.delay_filter0.delay = 30e-6
ptfb.delay_filter0.biquad0.apply_filter_settings(
    filter_type='bandpass',
    frequency=60e3,
    q_factor=4
)
ptfb.sum1.add0 = True

ptfb.trigger_now()
```

## Code Structure

All python code is found in the `src/rp_interface` directory. The `fpga` top level directory contains a snapshot of the FPGA project files. I will most likely not be keeping this up to date any time I do changes to the bitfiles in the future, but I think it's a good idea to include at least one version of a functioning project. 

Here's a brief description of how the different parts of `rp_interface` are broken up. This repository consists of 5 main files that describe the communication with a Red Pitaya:

- `red_pitaya.py`: Defines `RedPitaya`, which handles the SSH communication with the board, as well as some methods for writing to and reading from registers
- `red_pitaya_bitfile`: Defines a `Bitfile` class which is essentially a string and a few handy path handling methods
- `red_pitaya_register.py`: Defines two types of registers, i.e. locations in the programmable logic of the red pitaya that can be written to or read from. The two types are:
  - `Register`: A GPIO bus (or subsection thereof) described by an _AXI-GPIO_ block in Vivado. Up to 32 bits wide. It is defined by a single GPIO address, and descriptions of where the relevant bits are located.
  - `MuxedRegister`: A multiplexed version of a GPIO bus (or subsection thereof). This requires additional logic on the Red Pitaya board, but enables a single bus to write to multiple locations on chip. A separate bus is used for reading the data. The 32-bit bus is broken down into: 1 write_enable bit, 5 address bits, 26 data bits. This register is defined by 2 gpio addresses and one bus address
- `red_pitaya_parameter.py`: Defines `RedPitayaParameter`, which is a class that writes to one register on the red pitaya. You can optionally define `in_range`, `write_data` and/or `read_data` methods that translate user values into appropriate register values. Nothing should have to inherit from this class. Instead, each register that needs to be written to on the FPGA should be an instance of this class.
- `red_pitaya_module.py`: Defines two types of modules. Both are defined as abstract classes, which means that no instances of them are allowed to exist. Instead, subclasses must be defined that inherit from these classes. The two classes are:
  - `RedPitayaModule`: Defines a collection of registers, parameters and other modules. Each subclass should live in its own file in the `modules` directory. A subclass is a collection of registers, controls and other modules, and each subclass must define a `_parameters` dictionary and a `_submodules` list, which are descriptions of the user-facing parameters/submodules we'd like to be available when using the interface.  
  `RedPitayaModules` can vary widely, from very simple (e.g. `gain_module.py`) to more involved (e.g. `biquad_filter_module.py`). Ideally, individual registers should be passed to the `__init__` method, for maximum reusability. However, this is not always convenient, e.g. in a situation where we need many registers (for instance `delay_filter_module.py`). In those cases, try to make all registers `MuxedRegisters` of the same multiplexed GPIO bus, and pass the relevant addresses instead (see `delay_filter_module.py` for a concrete example).
  - `RedPitayaTopLevelModule`: This is the same thing as `RedPitayaModule`, but it additionally defines a bitfile. Subclasses of `RedPitayaTopLevelModule` should live in their own files, in the `top_level_modules` directory. When making a user-facing module (top-level or large submodule), keep addresses, registers and controls (or anything that isn't user-facing) private by prefixing it with an underscore. This makes the software much easier to use in practice.
  - `utils.py`: defines a few useful functions for converting to and from binary data, and for recursively getting and setting attributes
  - `gui_utils.py`: defines a few functions for generating a simple GUI from a `RedPitayaModule`


#### Defining defaults for a new interface
After creating a `RedPitayaTopLevelModule`, call: `your_module.save_settings('filename.yaml')` to generate a config file. Adjust the settings as desired, copy this file to the `config` directory, and add the file name to your class:

```python3
from rp_interface.top_level_modules import ExampleController

# Generate an instance of your class, without applying defaults or making gui
example = ExampleController(
    'red-pitaya-00.ee.ethz.ch',
    load_bitfile=True,
    apply_defaults=False,
    make_gui=False
)

# Define a new defaults file
example.save_settings('./my_new_default_settings.yaml')
# Then:
# - open and edit this file to match your desired settings
# - move it to the config directory
# - rename it to match example_controller.defaults_file
```

#### Defining a gui for a new interface
After creating the `RedPitayaTopLevelModule`, call: `rp_interface.gui_utils.generate_rp_module_gui_config_file('my_gui_config.yaml', 'my_module_name', my_module)` to generate a config file for the GUI. The default GUI settings assume that almost every input is a float, and doesn't set any limits on the inputs. Look at other examples in the `config` directory to see what options are available. Tweak the settings as desired, copy this file to the `config` directory, and add the file name to your class.

```python3
from rp_interface.top_level_modules import ExampleController

# Generate an instance of your class, without applying defaults or making gui
example = ExampleController(
    'red-pitaya-00.ee.ethz.ch',
    load_bitfile=True,
    apply_defaults=False,
    make_gui=False
)

# Define a new gui_config file
from rp_interface.gui_utils import generate_rp_module_gui_config_file
generate_rp_module_gui_config_file('./my_new_gui_config.yaml', 'Example Red Pitaya', example)
# Then:
# - open and edit this file to match your desired settings. There are usually quite a few things to change
#     (e.g. change the parameter type for multiplexers, rename inputs for sum modules, ...).
#     Look at other gui_config files for examples 
# - move it to the config directory
# - rename it to match example_controller.gui_config_file
```
