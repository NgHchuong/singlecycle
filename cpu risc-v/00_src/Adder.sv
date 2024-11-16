/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
`timescale 1ns / 1ps

module Adder #(
  parameter Width = 8
) (
  input  logic [Width-1:0] a, b,
  output logic [Width-1:0] sum,
  output logic             cOut
);
  logic [Width-1:0] c;

  FullAdder #(.Width(1)) fa [Width-1:0] (
    .a(a),
    .b(b),
    .cIn({1'b0, c}),
    .sum(sum),
    .cOut(c)
  );

  assign cOut = c[Width-1];

endmodule : Adder

