`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 06:11:25 PM
// Design Name: 
// Module Name: flip_flop
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


module flip_flop#(
    parameter WIDTH = 16
)(
    input clk_i,
    input rst_ni,
    input [WIDTH-1:0] data_i,
    output [WIDTH-1:0] data_o
    );
    
// declare signals
reg [WIDTH-1:0] data_q;

// connect outputs
assign data_o = data_q;

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data_q <= 0;
    end else begin
        data_q <= data_i;
    end
end


endmodule
