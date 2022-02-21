from rp_interface import red_pitaya_comms
from rp_interface.modules import red_pitaya_module, multiplexer, coarse_gain, delay, fine_gain, triggered_toggle, \
    biquad_filter
from rp_interface.modules.biquad_filter import BiquadFilterRegisters


class AOMModule(red_pitaya_module.RedPitayaModule):
    '''
    Implements an interface to an AOM module
    '''

    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False,
                 input_mux_register: red_pitaya_comms.MuxedRegister = None,
                 trap_enable_register: red_pitaya_comms.MuxedRegister = None,
                 trap_delay_register: red_pitaya_comms.MuxedRegister = None,
                 trap_toggle_register: red_pitaya_comms.MuxedRegister = None,
                 feedback_enable_register: red_pitaya_comms.MuxedRegister = None,
                 feedback_delay_register: red_pitaya_comms.MuxedRegister = None,
                 feedback_toggle_register: red_pitaya_comms.MuxedRegister = None,
                 feedback_gain_register: red_pitaya_comms.MuxedRegister = None,
                 fs: float = 125e6
                 ):
        super().__init__(red_pitaya=red_pitaya,
                         apply_defaults=apply_defaults)

        self.input_mux_register = input_mux_register
        self.trap_enable_register = trap_enable_register
        self.trap_delay_register = trap_delay_register
        self.trap_toggle_register = trap_toggle_register
        self.feedback_enable_register = feedback_enable_register
        self.feedback_delay_register = feedback_delay_register
        self.feedback_toggle_register = feedback_toggle_register
        self.feedback_gain_register = feedback_gain_register

        self.fs = fs



        # =======================================
        # =========== DEFINE MODULES ============
        # =======================================
        self.input_mux_module = multiplexer.Mux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.input_mux_register
        )

        self.trap_enable_module = multiplexer.BooleanMux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.trap_enable_register
        )

        self.trap_toggle_module = triggered_toggle.TriggeredToggle(
            red_pitaya=self.rp,
            apply_defaults=False,
            delay_register=self.trap_enable_register,
            active_register=self.trap_toggle_register,
            fs=self.fs
        )

        self.feedback_enable_module = multiplexer.BooleanMux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.feedback_enable_register
        )

        self.feedback_toggle_module = triggered_toggle.TriggeredToggle(
            red_pitaya=self.rp,
            apply_defaults=False,
            delay_register=self.feedback_enable_register,
            active_register=self.feedback_toggle_register,
            fs=self.fs
        )

        self.feedback_gain_module = fine_gain.FineGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.feedback_gain_register
        )

    @property
    def input_mux(self):
        return self.input_mux_module.select

    @input_mux.setter
    def input_mux(self, value):
        self.input_mux_module.select = value

    @property
    def trap_enable(self):
        return self.trap_enable_module.select

    @trap_enable.setter
    def trap_enable(self, value):
        self.trap_enable_module.select = value

    @property
    def trap_toggle_delay(self):
        return self.trap_toggle_module.delay

    @trap_toggle_delay.setter
    def trap_toggle_delay(self, value):
        self.trap_toggle_module.delay = value

    @property
    def trap_toggle_time(self):
        return self.trap_toggle_module.toggle_time

    @trap_toggle_time.setter
    def trap_toggle_time(self, value):
        self.trap_toggle_module.toggle_time = value

    @property
    def feedback_enable(self):
        return self.feedback_enable_module.select

    @feedback_enable.setter
    def feedback_enable(self, value):
        self.feedback_enable_module.select = value

    @property
    def feedback_toggle_delay(self):
        return self.feedback_toggle_module.delay

    @feedback_toggle_delay.setter
    def feedback_toggle_delay(self, value):
        self.feedback_toggle_module.delay = value

    @property
    def feedback_toggle_time(self):
        return self.feedback_toggle_module.toggle_time

    @feedback_toggle_time.setter
    def feedback_toggle_time(self, value):
        self.feedback_toggle_module.toggle_time = value

    @property
    def feedback_gain(self):
        return self.feedback_gain_module.gain

    @feedback_gain.setter
    def feedback_gain(self, value):
        self.feedback_gain_module.gain = value
