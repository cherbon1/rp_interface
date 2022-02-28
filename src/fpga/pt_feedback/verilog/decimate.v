`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 11:05:30 AM
// Design Name: 
// Module Name: decimate
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
// The decimation block generates a clock enable vector of the same size as the counter
// Everytime one bit of the counter rolls over, the corresponding ce_o bit will be high for one clock cycle
// 
//////////////////////////////////////////////////////////////////////////////////


module decimate #(
    parameter INPUT_WIDTH = 14,
    parameter LOG2_DECIMATION_FACTOR = 5,
    parameter DROP_LSB = 0
) (
    input clk_i,
    input rst_ni,
    
    input [INPUT_WIDTH-1:0] data0_i,
//    input [INPUT_WIDTH-1:0] data1_i,
    
    output [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data0_o,
//    output [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data1_o,
    
    output ce_o
    );

// declare signals
reg [LOG2_DECIMATION_FACTOR-1:0] counter_d, counter_q;
reg ce_d, ce_q;
reg [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-1:0] sum_data0_d, sum_data0_q;
reg [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data0_d, data0_q;
//reg [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-1:0] sum_data1_d, sum_data1_q;
//reg [INPUT_WIDTH+LOG2_DECIMATION_FACTOR-DROP_LSB-1:0] data1_d, data1_q;

// connect wires 
assign ce_o = ce_q;

    assign data0_o = data0_q;
//assign data1_o = data1_q;

// combinatorial block
always @(*) begin
    // defaults
    data0_d = data0_q;
//    data1_d = data1_q;
    
    // increment counter and generate clock enable signals
    // Detects bit rollover. If a bit rolls over, the next value is 0 while the current output is still 1
    // (i.e. detects a falling edge)
    counter_d = counter_q + 1;
    ce_d = ~counter_d[LOG2_DECIMATION_FACTOR-1] & counter_q[LOG2_DECIMATION_FACTOR-1];
    
    // If MSB rolled over, output sum and start over, otherwise add to sum
    // unconventional to check state of ce_d (rather than ce_q), but it makes the syntax easier
    if (ce_d) begin
        sum_data0_d = $signed(data0_i);  // force signed for proper padding
        data0_d = sum_data0_q[INPUT_WIDTH+LOG2_DECIMATION_FACTOR-1:DROP_LSB];  // drop LSBs
        
//        sum_data1_d = $signed(data1_i);
//        data1_d = sum_data1_q[INPUT_WIDTH+LOG2_DECIMATION_FACTOR-1:DROP_LSB];
    end else begin
        // For signed arithmetic, explicitly pad data0_i with LOG2_DECIMATION_FACTOR of MSB (sign bit)
        // This could also be achieved with a signed reg (e.g. how I did it for shift_mult_out in biquad_filter.v)
        // Both implementations should be identical in hardware
        sum_data0_d = sum_data0_q + {{LOG2_DECIMATION_FACTOR{data0_i[INPUT_WIDTH-1]}},data0_i};
//        sum_data1_d = sum_data1_q + {{LOG2_DECIMATION_FACTOR{data1_i[INPUT_WIDTH-1]}},data1_i};
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        counter_q <= 0;
        ce_q <= 0;
        sum_data0_q <= 0;
//        sum_data1_q <= 0;
        data0_q <= 0;
//        data1_q <= 0;
    end else begin
        counter_q <= counter_d;
        ce_q <= ce_d;
        sum_data0_q <= sum_data0_d;
//        sum_data1_q <= sum_data1_d;
        data0_q <= data0_d;
//        data1_q <= data1_d;
    end
    
end
    
    
endmodule
