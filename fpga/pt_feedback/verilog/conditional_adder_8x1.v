`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 02:53:05 PM
// Design Name: 
// Module Name: conditional_adder
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


module conditional_adder_8x1 #(
    parameter INPUT_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input [7:0] add_select_i,
    
    input signed [INPUT_WIDTH-1:0] data0_i,
    input signed [INPUT_WIDTH-1:0] data1_i,
    input signed [INPUT_WIDTH-1:0] data2_i,
    input signed [INPUT_WIDTH-1:0] data3_i,
    input signed [INPUT_WIDTH-1:0] data4_i,
    input signed [INPUT_WIDTH-1:0] data5_i,
    input signed [INPUT_WIDTH-1:0] data6_i,
    input signed [INPUT_WIDTH-1:0] data7_i,
    
    output signed [INPUT_WIDTH+2:0] data_o
    );

    
// declare signals
reg signed [INPUT_WIDTH+2:0] data_d, data_q;


// connect outputs
assign data_o = data_q;

// combinatorial block
always @* begin
    data_d = 0;
    if (add_select_i[0]) data_d = data_d + data0_i;
    if (add_select_i[1]) data_d = data_d + data1_i;
    if (add_select_i[2]) data_d = data_d + data2_i;
    if (add_select_i[3]) data_d = data_d + data3_i;
    if (add_select_i[4]) data_d = data_d + data4_i;
    if (add_select_i[5]) data_d = data_d + data5_i;
    if (add_select_i[6]) data_d = data_d + data6_i;
    if (add_select_i[7]) data_d = data_d + data7_i;
end

    

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data_q <= 0;
    end else begin
        data_q <= data_d;
    end
    
end

endmodule
