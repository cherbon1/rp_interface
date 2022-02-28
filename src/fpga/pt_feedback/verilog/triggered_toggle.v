`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2022 10:50:21 AM
// Design Name: 
// Module Name: triggered_toggle
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
// Outputs idle_data_i by default
// When trig_i goes high, waits for delay_cycles_i clock_enable pulses before
// setting output to toggle_data_i. Then waits for toggle_cycles_i clock_enable pulses
// before resetting output to idle_data_i.
// If toggle_cycles_i is zero, that state should be fully skipped
// 
//////////////////////////////////////////////////////////////////////////////////


module triggered_toggle #(
    parameter COUNTER_WIDTH = 18,
    parameter DATA_WIDTH = 14
) (
    input clk_i,
    input rst_ni,
    
    input ce_i,
    input trig_i,
    
    input [DATA_WIDTH-1:0] idle_data_i,
    input [DATA_WIDTH-1:0] toggle_data_i,
    
    input [COUNTER_WIDTH-1:0] delay_cycles_i,
    input [COUNTER_WIDTH-1:0] toggle_cycles_i,
    
    output  [DATA_WIDTH-1:0] data_o
    );

// declare signals
reg [COUNTER_WIDTH-1:0] counter_d, counter_q;  // implement a downcounter to avoid problems when changing input during a cycle
reg [DATA_WIDTH-1:0] data_d, data_q;
reg [1:0] state_d, state_q;  // 0: idle: wait for trigger, 1: count delay, 2: count active


// connect output
assign data_o = data_q;

// combinatorial block
always @* begin
    counter_d = counter_q; // default statements
    data_d = data_q;
    state_d = state_q;
    
    if (ce_i) begin
        case (state_q)
            // output idle_data_i
            // wait for trigger
            // launch counter
            // update state
            0 : begin
                data_d = idle_data_i;
                if (trig_i) begin
                    if (delay_cycles_i == 0) begin
                        if (toggle_cycles_i == 0) begin
                            state_d = 0;
                            counter_d = 0;
                        end else begin
                            state_d = 2;
                            counter_d = toggle_cycles_i-1;  // make counter click before next state to avoid delay
                        end
                    end else begin
                        state_d = 1;
                        counter_d = delay_cycles_i-1;  // make counter click before next state to avoid delay
                    end
                end
            end
            // output idle_data_i
            // increment counter
            // wait for counter to reach max value
            // reset counter
            // update state. If toggle_cycles_i is zero, skip state 2
            1 : begin
                data_d = idle_data_i;
                counter_d = counter_q - 1;
                if (counter_q == 0) begin
                    if (toggle_cycles_i == 0) begin
                        state_d = 0;
                        counter_d = 0;
                    end else begin
                        state_d = 2;
                        counter_d = toggle_cycles_i-1;  // make counter click before next state to avoid delay
                    end
                end
            end
            // output toggle_data_i
            // increment counter
            // wait for counter to reach max value
            // reset counter
            // update state
            2 : begin
                data_d = toggle_data_i;
                counter_d = counter_q - 1;
                if (counter_q == 0) begin
                    state_d = 0;
                    counter_d = 0;
                end
            end
            default : begin
                state_d = 0;
                counter_d = 0;
            end
        endcase
    end
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        counter_q <= 0;
        data_q <= 0;
        state_q <= 0;
    end else begin
        counter_q <= counter_d;
        data_q <= data_d;
        state_q <= state_d;
    end
end

endmodule
