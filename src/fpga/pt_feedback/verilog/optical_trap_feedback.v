`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 12:41:35 PM
// Design Name: 
// Module Name: optical_trap_feedback
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


module optical_trap_feedback #(
    parameter COUNTER_WIDTH = 18,
    parameter DATA_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input [COUNTER_WIDTH-1:0] delay_cycles_i,
    input [COUNTER_WIDTH-1:0] toggle_cycles_i,
    
    input trig_i,
    
    input feedback_enable_i,
    
    input [DATA_WIDTH-1:0] data_i,
    output [2*DATA_WIDTH-2:0] data_o
    );
    localparam MULT_WIDTH = 2*DATA_WIDTH-1;
    
// declare wires
wire [MULT_WIDTH-1:0] mult_w, data_w;

// declare sub-modules
multiply_and_invert #(
    .DATA_WIDTH(DATA_WIDTH)
) inst_mult_inv_opt_fb (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .a_i(data_i),
    .b_i(data_i),
    .c_o(mult_w)
);

triggered_toggle #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .DATA_WIDTH(MULT_WIDTH)
) inst_trig_toggle_opt_fb (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(1'b1),
    .trig_i(trig_i),
    .idle_data_i(mult_w), // idle squared value
    .toggle_data_i({MULT_WIDTH{1'b0}}), // active zero
    .delay_cycles_i(delay_cycles_i),
    .toggle_cycles_i(toggle_cycles_i),
    .data_o(data_w)
);
    
    // data_o outputs trigger if feedback_enable, otherwise outputs 
mux_2x1_internal #(
    .WIDTH(MULT_WIDTH)
) inst_mux_opt_fb (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sel_i(feedback_enable_i),
    .in0_i({MULT_WIDTH{1'b0}}),
    .in1_i(data_w),
    .out_o(data_o)
);
    
endmodule
