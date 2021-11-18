from rp_interface import red_pitaya_comms


class RedPitayaAOM(red_pitaya_comms.RedPitaya):
    bitfile = 'aom_control.bit'
    fs = 125e6 / 4.

    n_cycles_trap_address = '0x41200000'  # 32-bit value
    n_cycles_feedback_address = '0x41200008'  # 32-bit value
    trigger_address = '0x41210000'  # 1-bit value
    squarer_gain_address = '0x41210008'  # 32-bit value
    n_cycles_trigger_address = '0x41220000'  # 16-bit value
    misc_switches_address = '0x41220008'  # 4-bit value

    def defaults(self):
        self.trap_toggle_time = 1e-6
        self.feedback_toggle_time = 1e-3
        self.trigger_pulse_time = 500e-9
        self.feedback_amplitude = 0.05
        self.feedback_disable = 0
        self.output_select = 0

    @property
    def trap_toggle_time(self):
        return self.n_cycles_trap / self.fs

    @trap_toggle_time.setter
    def trap_toggle_time(self, value):
        self.n_cycles_trap = int(value * self.fs)

    @property
    def feedback_toggle_time(self):
        return self.n_cycles_feedback / self.fs

    @feedback_toggle_time.setter
    def feedback_toggle_time(self, value):
        self.n_cycles_feedback = int(value * self.fs)

    @property
    def feedback_amplitude(self):
        '''
        The feedback amplitude states how large the feedback signal will be for 1V at the input.
        It can range from 0 to 0.5
        '''
        return self.squarer_gain / (2 ** 32 - 1) / 2

    @feedback_amplitude.setter
    def feedback_amplitude(self, value):
        '''
        The feedback amplitude states how large the feedback signal will be for 1V at the input.
        It can range from 0 to 0.5
        '''
        if not 0 <= value <= 0.5:
            raise ValueError(f'Invalid value {value}. feedback_amplitude must be in range 0 to 0.5')
        self.squarer_gain = int(2 * value * (2 ** 32 - 1))

    def trigger_now(self):
        '''
        Launches the trigger
        '''
        self.trigger_register = False  # make sure it's low
        self.trigger_register = True  # bring high
        self.trigger_register = False  # bring low again

    @property
    def trigger_pulse_time(self):
        return self.n_cycles_trigger / self.fs

    @trigger_pulse_time.setter
    def trigger_pulse_time(self, value):
        self.n_cycles_trigger = int(value * self.fs)

    @property
    def n_cycles_trap(self):
        return self.read_register_decimal(self.n_cycles_trap_address, n_bits=32)

    @n_cycles_trap.setter
    def n_cycles_trap(self, value):
        self.write_register(self.n_cycles_trap_address, value)

    @property
    def n_cycles_feedback(self):
        return self.read_register_decimal(self.n_cycles_feedback_address, n_bits=32)

    @n_cycles_feedback.setter
    def n_cycles_feedback(self, value):
        self.write_register(self.n_cycles_feedback_address, value)

    @property
    def trigger_register(self):
        return int(self.read_register_bits(self.trigger_address, n_bits=1))

    @trigger_register.setter
    def trigger_register(self, value):
        self.write_register_bits(self.trigger_address, bin(value), lsb_location=0)

    @property
    def squarer_gain(self):
        return self.read_register_decimal(self.squarer_gain_address, n_bits=32)

    @squarer_gain.setter
    def squarer_gain(self, value):
        self.write_register(self.squarer_gain_address, value)

    @property
    def n_cycles_trigger(self):
        return self.read_register_decimal(self.n_cycles_trigger_address, n_bits=16)

    @n_cycles_trigger.setter
    def n_cycles_trigger(self, value):
        self.write_register(self.n_cycles_trigger_address, value)

    @property
    def feedback_disable(self):
        return self.read_register_bits(self.misc_switches_address, n_bits=4)[0]

    @feedback_disable.setter
    def feedback_disable(self, value):
        self.write_register_bits(self.misc_switches_address, bits=bin(value), lsb_location=3)

    @property
    def output_select(self):
        return int(self.read_register_bits(self.misc_switches_address, n_bits=3), 2)

    @output_select.setter
    def output_select(self, value):
        if not 0 <= value <= 7:
            raise ValueError(f'Invalid input {value}. output_select must be in range 0 to 7')
        self.write_register_bits(self.misc_switches_address, bits=bin(value), lsb_location=0)


if __name__ == "__main__":
    red = RedPitayaAOM(apply_defaults=True)
    # red.load_bitfile()
    red.defaults()
    red.trigger_now()