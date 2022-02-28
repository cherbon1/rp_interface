`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2022 10:46:45 AM
// Design Name: 
// Module Name: decimate_tb
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


module decimate_tb(

    );
    
    // inputs
    reg clk;
    reg rst;
    
    reg [13:0] data0_i;
//    reg [13:0] data1_i;
    
    wire [16:0] data0_o;
//    wire [16:0] data1_o;
    
    wire ce_o;
    
    decimate #(
        .INPUT_WIDTH(14),
        .LOG2_DECIMATION_FACTOR(4),
        .DROP_LSB(1)
    ) uut (
        .clk_i(clk),
        .rst_ni(rst),
        
        .data0_i(data0_i),
//        .data1_i(data1_i),
        
        .data0_o(data0_o),
//        .data1_o(data1_o),
        
        .ce_o(ce_o)
    ); 


// setup clock
initial begin
    clk = 0;
end

always
    #5 clk = ~clk; // 100MHz clock
    

initial begin
    // perform reset
    rst = 1;
    #20 rst = 0;
    #20 rst = 1;

    // define inputs
    data0_i = 100;
    #100 data0_i = -100;
    #1000 data0_i = -200;
    #1000 data0_i = 200;
    #2000 data0_i = -40000;
//    data1_i = 300;
end

endmodule
