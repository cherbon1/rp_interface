`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2022 02:12:08 PM
// Design Name: 
// Module Name: mux_2x1_with_valid
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


module mux_2x1_with_valid #(
    parameter WIDTH = 16
) (
    input clk_i,
    input rst_ni,
    
    input sel_i,
    
    input data_valid0_i,
    input [WIDTH-1:0] in0_i,
    input data_valid1_i,
    input [WIDTH-1:0] in1_i,
    
    output data_valid_o,
    output [WIDTH-1:0] out_o
    );

// declare signals
reg [WIDTH-1:0] out_d, out_q;
reg data_valid_d, data_valid_q;

// connect wires
assign out_o = out_q;
assign data_valid_o = data_valid_q;

// combinatorial block
always @* begin
    case(sel_i)
        0 : begin
            out_d = in0_i;
            data_valid_d = data_valid0_i;
        end
        1 : begin
            out_d = in1_i;
            data_valid_d = data_valid1_i;
        end
        default : begin
            out_d = in0_i;
            data_valid_d = data_valid0_i;
        end
    endcase
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        out_q <= 0;
        data_valid_q <= 0;
    end else begin
        out_q <= out_d;
        data_valid_q <= data_valid_d;
    end
    
end
    
endmodule
