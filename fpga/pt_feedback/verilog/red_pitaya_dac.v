`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2022 09:59:03 PM
// Design Name: 
// Module Name: red_pitaya_dac
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


module red_pitaya_dac #
(
  parameter integer DAC_DATA_WIDTH = 14,
  parameter integer AXIS_TDATA_WIDTH = 32
)
(
  // PLL signals
  input  wire                        aclk,
  input  wire                        ddr_clk,
  input  wire                        locked,

  // DAC signals
  (* X_INTERFACE_PARAMETER = "FREQ_HZ 250000000" *)
  output wire                        dac_clk,
  (* X_INTERFACE_PARAMETER = "FREQ_HZ 250000000" *)
  output wire                        dac_rst,
  (* X_INTERFACE_PARAMETER = "FREQ_HZ 250000000" *)
  output wire                        dac_sel,
  (* X_INTERFACE_PARAMETER = "FREQ_HZ 250000000" *)
  output wire                        dac_wrt,
  (* X_INTERFACE_PARAMETER = "FREQ_HZ 250000000" *)
  output wire [DAC_DATA_WIDTH-1:0]   dac_dat,

  // Signals
  input  wire [DAC_DATA_WIDTH-1:0]   dat_a_i,
  input  wire [DAC_DATA_WIDTH-1:0]   dat_b_i
);

  reg [DAC_DATA_WIDTH-1:0] int_dat_a_reg;
  reg [DAC_DATA_WIDTH-1:0] int_dat_b_reg;
  reg int_rst_reg;

  wire [DAC_DATA_WIDTH-1:0] int_dat_a_wire;
  wire [DAC_DATA_WIDTH-1:0] int_dat_b_wire;

  genvar j;

  always @(posedge aclk)
  begin
    if(~locked)
    begin
      int_dat_a_reg <= {(DAC_DATA_WIDTH){1'b0}};
      int_dat_b_reg <= {(DAC_DATA_WIDTH){1'b0}};
    end
    else
    begin
      int_dat_a_reg <= {dat_a_i[DAC_DATA_WIDTH-1], ~dat_a_i[DAC_DATA_WIDTH-2:0]};
      int_dat_b_reg <= {dat_b_i[DAC_DATA_WIDTH-1], ~dat_b_i[DAC_DATA_WIDTH-2:0]};
    end
    int_rst_reg <= ~locked;
  end

  ODDR ODDR_rst(.Q(dac_rst), .D1(int_rst_reg), .D2(int_rst_reg), .C(aclk), .CE(1'b1), .R(1'b0), .S(1'b0));
  ODDR ODDR_sel(.Q(dac_sel), .D1(1'b0), .D2(1'b1), .C(aclk), .CE(1'b1), .R(1'b0), .S(1'b0));
  ODDR ODDR_wrt(.Q(dac_wrt), .D1(1'b0), .D2(1'b1), .C(ddr_clk), .CE(1'b1), .R(1'b0), .S(1'b0));
  ODDR ODDR_clk(.Q(dac_clk), .D1(1'b0), .D2(1'b1), .C(ddr_clk), .CE(1'b1), .R(1'b0), .S(1'b0));

  generate
    for(j = 0; j < DAC_DATA_WIDTH; j = j + 1)
    begin : DAC_DAT
      ODDR ODDR_inst(
        .Q(dac_dat[j]),
        .D1(int_dat_a_reg[j]),
        .D2(int_dat_b_reg[j]),
        .C(aclk),
        .CE(1'b1),
        .R(1'b0),
        .S(1'b0)
      );
    end
  endgenerate

endmodule

