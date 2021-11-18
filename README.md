# Red Pitaya Interface 

A central repository for containing red pitaya bitfiles and python interfaces commonly used by our lab.

List of bitfiles and interfaces:
- [AOM Controller](src/rp_interface/bitfiles/aom_controller.md)

### Installation
Install repository with
```shell
pip install git+https://gitlab.ethz.ch/ebonvin/rp_interface.git
```

For upgrading, use the following options `--force-reinstall --no-deps`. Simply using `--upgrade` won't work because this option only compares the version number


### Adding a new interface
Create a new class that inherits from `red_pitaya_comms.RedPitaya`. This new class *must* define the following:
- `bitfile`: name of the bitfile to load. The corresponding bitfile must exist in the `bitfiles` directory.
- `fs`: The clock frequency of the red pitaya bitfile
- `defaults`: A series of default commands to be run

### Example

```python3
from rp_interface.aom_controller import AOMController

aom = AOMController(
    host='red-pitaya-01.ee.ethz.ch',
    load_bitfile=True,
    apply_defaults=True
)

aom.trap_toggle_time = 15e-6
aom.trigger_now()
```