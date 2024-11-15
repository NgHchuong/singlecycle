module ControlUnit (
 //input
  input logic br_less, br_equal, // result signal form BRC
  input logic [31:0] instr,      // Instruction to decode
 //output
  output logic pc_sel, 				// control signal for pc 
  output logic rd_wren, 		   // control signal for Regfile to read rd_data
  output logic insn_vld,			// 
  output logic br_un,				// control signal for BRC
  output logic opa_sel,				//
  output logic opb_sel,				//
  output logic alu_op,				// control signal for ALU
  output logic mem_wren,			// control signal for LSU
  output logic wb_sel				// control signal for WB stage
);

  
    // Define opcode for reading 
  localparam OP_RTYPE     = 7'b0110011;
  localparam OP_ITYPE     = 7'b0010011;
  localparam OP_LD      = 7'b0000011;
  localparam OP_ST     = 7'b0100011;
  localparam OP_BR    = 7'b1100011;

  // Control unit logic
  always @(*) begin
    // Set defaults
	 pc_sel = 0;
    rd_wren = 0;
	 insn_vld = 0;
	 br_un = 0;
	 opa_sel = 0;
    opb_sel = 0;
    alu_op = 0;
	 mem_wren = 0;
    wb_sel = 0;
	 
    case (instr[6:0])
      OP_RTYPE: begin
		  insn_vld = 1;
        rd_wren = 1;
        opa_sel = 0; // rs1
        opb_sel = 0; // rs2
        wb_sel = 0; // alu_data
      end
      OP_ITYPE: begin
		  insn_vld = 1;
        rd_wren = 1;
        opa_sel = 0; // rs1
        opb_sel = 1; // imm
        wb_sel = 0; // alu_data
      end
      OP_LD: begin
		  insn_vld = 1;
        rd_wren = 1;
        mem_wren = 0;
        opa_sel = 0; // rs1
        opb_sel = 1; // imm
        wb_sel = 1; // ld_data
      end
      OP_ST: begin
        mem_wren = 1;
		  insn_vld = 1;
        opa_sel = 0; // rs1
        opb_sel = 1; // imm
        // wb_sel is not relevant for STORE instructions
      end
      OP_BR: begin
			insn_vld = 1;     
      	case (instr[14:12])
			3'b000: begin
				br_un = 0;
				opa_sel = 1;
				opb_sel = 1;
			end
			3'b100: begin
			    br_un = 0;
			    opa_sel = 1;
			    opb_sel = 1;
			    end
			3'b110: begin
			    br_un = 1;
			    opa_sel = 1;
			    opb_sel = 1;
			    end
		default;
		endcase
      end
      default;
    endcase
  end


endmodule : ControlUnit
