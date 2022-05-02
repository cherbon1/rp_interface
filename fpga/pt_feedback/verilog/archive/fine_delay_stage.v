`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2022 04:00:05 PM
// Design Name: 
// Module Name: delay_stage
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
// Takes in data and a clock enable signal. The data is released one clock enable cycle
// after being read if delay is enabled, immediately otherwise
// A frequency halved clock enable signal is also generated, for potential use in the next delay stage
// 
//////////////////////////////////////////////////////////////////////////////////


module fine_delay_stage #(
    parameter WIDTH=14
) (
    input clk_i,
    input rst_ni,
    
    input data_valid_i,     // data_valid_i should NOT be always on
    input ce_i,             // clock enable differs from data_valid because it is meant for time keeping, not for data validation
    input delay_enable_i,
    input [WIDTH-1:0] data_i,
    
    output data_valid_o,
    output ce_o,
    output [WIDTH-1:0] data_o
    );
 
// declare signals
reg [WIDTH-1:0] input_data_d, input_data_q; 
reg [WIDTH-1:0] output_data_d, output_data_q; 
reg counter_d, counter_q;
reg output_next_cycle_d, output_next_cycle_q;
reg data_valid_d, data_valid_q;
reg ce_d, ce_q;

// connect outputs
assign data_o = output_data_q;
assign data_valid_o = data_valid_q;
assign ce_o = ce_q;

always @ (*) begin
    // defaults
    counter_d = counter_q;
    input_data_d = input_data_q;
    output_data_d = output_data_q;
    output_next_cycle_d = output_next_cycle_q;
    data_valid_d = 0;
    ce_d = 0;
    
    // At every clock enable
    if (ce_i) begin
        output_next_cycle_d = 0;
        // Increment counter, raise ce if counter is at 0
        counter_d = counter_q+1;
        ce_d = ce_i & (counter_q == 0);
        
        // If valid data arrived, load input data
        if (data_valid_i) begin
            input_data_d = data_i;
            
            // If delay is enabled, flag it for output at next clock cycle
            // Otherwise, output it now
            // When outputting, raise clock enable and reset counter to 1 to keep data_valid and clock_enable synced
            if (delay_enable_i) begin
                output_next_cycle_d = 1;
            end else begin
                output_data_d = data_i;
                data_valid_d = 1;
                ce_d = 1;
                counter_d = 1;
            end
        end
        
        // If data is flagged for output, do so.
        if (output_next_cycle_q) begin
            output_data_d = input_data_q;
            data_valid_d = 1;
            ce_d = 1;
            counter_d = 1;
        end
        
//        if (delay_enable_i) begin
//            if (counter_q) begin  // if counter_q is low, valid data came in last clock cycle or no data has changed
//                output_data_d = input_data_q;
//                data_valid_d = 1;
//            end
//        end else begin
//            if (data_valid_i) begin  // if data_valid is high, valid data came in this clock cycle 
//                output_data_d = data_i;
//                data_valid_d = 1;
//            end
//        end
    end
end


// sequential block with clock enable
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        input_data_q <= 0;
        output_data_q <= 0;
        counter_q <= 0;
        data_valid_q <= 0;
        ce_q <= 0;
        output_next_cycle_q <= 0;
    end else begin
        input_data_q <= input_data_d;
        output_data_q <= output_data_d;
        counter_q <= counter_d;
        data_valid_q <= data_valid_d;
        ce_q <= ce_d;
        output_next_cycle_q <= output_next_cycle_d;
    end
    
end

    
endmodule
