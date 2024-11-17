`include "timescale.svh"
module lsu (
	//input declar 
	  input logic i_clk,          			// Global clock, active on the rising edge.
	  input logic i_rst,         				// Global active reset.
	  input logic [31:0] i_lsu_addr,    	// Address for data read/write.
	  input logic [31:0] i_st_data, 			// Data to be stored.
	  input logic i_lsu_wren,          		// Write enable signal (1 if writing).
	  input logic [31:0] i_io_sw,   			// Input for switches. 
	//output declar
	  output logic [31:0] o_ld_data, 		// Data read from memory
	  output logic [31:0] o_io_ledr, 		// Output for red LEDs.
	  output logic [31:0] o_io_ledg, 		// Output for green LEDs.
	  output logic [31:0] o_io_lcd, 			// Output for the LCD register.	  	  
	  output logic [6:0] o_io_hex0, 			//	Output for 7-segment displays.
	  output logic [6:0] o_io_hex1, 
	  output logic [6:0] o_io_hex2,
	  output logic [6:0] o_io_hex3,
	  output logic [6:0] o_io_hex4,
	  output logic [6:0] o_io_hex5,
	  output logic [6:0] o_io_hex6,
	  output logic [6:0] o_io_hex7
);

  // Memory Map Addresses
  localparam ADDR_SW   = 32'h7800;
  localparam ADDR_LCD  = 32'h7030;
  localparam ADDR_LEDG = 32'h7010;
  localparam ADDR_LEDR = 32'h7000;
  localparam ADDR_HEX0 = 32'h7020;
  localparam ADDR_HEX1 = 32'h7021;
  localparam ADDR_HEX2 = 32'h7022;
  localparam ADDR_HEX3 = 32'h7023;
  localparam ADDR_HEX4 = 32'h7024;
  localparam ADDR_HEX5 = 32'h7025;
  localparam ADDR_HEX6 = 32'h7026;
  localparam ADDR_HEX7 = 32'h7027;
  localparam SRAM_MAX  = 32'h3FFF;
  localparam SRAM_MIN  = 32'h2000;

  // Internal registers for memory-mapped data
  logic [31:0] lcd_data, ledg_data, ledr_data, i_buffer;
  logic [31:0] hex0_data, hex1_data, hex2_data, hex3_data, hex4_data, hex5_data, hex6_data, hex7_data;
  logic [31:0] i_ADDR, i_WDATA, o_RDATA;
  logic [ 3:0] i_BMASK;
  logic        i_WREN, i_RDEN, o_ACK, flag;
  
  enum int unsigned { check = 0, write = 1, read = 2, wait_wr = 3, finish = 4, reset = 5 } p_state, n_state;
always_comb begin : next_state_logic
	  n_state = check;
	  case(p_state)
		check: n_state = (i_lsu_wren) ? write : read;
		write: n_state = (i_lsu_addr > SRAM_MAX) ? check : ((i_lsu_addr >= SRAM_MIN) && (i_lsu_addr <= SRAM_MAX )) ? wait_wr : finish;
		read: n_state = (i_lsu_addr > SRAM_MAX) ? check : ((i_lsu_addr >= SRAM_MIN) && (i_lsu_addr <= SRAM_MAX )) ? wait_wr : finish;
		wait_wr: n_state = o_ACK ? finish : wait_wr;
		finish : n_state = check;
		reset : n_state = check;
	  endcase
end

always_ff@(posedge i_clk or negedge i_rst) begin
	  if(~i_rst)
		 p_state <= reset;
	  else
		 p_state <= n_state;
end

  sram_IS61WV25616_controller_32b_3lr data_sram(
  .i_ADDR(i_ADDR),
  .i_WDATA(i_WDATA),
  .i_BMASK(i_BMASK), 
  .i_WREN(i_WREN),
  .i_RDEN(i_RDEN),
  .o_RDATA(o_RDATA), 
  .o_ACK(o_ACK), 
  .i_clk(i_clk), 
  .i_reset(i_rst)
  );
always_ff
begin
	case(p_state)
		reset: begin
				// Reset internal registers during reset
				lcd_data <= 32'h0;
				ledg_data <= 32'h0;
				ledr_data <= 32'h0;
				hex0_data <= 32'h0;
				hex1_data <= 32'h0;
				hex2_data <= 32'h0;
				hex3_data <= 32'h0;
				hex4_data <= 32'h0;
				hex5_data <= 32'h0;
				hex6_data <= 32'h0;
				hex7_data <= 32'h0;
				i_buffer  <= 32'h0;
				i_BMASK   <= 4'b0;
				end	
		check: begin 
			 flag = i_lsu_wren ? 1 : 0;
			 end
		write: begin
			 if (i_lsu_addr > SRAM_MAX) begin
      // Write data to memory-mapped registers based on address
					case(i_lsu_addr)
					ADDR_SW   : i_buffer  = i_io_sw;
					ADDR_LCD  : lcd_data  = i_st_data;
					ADDR_LEDG : ledg_data = i_st_data;
					ADDR_LEDR : ledr_data = i_st_data;
					ADDR_HEX0 : hex0_data = i_st_data;
					ADDR_HEX1 : hex1_data = i_st_data;
					ADDR_HEX2 : hex2_data = i_st_data;
					ADDR_HEX3 : hex3_data = i_st_data;
					ADDR_HEX4 : hex4_data = i_st_data;
					ADDR_HEX5 : hex5_data = i_st_data;
					ADDR_HEX6 : hex6_data = i_st_data;
					ADDR_HEX7 : hex7_data = i_st_data;
					 default;    							
					endcase
				 end
			else if ((i_lsu_addr >= SRAM_MIN) && (i_lsu_addr <= SRAM_MAX) ) begin
			// WRITE TO SRAM
					i_WDATA = i_st_data;
					i_WREN  = 1;
					i_ADDR  = i_lsu_addr;
					i_RDEN  = 0;
					i_BMASK = 4'b1111;
				end
			end
		read: begin
				if (i_lsu_addr > SRAM_MAX) 
				begin
		 // Read data from memory-mapped registers based on address
					 case(i_lsu_addr)
						ADDR_SW   : o_ld_data = i_buffer;
						ADDR_LCD  : o_ld_data = lcd_data;
						ADDR_LEDG : o_ld_data = ledg_data;
						ADDR_LEDR : o_ld_data = ledr_data;
						ADDR_HEX0 : o_ld_data = hex0_data;
						ADDR_HEX1 : o_ld_data = hex1_data;
						ADDR_HEX2 : o_ld_data = hex2_data;
						ADDR_HEX3 : o_ld_data = hex3_data;
						ADDR_HEX4 : o_ld_data = hex4_data;
						ADDR_HEX5 : o_ld_data = hex5_data;
						ADDR_HEX6 : o_ld_data = hex6_data;
						ADDR_HEX7 : o_ld_data = hex7_data;
						default   : o_ld_data = 32'h0; 		// Default value for other addresses
					 endcase
				end
				else if ((i_lsu_addr >= SRAM_MIN) && (i_lsu_addr <= SRAM_MAX) ) begin
			// READ FROM SRAM
						i_WDATA = 32'h0;
						i_WREN  = 0;
						i_ADDR  = i_lsu_addr;
						i_RDEN  = 1;
						i_BMASK = 4'b1111;
				end
		end
		wait_wr: begin
			o_ld_data = 32'hzzzz_zzzz;
		end
		finish:begin
			o_ld_data = o_RDATA;
		end	
	endcase
end
 
  // Peripheral Outputs
  assign o_io_lcd  = lcd_data;
  assign o_io_ledg = ledg_data;
  assign o_io_ledr = ledr_data;
  assign o_io_hex0 = hex0_data;
  assign o_io_hex1 = hex1_data;
  assign o_io_hex2 = hex2_data;
  assign o_io_hex3 = hex3_data;
  assign o_io_hex4 = hex4_data;
  assign o_io_hex5 = hex5_data;
  assign o_io_hex6 = hex6_data;
  assign o_io_hex7 = hex7_data;

endmodule : lsu
