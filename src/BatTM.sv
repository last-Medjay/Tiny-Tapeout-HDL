`timescale 1ns / 1ps

module tt_um_BatTM #(BITS=10, CLAUSES=64, CLASSES=5) (
    input logic clk,
    input logic rstn,
    input logic [$clog2(BITS+1)-1:0] I,
    input logic [$clog2(BITS+1)-1:0] V,
    input logic [$clog2(BITS+1)-1:0] T,
    output logic [CLASSES-1:0] Y
);

logic unsigned [3*BITS-1:0] literal;
logic unsigned [CLASSES*CLAUSES-1:0] CL;
logic unsigned [$clog2(CLAUSES)-1:0] sum [0:CLASSES-1];

InputLoad in0 (.clk, .rstn, .x(I), .literal(literal[BITS-1:0]));
InputLoad in1 (.clk, .rstn, .x(V), .literal(literal[2*BITS-1:BITS]));
InputLoad in2 (.clk, .rstn, .x(T), .literal(literal[3*BITS-1:2*BITS]));

ClauseCal cc0 (.clk, .rstn, .literal(literal), .CL(CL));

CLAP clap0 (.clk, .rstn, .CL(CL), .argmax(Y));

endmodule
