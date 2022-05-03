`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2022 05:44:00 PM
// Design Name: 
// Module Name: mux_2x1_tb
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


module mux_2x1_tb #(
    parameter WIDTH = 16
) (

    );
    
// define signals
// inputs
reg clk_i;
reg rst_ni;
reg sel_i;
reg [WIDTH-1:0] in0_i;
reg [WIDTH-1:0] in1_i;

// outputs
wire [WIDTH-1:0] out_o;

// instantiate unit under test
mux_2x1 #(

) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sel_i(sel_i),
    .in0_i(in0_i),
    .in1_i(in1_i),
    .out_o(out_o)
);


// setup clock
initial
    clk_i = 0;
always
    #5 clk_i = ~clk_i; // 100MHz clock

// Make input 0 ramp up
initial
    in0_i = 0;
always
    #50 in0_i = in0_i + 10;

initial begin
    // define initial inputs
    in1_i = 100;
    sel_i = 0;
    
    // perform reset
    rst_ni = 1;
    #20 rst_ni = 0;
    #20 rst_ni = 1;

    // define sequence of inputs
    #100 sel_i = 1;
    #1000 sel_i = 0;
    #1000 sel_i = 1;
    #2000 sel_i = 0;
end

endmodule
