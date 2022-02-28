`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Eric Bonvin
// 
// Create Date: 11/16/2021 11:41:52 AM
// Design Name: 
// Module Name: edge_detector
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
// Synchronously detect positive edges of sig_i. When sig_i goes high
// pe_o (positive_edge_output) will be high for one clock cycle
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detector(
    input clk_i,
    input rst_ni,
    input sig_i,
    output pe_o
    );
    
// define signals
reg sig_delay;  // signal delayed by one clock cycle

// Assign output
assign pe_o = sig_i & ~sig_delay;

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        sig_delay <= 0;
    end else begin
        sig_delay <= sig_i;
    end
end

endmodule
