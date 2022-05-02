`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 02:53:05 PM
// Design Name: 
// Module Name: conditional_adder_8x2
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


module conditional_adder_8x2 #(
    parameter INPUT_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input [7:0] add_select0_i,
    input [7:0] add_select1_i,
    
    input signed [INPUT_WIDTH-1:0] data0_i,
    input signed [INPUT_WIDTH-1:0] data1_i,
    input signed [INPUT_WIDTH-1:0] data2_i,
    input signed [INPUT_WIDTH-1:0] data3_i,
    input signed [INPUT_WIDTH-1:0] data4_i,
    input signed [INPUT_WIDTH-1:0] data5_i,
    input signed [INPUT_WIDTH-1:0] data6_i,
    input signed [INPUT_WIDTH-1:0] data7_i,
    
    output signed [INPUT_WIDTH+2:0] data0_o,
    output signed [INPUT_WIDTH+2:0] data1_o
    );

    
// declare signals
reg signed [INPUT_WIDTH+2:0] data0_d, data0_q, data1_d, data1_q;


// connect outputs
assign data0_o = data0_q;
assign data1_o = data1_q;

// combinatorial block
always @* begin
    data0_d = 0;
    if (add_select0_i[0]) data0_d = data0_d + data0_i;
    if (add_select0_i[1]) data0_d = data0_d + data1_i;
    if (add_select0_i[2]) data0_d = data0_d + data2_i;
    if (add_select0_i[3]) data0_d = data0_d + data3_i;
    if (add_select0_i[4]) data0_d = data0_d + data4_i;
    if (add_select0_i[5]) data0_d = data0_d + data5_i;
    if (add_select0_i[6]) data0_d = data0_d + data6_i;
    if (add_select0_i[7]) data0_d = data0_d + data7_i;
	
    data1_d = 0;
    if (add_select1_i[0]) data1_d = data1_d + data0_i;
    if (add_select1_i[1]) data1_d = data1_d + data1_i;
    if (add_select1_i[2]) data1_d = data1_d + data2_i;
    if (add_select1_i[3]) data1_d = data1_d + data3_i;
    if (add_select1_i[4]) data1_d = data1_d + data4_i;
    if (add_select1_i[5]) data1_d = data1_d + data5_i;
    if (add_select1_i[6]) data1_d = data1_d + data6_i;
    if (add_select1_i[7]) data1_d = data1_d + data7_i;
end

    

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data0_q <= 0;
        data1_q <= 0;
    end else begin
        data0_q <= data0_d;
        data1_q <= data1_d;
    end
    
end

endmodule
