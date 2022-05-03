`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 08:43:20 PM
// Design Name: 
// Module Name: fine_gain
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
// Multiply two numbers, output DATA_WIDTH MSBs 
// This is equivalent to multplying the input by a value in the range +/- 0.5
// 
//////////////////////////////////////////////////////////////////////////////////


module fine_gain #(
    parameter DATA_WIDTH = 24,
    parameter GAIN_WIDTH = 18
) (
    input clk_i,
    input rst_ni,
    
    input signed [DATA_WIDTH-1:0] data_i,
    input signed [GAIN_WIDTH-1:0] gain_i,
    
    output [DATA_WIDTH-1:0] data_o
    );

// declare wires
wire signed [DATA_WIDTH+GAIN_WIDTH-1:0] product_w;

assign data_o = product_w[DATA_WIDTH+GAIN_WIDTH-1:GAIN_WIDTH-1];

// declare sub-modules
simple_multiplier_internal #(
    .WIDTH_A(DATA_WIDTH),
    .WIDTH_B(GAIN_WIDTH)
) inst_mult (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .a_i(data_i),
    .b_i(gain_i),
    .c_o(product_w)
);
    
    
endmodule
