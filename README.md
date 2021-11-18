# Red Pitaya Interface 

A central repository for containing red pitaya bitfiles and python interfaces commonly used by our lab.

List of bitfiles and interfaces:
- [AOM Controller](src/rp_interface/bitfiles/aom_control.md)

### Installation
Install repository with `pip install git+https://gitlab.ethz.ch/ebonvin/rp_interface.git` (append `--force-reinstall` option for update)

### Adding a new interface
Create a new class that inherits from `red_pitaya_comss.RedPitaya`. This new class *must* define the following:
- `bitfile`: name of the bitfile to load. The corresponding bitfile must exist in the `bitfiles` directory.
- `fs`: The clock frequency of the red pitaya bitfile
- `defaults`: A series of default commands to be run

### Example

```python3
from rp_interface import red_pitaya_aom

aom_control = red_pitaya_aom.RedPitayaAOM(host='red-pitaya-01.ee.ethz.ch', apply_defaults=True)

aom_control.trap_toggle_time = 15e-6
aom_control.trigger_now()
```