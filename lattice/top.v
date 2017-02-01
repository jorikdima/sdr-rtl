
module top(
clk_sr1, clk_sr2, reset_n, 

// SDRAM
sdram_addr,
sdram_ba,
sdram_cas_n,
sdram_cke,
sdram_cs_n,
sdram_dq,
sdram_dqm,
sdram_ras_n,
sdram_we_n,
sdram_clk,


// AFE
afe_tx_d, afe_tx_clk, afe_tx_sel,
afe_rx_d, afe_rx_clk, afe_rx_sel,
afe_spi_clk, afe_spi_mosi, afe_spi_miso,
afe_sen, afe_tx_en, afe_rx_en, afe_reset,

//FT
ft_clk,
ft_txe_n,
ft_rxf_n,
ft_oe_n,
ft_wr_n,
ft_rd_n,

ft_data,
ft_be,

// Si535x
i2c_clk,
i2c_sda
);


parameter FT_DATA_WIDTH=32;
parameter IQ_PAIR_WIDTH = 24;

parameter SDRAM_DQ_WIDTH = 32;

//parameter FT_PACKET_WORDS = 32;

//parameter A2F_FIFO_WORDS = 128;
//parameter F2A_FIFO_WORDS = 128;

//parameter A2F_FIFO_FULL_ENOUGH = FT_PACKET_WORDS;
//parameter F2A_FIFO_FREE_ENOUGH = F2A_FIFO_WORDS - FT_PACKET_WORDS;


function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction


input wire	clk_sr1, clk_sr2, reset_n;

// SDRAM

output wire [12:0]               sdram_addr;
output wire [1:0]                sdram_ba;
output wire                      sdram_cas_n;
output wire                      sdram_cke;
output wire                      sdram_cs_n;
inout  wire [SDRAM_DQ_WIDTH-1:0] sdram_dq;
output wire                      sdram_dqm;
output wire                      sdram_ras_n;
output wire                      sdram_we_n;
output wire                      sdram_clk;


// AFE
output wire	afe_tx_clk;
output wire afe_tx_sel;
output wire [11:0] afe_tx_d;
output wire	afe_rx_clk;
input  wire afe_rx_sel;
input  wire [11:0] afe_rx_d;

output wire afe_spi_clk, afe_spi_mosi, afe_reset;
output wire afe_sen, afe_tx_en, afe_rx_en;
input wire afe_spi_miso;

// FT

input  wire ft_clk, ft_txe_n, ft_rxf_n;
output wire ft_oe_n, ft_wr_n, ft_rd_n;

inout wire[FT_DATA_WIDTH-1:0] ft_data;
inout wire[3:0] ft_be;

// Si535x
inout wire i2c_clk;
inout wire i2c_sda;


wire rd_req, ft_rd_clk, ft_wr_clk, ft_wr_req, ft_rd_req;

wire f2a_fifo_empty, f2a_fifo_full, f2a_fifo_req, f2a_fifo_clk;
wire a2f_fifo_wr, a2f_fifo_clk, a2f_fifo_full;
wire f2a_fifo_enough, a2f_fifo_enough, a2f_fifo_empty;

wire [IQ_PAIR_WIDTH-1:0] ft_rdata, f2a_fifo_data, afe_wdata, ft_wdata;

wire clk, pll_locked, clk_pll, clk_pll_shifted, i2c_sda_oe, i2c_scl_oe;

wire en = pll_locked & reset_n;

assign sdram_clk = clk_pll_shifted & en; 


GSR GSR_INST (.GSR (reset_n));
PUR PUR_INST (.PUR (reset_n));

afe #(.IQ_PAIR_WIDTH (IQ_PAIR_WIDTH))
afe_inst(
.reset_n(en), 

// AFE RX
.rx_d(afe_rx_d),
.rx_clk_2x(afe_rx_clk),
.rx_sel(afe_rx_sel),
.rx_sclk_2x(clk_sr2),

.rx_fifo_full(a2f_fifo_full),
.rx_fifo_data(afe_wdata),
.rx_fifo_wr(a2f_fifo_wr),
.rx_fifo_clk(a2f_fifo_clk),

// AFE TX
.tx_sclk_2x(clk_sr1),
.tx_clk_2x(afe_tx_clk),
.tx_sel(afe_tx_sel),
.tx_d(afe_tx_d),

.tx_fifo_empty(f2a_fifo_empty),
.tx_fifo_data(f2a_fifo_data),
.tx_fifo_req(f2a_fifo_req),
.tx_fifo_clk(f2a_fifo_clk)

);

