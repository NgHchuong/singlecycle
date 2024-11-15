module driver (
  input  logic        i_clk     ,
  input  logic        i_rst_n   ,
  output logic        i_pc_sel  ,
  output logic        i_pc_en   ,
  output logic [31:0] i_alu_data
);

  always @(posedge i_clk) begin : proc_ff_stimuli
    i_pc_sel   <= $random%10 == 9;
    i_pc_en    <= $random%10 <  8;
    i_alu_data <= $urandom_range(0,70)*4;
  end

endmodule : driver
