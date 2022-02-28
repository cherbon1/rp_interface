`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 05:02:57 PM
// Design Name: 
// Module Name: bram_delay_line_tb
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


module bram_delay_line_tb #(
    parameter DATA_WIDTH = 17  // in range 10-18
    
) ();
    
    
reg clk_i;
reg rst_ni;

reg ce_i;

reg [DATA_WIDTH-1:0] data_i;
reg [13:0] delay0_i;
reg [13:0] delay1_i;
reg [13:0] delay2_i;
reg [13:0] delay3_i;
reg [13:0] delay4_i;
reg [13:0] delay5_i;
reg [13:0] delay6_i;
reg [13:0] delay7_i;

    
wire data_valid0_o;
wire [DATA_WIDTH-1:0] data0_o;
wire data_valid1_o;
wire [DATA_WIDTH-1:0] data1_o;
wire data_valid2_o;
wire [DATA_WIDTH-1:0] data2_o;
wire data_valid3_o;
wire [DATA_WIDTH-1:0] data3_o;
wire data_valid4_o;
wire [DATA_WIDTH-1:0] data4_o;
wire data_valid5_o;
wire [DATA_WIDTH-1:0] data5_o;
wire data_valid6_o;
wire [DATA_WIDTH-1:0] data6_o;
wire data_valid7_o;
wire [DATA_WIDTH-1:0] data7_o;
    
bram_delay_line #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(ce_i),
    .data_i(data_i),
    .delay0_i(delay0_i),
    .delay1_i(delay1_i),
    .delay2_i(delay2_i),
    .delay3_i(delay3_i),
    .delay4_i(delay4_i),
    .delay5_i(delay5_i),
    .delay6_i(delay6_i),
    .delay7_i(delay7_i),
    .data_valid0_o(data_valid0_o),
    .data0_o(data0_o),
    .data_valid1_o(data_valid1_o),
    .data1_o(data1_o),
    .data_valid2_o(data_valid2_o),
    .data2_o(data2_o),
    .data_valid3_o(data_valid3_o),
    .data3_o(data3_o),
    .data_valid4_o(data_valid4_o),
    .data4_o(data4_o),
    .data_valid5_o(data_valid5_o),
    .data5_o(data5_o),
    .data_valid6_o(data_valid6_o),
    .data6_o(data6_o),
    .data_valid7_o(data_valid7_o),
    .data7_o(data7_o)
);

    
    // setup clock
    initial begin
        clk_i = 1;
    end
    
    always
        #5 clk_i = ~clk_i; // 100MHz clock
    
    // setup clock enable
    initial begin
        ce_i = 0;
    end
    
    always begin
        ce_i = 1;
        #10 ce_i = 0;
        #70;
    end
    
    // setup data_i ramp function
    initial begin
        data_i = 0;
    end
    
    always begin
        #80 data_i = data_i + 100;
        
    end
    
    
    
    initial begin
        // perform reset
        rst_ni = 1;
        #20 rst_ni = 0;
        #20 rst_ni = 1;
        #40;
    
        // define inputs
        data_i = 10;
        delay0_i = 100;
        delay1_i = 300;
        delay2_i = 500;
        delay3_i = 0;
        delay4_i = 20;
        delay5_i = 2000;
        delay6_i = 4500;
        delay7_i = 10;
        #800;
        
    end
    
endmodule
