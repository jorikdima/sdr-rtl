//-----------------------------------------------------------------------------
//
// Title       : sdram_vlg_tst
// Design      : sim
// Author      : Aldec, Inc
// Company     : Aldec, Inc
//
//-----------------------------------------------------------------------------
//
// File        : sdram_tb.v
// Generated   : Wed Feb  1 19:05:41 2017
// From        : C:\work\sdr-rtl\lattice\sim\src\TestBench\sdram_tb_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns
module sdram_vlg_tst;  
	
//Parameters declaration: 
defparam UUT.DQ_WIDTH = 16;
parameter DQ_WIDTH = 16;
defparam UUT.MODE = 4'd0000;
parameter MODE = 4'd0000;
defparam UUT.REFRESH = 4'd1;
parameter REFRESH = 4'd1;
defparam UUT.PRECHARGE = 4'd2;
parameter PRECHARGE = 4'd2;
defparam UUT.ACTIVE = 4'd3;
parameter ACTIVE = 4'd3;
defparam UUT.WRITE = 4'd4;
parameter WRITE = 4'd4;
defparam UUT.READ = 4'd5;
parameter READ = 4'd5;
defparam UUT.TERMINATE = 4'd6;
parameter TERMINATE = 4'd6;
defparam UUT.NOP = 4'd7;
parameter NOP = 4'd7;
defparam UUT.WAIT = 4'd10;
parameter WAIT = 4'd10;
defparam UUT.RAS = 4'd11;
parameter RAS = 4'd11;
defparam UUT.PRECH_ALL = 4'd12;
parameter PRECH_ALL = 4'd12;
defparam UUT.REFRESH1 = 3'd000;
parameter REFRESH1 = 3'd000;
defparam UUT.REFRESH2 = 3'd1;
parameter REFRESH2 = 3'd1;
defparam UUT.INIT_MODE = 3'd2;
parameter INIT_MODE = 3'd2;
defparam UUT.READY = 3'd3;
parameter READY = 3'd3;
defparam UUT.START_REFRESH = 3'd4;
parameter START_REFRESH = 3'd4;

//Internal signals declarations:
reg clk;
tri [DQ_WIDTH-1:0]sdram_dq_bidir;
reg [DQ_WIDTH-1:0]sdram_dq;
//Continous assignment for inout port "sdram_dq".
//assign sdram_dq_bidir = sdram_dq;

wire [12:0]sdram_addr;
wire [1:0]sdram_ba;
wire sdram_cs;
wire sdram_ras;
wire sdram_cas;
wire sdram_we;
wire sdram_dqm;
reg [23:0]addr;
reg wr_req;
wire wr_ack;
wire next_wr_ack;
reg [DQ_WIDTH-1:0]wr_data;
reg rd_req;
wire rd_ack;
wire rd_valid;
wire next_rd_valid;
wire [DQ_WIDTH-1:0]rd_data;



// Unit Under Test port map
	sdram UUT (
		.clk(clk),
		.sdram_dq(sdram_dq_bidir),
		.sdram_addr(sdram_addr),
		.sdram_ba(sdram_ba),
		.sdram_cs(sdram_cs),
		.sdram_ras(sdram_ras),
		.sdram_cas(sdram_cas),
		.sdram_we(sdram_we),
		.sdram_dqm(sdram_dqm),
		.addr(addr),
		.wr_req(wr_req),
		.wr_ack(wr_ack),
		.next_wr_ack(next_wr_ack),
		.wr_data(wr_data),
		.rd_req(rd_req),
		.rd_ack(rd_ack),
		.rd_valid(rd_valid),
		.next_rd_valid(next_rd_valid),
		.rd_data(rd_data));

initial	 
begin	
	//$monitor($realtime,,"ps %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h ",clk,sdram_dq_bidir,sdram_addr,sdram_ba,sdram_cs,sdram_ras,sdram_cas,sdram_we,sdram_dqm,addr,wr_req,wr_ack,next_wr_ack,wr_data,rd_req,rd_ack,rd_valid,next_rd_valid,rd_data);
	clk = 0;  
	wr_req = 0;
	wr_data = 16'hffaa;
	addr = 0;
	
	#6000 wr_req = 1;
end	
	
initial	forever #5 clk = ~clk;
	
always @(negedge clk)
if (wr_ack)
begin	
	addr <= addr + 3'h4;
	wr_data <= wr_data + 1'b1;
end
	
endmodule
