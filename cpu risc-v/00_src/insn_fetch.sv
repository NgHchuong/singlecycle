/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */

`include "timescale.svh"
module insn_fetch(
  input  logic        i_clk     ,
  input  logic        i_rst_n   ,
  input  logic        i_pc_sel  ,
  input  logic        i_pc_en   ,
  input  logic [31:0] i_alu_data,
  output logic [31:0] o_pc      ,
  output logic [31:0] o_insn
);

  logic [31:0] pc;
  logic [12:0] raddr;
  logic [31:0] rdata;

  pc_gen pcGen(
    .i_clk     (i_clk     ),
    .i_rst_n   (i_rst_n   ),
    .i_pc_sel  (i_pc_sel  ),
    .i_pc_en   (i_pc_en   ),
    .i_alu_data(i_alu_data),
    .o_pc      (pc        )
  );

  insn_mem insnMem(
    .i_raddr(raddr),
    .o_rdata(rdata)
  );

  assign raddr  = pc[12:0];
  assign o_pc   = pc;
  assign o_insn = i_rst_n ? rdata : 32'h0;

endmodule : insn_fetch
