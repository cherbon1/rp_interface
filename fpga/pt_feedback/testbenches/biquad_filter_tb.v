`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2022 10:00:02 AM
// Design Name: 
// Module Name: biquad_filter_tb
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





module biquad_filter_tb #(
        parameter INPUT_WIDTH = 17,
        parameter COEFF_WIDTH = 26,
        parameter OUTPUT_WIDTH = 36
    ) (

    );
    
    

    // inputs
    reg clk_i;
    reg rst_ni;
    reg reinit_i;
    
    reg [INPUT_WIDTH-1:0] data_i;
    reg data_valid_i;
    
    wire [OUTPUT_WIDTH-1:0] data_o;
    wire data_valid_o;
    
    wire busy_o;
    
    reg [COEFF_WIDTH-1:0] a1_i;
    reg [COEFF_WIDTH-1:0] a2_i;
    reg [COEFF_WIDTH-1:0] b0_i;
    reg [COEFF_WIDTH-1:0] b1_i;
    reg [COEFF_WIDTH-1:0] b2_i;
    
    biquad_filter #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .COEFF_WIDTH(COEFF_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH)
    ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .reinit_i(reinit_i),
        
        .data_i(data_i),
        .data_valid_i(data_valid_i),
        
        .data_o(data_o),
        .data_valid_o(data_valid_o),
        
        .busy_o(busy_o),
        
        .a1_i(a1_i),
        .a2_i(a2_i),
        .b0_i(b0_i),
        .b1_i(b1_i),
        .b2_i(b2_i)
    ); 


// setup clock
initial begin
    clk_i = 1;
end

always
    #5 clk_i = ~clk_i; // 100MHz clock

// setup data_valid input -- True for one clock cycle every 8 cycles
initial begin
    data_valid_i = 0;
end

always begin
    data_valid_i = 1; // go high
    #10 data_valid_i = 0; // wait for 1 clock cycle and go low
    #70;   // wait for 7 clock cycles
end


// setup input data ramp
initial begin
    data_i = 0;
end

always
    #10 data_i = data_i + 100; 

initial begin
    // perform reset
    rst_ni = 1;
    #20 rst_ni = 0;
    #20 rst_ni = 1;

    // define inputs
    
//    // low-q bandpass:
//    a1_i = $signed(-27915978);
//    a2_i = $signed(11161348);
//    b0_i = $signed(2807933);
//    b1_i = 0;
//    b2_i = $signed(-2807933);
    
//    // high-q bandpass:
//    a1_i = $signed(-33460049);
//    a2_i = $signed(16709904);
//    b0_i = $signed(33655);
//    b1_i = 0;
//    b2_i = $signed(-33655);
    
//    // single-pole highpass:
//    a1_i = $signed(727930);
//    a2_i = 0;
//    b0_i = $signed(16049285);
//    b1_i = 0;
//    b2_i = 0;
    
    // single-pole lowpass:
    a1_i = $signed(-16709886);
    a2_i = 0;
    b0_i = $signed(67329);
    b1_i = 0;
    b2_i = 0;
    
end

endmodule
