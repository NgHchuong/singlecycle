module scoreboard(
  input  logic        i_clk     ,
  input  logic        i_rst_n   ,
  input  logic        i_pc_sel  ,
  input  logic        i_pc_en   ,
  input  logic [31:0] i_alu_data,
  input  logic [31:0] o_pc      ,
  input  logic [31:0] o_insn
);

  logic v_in_reset;

  always @(posedge i_clk) begin
    v_in_reset = $past(i_rst_n) && i_rst_n;
    $display("@%05d rst=%1b, PC = %08h, INSTRUCTION = %08h", $time, i_rst_n, o_pc, o_insn);
  end

  property prop_insn_is_valid;
    @(posedge i_clk) !v_in_reset || (o_insn != 32'h00000000);
  endproperty

  property prop_pc_is_048C;
    @(posedge i_clk) (o_pc[1:0] == 2'b00);
  endproperty

  property prop_pc_remains;
    @(posedge i_clk) !(v_in_reset && !$past(i_pc_en)) || 
      (o_pc == $past(o_pc));
  endproperty

  property prop_pc_only_inc_4;
    @(posedge i_clk) !(v_in_reset && $past(i_pc_en) && !$past(i_pc_sel)) || 
      (o_pc == $past(o_pc) + 32'h4);
  endproperty

  property prop_pc_eq_alu_data;
    @(posedge i_clk) !(v_in_reset && $past(i_pc_en) && $past(i_pc_sel)) || 
      (o_pc == $past(i_alu_data));
  endproperty

  asst_insn_is_valid:  assert property(prop_insn_is_valid);
    else #1 $error;
  asst_pc_is_048C:     assert property(prop_pc_is_048C);
    else #1 $error;
  asst_pc_remains:     assert property(prop_pc_remains);
    else #1 $error;
  asst_pc_only_inc_4:  assert property(prop_pc_only_inc_4);
    else #1 $error;
  asst_pc_eq_alu_data: assert property(prop_pc_eq_alu_data);
    else #1 $error;


endmodule : scoreboard
