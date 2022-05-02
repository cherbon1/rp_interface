# Paul trap feedback controller
### Red Pitaya based AOM controller and delay line filter
The name _Paul trap feedback controller_ is a bit misleading, but it stems from the fact I developed this for use on the Paul trap setup.

## Basic description
This red pitaya interface can be used to generate useful feedback cooling signals. On the one hand, it can be used to control an AOM for parametric feedback (by squaring an input signal, thereby frequency doubling it) as well as turning it on and off. On the other hand, it can be used to apply cold damping by using one of multiple delay line and filter modules.

Defines the following:
- one `aom_control` module: a module used for generating a signal that will drive the modulation input of an AOM. The signal can be turned on or off and can be modulated based on an input signal
- four `delay_filter` modules: these modules take an input signal, delay it by a specified amount, and apply filters to the delayed signal. Up to 4 `biquad_filters` can be applied per signal. Finally, and arbitrary gain can be applied to the signal.
- two `sum` modules: these modules take the output of the filters as inputs and can selectively add them.

## Detailed description
Here's the detailed list of what the `PaulTrapFeedbackController` class describes.

- `PaulTrapFeedbackController`
  - `trigger_delay`
  - `trigger_mode`
  - `output0_select`
  - `output1_select`
  - `constant`
  - `sum0`
  - `sum1`
  - `aom_control`
  - `delay_filter0`
  - `delay_filter1`
  - `delay_filter2`
  - `delay_filter3`
  - `trigger_now()`
  - `description()`
  - `input_select_names`
  - `output_select_names`


- `AOMControlModule`
  - `input_select`
  - `trap_enable`
  - `trap_toggle_delay`
  - `trap_toggle_time`
  - `feedback_enable`
  - `feedback_toggle_delay`
  - `feedback_toggle_time`
  - `feedback_gain`
  - `input_select_names`


- `DelayFilterModule`
  - `input_select`
  - `ac_coupling`
  - `preamp_gain`
  - `delay`
  - `output_select`
  - `gain`
  - `toggle_delay`
  - `toggle_time`
  - `constant`
  - `biquad0`
  - `biquad1`
  - `biquad2`
  - `biquad3`
  - `input_select_names`
  - `output_select_names`
  - `refresh_dc_block`

Each delay filter modules only exposes 4 biquad filter modules while 6 are programmed in hardware. `biquad4` and `biquad5` are identical copies of `biquad2` and `biquad3` respectively (i.e. they're connected to the same parameters).  They are meant to e.g. generate higher order lowpass/highpass filter.

- `BiquadFilterModule`
  - `filter_type`
  - `frequency`
  - `q_factor`
  - `biquad_coefficients`
  - `write_biquad_coefficients`
  - `calculate_biquad_coefficients`
  - `apply_filter_settings`
  - `refresh_filter`
  - `transfer_function`


- `SumModule`
  - `add0`
  - `add1`
  - `add2`
  - `add3`
  - `add4`
  - `add5`
  - `add6`
  - `add7`
  - `divide_by`
  - `sum_input_names`


- `WavegenModule`
  - `frequency`
  - `amplitude`

### Usage example

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