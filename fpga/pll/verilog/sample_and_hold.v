`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 10:27:39 AM
// Design Name: 
// Module Name: sample_and_hold
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
// A very simple module that outputs the latest read valid data
// 
//////////////////////////////////////////////////////////////////////////////////


module sample_and_hold #(
    parameter WIDTH = 16
) (
    input clk_i,
    input rst_ni,
    
    input data_valid_i,
    input [WIDTH-1:0] data_i,
    
    output data_valid_o,
    output [WIDTH-1:0] data_o
    );

// define signals
reg data_valid_d, data_valid_q;
reg [WIDTH-1:0] data_d, data_q;

// connect outputs
assign data_valid_o = data_valid_q;
assign data_o = data_q;


// combinatorial block
always @* begin
    // defaults
    data_valid_d = 0;
    data_d = data_q;
    
    if (data_valid_i == 1) begin
        data_valid_d = 1;
        data_d = data_i;
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data_valid_q <= 0;
        data_q <= 0;
    end else begin
        data_valid_q <= data_valid_d;
        data_q <= data_d;
    end
    
end
    
endmodule
