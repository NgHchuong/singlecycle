module ALU_tb;
    logic [31:0] i_operand_a, i_operand_b;
    logic [3:0] i_alu_op;
    logic [31:0] o_alu_data;
    logic Zero;

    ALU uut (
        .i_operand_a(i_operand_a),
        .i_operand_b(i_operand_b),
        .i_alu_op(i_alu_op),
        .o_alu_data(o_alu_data),
        .Zero(Zero)
    );

    logic [31:0] expected_result;
    // Hàm kiểm tra với assert
    task check_output(input [31:0] expected);
		$display("Zero = %b", Zero);
        if (o_alu_data === expected) begin
            $display("PASSED: i_operand_a=%h, i_operand_b=%h, i_alu_op=%h, o_alu_data=%h", i_operand_a, i_operand_b, i_alu_op, o_alu_data);
        end else begin
            $display("FAILED: i_operand_a=%h, i_operand_b=%h, i_alu_op=%h, o_alu_data=%h, expected=%h", i_operand_a, i_operand_b, i_alu_op, o_alu_data, expected);
            assert(o_alu_data === expected) else $fatal("Assertion failed: output does not match expected result.");
        end
    endtask

    initial begin
		// Test cho từng phép toán với các giá trị ngẫu nhiên

        // cộng
        i_alu_op = 4'b0000;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = i_operand_a + i_operand_b;
            #1; // Chờ 1 chu kỳ để cập nhật giá trị
            check_output(expected_result);
        end

        // trừ
        i_alu_op = 4'b0001;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = i_operand_a - i_operand_b;
            #1;
            check_output(expected_result);
        end

        // AND
        i_alu_op = 4'b0010;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = i_operand_a & i_operand_b;
            #1;
            check_output(expected_result);
        end

        // OR
        i_alu_op = 4'b0011;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = i_operand_a | i_operand_b;
            #1;
            check_output(expected_result);
        end

        // XOR
        i_alu_op = 4'b0100;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = i_operand_a ^ i_operand_b;
            #1;
            check_output(expected_result);
        end

        // Dịch trái
        i_alu_op = 4'b0101;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'h0000001F; // Giới hạn giá trị 5 bit cho phép dịch
            expected_result = i_operand_a << i_operand_b[4:0]; // Dịch trái
            #1;
            check_output(expected_result);
        end

        // Dịch phải
        i_alu_op = 4'b0110;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'h0000001F; // Giới hạn giá trị 5 bit cho phép dịch
            expected_result = i_operand_a >> i_operand_b[4:0]; // Dịch phải
            #1;
            check_output(expected_result);
        end
		
		// SLTU
        i_alu_op = 4'b0111;
        repeat(10) begin
            i_operand_a = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            expected_result = (i_operand_a < i_operand_b) ? 32'b1 : 32'b0; // SLTU
            #1;
            check_output(expected_result);
        end

        // SLT
        i_alu_op = 4'b1000;
        repeat(10) begin
            i_operand_a = $signed($random) & 32'hFFFFFFFF ; 
            i_operand_b = $signed($random) & 32'hFFFFFFFF ; 
            expected_result = ($signed(i_operand_a) < $signed(i_operand_b)) ? 32'b1 : 32'b0; // SLT
            #1;
            check_output(expected_result);
        end

        // SRA
        i_alu_op = 4'b1001;
        repeat(10) begin
            i_operand_a = $signed($random) & 32'hFFFFFFFF; // Giới hạn giá trị 32 bit
            i_operand_b = $random & 32'h0000001F; // Giới hạn giá trị 5 bit cho phép dịch
            expected_result = $signed(i_operand_a) >>> i_operand_b; // SRA
            #1;
            check_output(expected_result);
        end
        $display("ALL TEST PASSED");
        

        $finish; // Kết thúc mô phỏng
    end
endmodule
