`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2022 08:15:43 PM
// Design Name: 
// Module Name: mux_8x1
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



module mux_8x1 #(
    parameter WIDTH = 14
) (
    input clk_i,
    input rst_ni,
	
	input [2:0] select_i,
	
    input [WIDTH-1:0] in0_i,
    input [WIDTH-1:0] in1_i,
    input [WIDTH-1:0] in2_i,
    input [WIDTH-1:0] in3_i,
    input [WIDTH-1:0] in4_i,
    input [WIDTH-1:0] in5_i,
    input [WIDTH-1:0] in6_i,
    input [WIDTH-1:0] in7_i,
	
    output [WIDTH-1:0] out_o
    );
 
// declare signals
reg [WIDTH-1:0] out_d, out_q;

// connect wires 
assign out_o = out_q;

// combinatorial block
always @* begin
    // assign outputs
    case(select_i)
        0       : out_d = in0_i;
        1       : out_d = in1_i;
        2       : out_d = in2_i;
        3       : out_d = in3_i;
        4       : out_d = in4_i;
        5       : out_d = in5_i;
        6       : out_d = in6_i;
        7       : out_d = in7_i;
        default : out_d = in0_i;
	endcase
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        out_q <= 0;
    end else begin
        out_q <= out_d;
    end
end


endmodule

