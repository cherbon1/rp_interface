# Red Pitaya based PLL controller

## Basic description
This red pitaya interface contains four PLL modules that can be used to generate a parametric feedback cooling signal.

Defines the following:
- four `pll_modules` modules: these are the PLL modules that phase lock to an input signal
- two `sum` modules: these modules take the output of the pll modules as inputs and can selectively add them.

## Detailed description
Here's the detailed list of what the `PLLController` class describes.

- `PLLController`
  - `output0_select`
  - `output1_select`
  - `sum0`
  - `sum1`
  - `pll0`
  - `pll1`
  - `pll2`
  - `pll3`
  - `output_select_names`


- `PLLModule`
  - `input_select`
  - `second_harmonic`
  - `a`
  - `phi`
  - `PID_enable`
  - `kp`
  - `ki`
  - `frequency`
  - `PID_bandwidth`
  - `alpha`
  - `order`
  - `output_select`
  - `gain`
  - `input_select_names`
  - `output_select_names`  


- `SumModule`
  - `add0`
  - `add1`
  - `add2`
  - `add3`
  - `add4`
  - `add5`
  - `input_names`
  - `divide_by`

### Usage example

```python3
from rp_interface.top_level_modules import PLLController

pc = PLLController(
    red_pitaya='red-pitaya-01.ee.ethz.ch',
    load_bitfile=True,
    apply_defaults=True
)

# set up pll0
pc.input_select = 0
pc.frequency = 65e3
pc.pll0.pid_enable = True
pc.pll0.gain = 1.8

# set up pll1
pc.input_select = 1
pc.frequency = 72e3
pc.pll1.pid_enable = True

# set up sum module to add plls 0 and 1
pc.sum0.add0 = False
pc.sum0.add1 = False
pc.sum0.add2 = True
pc.sum0.add3 = True
pc.sum0.add4 = False
pc.sum0.add5 = False
pc.sum0.divide_by = 1.  # Don't downscale output

# set output 0
pc.output0_select = 6  # output from Sum0 module
```