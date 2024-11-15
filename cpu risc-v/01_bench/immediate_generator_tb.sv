`include "timescale.svh"
module immediate_generator_tb;

  // Khai báo tín hiệu
  logic clk;
  logic [31:0] instr;
  logic [31:0] imm;

  // Khởi tạo instance của module immediate_generator
  immediate_generator dut (
    .instruction (instr),
    .imm_out (imm)
  );

  // Khởi tạo tín hiệu đồng hồ
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  // Task để kiểm tra kết quả
  task check_imm(input [31:0] expected_imm);
    if (imm === expected_imm)
      $display("PASS: instr = %h, imm = %h", instr, imm);
    else
      $display("FAIL: instr = %h, imm = %h, expected = %h", instr, imm, expected_imm);
  endtask

  // Thực hiện các test
  initial begin
    $display("Starting immediate_generator testbench...");

    // Test I-type (ví dụ với instr = 32'h00100193)
    instr = 32'h00100193; // opcode = I-type, funct3 = 001
    #1 check_imm(32'h00000001); // Kiểm tra imm_out = 4

    // Test Load (LW)
    instr = 32'hFFC32303; // opcode = Load
    #1 check_imm(-32'd4); // Kiểm tra imm_out = -4

    // Test BEQ
    instr = 32'h00030C63; // opcode = BEQ
    #1 check_imm(32'd24); // Kiểm tra imm_out = 24

    // Test BLT
    instr = 32'h00534663; // opcode = BLT
    #1 check_imm(32'd12); // Kiểm tra imm_out = 12

    // Test JAL
    instr = 32'hFEDFF06F; // opcode = JAL
    #1 check_imm(-32'd20); // Kiểm tra imm_out = -20

    // Test AUIPC
    instr = 32'h10000297; // opcode = AUIPC
    #1 check_imm(32'h10000000); // Kiểm tra imm_out = 0x10000000

    // Test U-type (LUI)
    instr = 32'h00000137; // opcode = LUI
    #1 check_imm(32'h00000000); // Kiểm tra imm_out = 0x00000000

    $display("Testbench completed.");
    $finish;
  end

endmodule
