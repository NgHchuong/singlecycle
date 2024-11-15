/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off UNUSEDSIGNAL */
module regfile_tb;

logic i_clk;
logic i_rst;
logic i_rd_wren;
logic [4:0] i_rd_addr;
logic [4:0] i_rs1_addr;
logic [4:0] i_rs2_addr;
logic [31:0] i_rd_data;
logic [31:0] o_rs1_data;
logic [31:0] o_rs2_data;

regfile uut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_rd_wren(i_rd_wren),
    .i_rd_addr(i_rd_addr),
    .i_rs1_addr(i_rs1_addr),
    .i_rs2_addr(i_rs2_addr),
    .i_rd_data(i_rd_data),
    .o_rs1_data(o_rs1_data),
    .o_rs2_data(o_rs2_data)
);

// Clock generation
initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk; 
end

// Reset and test logic
initial begin
    // Initialize signals
    i_rst = 0;
    i_rd_wren = 0;
    i_rd_addr = 5'b00000;
    i_rs1_addr = 5'b00000;
    i_rs2_addr = 5'b00000;
    i_rd_data = 32'b0;

    // Apply reset
    #10;
    i_rst = 0;  // Đặt reset
    #10;
    i_rst = 1;  // Thả reset
    #10;

    for (int i = 0; i < 10; i = i + 1) begin
        i_rd_addr = $random % 32;   // Giới hạn 5 bit cho i_rd_addr (0 - 31)
        i_rd_data = $random;        // Dữ liệu ngẫu nhiên cho i_rd_data

        if (i_rd_addr !== 5'b00000) begin
            // Write
            i_rd_wren = 1;
            #10;  
            i_rd_wren = 0;

            // Read
            i_rs1_addr = i_rd_addr;
            #10;  
			
            // Debugging: Hiển thị dữ liệu đọc và ghi
            $display("Writing to register %d, data = %h", i_rd_addr, i_rd_data);
            $display("Reading from register %d, data = %h", i_rd_addr, o_rs1_data);
            
            // Assert: Kiểm tra dữ liệu đọc
            assert (o_rs1_data === i_rd_data) else 
                    $fatal("FAIL: Register %d expected value %h but got %h", i_rd_addr, i_rd_data, o_rs1_data);
        end
    end

    // Kiểm tra việc ghi vào thanh ghi 0 
    i_rd_addr = 5'b00000;
    i_rd_data = 32'hDEADBEEF; // Dữ liệu bất kỳ
    i_rd_wren = 1;
    #10;
    i_rd_wren = 0;
    #10;
    i_rs1_addr = 5'b0000;
	#10;
    assert (o_rs1_data === 32'h00000000) else 
            $fatal("FAIL: Register 0 expected to remain 0 but got %h", o_rs1_data);

    // Kiểm tra việc đọc từ thanh ghi 0 
    i_rs1_addr = 5'b00000;
    #10; 
    assert (o_rs1_data === 32'h00000000) else 
            $fatal("FAIL: Register 0 expected value 0 but got %h", o_rs1_data);
    
    $display("All tests passed successfully.");
    $finish;
end

// Timeout check 
initial begin
    #1000; // Thời gian chờ tối đa là 1000 thời gian đơn vị
    $fatal("FAIL: Simulation timed out.");
end

endmodule
