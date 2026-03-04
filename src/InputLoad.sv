`timescale 1ns / 1ps
module InputLoad #(BITS=10) (
    input logic clk,
    input logic rstn,
    input logic unsigned [$clog2(BITS+1)-1:0] x,
    output logic unsigned [BITS-1:0] literal
);

always_ff @(posedge clk) begin
    if (!rstn) begin
        literal <= 0;
    end else begin 
        literal <= ~({BITS{1'b1}} >> x);
    end
end

endmodule