/*
sdram_controller sdram_controller_inst(

    // inputs:
    //.az_addr(az_addr),
    //.az_be_n(az_be_n),
    //.az_cs(az_cs),
    //.az_data(az_data),
    //.az_rd_n(az_rd_n),
    //.az_wr_n(az_wr_n),
    .clk(1'b0),
    .reset_n(1'b0),

   // outputs:
    //.za_data(za_data),
    //.za_valid(za_valid),
    //.za_waitrequest(za_waitrequest),
    .zs_addr(sdram_addr),
    .zs_ba(sdram_ba),
    .zs_cas_n(sdram_cas_n),
    .zs_cke(sdram_cke),
    .zs_cs_n(sdram_cs_n),
    .zs_dq(sdram_dq),
    .zs_dqm(sdram_dqm),
    .zs_ras_n(sdram_ras_n),
    .zs_we_n(sdram_we_n)
	);
*/

sdram #(.DQ_WIDTH (SDRAM_DQ_WIDTH))
sdram_inst (
    .clk(clk_pll),
// SDRAM interface
	.sdram_dq(sdram_dq), 
	.sdram_addr(sdram_addr), 
	.sdram_ba(sdram_ba), 
	.sdram_cs(sdram_cs_n),
	.sdram_ras(sdram_ras_n), 
	.sdram_cas(sdram_cas_n), 
	.sdram_we(sdram_we_n), 
	.sdram_dqm(sdram_dqm),

	// read/write address
    .addr(24'hffffff),

	// write port
	.wr_req(1), 		// write request 
	//.wr_ack(), 	// write acknowledgement 
	//.next_wr_ack(),
	.wr_data(0),

	// read port
	.rd_req(0) 
	//.rd_ack(), 
	//.rd_valid(), 
	//.next_rd_valid(),
    //.rd_data()
);

a2f_fifo a2f_fifo_inst (.Data(afe_wdata ), .WrClock(a2f_fifo_clk ), .RdClock(ft_wr_clk ), .WrEn(a2f_fifo_wr ), .RdEn(ft_wr_req ), 
    .Reset(1'b0 ), .RPReset( 1'b0), .Q( ft_wdata), .AlmostFull(a2f_fifo_enough ), .Empty(a2f_fifo_empty ), .Full(a2f_fifo_full ));
	
f2a_fifo f2a_fifo_inst (.Data(ft_rdata ), .WrClock( ft_rd_clk), .RdClock( f2a_fifo_clk), .WrEn(ft_rd_req ), .RdEn(f2a_fifo_req ), 
    .Reset(1'b0 ), .RPReset(1'b0 ), .Q( f2a_fifo_data), .AlmostEmpty(f2a_fifo_enough ), .Empty( f2a_fifo_empty), .Full(f2a_fifo_full ));	


ft600_fsm #(.FT_DATA_WIDTH (FT_DATA_WIDTH),		    .IQ_PAIR_WIDTH (IQ_PAIR_WIDTH))
fsm_inst
(
    .clk(clk),
    .reset_n(en),

    .rxf_n(ft_rxf_n),
    .wr_n(ft_wr_n),
    
    .wdata(ft_wdata),
    .wr_enough(a2f_fifo_enough),
    .wr_empty(a2f_fifo_empty),
    
    .rd_full(f2a_fifo_full),
    .rd_enough(f2a_fifo_enough),
    
    //output
    .txe_n(ft_txe_n),
    .rd_n(ft_rd_n),
    .oe_n(ft_oe_n),
    
    .rdata(ft_rdata),
    .rd_req(ft_rd_req),
    .rd_clk(ft_rd_clk),
    
    .wr_clk(ft_wr_clk),
    .wr_req(ft_wr_req),
    
    //inout
    .ft_data(ft_data),
    .ft_be(ft_be)
);


pll pll_inst (.CLKI(ft_clk ), .CLKOP(clk ), .CLKOS(clk_pll ), .CLKOS2( clk_pll_shifted), .LOCK(pll_locked ));

endmodule