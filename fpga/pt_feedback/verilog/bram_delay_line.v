`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 02:33:50 PM
// Design Name: 
// Module Name: bram_delay_line
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



///////////////////////////////////////////////////////////////////////
//  READ_WIDTH | BRAM_SIZE | READ Depth  | RDADDR Width |            //
// WRITE_WIDTH |           | WRITE Depth | WRADDR Width |  WE Width  //
// ============|===========|=============|==============|============//
//    37-72    |  "36Kb"   |      512    |      9-bit   |    8-bit   //
//    19-36    |  "36Kb"   |     1024    |     10-bit   |    4-bit   //
//    19-36    |  "18Kb"   |      512    |      9-bit   |    4-bit   //
//    10-18    |  "36Kb"   |     2048    |     11-bit   |    2-bit   //
//    10-18    |  "18Kb"   |     1024    |     10-bit   |    2-bit   //
//     5-9     |  "36Kb"   |     4096    |     12-bit   |    1-bit   //
//     5-9     |  "18Kb"   |     2048    |     11-bit   |    1-bit   //
//     3-4     |  "36Kb"   |     8192    |     13-bit   |    1-bit   //
//     3-4     |  "18Kb"   |     4096    |     12-bit   |    1-bit   //
//       2     |  "36Kb"   |    16384    |     14-bit   |    1-bit   //
//       2     |  "18Kb"   |     8192    |     13-bit   |    1-bit   //
//       1     |  "36Kb"   |    32768    |     15-bit   |    1-bit   //
//       1     |  "18Kb"   |    16384    |     14-bit   |    1-bit   //
///////////////////////////////////////////////////////////////////////

// We're using:
///////////////////////////////////////////////////////////////////////
//  READ_WIDTH | BRAM_SIZE | READ Depth  | RDADDR Width |            //
// WRITE_WIDTH |           | WRITE Depth | WRADDR Width |  WE Width  //
// ============|===========|=============|==============|============//
//    10-18    |  "36Kb"   |     2048    |     11-bit   |    2-bit   //
///////////////////////////////////////////////////////////////////////

module bram_delay_line #(
    parameter DATA_WIDTH = 17  // in range 10-18
) (
    input clk_i,
    input rst_ni,
    
    input ce_i,
    
    input [DATA_WIDTH-1:0] data_i,
    input [13:0] delay0_i,
    input [13:0] delay1_i,
    input [13:0] delay2_i,
    input [13:0] delay3_i,
    input [13:0] delay4_i,
    input [13:0] delay5_i,
    input [13:0] delay6_i,
    input [13:0] delay7_i,
    
    output data_valid0_o,
    output [DATA_WIDTH-1:0] data0_o,
    output data_valid1_o,
    output [DATA_WIDTH-1:0] data1_o,
    output data_valid2_o,
    output [DATA_WIDTH-1:0] data2_o,
    output data_valid3_o,
    output [DATA_WIDTH-1:0] data3_o,
    output data_valid4_o,
    output [DATA_WIDTH-1:0] data4_o,
    output data_valid5_o,
    output [DATA_WIDTH-1:0] data5_o,
    output data_valid6_o,
    output [DATA_WIDTH-1:0] data6_o,
    output data_valid7_o,
    output [DATA_WIDTH-1:0] data7_o
    );

// After requesting data from a BRAM module, it takes one clock cycles for the data to reach the output ragister
// For building output data (e.g. data_0, data_valid_0, ...), we need signals (raddr_msb, counter, ...) that are delayed from their inputs accordingly
// Also note that the output counter needs to be delayed by one more cycle, since the output of the BRAM goes through a nulitplexer first 
localparam BRAM_READ_DELAY = 2;

// define registers
reg [13:0] waddr_d, waddr_q;    // Defines where data is written
reg rst_q;                      // Synchronous reset of BRAM modules
reg [7:0] wren_d, wren_q;       // 1-bit select for writing to BRAM. lags behing waddr by one cycle
reg [13:0] delay_d, delay_q;    // stores the delay of the current cycle. Is mutilplexed for 8 data channels
reg [2:0] counter_d, counter_q;                 // Keeps track of which data output is currently being requested

// Define output signal delay lines
reg [2:0] output_counter_delay_d [BRAM_READ_DELAY:0];   // Keeps track of which data output is currently being written to
reg [2:0] output_counter_delay_q [BRAM_READ_DELAY:0];
reg [2:0] bram_select_delay_d [BRAM_READ_DELAY-1:0];    // Select signal of output multiplexer (in sync with output counter)
reg [2:0] bram_select_delay_q [BRAM_READ_DELAY-1:0];

reg [DATA_WIDTH-1:0] data_d [7:0];
reg [DATA_WIDTH-1:0] data_q [7:0];
reg data_valid_d [7:0];
reg data_valid_q [7:0];

// define wires
// read counters
wire [13:0] raddr_w;
assign raddr_w = waddr_q - delay_q - 1;

// break down address bits into bram select and bram address
// MSBs of addresses are used for bram_select
// LSBs of addresses are used for bram writing
wire [2:0] waddr_msb_w;
wire [10:0] waddr_lsb_w;
wire [2:0] raddr_msb_w;
wire [10:0] raddr_lsb_w;

assign {waddr_msb_w, waddr_lsb_w} = waddr_q;
assign {raddr_msb_w, raddr_lsb_w} = raddr_w;

// declare wire outputs of bram instances
wire [DATA_WIDTH-1:0] data_N [7:0];

// connect inputs and outputs
wire [13:0] delay_w [7:0];
assign delay_w[0] = delay0_i;
assign delay_w[1] = delay1_i;
assign delay_w[2] = delay2_i;
assign delay_w[3] = delay3_i;
assign delay_w[4] = delay4_i;
assign delay_w[5] = delay5_i;
assign delay_w[6] = delay6_i;
assign delay_w[7] = delay7_i;
assign data0_o = data_q[0];
assign data1_o = data_q[1];
assign data2_o = data_q[2];
assign data3_o = data_q[3];
assign data4_o = data_q[4];
assign data5_o = data_q[5];
assign data6_o = data_q[6];
assign data7_o = data_q[7];
assign data_valid0_o = data_valid_q[0];
assign data_valid1_o = data_valid_q[1];
assign data_valid2_o = data_valid_q[2]; 
assign data_valid3_o = data_valid_q[3];
assign data_valid4_o = data_valid_q[4];
assign data_valid5_o = data_valid_q[5];
assign data_valid6_o = data_valid_q[6];
assign data_valid7_o = data_valid_q[7];

for (genvar i=0; i<8; i=i+1) begin : bram_modules
    BRAM_SDP_MACRO #(
            .BRAM_SIZE("36Kb"),     // Target BRAM, "18Kb" or "36Kb"
            .DEVICE("7SERIES"),     // Target device: "7SERIES"
            .WRITE_WIDTH(DATA_WIDTH),        // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
            .READ_WIDTH(DATA_WIDTH),         // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
            .DO_REG(1),             // Optional output register (0 or 1)
            .INIT_FILE ("NONE"),
            .SIM_COLLISION_CHECK ("ALL"),   // Collision check enable "ALL", "WARNING_ONLY",
                                            //   "GENERATE_X_ONLY" or "NONE"
            .SRVAL(72'h000000000000000000), // Set/Reset value forr port output
            .INIT(72'h000000000000000000),  // Initial values on output port
            .WRITE_MODE("READ_FIRST")  // Specify "READ_FIRST" forr same clock or synchronous clocks
                                            //   Specify "WRITE_FIRST forr asynchronous clocks on ports
    )
    BRAM_SDP_MACRO_inst
    (
            .DO(data_N[i]),         // Output read data port, width defined by READ_WIDTH parameter
            .DI(data_i),         // Input write data port, width defined by WRITE_WIDTH parameter
            .RDADDR(raddr_lsb_w), // Input read address, width defined by read port depth
            .RDCLK(clk_i),   // 1-bit input read clock
            .RDEN(1'b1),     // 1-bit input read port enable
            .REGCE(1'b1),   // 1-bit input read output register enable
            .RST(rst_q),       // 1-bit input reset
            .WE(2'b11),         // Input write enable, width defined by write port depth
            .WRADDR(waddr_lsb_w), // Input write address, width defined by write port depth
            .WRCLK(clk_i),   // 1-bit input write clock
            .WREN(wren_q[i])      // 1-bit input write port enable
    );
end


// variable for for loops
integer i;

// combinatorial block
always @* begin
    // default "slow" singals (increment once per ce_i pulse)
    waddr_d = waddr_q;
    wren_d = wren_q;
    
    // default "fast" singals (increment once per clk_i pulse)
    counter_d = counter_q;
    delay_d = delay_q;
    for (i=0; i<8; i=i+1) begin
        data_d[i] = data_q[i];
        data_valid_d[i] = 0;
    end
    for (i=0; i<BRAM_READ_DELAY; i=i+1) bram_select_delay_d[i] = bram_select_delay_q[i];
    for (i=0; i<BRAM_READ_DELAY+1; i=i+1) output_counter_delay_d[i] = output_counter_delay_q[i];
    
    // if clock enable
    //   increment write address
    //   define write_enable
    //   and reset counter
    // Otherwise, increment counter
    if (ce_i) begin
        waddr_d = waddr_q + 1;
        wren_d = 8'b0;
        wren_d[waddr_d[13:11]] = 1'b1;  // using waddr_d for easier syntax. Bad practice...
        
        counter_d = 0;
    end else begin
        counter_d = counter_q + 1;
    end
    
    // input delay for next bram read
    delay_d = delay_w[counter_q];
    
    // bram_select lags behind raddr_msb
    // output counter lags behind counter
    bram_select_delay_d[0] = raddr_msb_w;  // which depends on delay_q
    for (i=1; i<BRAM_READ_DELAY; i=i+1) bram_select_delay_d[i] = bram_select_delay_q[i-1];
    output_counter_delay_d[0] = counter_q;
    for (i=1; i<BRAM_READ_DELAY+1; i=i+1) output_counter_delay_d[i] = output_counter_delay_q[i-1];
    
    // apply data_valid and data outputs
    for (i=0; i<8; i=i+1) begin
        if (output_counter_delay_q[BRAM_READ_DELAY] == i) begin
            data_valid_d[i] = 1;
            data_d[i] = data_N[bram_select_delay_q[BRAM_READ_DELAY-1]];
        end
    end

end

// sequential block
always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        waddr_q <= 0;
        rst_q <= 1;
        wren_q <= 0;
        delay_q <= 0;
        counter_q <= 0;
        
        for (i=0; i<8; i=i+1) begin
            data_q[i] <= 0;
            data_valid_q[i] = 0;
        end
        for (i=0; i<BRAM_READ_DELAY; i=i+1) bram_select_delay_q[i] <= 0;
        for (i=0; i<BRAM_READ_DELAY+1; i=i+1) output_counter_delay_q[i] <= 0;
    end else begin
        waddr_q <= waddr_d;
        rst_q <= 0;
        wren_q <= wren_d;
        delay_q <= delay_d;
        counter_q <= counter_d;
//        output_counter_q <= output_counter_d;
//        bram_select_q <= bram_select_d;
        
        
        for (i=0; i<8; i=i+1) begin
            data_q[i] <= data_d[i];
            data_valid_q[i] = data_valid_d[i];
        end
        for (i=0; i<BRAM_READ_DELAY; i=i+1) bram_select_delay_q[i] <= bram_select_delay_d[i];
        for (i=0; i<BRAM_READ_DELAY+1; i=i+1) output_counter_delay_q[i] <= output_counter_delay_d[i];
    end
end
    

endmodule
