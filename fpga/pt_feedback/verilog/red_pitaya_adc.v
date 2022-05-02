`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2022 09:27:17 PM
// Design Name: 
// Module Name: red_pitaya_adc
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
// Convert the differential ADC clock to a clock signal for FPGA
// Buffers input data
// 
//////////////////////////////////////////////////////////////////////////////////


module red_pitaya_adc #
(
  parameter integer ADC_DATA_WIDTH = 14
)
(
  // System signals  
//  (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF adc_clk, FREQ_HZ 125000000" *)
  output wire                        adc_clk,

  // ADC signals
  output wire                        adc_csn,
  
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF adc_clk_p, FREQ_HZ 125000000" *)
  input  wire                        adc_clk_p,
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF adc_clk_n, FREQ_HZ 125000000" *)
  input  wire                        adc_clk_n,
  input  wire [ADC_DATA_WIDTH-1:0]   adc_dat_a_i,
  input  wire [ADC_DATA_WIDTH-1:0]   adc_dat_b_i,

  // Master side
  output  wire [ADC_DATA_WIDTH-1:0]   adc_dat_a_o,
  output  wire [ADC_DATA_WIDTH-1:0]   adc_dat_b_o
);

  reg  [ADC_DATA_WIDTH-1:0] int_dat_a_reg;
  reg  [ADC_DATA_WIDTH-1:0] int_dat_b_reg;
  wire                      int_clk0;
  wire 						int_clk;

  IBUFGDS adc_clk_inst0 (.I(adc_clk_p), .IB(adc_clk_n), .O(int_clk0));
  BUFG adc_clk_inst (.I(int_clk0), .O(int_clk));

  always @(posedge int_clk)
  begin
    int_dat_a_reg <= {adc_dat_a_i[ADC_DATA_WIDTH-1], ~adc_dat_a_i[ADC_DATA_WIDTH-2:0]};
    int_dat_b_reg <= {adc_dat_b_i[ADC_DATA_WIDTH-1], ~adc_dat_b_i[ADC_DATA_WIDTH-2:0]};
  end

  assign adc_clk = int_clk;

  assign adc_csn = 1'b1;
  
  assign adc_dat_a_o = int_dat_a_reg;
  assign adc_dat_b_o = int_dat_b_reg;

endmodule
