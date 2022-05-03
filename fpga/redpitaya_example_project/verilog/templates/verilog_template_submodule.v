`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Eric Bonvin
// 
// Create Date: 11/16/2021 08:12:15 AM
// Design Name: 
// Module Name: square_wave_dummy
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
// This is the square wave class that can also be found in square_wave.v
// I simply saved it as a template because it's an example of a file that's simple, but has
// enough going on to serve as an example of the xommonly used syntax.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module square_wave_dummy #(
    parameter WIDTH = 32,
    parameter INVERT = 0
) (
    input clk_i,
    input rst_ni,
    input [WIDTH-1:0] n_cycles_i,
    input trig_i,
    output wave_o,
    output [WIDTH-1:0] count_o
    );
 
// declare signals
reg wave_d, wave_q;

// declare wires 
wire counter_start, counter_done;

// connect wires 
if (INVERT)
    assign wave_o = ~wave_q;
else
    assign wave_o = wave_q;

// declare sub-modules
variable_counter #(
    .COUNTER_WIDTH(WIDTH)
) wave_on_counter (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .enable_i(wave_q), // trig_i is responsible for starting wave_q, which will launch the counter
    .counter_max_i(n_cycles_i),
    .count_o(count_o),
    .trig_o(counter_done)
);

edge_detector trig_i_edge_detector(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sig_i(trig_i),
    .pe_o(counter_start)
);

// combinatorial block
always @* begin
    wave_d = wave_q; // default statement
    if (counter_start) begin  // If trigger pulse comes, enable wave
        wave_d = 1'b1;
    end else if (counter_done) begin  // If the counter reaches the end, disable wave
        wave_d = 1'b0;
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        wave_q <= 0;
    end else begin
        wave_q <= wave_d;
    end
    
end


endmodule
