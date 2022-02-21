from dataclasses import dataclass
from typing import Union

import numpy as np
from rp_interface import red_pitaya_controller, red_pitaya_comms
from rp_interface.modules import biquad_filter, filter_block, aom_block, multiplexer, conditional_adder, coarse_gain


class PaulTrapFeedbackController(red_pitaya_controller.RedPitayaController):
    bitfile = 'paul_trap_feedback_controller.bit'

    def defaults(self):
        pass

    def __init__(self,
                 red_pitaya: Union[red_pitaya_comms.RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False):
        super().__init__(red_pitaya=red_pitaya, load_bitfile=load_bitfile, apply_defaults=apply_defaults)


        # =======================================
        # ====== DEFINE REGISTER LOCATIONS ======
        # =======================================
        self.trigger_detector_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=0,
            n_bits=1,
            signed_data=False
        )

        self.input_mux_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=1,
            n_bits=1,
            signed_data=False
        )

        self.trap_enable_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=2,
            n_bits=1,
            signed_data=False
        )

        self.trap_delay_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=3,
            n_bits=26,
            signed_data=False
        )

        self.trap_toggle_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=4,
            n_bits=26,
            signed_data=False
        )

        self.feedback_enable_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=5,
            n_bits=1,
            signed_data=False
        )

        self.feedback_delay_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=6,
            n_bits=26,
            signed_data=False
        )

        self.feedback_toggle_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=7,
            n_bits=26,
            signed_data=False
        )

        self.feedback_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=8,
            n_bits=17,
            signed_data=True
        )

        self.simple_aom_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=12,
            n_bits=1,
            signed_data=False
        )

        self.conditional_adder0_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=13,
            n_bits=4,
            signed_data=False
        )

        self.conditional_adder1_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=14,
            n_bits=4,
            signed_data=False
        )

        self.post_adder0_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=15,
            n_bits=2,
            signed_data=False
        )

        self.post_adder1_gain_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=16,
            n_bits=2,
            signed_data=False
        )

        self.output_mux0_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=17,
            n_bits=3,
            signed_data=False
        )

        self.output_mux1_register = red_pitaya_comms.MuxedRegister(
            gpio_write_address='0x41200000',
            gpio_read_address='0x41200008',
            register_address=18,
            n_bits=3,
            signed_data=False
        )

        # =======================================
        # ====== DEFINE HIGH LEVEL MODULES ======
        # =======================================
        self.filter0 = filter_block.FilterModule(
            red_pitaya=self.rp,
            apply_defaults=False,
            gpio_write_address='0x41210000',
            gpio_read_address='0x41210008',
            fs=125e6,
            decimation_factor=2**10
        )

        self.aom = aom_block.AOMModule(
            red_pitaya=self.rp,
            apply_defaults=False,
            input_mux_register=self.input_mux_register,
            trap_enable_register=self.trap_enable_register,
            trap_delay_register=self.trap_delay_register,
            trap_toggle_register=self.trap_toggle_register,
            feedback_enable_register=self.feedback_enable_register,
            feedback_delay_register=self.feedback_delay_register,
            feedback_toggle_register=self.feedback_toggle_register,
            feedback_gain_register=self.feedback_gain_register,
            fs=125e6
        )

        self.simple_aom_module = multiplexer.BooleanMux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.simple_aom_register
        )

        self.adder0 = conditional_adder.ConditionalAdder(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.conditional_adder0_register
        )

        self.adder1 = conditional_adder.ConditionalAdder(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.conditional_adder1_register
        )

        self.adder0_gain_module = coarse_gain.CoarseGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.post_adder0_gain_register
        )

        self.adder1_gain_module = coarse_gain.CoarseGain(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.post_adder1_gain_register
        )

        self.output_mux0_module = multiplexer.Mux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.output_mux0_register
        )

        self.output_mux1_module = multiplexer.Mux(
            red_pitaya=self.rp,
            apply_defaults=False,
            register=self.output_mux1_register
        )

    @property
    def simple_aom_enable(self):
        return self.simple_aom_module.select

    @simple_aom_enable.setter
    def simple_aom_enable(self, value):
        self.simple_aom_module.select = value

    @property
    def adder0_gain(self):
        return self.adder0_gain_module.gain

    @adder0_gain.setter
    def adder0_gain(self, value):
        self.adder0_gain_module.gain = value

    @property
    def adder1_gain(self):
        return self.adder1_gain_module.gain

    @adder1_gain.setter
    def adder1_gain(self, value):
        self.adder1_gain_module.gain = value

    @property
    def output0_mux(self):
        return self.output_mux0_module.select

    @output0_mux.setter
    def output0_mux(self, value):
        self.output_mux0_module.select = value

    @property
    def output1_mux(self):
        return self.output_mux1_module.select

    @output1_mux.setter
    def output1_mux(self, value):
        self.output_mux1_module.select = value
