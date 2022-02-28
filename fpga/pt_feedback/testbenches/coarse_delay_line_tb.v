`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 10:01:37 PM
// Design Name: 
// Module Name: coarse_delay_line_tb
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


module coarse_delay_line_tb #(
parameter WIDTH = 14,
parameter LOG2_MAX_DELAY = 4
) (

    );
    
    
    reg clk_i;
    reg rst_ni;
    reg ce_i;
    
    reg [LOG2_MAX_DELAY-1:0] delay_i;
    reg [WIDTH-1:0] data_i;
    wire [WIDTH-1:0] data_o;

    coarse_delay_line #(
        .WIDTH(WIDTH),
        .LOG2_MAX_DELAY(LOG2_MAX_DELAY)
    ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .ce_i(ce_i),
        .delay_i(delay_i),
        .data_i(data_i),
        .data_o(data_o)
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
    
    
    
    initial begin
        // perform reset
        rst_ni = 1;
        #20 rst_ni = 0;
        #20 rst_ni = 1;
        #40;
    
        // define inputs
        data_i = 10;
        delay_i = 1;
        #400
        
        data_i = 15;
        delay_i = 2;
        #400
        
        
        data_i = 30;
        delay_i = 3;
        #400
        
        
        data_i = 10;
        delay_i = 8;
        #1600;
        
        data_i = 6;
        delay_i = 11;
        #1600;
        
        data_i = 15;
        
    end
    
endmodule
