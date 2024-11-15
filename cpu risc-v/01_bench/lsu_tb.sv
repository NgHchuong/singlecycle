`timescale 1ns / 1ps
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
module lsu_tb;

    // Tín hiệu để kết nối
    reg clk;
    reg rst;
    reg lsu_wren;
    reg [31:0] lsu_addr;
    reg [31:0] st_data;
    reg [31:0] io_sw;
    reg [3:0] io_btn;

    wire [31:0] ld_data;
    wire [31:0] io_ledr;
    wire [31:0] io_ledg;
    wire [6:0] io_hex0;
    wire [6:0] io_hex1;
    wire [6:0] io_hex2;
    wire [6:0] io_hex3;
    wire [6:0] io_hex4;
    wire [6:0] io_hex5;
    wire [6:0] io_hex6;
    wire [6:0] io_hex7;
    wire [31:0] io_lcd;

    wire [15:0] SRAM_DQ;
    wire [17:0] SRAM_ADDR;
    wire SRAM_CE_N;
    wire SRAM_WE_N;
    wire SRAM_OE_N;
    wire SRAM_LB_N;
    wire SRAM_UB_N;

    // Trạng thái của SRAM để mô phỏng
    reg [15:0] sram_mem [0:65535];

    reg [31:0] expected_data1;
    reg [31:0] expected_data2;
    reg [31:0] expected_data3;
    reg [31:0] expected_data4;
    reg [31:0] expected_data5;

    // DUT instantiation
    lsu dut (
        .i_clk(clk),
        .i_rst(rst),
        .i_lsu_wren(lsu_wren),
        .i_lsu_addr(lsu_addr),
        .i_st_data(st_data),
        .i_io_sw(io_sw),
        .i_io_btn(io_btn),
        .o_ld_data(ld_data),
        .o_io_ledr(io_ledr),
        .o_io_ledg(io_ledg),
        .o_io_hex0(io_hex0),
        .o_io_hex1(io_hex1),
        .o_io_hex2(io_hex2),
        .o_io_hex3(io_hex3),
        .o_io_hex4(io_hex4),
        .o_io_hex5(io_hex5),
        .o_io_hex6(io_hex6),
        .o_io_hex7(io_hex7),
        .o_io_lcd(io_lcd),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_UB_N(SRAM_UB_N)
    );

    // Tạo xung clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ clock là 10ns
    end

    // Kết nối mô phỏng SRAM
    assign SRAM_DQ = (SRAM_WE_N == 0) ? st_data[15:0] : 16'bz;

    always @(negedge SRAM_WE_N) begin
        if (!SRAM_WE_N) begin
            sram_mem[SRAM_ADDR] <= st_data[15:0];
        end
    end

    // Testbench
    initial begin
        rst = 1;
        lsu_wren = 0;
        lsu_addr = 0;
        st_data = 0;
        io_sw = 0;
        io_btn = 0;

        // Đặt tín hiệu reset
        #10;
        rst = 0;

        // Test case 1: Ghi dữ liệu vào bộ nhớ
        #10;
        $display("Test Case 1: Ghi dữ liệu vào bộ nhớ");
        lsu_wren = 1;
        lsu_addr = 32'h0000_0004;
        st_data = 32'hDEAD_BEEF;
        expected_data1 = 32'hDEAD_BEEF;
        #10;
        lsu_wren = 0;
        #10;
        $display("Địa chỉ: 0x%h, Dữ liệu ghi: 0x%h", lsu_addr, st_data);

        // Test case 2: Đọc dữ liệu từ bộ nhớ
        #10;
        $display("Test Case 2: Đọc dữ liệu từ bộ nhớ");
        lsu_addr = 32'h0000_0004;
        #10;
        $display("Địa chỉ: 0x%h, Dữ liệu đọc: 0x%h", lsu_addr, ld_data);

        // Test case 3: Kiểm tra ghi và đọc từ SRAM
        #10;
        $display("Test Case 3: Kiểm tra ghi và đọc từ SRAM");
        lsu_wren = 1;
        lsu_addr = 32'h2000;
        st_data = 32'h1234_5678;
        expected_data2 = 32'h1234_5678;
        #10;
        lsu_wren = 0;
        #10;
        lsu_addr = 32'h2000;
        #10;
        $display("Địa chỉ: 0x%h, Dữ liệu SRAM ghi: 0x%h", lsu_addr, st_data);
        $display("Địa chỉ: 0x%h, Dữ liệu SRAM đọc: 0x%h", lsu_addr, ld_data);

        // Test case 4: Kiểm tra ghi và đọc từ LED
        #10;
        $display("Test Case 4: Kiểm tra ghi và đọc từ LED");
        lsu_wren = 1;
        lsu_addr = 32'h7000;
        st_data = 32'h1234_5678;
        expected_data3 = 32'h1234_5678;
        #10;
        lsu_wren = 0;
        #10;
        lsu_addr = 32'h7000;
        #10;
        $display("Địa chỉ: 0x%h, Dữ liệu LED đỏ ghi: 0x%h", lsu_addr, st_data);
        $display("Địa chỉ: 0x%h, Dữ liệu LED đỏ đọc: 0x%h", lsu_addr, ld_data);

        // Test case 5: Kiểm tra switch input
        #10;
        $display("Test Case 5: Kiểm tra switch input");
        io_sw = 32'h8765_4321;
        expected_data4 = 32'h8765_4321;
        lsu_addr = 32'h7800;
        #10;
        $display("Địa chỉ: 0x%h, Dữ liệu switch đọc: 0x%h", lsu_addr, ld_data);

        #10;
        $display("Kiểm tra assert sau tất cả các test case");

        assert (ld_data == expected_data1) else $fatal("Lỗi: Dữ liệu đọc không khớp sau khi ghi (Test case 1)");
        assert (ld_data == expected_data2) else $fatal("Lỗi: Dữ liệu SRAM đọc không khớp (Test case 3)");
        assert (ld_data == expected_data3) else $fatal("Lỗi: Dữ liệu LED đọc không khớp (Test case 4)");
        assert (ld_data == expected_data4) else $fatal("Lỗi: Dữ liệu switch đọc không khớp (Test case 5)");

        // Kết thúc mô phỏng
        #50;
        $finish;
    end

endmodule
