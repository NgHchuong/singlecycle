module ImmGen (
 //input
  input logic [31:0] instr, // instruction have to generate
 //output
  output logic [31:0] instr_gen  // Generated instruction
);

 always @(*) begin
        case (instr[6:0])
            7'b0010011: instr_gen = {{20{instr[31]}},instr[31:20]};
            7'b0000011: instr_gen = {{20{instr[31]}},instr[31:20]};
				7'b0100011: instr_gen = {{20{instr[31]}},instr[31:25],instr[11:7]};
				7'b1100011: instr_gen = {{20{instr[31]}},instr[31:25],instr[11:7]};
				default: instr_gen = {32{1'b0}};
					 endcase
 /*verilator lint_on UNUSED*/
end	

endmodule : ImmGen
