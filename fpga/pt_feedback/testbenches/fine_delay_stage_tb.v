`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 08:13:24 AM
// Design Name: 
// Module Name: fine_delay_stage_tb
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


module fine_delay_stage_tb #(
    parameter WIDTH = 14
) (
    );
    
    reg clk_i;
    reg rst_ni;
    
    reg ce_i;
    reg delay_enable_i;
    reg [WIDTH-1:0] data_i;
    
    wire ce_o;
    wire [WIDTH-1:0] data_o;
    
    fine_delay_stage#(
        .WIDTH(WIDTH)
     ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        
        .ce_i(ce_i),
        .delay_enable_i(delay_enable_i),
        .data_i(data_i),
        
        .ce_o(ce_o),
        .data_o(data_o)
     );
     

    // setup clock
    initial begin
        clk_i = 1;
    end
    
    always
        #10 clk_i = ~clk_i; // 50MHz clock
        
    // handle ce_i (will only work if 3 bits wide)
    // setup ce_i starts low
    initial begin
        ce_i = 0;
    end
    
    // handle bit 2
    always begin
        ce_i = 1; // set high
        #20 ce_i = 0; // wait for 1 clock cycle and go low
        #140;   // wait for 7 clock cycles
    end
    
    
    initial begin
        // perform reset
        rst_ni = 1;
        #20 rst_ni = 0;
        #20 rst_ni = 1;
    
        // define inputs
        #120 data_i = 100;
        delay_enable_i = 0;
        
        #460 delay_enable_i = 1;
        #20 data_i=99;
        
        #460 delay_enable_i = 0;
        #20 data_i=98;
        
        #460 delay_enable_i = 1;
        #20 data_i=97;
        
    end
endmodule
