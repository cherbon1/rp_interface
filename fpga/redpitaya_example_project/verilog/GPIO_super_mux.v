`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2022 02:28:20 PM
// Design Name: 
// Module Name: GPIO_super_mux
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


module GPIO_super_mux(
    input clk_i,
    input rst_ni,
    
    input [31:0] gpio1_i,
    
    input [31:0] gpio2_0_i,
    input [31:0] gpio2_1_i,
    input [31:0] gpio2_2_i,
    input [31:0] gpio2_3_i,
    
    output [31:0] gpio2_o
    );
    
    // get address_msb input
    wire [1:0] address_msb_i;
    assign address_msb_i = gpio1_i[30:29];
   
 // define output register and connect
 reg [31:0] gpio2_q;
 assign gpio2_o = gpio2_q;
 

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        gpio2_q <= 0;
    end else begin
        case (address_msb_i)
            0       : gpio2_q <= gpio2_0_i;
            1       : gpio2_q <= gpio2_1_i;
            2       : gpio2_q <= gpio2_2_i;
            3       : gpio2_q <= gpio2_3_i;
            default : gpio2_q <= 0;
        endcase
    end
    
end

 
endmodule
