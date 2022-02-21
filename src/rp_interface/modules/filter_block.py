from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module, multiplexer, coarse_gain, delay, fine_gain, triggered_toggle, \
    biquad_filter
from rp_interface.modules.biquad_filter import BiquadFilterRegisters


class FilterModule(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to an entire filter block
    '''

    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 gpio_write_address: str = None,
                 gpio_read_address: str = None,
                 fs: float = 125e6,
                 decimation_factor: float = 2**10
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        if gpio_write_address is None:
            raise KeyError('Need to define gpio_write_address for {}'.format(self.__class__.__name__))
        self.gpio_write_address = gpio_write_address

        if gpio_read_address is None:
            raise KeyError('Need to define gpio_read_address for {}'.format(self.__class__.__name__))
        self.gpio_read_address = gpio_read_address

        self.fs = fs
        self.decimation_factor = decimation_factor

        # =======================================
        # ====== DEFINE REGISTER LOCATIONS ======
        # =======================================
        self.input_mux_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=0,
            n_bits=1,
            signed_data=False
        )

        self.input_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=1,
            n_bits=3,
            signed_data=False
        )

        self.fir_bypass_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=2,
            n_bits=1,
            signed_data=False
        )

        self.delay_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=3,
            n_bits=15,
            signed_data=False
        )

        self.output_mux_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=24,
            n_bits=3,
            signed_data=False
        )

        self.output_fine_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=25,
            n_bits=17,
            signed_data=True
        )

        self.output_coarse_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=26,
            n_bits=4,
            signed_data=False
        )

        self.output_gate_delay_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=27,
            n_bits=26,
            signed_data=False
        )

        self.output_gate_active_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address=self.gpio_write_address,
            gpio_read_address=self.gpio_read_address,
            register_address=28,
            n_bits=26,
            signed_data=False
        )

        # =======================================
        # ==========  DEFINE MODULES ============
        # =======================================
        self.input_mux_module = multiplexer.Mux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.input_mux_register
        )

        self.input_gain_module = coarse_gain.CoarseGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.input_gain_register
        )

        self.fir_bypass_module = multiplexer.BooleanMux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.fir_bypass_register
        )

        self.delay_module = delay.Delay(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.delay_register,
            fs=self.fs
        )

        self.output_mux_module = multiplexer.Mux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.output_mux_register
        )

        self.output_fine_gain_module = fine_gain.FineGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.output_fine_gain_register
        )

        self.output_coarse_gain_module = coarse_gain.CoarseGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.output_coarse_gain_register
        )

        self.output_gate_module = triggered_toggle.TriggeredToggle(
            red_pitaya=self.rp,
            apply_defaults=False,
            delay_register=self.output_gate_delay_register,
            active_register=self.output_gate_active_register,
            fs=self.fs
        )

        # =======================================
        # === DEFINE BIQUAD FILTER LOCATIONS ====
        # =======================================
        self.biquad0_registers = BiquadFilterRegisters(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            a1_address=4,
            a2_address=5,
            b0_address=6,
            b1_address=7,
            b2_address=8,
            n_bits=26
        )

        self.biquad1_registers = BiquadFilterRegisters(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            a1_address=9,
            a2_address=10,
            b0_address=11,
            b1_address=12,
            b2_address=13,
            n_bits=26
        )

        self.biquad2_registers = BiquadFilterRegisters(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            a1_address=14,
            a2_address=15,
            b0_address=16,
            b1_address=17,
            b2_address=18,
            n_bits=26
        )

        self.biquad3_registers = BiquadFilterRegisters(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            a1_address=19,
            a2_address=20,
            b0_address=21,
            b1_address=22,
            b2_address=23,
            n_bits=26
        )

        # =======================================
        # ==== DEFINE BIQUAD FILTER MODULES =====
        # =======================================
        self.biquad0 = biquad_filter.BiquadFilter(
            red_pitaya=self.rp,
            apply_defaults=False,
            registers=self.biquad0_registers,
            fs= self.fs / self.decimation_factor,
            n_bits=26
        )

        self.biquad1 = biquad_filter.BiquadFilter(
            red_pitaya=self.rp,
            apply_defaults=False,
            registers=self.biquad1_registers,
            fs= self.fs / self.decimation_factor,
            n_bits=26
        )

        self.biquad2 = biquad_filter.BiquadFilter(
            red_pitaya=self.rp,
            apply_defaults=False,
            registers=self.biquad2_registers,
            fs= self.fs / self.decimation_factor,
            n_bits=26
        )

        self.biquad3 = biquad_filter.BiquadFilter(
            red_pitaya=self.rp,
            apply_defaults=False,
            registers=self.biquad3_registers,
            fs= self.fs / self.decimation_factor,
            n_bits=26
        )

    @property
    def input_mux(self):
        return self.input_mux_module.select

    @input_mux.setter
    def input_mux(self, value):
        self.input_mux_module.select = value

    @property
    def input_gain(self):
        return self.input_gain_module.gain

    @input_gain.setter
    def input_gain(self, value):
        self.input_gain_module.gain = value

    @property
    def fir_bypass(self):
        return self.fir_bypass_module.select

    @fir_bypass.setter
    def fir_bypass(self, value):
        self.fir_bypass_module.select = value

    @property
    def delay(self):
        return self.delay_module.delay

    @delay.setter
    def delay(self, value):
        self.delay_module.delay = value

    @property
    def output_mux(self):
        return self.output_mux_module.select

    @output_mux.setter
    def output_mux(self, value):
        self.output_mux_module.select = value

    @property
    def output_gain(self):
        return self.output_fine_gain_module.gain * self.output_coarse_gain_module

    @output_gain.setter
    def output_gain(self, value):
        divider = 1
        while not (-0.5 <= value < 0.5):
            value /= 2.
            divider *= 2
        self.output_fine_gain_module.gain = value
        self.output_coarse_gain_module.gain = divider

    @property
    def toggle_delay(self):
        return self.output_gate_module.delay

    @toggle_delay.setter
    def toggle_delay(self, value):
        self.output_gate_module.delay = value

    @property
    def toggle_time(self):
        return self.output_gate_module.toggle_time

    @toggle_time.setter
    def toggle_time(self, value):
        self.output_gate_module.toggle_time = value

    def defaults(self):
        pass