`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 01:08:01 PM
// Design Name: 
// Module Name: multiply_and_invert
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
// Multiply inputs and invert. The inverted product of 2 n-bit signed integers fits in a 2n-2 bit integer
// which makes use of the full dynamic range
// 
//////////////////////////////////////////////////////////////////////////////////


module multiply_and_invert #(
    parameter DATA_WIDTH = 18
)(
    input clk_i,
    input rst_ni,
    
    input signed [DATA_WIDTH-1:0] a_i,
    input signed [DATA_WIDTH-1:0] b_i,
    
    output signed [2*DATA_WIDTH-2:0] c_o
    );
    
// declare signals
reg [2*DATA_WIDTH-1:0] c_q;

// connect outputs
// drop MSB (sign bit and MSB are the same, so this works)
assign c_o = c_q[2*DATA_WIDTH-2:0];

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        c_q <= 0;
    end else begin
        c_q <= - a_i * b_i;
    end
end

endmodule

