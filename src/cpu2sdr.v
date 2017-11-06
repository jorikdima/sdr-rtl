
module cpu2sdr (
    reset_n,
// Commands from Host    
    InData, 
    InClk, 
    InWr, 
    
// Replies from CPU    
    OutData,
    OutClk,
    OutRd, 
    OutWc,
    
 // Wishbone interface
    wb_clk_i  ,
    wb_rst_i  ,
    wb_adr_i  ,
    wb_dat_i  ,
    wb_we_i   ,
    wb_cyc_i  ,
    wb_stb_i  ,
    wb_sel_i  ,
    wb_cti_i  ,
    wb_bte_i  ,
    wb_lock_i ,
    wb_dat_o  ,
    wb_ack_o  ,
    wb_err_o  ,
    wb_rty_o  	
 );

parameter FT_DATA_WIDTH = 32;
 

input wire reset_n;
input wire [FT_DATA_WIDTH-1:0] InData;
input wire InClk;
input wire  InWr;

output wire [FT_DATA_WIDTH-1:0] OutData;
input wire OutClk;
input wire OutRd;
output wire [7:0] OutWc;

input               wb_clk_i;    
input               wb_rst_i;
input [31:0]        wb_adr_i;  
input [31:0]        wb_dat_i;
input               wb_we_i;   
input               wb_cyc_i;   
input               wb_stb_i;   
input [3:0]	        wb_sel_i;   
input [2:0]	        wb_cti_i;
input [1:0]	        wb_bte_i;
input               wb_lock_i;
output [31:0]       wb_dat_o;   
output           wb_ack_o;   
output              wb_err_o;   
output              wb_rty_o; 



//----------------------------------------------------------------------

wire[FT_DATA_WIDTH-1:0] cpuin_fifo_q;
wire[FT_DATA_WIDTH-1:0] cpuout_fifo_data;
wire cpuin_fifo_rden, cpuin_fifo_rdclk;

wire cpuin_fifo_empty, cpuin_fifo_full;
wire cpuout_fifo_wr, cpuout_fifo_full, cpuout_fifo_empty, cpuout_fifo_clk;

reg wc_valid1, wc_valid2, wc_valid3;
reg [7:0] fofoout_wc;
wire [7:0] fifoout_wcadd;
wire fifoout_wcen;


// From CPU
cpucmd_fifo cpuout_fifo_inst (.Data(cpuout_fifo_data ), .WrClock(cpuout_fifo_clk ), .RdClock(OutClk), .WrEn(cpuout_fifo_wr ), .RdEn(OutRd), 
    .Reset(~reset_n), .RPReset(1'b0 ), .Q(OutData ), .Empty(cpuout_fifo_empty ), .Full(cpuout_fifo_full ));
    

//From Host    
cpucmd_fifo cpuin_fifo_inst (.Data(InData ), .WrClock(InClk ), .RdClock(cpuin_fifo_rdclk ), .WrEn(InWr ), .RdEn(cpuin_fifo_rden ), 
    .Reset(~reset_n), .RPReset(1'b0 ), .Q(cpuin_fifo_q ), .Empty(cpuin_fifo_empty ), .Full(cpuin_fifo_full ));
    
    
wb2fifo #(.FT_DATA_WIDTH (FT_DATA_WIDTH))
wb2fifo_inst 
(
	// FIFO to read from
	.fifoin_data_i(cpuin_fifo_q),
	.fifoin_clk_o(cpuin_fifo_rdclk),
	.fifoin_rd_o(cpuin_fifo_rden),
    .fifoin_empty_i(cpuin_fifo_empty),
    .fifoin_full_i(cpuin_fifo_full),
    
	
	//FIFO to write to
	.fifoout_data_o(cpuout_fifo_data),
    .fifoout_empty_i(cpuout_fifo_empty),
    .fifoout_full_i(cpuout_fifo_full),
	.fifoout_clk_o(cpuout_fifo_clk),
	.fifoout_wr_o(cpuout_fifo_wr),
    
    .fifoout_wc_o(fifoout_wcadd),
    .fifoout_wcen_o(fifoout_wcen),


    // Wishbone interface
    .wb_clk_i(wb_clk_i)  ,
    .wb_rst_i(wb_rst_i)  ,
    .wb_adr_i(wb_adr_i)  ,
    .wb_dat_i(wb_dat_i)  ,
    .wb_we_i(wb_we_i)   ,
    .wb_cyc_i(wb_cyc_i)  ,
    .wb_stb_i(wb_stb_i) ,
    .wb_sel_i(wb_sel_i)  ,
    .wb_cti_i(wb_cti_i)  ,
    .wb_bte_i(wb_bte_i)  ,
    .wb_lock_i(wb_lock_i) ,
    .wb_dat_o(wb_dat_o)  ,
    .wb_ack_o(wb_ack_o)  ,
    .wb_err_o(wb_err_o)  ,
    .wb_rty_o(wb_rty_o)  	
);

always @(posedge OutClk or negedge reset_n)
if (~reset_n) begin
    wc_valid1 <= 1'b0;
    wc_valid2 <= 1'b0;
    wc_valid3 <= 1'b0;
    fofoout_wc <= 8'b0;
    end
else begin
    wc_valid1 <= fifoout_wcen;
    wc_valid2 <= wc_valid1;
    wc_valid3 <= wc_valid2;
    if (wc_valid2 & ~wc_valid3)
        fofoout_wc = fofoout_wc + fifoout_wcadd;   // synced with OutClk
    end

assign OutWc = fofoout_wc;


endmodule