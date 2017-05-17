//-----------------------------------------------------------------------------
//
// Title       : sdram_wb_tb
// Design      : sim
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : sdram_wb_tb.v
// Generated   : Thu Feb  2 20:07:06 2017
// From        : C:\work\sdr-rtl\lattice\sim\src\TestBench\sdram_wb_tb_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns
module sdram_wb_tb;
//Parameters declaration: 
defparam UUT.SDRAM_MHZ = 100;
parameter SDRAM_MHZ = 100;
defparam UUT.SDRAM_ADDR_W = 24;
parameter SDRAM_ADDR_W = 24;
defparam UUT.SDRAM_COL_W = 9;
parameter SDRAM_COL_W = 9;
defparam UUT.SDRAM_BANK_W = 2;
parameter SDRAM_BANK_W = 2;
//defparam UUT.SDRAM_DQM_W = 2;
//parameter SDRAM_DQM_W = 2;
defparam UUT.SDRAM_BANKS = 2**SDRAM_BANK_W;
parameter SDRAM_BANKS = 2**SDRAM_BANK_W;
defparam UUT.SDRAM_ROW_W = SDRAM_ADDR_W-SDRAM_COL_W-SDRAM_BANK_W;
parameter SDRAM_ROW_W = SDRAM_ADDR_W-SDRAM_COL_W-SDRAM_BANK_W;
defparam UUT.SDRAM_REFRESH_CNT = 2**SDRAM_ROW_W;
parameter SDRAM_REFRESH_CNT = 2**SDRAM_ROW_W;
defparam UUT.SDRAM_START_DELAY = 100000/1000/SDRAM_MHZ;
parameter SDRAM_START_DELAY = 100000/1000/SDRAM_MHZ;
defparam UUT.SDRAM_REFRESH_CYCLES = 64000*SDRAM_MHZ/SDRAM_REFRESH_CNT-1;
parameter SDRAM_REFRESH_CYCLES = 64000*SDRAM_MHZ/SDRAM_REFRESH_CNT-1;
defparam UUT.SDRAM_READ_LATENCY = 3;
parameter SDRAM_READ_LATENCY = 3;
defparam UUT.SDRAM_TARGET = "LATTICE";
parameter SDRAM_TARGET = "LATTICE";

parameter CMD_W = 4;

parameter CMD_NOP = 4'b0111;

parameter CMD_ACTIVE = 4'b0011;

parameter CMD_READ = 4'b0101;

parameter CMD_WRITE = 4'b0100;

parameter CMD_TERMINATE = 4'b0110;

parameter CMD_PRECHARGE = 4'b0010;

parameter CMD_REFRESH = 4'b0001;

parameter CMD_LOAD_MODE = 4'b0000;

parameter MODE_REG = {3'b000,1'b0,2'b00,3'b010,1'b0,3'b001};

parameter STATE_W = 4;

parameter STATE_INIT = 4'd0000;

parameter STATE_DELAY = 4'd1;

parameter STATE_IDLE = 4'd2;

parameter STATE_ACTIVATE = 4'd3;

parameter STATE_READ = 4'd4;

parameter STATE_READ_WAIT = 4'd5;

parameter STATE_WRITE0 = 4'd6;

parameter STATE_WRITE1 = 4'd7;

parameter STATE_PRECHARGE = 4'd8;

parameter STATE_REFRESH = 4'd9;

parameter AUTO_PRECHARGE = 10;

parameter ALL_BANKS = 10;

parameter SDRAM_DATA_W = 16;

parameter CYCLE_TIME_NS = 1000/SDRAM_MHZ;

parameter SDRAM_TRCD_CYCLES = (20+CYCLE_TIME_NS-1)/CYCLE_TIME_NS;

parameter SDRAM_TRP_CYCLES = (20+CYCLE_TIME_NS-1)/CYCLE_TIME_NS;

parameter SDRAM_TRFC_CYCLES = (60+CYCLE_TIME_NS-1)/CYCLE_TIME_NS;

parameter DELAY_W = 4;

parameter REFRESH_CNT_W = 24;

//Internal signals declarations:
reg clk, clk_sdram;
reg reset_n;
reg stb;
reg we;

reg cyc;
reg [31:0]addr;
reg [31:0]data_i, read_data;
wire [31:0]data_o;
wire stall;
wire ack;
wire sdram_cke;
wire sdram_cs;
wire sdram_ras;
wire sdram_cas;
wire sdram_we;
wire [1:0]sdram_dqm;
wire [12:0]sdram_addr;
wire [1:0]sdram_ba;

wire [15:0]sdram_data_io; 

 

sdram_model mem_model (
	       .CLK	(clk_sdram ),
           .CKE	( sdram_cke),
           .CS_N	(sdram_cs ),
           .RAS_N	(sdram_ras ),
           .CAS_N	(sdram_cas ),
           .WE_N	(sdram_we ),
           .BA      (sdram_ba ),
           .DQM     (sdram_dqm),
           .ADDR    (sdram_addr),
		   .DQ      (sdram_data_io)
     );


// Unit Under Test port map
	sdram UUT (
		.clk_i(clk),
		.rst_i(reset_n),
		.stb_i(stb),
		.we_i(we),
		.sel_i(4'b1111),
		.cyc_i(cyc),
		.addr_i(addr),
		.data_i(data_i),
		.data_o(data_o),
		.stall_o(stall),
		.ack_o(ack),
		.sdram_cke_o(sdram_cke),
		.sdram_cs_o(sdram_cs),
		.sdram_ras_o(sdram_ras),
		.sdram_cas_o(sdram_cas),
		.sdram_we_o(sdram_we),
		.sdram_dqm_o(sdram_dqm),
		.sdram_addr_o(sdram_addr),
		.sdram_ba_o(sdram_ba),
		.sdram_data_io(sdram_data_io));

initial
begin	
	//$monitor($realtime,,"ps %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h ",clk,sdram_dq_bidir,sdram_addr,sdram_ba,sdram_cs,sdram_ras,sdram_cas,sdram_we,sdram_dqm,addr,wr_req,wr_ack,next_wr_ack,wr_data,rd_req,rd_ack,rd_valid,next_rd_valid,rd_data);
	clk = 0;  
	clk_sdram = 0; 
	stb = 0;
	cyc = 0;
	we = 0;
	data_i = 32'hddeeffaa;
	addr = 0; 
	reset_n = 1;
	
	#10reset_n = 0;
	
	#1700 we = 1;	
	cyc = 1; 
	stb = 1; 

	#5700 we = 0;
	addr = 0;
	
end		

initial	 
begin	
	#2.5 clk_sdram = 0;
	forever #5 clk_sdram = ~clk_sdram;
end

initial	forever #5 clk = ~clk;
	
always @(posedge clk)	
begin	
	if (ack)
	begin
		addr <= addr + 3'h4;
		if (we)
			data_i <= data_i + 1'b1;
		else
			read_data <= data_o;
	end
end	
/*	
always @(posedge clk)
if (reset_n)
	data_i <= 0;
else if (ack)
begin	
	addr <= addr + 3'h1;
	if (we)
		data_i <= data_i + 1'b1;
	else
		read_data <= data_o;
end	   
 */

endmodule
