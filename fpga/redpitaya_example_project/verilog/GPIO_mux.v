`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2022 01:31:49 PM
// Design Name: 
// Module Name: GPIO_mux
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
// multiplex a single GPIO interface (up to 32x25 bits per GPIO block)
// Use GPIO1 in output only mode, and GPIO2 in input only mode
// A bus is broken down into 1 write_enable bit, 5 address bits and 26 data bits
// 
// The write_enable bit selects whether we want to write the contents of gpio1 to the addressed register
// The first two address bits designate one of four 8x multiplexers, and the last two address bits designate the register
// The 26 LSB are used to transfer data.
// 
//////////////////////////////////////////////////////////////////////////////////


module GPIO_mux #(
    parameter ADDRESS_PREFIX = 0,  // 0, 1, 2 or 3
    parameter DATA_WIDTH_0 = 26,
    parameter DATA_WIDTH_1 = 26,
    parameter DATA_WIDTH_2 = 26,
    parameter DATA_WIDTH_3 = 26,
    parameter DATA_WIDTH_4 = 26,
    parameter DATA_WIDTH_5 = 26,
    parameter DATA_WIDTH_6 = 26,
    parameter DATA_WIDTH_7 = 26
) (
    input clk_i,
    input rst_ni,
    
    input [31:0] gpio1_i,
    
    output  [31:0] gpio2_o,
    
    output [DATA_WIDTH_0-1:0] data0_o,
    output [DATA_WIDTH_1-1:0] data1_o,
    output [DATA_WIDTH_2-1:0] data2_o,
    output [DATA_WIDTH_3-1:0] data3_o,
    output [DATA_WIDTH_4-1:0] data4_o,
    output [DATA_WIDTH_5-1:0] data5_o,
    output [DATA_WIDTH_6-1:0] data6_o,
    output [DATA_WIDTH_7-1:0] data7_o
    );
    localparam ADDRESS_MSB = ADDRESS_PREFIX[1:0];
    
 // define inputs
 wire write_enable_i;
 wire [1:0] address_msb_i;
 wire [2:0] address_lsb_i;
 wire [25:0] data_i;
 assign {write_enable_i, address_msb_i, address_lsb_i, data_i} = gpio1_i;
 
 // define registers
 reg [31:0] gpio2_d, gpio2_q;
 reg [25:0] data_o;
 reg [DATA_WIDTH_0-1:0] data0_d, data0_q;
 reg [DATA_WIDTH_1-1:0] data1_d, data1_q;
 reg [DATA_WIDTH_2-1:0] data2_d, data2_q;
 reg [DATA_WIDTH_3-1:0] data3_d, data3_q;
 reg [DATA_WIDTH_4-1:0] data4_d, data4_q;
 reg [DATA_WIDTH_5-1:0] data5_d, data5_q;
 reg [DATA_WIDTH_6-1:0] data6_d, data6_q;
 reg [DATA_WIDTH_7-1:0] data7_d, data7_q;
 
 //connect outputs
 assign gpio2_o = gpio2_q;
 assign data0_o = data0_q;
 assign data1_o = data1_q;
 assign data2_o = data2_q;
 assign data3_o = data3_q;
 assign data4_o = data4_q;
 assign data5_o = data5_q;
 assign data6_o = data6_q;
 assign data7_o = data7_q;
 
 always @* begin
    // defaults
    data_o = 0;
    data0_d = data0_q;
    data1_d = data1_q;
    data2_d = data2_q;
    data3_d = data3_q;
    data4_d = data4_q;
    data5_d = data5_q;
    data6_d = data6_q;
    data7_d = data7_q;
    
    case(address_lsb_i)
        0       : data_o = data0_q;
        1       : data_o = data1_q;
        2       : data_o = data2_q;
        3       : data_o = data3_q;
        4       : data_o = data4_q;
        5       : data_o = data5_q;
        6       : data_o = data6_q;
        7       : data_o = data7_q;
        default : data_o = 0;
    endcase
    
    gpio2_d = {1'b0, ADDRESS_MSB, address_lsb_i, data_o};
    
    if(write_enable_i & (address_msb_i == ADDRESS_MSB)) begin
        case(address_lsb_i)
            0       : data0_d = data_i;
            1       : data1_d = data_i;
            2       : data2_d = data_i;
            3       : data3_d = data_i;
            4       : data4_d = data_i;
            5       : data5_d = data_i;
            6       : data6_d = data_i;
            7       : data7_d = data_i;
            default : data0_d = data0_q;
        endcase
    end
    
 
 end
 
// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        gpio2_q <= 0;
        data0_q <= 0;
        data1_q <= 0;
        data2_q <= 0;
        data3_q <= 0;
        data4_q <= 0;
        data5_q <= 0;
        data6_q <= 0;
        data7_q <= 0;
    end else begin
        gpio2_q <= gpio2_d;
        data0_q <= data0_d;
        data1_q <= data1_d;
        data2_q <= data2_d;
        data3_q <= data3_d;
        data4_q <= data4_d;
        data5_q <= data5_d;
        data6_q <= data6_d;
        data7_q <= data7_d;
    end
end
endmodule
