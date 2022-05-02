`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Eric Bonvin
// 
// Create Date: 03/02/2022 08:12:15 AM
// Design Name: 
// Module Name: dac_out_switch
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
// 8-to-2 multiplexer for 14-bit inputs. The two outputs are packed into a single 32-bit output
// compatible with the red pitaya DACs.
// Each input also takes a "Valid" input. A new value is only read when Valid is true, otherwise
// The previous value is kept.
// Takes up to 8 14-bit inputs, and 
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_8x2 #(
    parameter WIDTH = 14
) (
    input clk_i,
    input rst_ni,
	
	input [2:0] select0_i,
	input [2:0] select1_i,
	
    input [WIDTH-1:0] in0_i,
    input [WIDTH-1:0] in1_i,
    input [WIDTH-1:0] in2_i,
    input [WIDTH-1:0] in3_i,
    input [WIDTH-1:0] in4_i,
    input [WIDTH-1:0] in5_i,
    input [WIDTH-1:0] in6_i,
    input [WIDTH-1:0] in7_i,
	
    output [WIDTH-1:0] out0_o,
    output [WIDTH-1:0] out1_o
    );
 
// declare signals
reg [WIDTH-1:0] out0_d, out0_q, out1_d, out1_q;

// connect wires 
assign out0_o = out0_q;
assign out1_o = out1_q;

// combinatorial block
always @* begin
    // assign outputs
    case(select0_i)
        0       : out0_d = in0_i;
        1       : out0_d = in1_i;
        2       : out0_d = in2_i;
        3       : out0_d = in3_i;
        4       : out0_d = in4_i;
        5       : out0_d = in5_i;
        6       : out0_d = in6_i;
        7       : out0_d = in7_i;
        default : out0_d = in0_i;
	endcase
	
    case(select1_i)
        0       : out1_d = in0_i;
        1       : out1_d = in1_i;
        2       : out1_d = in2_i;
        3       : out1_d = in3_i;
        4       : out1_d = in4_i;
        5       : out1_d = in5_i;
        6       : out1_d = in6_i;
        7       : out1_d = in7_i;
        default : out1_d = in0_i;
	endcase
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        out0_q <= 0;
        out1_q <= 0;
    end else begin
        out0_q <= out0_d;
        out1_q <= out1_d;
    end
    
end


endmodule
