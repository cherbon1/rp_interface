`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2022 11:27:59 AM
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
// 
//////////////////////////////////////////////////////////////////////////////////


module fine_delay_line #(
    parameter DATA_WIDTH = 17,
    parameter LOG2_MAX_DELAY = 3
) (
    input clk_i,
    input rst_ni,
    
    input [LOG2_MAX_DELAY-1:0] delay_i,
    
    input data_valid_i,
    input [DATA_WIDTH-1:0] data_i,
    
    output data_valid_o,
    output [DATA_WIDTH-1:0] data_o
    );
    
// define registers
reg [LOG2_MAX_DELAY-1:0] counter_d, counter_q;
reg data_valid_d, data_valid_q;
reg [DATA_WIDTH-1:0] input_data_d, input_data_q, delayed_data_d, delayed_data_q;

// connect outputs
assign data_valid_o = data_valid_q;
assign data_o = delayed_data_q;

// combinatorial block
always @* begin
    //defaults
    data_valid_d = 0;
    input_data_d = input_data_q;
    delayed_data_d = delayed_data_q;
    counter_d = counter_q - 1;
    
    // If new data comes in, reset counter and store data
    if (data_valid_i) begin
        counter_d = delay_i;
        input_data_d = data_i;
    end
    
    // If counter reaches 0 load input data into delayed data
    if (counter_q == 0) begin
        delayed_data_d = input_data_q;
        data_valid_d = 1;
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        counter_q <= 0;
        data_valid_q <= 0;
        input_data_q <= 0;
        delayed_data_q <= 0;
    end else begin
        counter_q <= counter_d;
        data_valid_q <= data_valid_d;
        input_data_q <= input_data_d;
        delayed_data_q <= delayed_data_d;
    end
    
end
    

endmodule
