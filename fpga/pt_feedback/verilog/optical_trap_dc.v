`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 12:38:50 PM
// Design Name: 
// Module Name: optical_trap_dc
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
// 
//////////////////////////////////////////////////////////////////////////////////


module optical_trap_dc #(
    parameter COUNTER_WIDTH = 18,
    parameter DATA_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input [COUNTER_WIDTH-1:0] delay_cycles_i,
    input [COUNTER_WIDTH-1:0] toggle_cycles_i,
    
    input trig_i,
    
    input trap_enable_i,
    
    output [DATA_WIDTH-1:0] data_o
    );
    
    localparam MAX_VALUE = 2**(DATA_WIDTH-1) - 1;  // max value for a signed integer


// declare wires 
wire [DATA_WIDTH-1:0] data_w;

// declare sub-modules
triggered_toggle #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) inst_trig_toggle_opt_dc (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(1'b1),
    .trig_i(trig_i),
    .idle_data_i(MAX_VALUE), // idle max value
    .toggle_data_i(1'b0),                // active zero
    .delay_cycles_i(delay_cycles_i),
    .toggle_cycles_i(toggle_cycles_i),
    .data_o(data_w)
);

// data_o outputs trigger if trap_enable_i, otherwise outputs 0
mux_2x1_internal #(
    .WIDTH(DATA_WIDTH)
) inst_mux_opt_dc (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sel_i(trap_enable_i),
    .in0_i({DATA_WIDTH{1'b0}}),
    .in1_i(data_w),
    .out_o(data_o)
);


endmodule
