`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2022 11:22:00 AM
// Design Name: 
// Module Name: decimate_and_delay
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
// Defines a decimation filter followed by coarse and fine delay stages.
// The sample frequency of the output will be the input frequency divided by 2**LOG2_DECIMATION_FACTOR
// The max achievable delay is given by 2**LOG2_MAX_DELAY/input frequency
// The width of the output will be input width + LOG2_DECIMATION_FACTOR - DROP_LSB
// The required number of flip flops will roughly be output width * (2**(LOG2_MAX_DELAY - LOG2_DECIMATION_FACTOR) + LOG2_DECIMATION_FACTOR)
// 
// Example:
// Input frequency of 31.25MHz, input width 16-bits (and DROP_LSB of 0)
// LOG2_DECIMATION_FACTOR = 6 --> output sample frequnecy of 488.28 kHz
// LOG2_MAX_DELAY = 12 --> max output delay 131us, corresponding to a minimum frequency of 1.9kHz
// The output width is 16+6-0 = 22
// The required number of flip flops for this would be more than 22 * (64 + 5) = 1518
// 
//////////////////////////////////////////////////////////////////////////////////


module decimate_and_delay #(
    parameter INPUT_WIDTH = 14,
    parameter DROP_LSB = 0, // How much precision on the output should be ignored?
    parameter LOG2_DECIMATION_FACTOR = 5,  // Larger decimation factor mean less area use but also lower effective sample freq
    parameter LOG2_MAX_DELAY = 9  // Longer max delay 
) (
    input clk_i,
    input rst_ni,
    
    input [LOG2_MAX_DELAY-1:0] delay_i,
    input [INPUT_WIDTH-1:0] data_i,
    
    output data_valid_o,
    output [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data_o
    
    );
    
    localparam OUTPUT_WIDTH = INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB;
 
// declare wires 
wire [OUTPUT_WIDTH-1:0] data_o_dec, data_o_coarse;
wire ce_o_dec, data_valid_o_coarse;

// instantiate sub-modules
decimate #(
    .INPUT_WIDTH(INPUT_WIDTH),
    .LOG2_DECIMATION_FACTOR(LOG2_DECIMATION_FACTOR),
    .DROP_LSB(DROP_LSB)
) inst_dec (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .data0_i(data_i),
    .data0_o(data_o_dec),
    .ce_o(ce_o_dec)
);

coarse_delay_line #(
    .WIDTH(OUTPUT_WIDTH),
    .LOG2_MAX_DELAY(LOG2_MAX_DELAY-LOG2_DECIMATION_FACTOR)  // Timebase of coarse delay is ce_i
) inst_coarse_delay (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ce_i(ce_o_dec),
    .delay_i(delay_i[LOG2_MAX_DELAY-1:LOG2_DECIMATION_FACTOR]),
    .data_i(data_o_dec),
    .data_valid_o(data_valid_o_coarse),
    .data_o(data_o_coarse)
);


fine_delay_line #(
    .N_STAGES(LOG2_DECIMATION_FACTOR),
    .INPUT_WIDTH(OUTPUT_WIDTH)
) inst_fine_delay (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .delay_i(delay_i[LOG2_DECIMATION_FACTOR-1:0]),
    .data_valid_i(data_valid_o_coarse),
    .data_i(data_o_coarse),
    .data_valid_o(data_valid_o),
    .data_o(data_o)
    );

endmodule
