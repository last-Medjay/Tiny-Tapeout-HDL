`timescale 1ns / 1ps

module CLAP #(CLAUSES=64, CLASSES=5) (
    input logic clk,
    input logic rstn,
    input logic unsigned [CLASSES*CLAUSES-1:0] CL,
    output logic unsigned [CLASSES-1:0] argmax
);

logic unsigned [$clog2(CLAUSES)-1:0] sum [0:CLASSES-1];

PopCount pc0 (.clk, .rstn, .CL(CL[CLAUSES-1:0]), .sum(sum[0]));
PopCount pc1 (.clk, .rstn, .CL(CL[2*CLAUSES-1:CLAUSES]), .sum(sum[1]));
PopCount pc2 (.clk, .rstn, .CL(CL[3*CLAUSES-1:2*CLAUSES]), .sum(sum[2]));
PopCount pc3 (.clk, .rstn, .CL(CL[4*CLAUSES-1:3*CLAUSES]), .sum(sum[3]));
PopCount pc4 (.clk, .rstn, .CL(CL[5*CLAUSES-1:4*CLAUSES]), .sum(sum[4]));

ArgMax am0 (.clk, .rstn, .sum(sum), .argmax(argmax));

endmodule

module PopCount #(CLAUSES=64) (
    input logic clk,
    input logic rstn,
    input logic unsigned [CLAUSES-1:0] CL,
    output logic unsigned [$clog2(CLAUSES)-1:0] sum
);

logic unsigned [$clog2(CLAUSES)-1:0] ClassSum;

always_comb begin
    ClassSum = 0;
    for (int i = 0; i < CLAUSES; i++) begin
        ClassSum = ClassSum + ~CL[i];    
    end
    sum = ClassSum;
end

endmodule

module ArgMax #(CLAUSES=64, CLASSES=5) (
    input logic clk,
    input logic rstn,
    input logic unsigned [CLASSES*$clog2(CLAUSES)-1:0] sum,
    output logic unsigned [CLASSES-1:0] argmax
);

logic unsigned [$clog2(CLAUSES)-1:0] sum_intern [0:CLASSES-1];
logic unsigned [$clog2(CLAUSES)-1:0] MaxSum;
logic unsigned [CLASSES-1:0] MaxClass;

genvar i;
generate
    for (i = 0; i < CLASSES; i++) begin : sum_assign
        assign sum_intern[i] = sum[i*$clog2(CLAUSES) +: $clog2(CLAUSES)];
    end
endgenerate

always_comb begin
    MaxSum = sum_intern[0];
    for (int i = 1; i < CLASSES; i++) begin
        if (sum_intern[i] > MaxSum) begin
            MaxSum = sum_intern[i];
        end
    end

    MaxClass = 0;
    for (int i = 0; i < 5; i++) begin
        if (sum_intern[i] == MaxSum) begin
            MaxClass[i] = 1;
        end
    end

    argmax = MaxClass;
end

endmodule

