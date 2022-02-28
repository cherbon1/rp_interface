`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2022 03:50:43 PM
// Design Name: 
// Module Name: fine_delay_line_tb
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


module fine_delay_line_tb #(
    parameter LOG2_MAX_DELAY = 5,
    parameter DATA_WIDTH = 13
) (
    );
    
    reg clk_i;
    reg rst_ni;
    
    reg [LOG2_MAX_DELAY-1:0] delay_i;
    
    reg data_valid_i;
    reg [DATA_WIDTH-1:0] data_i;
    
    wire [DATA_WIDTH-1:0] data_o;
    wire data_valid_o;
    
    fine_delay_line #(
        .LOG2_MAX_DELAY(LOG2_MAX_DELAY),
        .DATA_WIDTH(DATA_WIDTH)
     ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        
        .delay_i(delay_i),
        
        .data_valid_i(data_valid_i),
        .data_i(data_i),
        
        .data_o(data_o),
        .data_valid_o(data_valid_o)
     );
     

    // setup clock
    initial begin
        clk_i = 1;
    end
    
    always
        #10 clk_i = ~clk_i; // 50MHz clock
    
    
    
    initial begin
        // perform reset
        rst_ni = 1;
        #20 rst_ni = 0;
        #20 rst_ni = 1;
    
        // define inputs
        data_i = 100;
        data_valid_i = 1; #20 data_valid_i=0;
        delay_i = 0;
        
        #1260 delay_i = 1;
        data_i=99;
        data_valid_i = 1; #20 data_valid_i=0;
        
        #1260 data_i=0;
        data_valid_i = 1; #20 data_valid_i=0;
        
        #1280 delay_i = 3;
        data_i=98;
        data_valid_i = 1; #20 data_valid_i=0;
        #1280 data_i=0;
        data_valid_i = 1; #20 data_valid_i=0;
        
        #1280 delay_i = 7;
        data_i=97;
        data_valid_i = 1; #20 data_valid_i=0;
        #1280 data_i=0;
        data_valid_i = 1; #20 data_valid_i=0;
        
        #2560 delay_i = 11;
        data_i=96;
        data_valid_i = 1; #20 data_valid_i=0;
        #1280 data_i=0;
        data_valid_i = 1; #20 data_valid_i=0;
        
        #2560 delay_i = -1;
        data_i=96;
        data_valid_i = 1; #20 data_valid_i=0;
        #1280 data_i=0;
        data_valid_i = 1; #20 data_valid_i=0;
        
    end
    
endmodule
