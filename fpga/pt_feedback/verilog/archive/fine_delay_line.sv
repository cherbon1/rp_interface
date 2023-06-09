`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2022 02:38:28 PM
// Design Name: 
// Module Name: fine_delay_line
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
// Takes in data, and feeds it through a series of flip flops driven by differently paced clock-enable signals
// Each delay flip flop can be bypassed by setting the corresponding delay signal low (this will result in the 
// signal being passed through a the next clock cycle, rather than the clock enable cycle)
//
// The delay line is composed of CE_WIDTH delay stages, where ce_i is a vector of clock enable signals at
// different frequencies. The MSB is the slowest ce_signal while the LSB is the fastest ce_signal operating
// at clk/2.
// The first MSB of ce is ignored, b.c. that delay is generated by the coarse delay line.
// The final delay stage is fed a clock enable signal of 1, in order to adjust the delay down to the 
// single clock cycle
// 
//////////////////////////////////////////////////////////////////////////////////


module fine_delay_line #(
    parameter N_STAGES = 4,
    parameter INPUT_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input [N_STAGES-1:0] delay_i,
    
    input data_valid_i,
    input [INPUT_WIDTH-1:0] data_i,
    
    output data_valid_o,
    output [INPUT_WIDTH-1:0] data_o
    );
    
    
    
// declare chain of fine_delay_stages
// https://stackoverflow.com/questions/14078716/how-can-i-build-a-chain-of-modules
// This need to be done in SystemVerilog (double packed arrays forbidden in regular verilog
// So if you ever need to integrate this module directly in a block diagram, make a verilog
// wrapper around it first
wire [0:N_STAGES-2] [INPUT_WIDTH-1:0] data_N;
wire [0:N_STAGES-2] ce_N;
wire [0:N_STAGES-2] data_valid_N;
wire [N_STAGES-1:0] flipped_delay;  // delay needs to be flipped b.c. LSB corresponds to first stage
wire unused_output;


genvar i;
for (i=0; i<N_STAGES; i=i+1) assign flipped_delay[i] = delay_i[N_STAGES-1-i];

fine_delay_stage #(
    .WIDTH(INPUT_WIDTH)
   ) delay_stages[0:N_STAGES-1] (
    clk_i,
    rst_ni,
    {data_valid_i, data_valid_N},   //data_valid_i
    {1'b1, ce_N},                   //ce_i
    flipped_delay[N_STAGES-1:0],    // delay_enable_i
    {data_i, data_N},               // data_i
    {data_valid_N, data_valid_o},   // data_valid_o
    {ce_N, unused_output},           // ce_o
    {data_N, data_o}                // data_o
   );

endmodule
