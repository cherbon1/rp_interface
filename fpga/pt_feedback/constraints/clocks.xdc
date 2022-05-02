create_clock -period 8.000 -name adc_clk [get_ports adc_clk_p_i]

set_input_delay -clock adc_clk -max 3.400 [get_ports {adc_dat_a_i[*]}]
set_input_delay -clock adc_clk -max 3.400 [get_ports {adc_dat_b_i[*]}]

create_clock -period 4.000 -name rx_clk [get_ports {daisy_p_i[1]}]


#set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks adc_clk]
#set_false_path -from [get_clocks adc_clk] -to [get_clocks clk_fpga_0]

#create_generated_clock -name dac_clk_o -source [get_pins system_i/red_pitaya_dac_0/inst/ODDR_clk/C] -divide_by 1 -invert [get_ports dac_clk_o]
#create_generated_clock -name dac_sel_o -source [get_pins system_i/red_pitaya_dac_0/inst/ODDR_sel/C] -divide_by 1 -invert [get_ports dac_sel_o]
#create_generated_clock -name dac_wrt_o -source [get_pins system_i/red_pitaya_dac_0/inst/ODDR_wrt/C] -divide_by 1 -invert [get_ports dac_wrt_o]

#set_false_path -to [get_pins */multi_GPIO_?/GPIO_mux_?/gpio1_i*_reg[*]]
#set_false_path -from [get_cells -hierarchical */multi_GPIO_?/GPIO_mux_?/gpio2_o[*]]
#set_false_path -from [get_cells -hierarchical */multi_GPIO_?/GPIO_super_mux_?/gpio2_o[*]]