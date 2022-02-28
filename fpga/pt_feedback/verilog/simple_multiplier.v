`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 03:36:50 PM
// Design Name: 
// Module Name: simple_multiplier
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
// Default sizes are meant to match DSP multiplier size of DSP48E1 block of Zynq-7000 series chips
// The multiplier is spec'd for 25x18, but because of carry bits (I think), you should use 24x18 instead
// Using larger sizes will cause more DSP blocks to be used (multiply by 2 (or ceil(width/dim) for larger values)
// for every dimension that overflows, e.g. 32x16 would use 2 DSP blocks, and 32x32 would use 4 DSP blocks)
// 
//////////////////////////////////////////////////////////////////////////////////


module simple_multiplier #(
    parameter WIDTH_A = 24,
    parameter WIDTH_B = 18
)(
    input clk_i,
    input rst_ni,
    
    input signed [WIDTH_A-1:0] a_i,
    input signed [WIDTH_B-1:0] b_i,
    
    output signed [WIDTH_A+WIDTH_B-1:0] c_o
    );
    
// declare signals
reg [WIDTH_A+WIDTH_B-1:0] c_q;

// connect outputs
assign c_o = c_q;

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        c_q <= 0;
    end else begin
        c_q <= a_i * b_i;
    end
end

    
endmodule
