`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 11:11:16 PM
// Design Name: 
// Module Name: triggered_gate
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
// implements a triggered toggle
// ce_i is held high, active_i is 0
// 
//////////////////////////////////////////////////////////////////////////////////


module triggered_gate #(
    parameter COUNTER_WIDTH = 18,
    parameter DATA_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input trig_i,
    
    input [DATA_WIDTH-1:0] data_i,
    
    input [COUNTER_WIDTH-1:0] delay_cycles_i,
    input [COUNTER_WIDTH-1:0] toggle_cycles_i,
    
    output  [DATA_WIDTH-1:0] data_o
    );
    

// declare sub-modules
triggered_toggle #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) inst_trig_toggle_opt_dc (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(1'b1),
    .trig_i(trig_i),
    .idle_data_i(data_i), // idle is input value
    .toggle_data_i(1'b0), // active zero
    .delay_cycles_i(delay_cycles_i),
    .toggle_cycles_i(toggle_cycles_i),
    .data_o(data_o)
);
endmodule
