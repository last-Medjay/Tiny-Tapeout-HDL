`default_nettype none
`timescale 1ns / 1ps

module tt_um_BatTM (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);
   
  assign uio_oe  = 0;
  assign uio_out = 0;
  wire _unused = &{ena, uio_in, uo_out[7:5], uio_in[7:4], 1'b0};
    
  BatTM #(
    .BITS(10),
    .CLAUSES(64),
    .CLASSES(5)
  ) BatTM_inst (
    .clk(clk),
    .rstn(rst_n),
    .I(ui_in[3:0]),
    .V(ui_in[7:4]),
    .T(uio_in[3:0]),
    .Y(uo_out[4:0])
  );
    
endmodule
