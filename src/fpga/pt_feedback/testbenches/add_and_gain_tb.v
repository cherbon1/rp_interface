`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 03:47:46 PM
// Design Name: 
// Module Name: add_and_gain_tb
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


module add_and_gain_tb #(
    parameter INPUT_WIDTH = 14,
    parameter OUTPUT_WIDTH = 14,
    parameter MAX_LOG2_GAIN = 3,
    parameter WIDTH_LOG2_GAIN  = 2
) ();

    // adder signals
    
    reg clk_i;
    reg rst_ni;
    
    reg [3:0] add_select0_i;
    reg [3:0] add_select1_i;
    
    reg [INPUT_WIDTH-1:0] data0_i;
    reg [INPUT_WIDTH-1:0] data1_i;
    reg [INPUT_WIDTH-1:0] data2_i;
    reg [INPUT_WIDTH-1:0] data3_i;
    
    wire [INPUT_WIDTH+1:0] data0_o;
    wire [INPUT_WIDTH+1:0] data1_o;
    
    // coarse gain signals
    
    reg [WIDTH_LOG2_GAIN-1:0] log2_gain_i;
    
    wire [INPUT_WIDTH-1:0] data_o;
    
    
    conditional_adder_4x2 #(
        .INPUT_WIDTH(INPUT_WIDTH)
    ) adder_uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        
        .add_select0_i(add_select0_i),
        .add_select1_i(add_select1_i),
        
        .data0_i(data0_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .data3_i(data3_i),
        
        .data0_o(data0_o),
        .data1_o(data1_o)
    );

    
    coarse_gain_and_limiter #(
        .INPUT_WIDTH(INPUT_WIDTH+2),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .MAX_LOG2_GAIN(MAX_LOG2_GAIN),
        .WIDTH_LOG2_GAIN(WIDTH_LOG2_GAIN)
    ) coarse_gain_uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .log2_gain_i(log2_gain_i),
        .data_i(data0_o),
        .data_o(data_o)
    );
    
// setup clock
initial begin
    clk_i = 1;
end

always
    #5 clk_i = ~clk_i; // 100MHz clock


// setup input data ramp
initial begin
    data0_i = 0;
    data1_i = 0;
    data2_i = 0;
    data3_i = 0;
    
    add_select0_i = 1;
    add_select1_i = 3;
    log2_gain_i = 2;
end

always
    #10 data0_i = data0_i + 100; 
    
always
    #10 data1_i = data1_i + 150; 
    
always
    #10 data2_i = data2_i + 275; 
    
always
    #10 data3_i = data3_i + 515; 

initial begin
    // perform reset
    rst_ni = 1;
    #20 rst_ni = 0;
    #20 rst_ni = 1;

    // define inputs
    
end



endmodule
