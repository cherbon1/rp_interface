`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 11:17:00 PM
// Design Name: 
// Module Name: decimate_and_delay_tb
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


module decimate_and_delay_tb #(
    parameter INPUT_WIDTH = 14,
    parameter DROP_LSB = 1, // How much precision on the output should be ignored?
    parameter LOG2_DECIMATION_FACTOR = 5,  // Larger decimation factor mean less area use but also lower effective sample freq
    parameter LOG2_MAX_DELAY = 15  // Longer max delay 
)(

    );
    
    
    reg clk_i;
    reg rst_ni;
    
    reg [LOG2_MAX_DELAY-1:0] delay_i;
    reg [INPUT_WIDTH-1:0] data_i;
    
    wire data_valid_o;
    wire [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data_o;
    
decimate_and_delay #(
    .INPUT_WIDTH(INPUT_WIDTH),
    .DROP_LSB(DROP_LSB),
    .LOG2_DECIMATION_FACTOR(LOG2_DECIMATION_FACTOR),
    .LOG2_MAX_DELAY(LOG2_MAX_DELAY)
) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .delay_i(delay_i),
    .data_i(data_i),
    .data_valid_o(data_valid_o),
    .data_o(data_o)
    );
    
     

    // setup clock
    initial begin
        clk_i = 1;
    end
    
    always
        #5 clk_i = ~clk_i; // 100MHz clock
        
    // setup a sawtooth wave
    initial begin
        data_i = 1;
    end
    
    always
        #10 data_i = data_i + 5; // 100MHz clock
        
    
    
    initial begin
        // perform reset
        rst_ni = 1;
        #20 rst_ni = 0;
        #20 rst_ni = 1;
        
        // max_delay is 511 --> 5110ns
    
        // define inputs
        delay_i = 1;
        #10300
        #10300
        #10300
        #10300
        #10300
        
        delay_i = 12000;
        #10300
        #10300
        #10300
        #10300
        
        delay_i = 3000;
        #10300
        #10300
        #10300
        #10300
        #10300
        
        delay_i = 14000;
        #1700
        #10300
        #10300
        #10300
        #10300
        
        delay_i = 1506;
        #1700
        #10300
        #10300
        #10300
        
        #130
        delay_i = 511;
        #160 data_i = 10;
        #160 data_i = 2;
        #160 data_i = 20;
        #5200;
        
        
        
    end
endmodule
