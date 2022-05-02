`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 04:24:34 PM
// Design Name: 
// Module Name: coarse_gain_and_limiter
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
// Multiply input signal by 2**log2_gain_i. In case of an overflow, the output will
// saturate rather than overflow. The output is then fit into OUTPUT_WIDTH bits.
// MAX_LOG2_GAIN is the maximum bitshift that can be done, and it should be equal to 
// 2**WIDTH_LOG2_GAIN - 1. Both constants are required internally for properly handling
// large bitshifts, and due to verilog limitations, we can't directly calculate WIDTH_LOG2_GAIN from
// MAX_LOG2_GAIN...
// 
//////////////////////////////////////////////////////////////////////////////////


module coarse_gain_and_limiter #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 14,
    parameter MAX_LOG2_GAIN = 3,
    parameter WIDTH_LOG2_GAIN = 2
) (
    input clk_i,
    input rst_ni,
    
    input [WIDTH_LOG2_GAIN-1:0] log2_gain_i,
    input [INPUT_WIDTH-1:0] data_i,
    
    output [OUTPUT_WIDTH-1:0] data_o
    );
    // add INPUT_WIDTH - OUTPUT_WIDTH + WIDTH_LOG2_GAIN bits of padding to internal data
    // wire to avoid bit shifting troubles
    localparam INTERNAL_DATA_WIDTH = INPUT_WIDTH + INPUT_WIDTH - OUTPUT_WIDTH + MAX_LOG2_GAIN;
    localparam PADDING_WIDTH = INPUT_WIDTH - OUTPUT_WIDTH + MAX_LOG2_GAIN;
    
// declare signals
reg [OUTPUT_WIDTH-1:0] data_d, data_q;
reg [INPUT_WIDTH-1:0] bitmask;

// define wires
// extend data_wire to 
wire [INTERNAL_DATA_WIDTH-1:0] internal_data_w;
assign internal_data_w = {data_i, {PADDING_WIDTH{1'b0}} };

// connect outputs
assign data_o = data_q;

// combinatorial block
always @* begin
    // The (log2_gain_i + 1) MSBs must be the same. If they differ, saturate
    // select leading bits
    // if leading_bits equals all ones or all zeros, no saturation
    // if leading bits not all equal, saturate based on value of sign bit
    bitmask = $signed({1'b1, {(INPUT_WIDTH-1){1'b0}} }) >>> log2_gain_i;
    if ((bitmask & data_i) == bitmask || (bitmask & data_i) == 0) begin
        // If no saturation, 
        data_d = internal_data_w >> (INPUT_WIDTH + PADDING_WIDTH - OUTPUT_WIDTH - log2_gain_i);
    end else if (data_i[INPUT_WIDTH-1]) begin
        // if inputs saturates and is negative
        data_d = {1'b1, {(OUTPUT_WIDTH-1){1'b0}} };  // most negative number
    end else begin
        // if inputs saturates and is positive
        data_d = {1'b0, {(OUTPUT_WIDTH-1){1'b1}} };  // most positive number 
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        data_q <= 0;
    end else begin
        data_q <= data_d;
    end
end

    
endmodule
