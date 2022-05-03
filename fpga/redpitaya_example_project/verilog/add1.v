`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 06:11:25 PM
// Design Name: 
// Module Name: add1
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


module add1#(
    parameter WIDTH = 14
)(
    input clk_i,
    input rst_ni,
    input [WIDTH-1:0] data_i,
    output [WIDTH-1:0] data_o
    );

//// No flip flop implementation
//assign data_o = data_i + 1;


// Flip flop implementation
// declare signals
reg [WIDTH-1:0] data_q;

// connect outputs
assign data_o = data_q + 1;

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data_q <= 0;
    end else begin
        data_q <= data_i;
    end
end


endmodule
