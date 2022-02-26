# Paul trap feedback controller
### Red Pitaya based AOM controller and delay line filter
The name _Paul trap feedback controller_ is a bit misleading, but it stems from the fact I developed this for use on the Paul trap setup.

## Basic description
This red pitaya interface can be used to generate useful feedback cooling signals. On the one hand, it can be used to control an AOM for parametric feedback (by squaring an input signal, thereby frequency doubling it) as well as turning it on and off. On the other hand, it can be used to apply cold damping by using one of multiple delay line and filter modules.

Defines the following:
- one `aom_control` module: a module used for generating a signal that will drive the modulation input of an AOM. The signal can be turned on or off and can be modulated based on an input signal
- four `delay_filter` modules: these modules take an input signal, delay it by a specified amount, and apply filters to the delayed signal. Up to 4 filters can be applied per signal. Finally, and arbitrary gain can be applied to the signal.
- two `sum` modules: these modules take the output of the filters as inputs and can selectively add them.




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
    center_frequency=60e3,
    q_factor=4
)
ptfb.sum1.add0 = True

ptfb.trigger_now()
```