`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Eric Bonvin
// 
// Create Date: 11/16/2021 01:17:41 PM
// Design Name: 
// Module Name: two_way_mux
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


module mux_2x1 #(
    parameter WIDTH = 16
) (
    input clk_i,
    input rst_ni,
    
    input sel_i,
    
    input [WIDTH-1:0] in0_i,
    input [WIDTH-1:0] in1_i,
    
    output [WIDTH-1:0] out_o
    );

// declare signals
reg [WIDTH-1:0] out_d, out_q;

// connect wires
assign out_o = out_q;

// combinatorial block
always @* begin
    case(sel_i)
        0       : out_d = in0_i;
        1       : out_d = in1_i;
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
