`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 12:55:59 PM
// Design Name: 
// Module Name: GPIO_trigger_pulse
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// When trig_i comes in, waits for delay then sends out a 400ns (50 cycle) wide pulse.
// There are two outputs: trig_o is 1-bit wide, data_trig_o is 14-bits wide, to be sent to DAC
// 
//////////////////////////////////////////////////////////////////////////////////


module GPIO_trigger_pulse #(
    parameter COUNTER_WIDTH = 26
) (
    input clk_i,
    input rst_ni,
    
    input trig_i,
    
    input [COUNTER_WIDTH-1:0] delay_cycles_i,
    
    output trig_o,
    output [13:0] data_trig_o
    );

// 8191 is the max value for a 14 bit signed int
assign data_trig_o = trig_o ? 8191 : 0;

// declare sub-modules
triggered_toggle #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .DATA_WIDTH(1)
) inst_trig_toggle_opt_dc (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(1'b1),
    .trig_i(trig_i),
    .idle_data_i(1'b0), // idle is input valuelow
    .toggle_data_i(1'b1), // active is high
    .delay_cycles_i(delay_cycles_i),
    .toggle_cycles_i(50),
    .data_o(trig_o)
);
endmodule
