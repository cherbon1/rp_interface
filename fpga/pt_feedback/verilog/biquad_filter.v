`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 03:35:37 PM
// Design Name: 
// Module Name: biquad_filter
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
// Calculates a biquad filter in 5 clock cycles. Implements direct form I (https://en.wikipedia.org/wiki/Digital_biquad_filter)
// For a proper fixed-point evaluation the input coefficients should be bit-shifted by COEFF BITSHIFT. The outputs will already 
// bit-shifted back.
// 
//////////////////////////////////////////////////////////////////////////////////


module biquad_filter #(
    parameter INPUT_WIDTH = 17,
    parameter COEFF_WIDTH = 24,
    parameter OUTPUT_WIDTH = 17  // output width >= input width
) (
    input clk_i,
    input rst_ni,
    
    input reinit_i,
    
    input [INPUT_WIDTH-1:0] data_i,
    input data_valid_i,
    
    output [OUTPUT_WIDTH-1:0] data_o,
    output data_valid_o,
    
    output busy_o,
    
    input [COEFF_WIDTH-1:0] a1_i,
    input [COEFF_WIDTH-1:0] a2_i,
    input [COEFF_WIDTH-1:0] b0_i,
    input [COEFF_WIDTH-1:0] b1_i,
    input [COEFF_WIDTH-1:0] b2_i
);

// define all internal register based on OUTPUT_WIDTH

// The temp register will store the intermediate output. Since it will add up 5 different values of 
// (OUTPUT_WIDTH + COEFF_WIDTH - COEFF_BITSHIFT) each, it needs to be clog2(5)=3 bits larger than
// (OUTPUT_WIDTH + COEFF_WIDTH - COEFF_BITSHIFT)
localparam COEFF_BITSHIFT = COEFF_WIDTH - 2;
localparam TEMP_WIDTH = OUTPUT_WIDTH + COEFF_WIDTH - COEFF_BITSHIFT + 3;

// declare signals for multiplier
// Multiplier input is also buffered, so it takes 2 clock cycles for the multiplication result to propagate
reg [COEFF_WIDTH-1:0] mult_in_coeff_d, mult_in_coeff_q;
reg [OUTPUT_WIDTH-1:0] mult_in_data_d, mult_in_data_q;
wire [COEFF_WIDTH+OUTPUT_WIDTH-1:0] mult_out;
reg [TEMP_WIDTH-1:0] shifted_mult_out;

// for trouble shooting. can be bypassed in the end
reg [TEMP_WIDTH-1:0] full_data_d, full_data_q;

// define flip flops
reg [TEMP_WIDTH-1:0] temp_d, temp_q;
reg [OUTPUT_WIDTH-1:0] in_z0_d, in_z0_q, in_z1_d, in_z1_q, in_z2_d, in_z2_q;
reg [OUTPUT_WIDTH-1:0] out_z1_d, out_z1_q, out_z2_d, out_z2_q;

// register for keeping track of state
(* MAX_FANOUT = 50 *) reg [2:0] state_d, state_q;

// output registers
reg [OUTPUT_WIDTH-1:0] data_d, data_q;
reg data_valid_d, data_valid_q, busy_d, busy_q;

// connect outputs
assign data_o = data_q;
assign data_valid_o = data_valid_q;
assign busy_o = busy_q;

// declare sub-modules
simple_multiplier_internal #(
    .WIDTH_A(COEFF_WIDTH),
    .WIDTH_B(OUTPUT_WIDTH)
) inst_mult (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .a_i(mult_in_coeff_q),
    .b_i(mult_in_data_q),
    .c_o(mult_out)
);

// combinatorial block
always @(*) begin
    // default assignments
    temp_d = temp_q;
    in_z0_d = in_z0_q;
    in_z1_d = in_z1_q;
    in_z2_d = in_z2_q;
    out_z1_d = out_z1_q;
    out_z2_d = out_z2_q;
    state_d = state_q;
    data_d = data_q;
    data_valid_d = data_valid_q;
    busy_d = busy_q;
    mult_in_coeff_d = 0;
    mult_in_data_d = 0;
    
    full_data_d = full_data_q;
    
    // bitshift by COEFF_BITSHIFT
    // (syntax example https://www.nandland.com/verilog/examples/example-shift-operator-verilog.html)
    // temporary variable for accessing relevant bits. Will have no impact on
    // hardware, see: https://stackoverflow.com/questions/16468114/verilog-access-specific-bits
    shifted_mult_out = $signed(mult_out) >>> COEFF_BITSHIFT;

    case (state_q)
        // Turn off data_valid_d and busy_d (from end of last cycle)
        // If a valid sample comes, do the following:
        // Shift all delay registers, and store current input into "undelayed" register
        // (the undelayed register is required b.c. it should stay constant throughout a measurement
        // and it needs to still be available to shift it into its corresponding delay)
        // load multiplier with b0_i * in_z0_q (which is called data_i at this stage)
        // increment state, turn on busy
        0 : begin
            data_valid_d = 0;
            busy_d = 0;
            if (data_valid_i) begin
                in_z0_d = data_i << (OUTPUT_WIDTH - INPUT_WIDTH);
                in_z1_d = in_z0_q;
                in_z2_d = in_z1_q;
                out_z1_d = data_q;  // out_z1 loads the latest output data, which is stored here
                out_z2_d = out_z1_q;
                
                mult_in_coeff_d = b0_i;
                mult_in_data_d = data_i << (OUTPUT_WIDTH - INPUT_WIDTH);
                
                state_d = 1;
                busy_d = 1;
            end
        end
        
        // load multiplier with b1_i * in_z1_q
        // increment state
        1 : begin
            mult_in_coeff_d = b1_i;
            mult_in_data_d = in_z1_q;
            state_d = 2;
        end
        
        // save result of b0_i * in_z0_q to temp
        // load multiplier with b2_i * in_z2_q
        // increment state
        2 : begin
            temp_d = shifted_mult_out[TEMP_WIDTH-1:0];
            
            mult_in_coeff_d = b2_i;
            mult_in_data_d = in_z2_q;
            state_d = 3;
        end
        
        // add result of b1_i * in_z1_q to temp
        // load multiplier with a1_i * out_z1_q
        // increment state
        3 : begin
            temp_d = temp_q + shifted_mult_out[TEMP_WIDTH-1:0];
            
            mult_in_coeff_d = a1_i;
            mult_in_data_d = out_z1_q;
            state_d = 4;
        end
        
        // add result of in_b2_i * in_z2_q to temp
        // load multiplier with  a2_i * out_z2_q
        // increment state
        4 : begin
            temp_d = temp_q + shifted_mult_out[TEMP_WIDTH-1:0];
            
            mult_in_coeff_d = a2_i;
            mult_in_data_d = out_z2_q;
            state_d = 5;
        end
        
        // subtract result of a1_i * out_z1_q from temp
        // increment state
        5 : begin
            temp_d = temp_q - shifted_mult_out[TEMP_WIDTH-1:0];
            state_d = 6;
        end
        
        // subtract result of a2_i * out_z2_q from temp and save to data output
        // apply output valid signal
        // update state
        6 : begin
            full_data_d = temp_q - shifted_mult_out[TEMP_WIDTH-1:0];
            data_d = temp_q - shifted_mult_out[TEMP_WIDTH-1:0];
            data_valid_d = 1;
            state_d = 0;
        end
        default : begin
            state_d = 0;
        end
    endcase
end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni || reinit_i) begin
        temp_q <= 0;
        in_z0_q <= 0;
        in_z1_q <= 0;
        in_z2_q <= 0;
        out_z1_q <= 0;
        out_z2_q <= 0;
        state_q <= 0;
        data_q <= 0;
        data_valid_q <= 0;
        busy_q <= 0;
        mult_in_coeff_q <= 0;
        mult_in_data_q <= 0;
        
        full_data_q <= 0;
    end else begin
        temp_q <= temp_d;
        in_z0_q <= in_z0_d;
        in_z1_q <= in_z1_d;
        in_z2_q <= in_z2_d;
        out_z1_q <= out_z1_d;
        out_z2_q <= out_z2_d;
        state_q <= state_d;
        data_q <= data_d;
        data_valid_q <= data_valid_d;
        busy_q <= busy_d;
        mult_in_coeff_q <= mult_in_coeff_d;
        mult_in_data_q <= mult_in_data_d;
        
        full_data_q <= full_data_d;
    end 
end


endmodule
