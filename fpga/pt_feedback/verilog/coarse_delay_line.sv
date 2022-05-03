`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2022 05:52:56 PM
// Design Name: 
// Module Name: coarse_delay_stage
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


module coarse_delay_line #(
    parameter WIDTH = 14,
    parameter LOG2_MAX_DELAY = 4
) (
    input clk_i,
    input rst_ni,
    input ce_i,
    
    input [LOG2_MAX_DELAY-1:0] delay_i,
    input [WIDTH-1:0] data_i,
    
    output data_valid_o,
    output [WIDTH-1:0] data_o
    );

    localparam ARRAY_WIDTH = 2**LOG2_MAX_DELAY;

    // declare signals
    reg [0:ARRAY_WIDTH-1] [WIDTH-1:0] delayed_data_array_d, delayed_data_array_q;
    reg data_valid_d, data_valid_q;
    
    // connect wires
    assign data_valid_o = data_valid_q;
    assign data_o = delayed_data_array_q[delay_i];
    
    always @(*) begin
        // defaults
        delayed_data_array_d = delayed_data_array_q;
        data_valid_d = 0;
        
        // If clock enable, shift data in registers and turn data_valid on
        if (ce_i) begin
            delayed_data_array_d[0] = data_i;
            delayed_data_array_d[1:ARRAY_WIDTH-1] = delayed_data_array_q[0:ARRAY_WIDTH-2];
            data_valid_d = 1;
        end
        
    end
    
    // sequential block
    always @(posedge clk_i or negedge rst_ni) begin
        if (~rst_ni) begin
            delayed_data_array_q <= 0;
            data_valid_q <= 0;
        end else begin
            delayed_data_array_q <= delayed_data_array_d;
            data_valid_q <= data_valid_d;
        end
end
endmodule
