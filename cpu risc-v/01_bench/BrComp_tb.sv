module BrComp_tb;

    logic [31:0] i_rs1_data, i_rs2_data;
    logic i_br_un;
    logic o_br_less, o_br_equal;
    logic expected_less, expected_equal;

    BrComp uut (
        .i_rs1_data(i_rs1_data),
        .i_rs2_data(i_rs2_data),
        .i_br_un(i_br_un),
        .o_br_less(o_br_less),
        .o_br_equal(o_br_equal)
    );

    // Function task and assert
    task check_output(input logic exp_less, input logic exp_equal);
        if (o_br_less === exp_less && o_br_equal === exp_equal) begin
            $display("PASSED: i_rs1_data=%h, i_rs2_data=%h, i_br_un=%b, o_br_less=%b, o_br_equal=%b",
                     i_rs1_data, i_rs2_data, i_br_un, o_br_less, o_br_equal);
        end else begin
            $display("FAILED: i_rs1_data=%h, i_rs2_data=%h, i_br_un=%b, o_br_less=%b, o_br_equal=%b, exp_less=%b, exp_equal=%b",
                     i_rs1_data, i_rs2_data, i_br_un, o_br_less, o_br_equal, exp_less, exp_equal);
            assert(o_br_less === exp_less && o_br_equal === exp_equal) else $fatal("Assertion failed: Output does not match expected result.");
        end
    endtask

   initial begin
    // unsigned
    i_br_un = 1;
    
    // Các trường hợp đặc biệt
    i_rs1_data = 32'h00000000; i_rs2_data = 32'h00000000;
    expected_equal = 1;
    expected_less = 0;
    #1;
    check_output(expected_less, expected_equal);
    
    i_rs1_data = 32'hFFFFFFFF; i_rs2_data = 32'h00000000;
    expected_equal = 0;
    expected_less = 0;
    #1;
    check_output(expected_less, expected_equal);

    // Kiểm thử với các giá trị ngẫu nhiên
    repeat(5) begin
        i_rs1_data = $random & 32'hFFFFFFFF;
        i_rs2_data = $random & 32'hFFFFFFFF;
        expected_equal = (i_rs1_data == i_rs2_data);
        expected_less = (i_rs1_data < i_rs2_data);
        #1;
        check_output(expected_less, expected_equal);
    end

    // Test signed
    i_br_un = 0;
    
    // Các trường hợp đặc biệt
    i_rs1_data = 32'h80000000; i_rs2_data = 32'h7FFFFFFF;
    expected_equal = 0;
    expected_less = 1;
    #1;
    check_output(expected_less, expected_equal);
    
    i_rs1_data = 32'hFFFFFFFF; i_rs2_data = 32'hFFFFFFFF;
    expected_equal = 1;
    expected_less = 0;
    #1;
    check_output(expected_less, expected_equal);

    // Kiểm thử với các giá trị ngẫu nhiên
    repeat(10) begin
        i_rs1_data = $signed($random) & 32'hFFFFFFFF;
        i_rs2_data = $signed($random) & 32'hFFFFFFFF;
        expected_equal = (i_rs1_data == i_rs2_data);
        expected_less = ($signed(i_rs1_data) < $signed(i_rs2_data));
        #1;
        check_output(expected_less, expected_equal);
    end

    $display("All tests completed.");
    $finish;
end
endmodule

