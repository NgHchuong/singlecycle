`include "timescale.svh"

`define RESETPERIOD 55
`define FINISH      1005

module tbench;

// Clock and reset generator
  logic i_clk;
  logic i_rst_n;

  initial tsk_clock_gen(i_clk);
  initial tsk_reset(i_rst_n, `RESETPERIOD);
  initial tsk_timeout(`FINISH);


// Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, dut);
  end

// From here, you're free to do your code to suit your testcase.
  logic        i_pc_sel  ;
  logic        i_pc_en   ;
  logic [31:0] i_alu_data;
  logic [31:0] o_pc      ;
  logic [31:0] o_insn    ;

  driver driverUnit(
    .i_clk     (i_clk     ),
    .i_rst_n   (i_rst_n   ),
    .i_pc_sel  (i_pc_sel  ),
    .i_pc_en   (i_pc_en   ),
    .i_alu_data(i_alu_data)
  );

  insn_fetch dut (
    .i_clk     (i_clk     ),
    .i_rst_n   (i_rst_n   ),
    .i_pc_sel  (i_pc_sel  ),
    .i_pc_en   (i_pc_en   ),
    .i_alu_data(i_alu_data),
    .o_pc      (o_pc      ),
    .o_insn    (o_insn    )
  );

  scoreboard scoreboardUnit(
    .i_clk     (i_clk     ),
    .i_rst_n   (i_rst_n   ),
    .i_pc_sel  (i_pc_sel  ),
    .i_pc_en   (i_pc_en   ),
    .i_alu_data(i_alu_data),
    .o_pc      (o_pc      ),
    .o_insn    (o_insn    )
  );

endmodule : tbench
