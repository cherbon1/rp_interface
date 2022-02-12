from dataclasses import dataclass
import numpy as np
from rp_interface import red_pitaya_comms

@dataclass
class BiquadFilterAddresses:
    a1: red_pitaya_comms.MuxedRegister
    a2: red_pitaya_comms.MuxedRegister
    b0: red_pitaya_comms.MuxedRegister
    b1: red_pitaya_comms.MuxedRegister
    b2: red_pitaya_comms.MuxedRegister
    bitshift: int

    def __init__(self, gpio_write_address, gpio_read_address, a1_address,
                 a2_address, b0_address, b1_address, b2_address, n_bits=24):
        self.bitshift = n_bits-2

        self.a1 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a1_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.a2 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=a2_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b0 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b0_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b1 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b1_address,
            n_bits=n_bits,
            signed_data=True
        )

        self.b2 = red_pitaya_comms.MuxedRegister(
            gpio_write_address=gpio_write_address,
            gpio_read_address=gpio_read_address,
            register_address=b2_address,
            n_bits=n_bits,
            signed_data=True
        )

# @dataclass
# class BiquadFilterSettings:
#     '''
#     A collection of values and functions for controlling a biquad notch filter
#     '''
#     sample_frequency: float
#     center_frequency: float = 1e3
#     q_factor: float = 10
#     gain: float = 1
#     filter_type: str = 'notch'
#
#     def get_params(self):
#         K = np.tan(np.pi * self.center_frequency / self.sample_frequency)
#         norm = 1 / (1 + K / self.q_factor + K * K)
#         b0 = (1 + K * K) * norm
#         b1 = 2 * (K * K - 1) * norm
#         b2 = b0
#         a1 = b1
#         a2 = (1 - K / self.q_factor + K * K) * norm
#
#         return a1, a2, b0, b1, b2


class PaulTrapFeedbackController(red_pitaya_comms.RedPitaya):
    bitfile = 'paul_trap_feedback_controller.bit'
    fs = 125e6

    def defaults(self):
        pass

    # muxed registers address definitions
    output_mux_0_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000',
                                                          gpio_read_address='0x42000008',
                                                          register_address=0, n_bits=3, signed_data=False)

    output_mux_1_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000',
                                                          gpio_read_address='0x42000008',
                                                          register_address=1, n_bits=3, signed_data=False)

    delay_input_mux_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000',
                                                             gpio_read_address='0x42000008',
                                                             register_address=2, n_bits=1, signed_data=False)

    delay_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000', gpio_read_address='0x42000008',
                                                   register_address=3, n_bits=15, signed_data=False)

    delay_output_mux_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000',
                                                              gpio_read_address='0x42000008',
                                                              register_address=24, n_bits=3, signed_data=False)

    aom_enable_mux_address = red_pitaya_comms.MuxedRegister(gpio_write_address='0x42000000',
                                                             gpio_read_address='0x42000008',
                                                             register_address=25, n_bits=1, signed_data=False)

    # biquad0 = BiquadFilterSettings(sample_frequency=125e6 / 2**10)
    # biquad1 = BiquadFilterSettings(sample_frequency=125e6 / 2**10)
    # biquad2 = BiquadFilterSettings(sample_frequency=125e6 / 2**10)
    # biquad3 = BiquadFilterSettings(sample_frequency=125e6 / 2**10)

    # Biquad addresses
    biquad0_address = BiquadFilterAddresses(gpio_write_address='0x42000000', gpio_read_address='0x42000008',
                                       a1_address=4, a2_address=5, b0_address=6, b1_address=7, b2_address=8)

    biquad1_address = BiquadFilterAddresses(gpio_write_address='0x42000000', gpio_read_address='0x42000008',
                                       a1_address=9, a2_address=10, b0_address=11, b1_address=12, b2_address=13)

    biquad2_address = BiquadFilterAddresses(gpio_write_address='0x42000000', gpio_read_address='0x42000008',
                                       a1_address=14, a2_address=15, b0_address=16, b1_address=17, b2_address=18)

    biquad3_address = BiquadFilterAddresses(gpio_write_address='0x42000000', gpio_read_address='0x42000008',
                                       a1_address=19, a2_address=20, b0_address=21, b1_address=22, b2_address=23)

    def apply_biquad_filter_settings(self, biquad_number, center_frequency, q_factor, gain):
        # compute params for a notch filter
        K = np.tan(np.pi * center_frequency / self.fs)
        norm = 1 / (1 + K / q_factor + K * K)
        b0 = (1 + K * K) * norm
        b1 = 2 * (K * K - 1) * norm
        b2 = b0
        a1 = b1
        a2 = (1 - K / q_factor + K * K) * norm

        # apply settings
        self.write_biquad(biquad_number, a1, a2, b0, b1, b2)

    @property
    def delay(self):
        return self.delay_cycles / self.fs

    @delay.setter
    def delay(self, value):
        self.delay_cycles = int(value * self.fs)

    @property
    def output_mux_0(self):
        return self.read_muxed_register_decimal(self.output_mux_0_address)

    @output_mux_0.setter
    def output_mux_0(self, value):
        self.write_muxed_register_decimal(self.output_mux_0_address, value)

    @property
    def output_mux_1(self):
        return self.read_muxed_register_decimal(self.output_mux_1_address)

    @output_mux_1.setter
    def output_mux_1(self, value):
        self.write_muxed_register_decimal(self.output_mux_1_address, value)

    @property
    def delay_input_mux(self):
        return self.read_muxed_register_decimal(self.delay_input_mux_address)

    @delay_input_mux.setter
    def delay_input_mux(self, value):
        self.write_muxed_register_decimal(self.delay_input_mux_address, value)

    @property
    def delay_output_mux(self):
        return self.read_muxed_register_decimal(self.delay_output_mux_address)

    @delay_output_mux.setter
    def delay_output_mux(self, value):
        self.write_muxed_register_decimal(self.delay_output_mux_address, value)

    @property
    def aom_enable(self):
        return bool(self.read_muxed_register_decimal(self.aom_enable_mux_address))

    @aom_enable.setter
    def aom_enable(self, value):
        self.write_muxed_register_decimal(self.aom_enable_mux_address, int(bool(value)))

    # =======================================
    # ========  LOW LEVEL INTERFACE  ========
    # =======================================
    def write_biquad(self, biquad_number, a1, a2, b0, b1, b2):
        biquad_address = [self.biquad0_address, self.biquad1_address,
                          self.biquad2_address, self.biquad3_address][biquad_number]
        self.write_muxed_register_decimal(biquad_address.a1, int(a1 * 2**biquad_address.bitshift))
        self.write_muxed_register_decimal(biquad_address.a2, int(a1 * 2**biquad_address.bitshift))
        self.write_muxed_register_decimal(biquad_address.b0, int(a1 * 2**biquad_address.bitshift))
        self.write_muxed_register_decimal(biquad_address.b1, int(a1 * 2**biquad_address.bitshift))
        self.write_muxed_register_decimal(biquad_address.b2, int(a1 * 2**biquad_address.bitshift))

    @property
    def delay_cycles(self):
        return self.read_muxed_register_decimal(self.delay_address)

    @delay_cycles.setter
    def delay_cycles(self, value):
        self.write_muxed_register_decimal(self.delay_address, value)