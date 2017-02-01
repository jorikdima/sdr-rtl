
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

parameter FT_PACKET_WORDS = 4096;

parameter A2F_FIFO_WORDS = 8192;
parameter F2A_FIFO_WORDS = 8192;

parameter A2F_FIFO_FULL_ENOUGH = FT_PACKET_WORDS;
parameter F2A_FIFO_FREE_ENOUGH = F2A_FIFO_WORDS - FT_PACKET_WORDS;

parameter A2F_FIFO_USEDW_WIDTH = log2(A2F_FIFO_WORDS);
parameter F2A_FIFO_USEDW_WIDTH = log2(F2A_FIFO_WORDS);

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

output wire [10:0] sdram_addr;
output wire [1:0]  sdram_ba;
output wire        sdram_cas_n;
output wire        sdram_cke;
output wire        sdram_cs_n;
inout  wire [15:0] sdram_dq;
output wire [1:0]  sdram_dqm;
output wire        sdram_ras_n;
output wire        sdram_we_n;
output wire        sdram_clk;


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

wire [IQ_PAIR_WIDTH-1:0] ft_rdata, f2a_fifo_data, afe_wdata, ft_wdata;

wire [A2F_FIFO_USEDW_WIDTH-1:0] a2f_wr_usedw;
wire [F2A_FIFO_USEDW_WIDTH-1:0] f2a_wr_usedw;

wire pll_locked, pll_main, pll_shifted, i2c_sda_oe, i2c_scl_oe;

wire en = pll_locked & reset_n;

wire clk_main = pll_main & en;
assign sdram_clk = pll_shifted;

sdram_controller sdram_controller_inst(

    // inputs:
    //.az_addr(az_addr),
    //.az_be_n(az_be_n),
    //.az_cs(az_cs),
    //.az_data(az_data),
    //.az_rd_n(az_rd_n),
    //.az_wr_n(az_wr_n),
    .clk(clk_main),
    .reset_n(reset_n),

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

a2f_fifo	a2f_fifo_inst (
    .aclr ( ~en ),
    .data ( afe_wdata ),
    .rdclk ( ft_wr_clk ),
    .rdreq ( ft_wr_req ),
    .wrclk ( a2f_fifo_clk ),
    .wrreq ( a2f_fifo_wr ),
    .q ( ft_wdata ),    
    .rdusedw ( a2f_wr_usedw ),    
    .wrfull ( a2f_fifo_full )
	);

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


f2a_fifo	f2a_fifo_inst (
//input
	.aclr ( ~en ),
	.data ( ft_rdata ),
	.rdclk ( f2a_fifo_clk ),
	.rdreq ( f2a_fifo_req ),
	.wrclk ( ft_rd_clk ),
	.wrreq ( ft_rd_req ),
//output	
	.q ( f2a_fifo_data ),
	.wrusedw ( f2a_wr_usedw ),
	.wrfull ( f2a_fifo_full ),
    .rdempty(f2a_fifo_empty)
	);


ft600_fsm #(.FT_DATA_WIDTH (FT_DATA_WIDTH),
        .IQ_PAIR_WIDTH (IQ_PAIR_WIDTH))
fsm_inst
(
    .clk(ft_clk),
    .reset_n(en),

    .rxf_n(ft_rxf_n),
    .wr_n(ft_wr_n),
    
    .wdata(ft_wdata),
    .wr_enough(a2f_wr_usedw >= A2F_FIFO_FULL_ENOUGH),
    .wr_empty(a2f_wr_usedw == 1),
    
    .rd_full(f2a_fifo_full),
    .rd_enough(f2a_wr_usedw <= F2A_FIFO_FREE_ENOUGH),
    
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


pll	pll_inst (
	.areset ( ~reset_n ),
	.inclk0 ( ft_clk ),
	.c0 ( pll_main ),
	.c1 ( pll_shifted ),
	.locked ( pll_locked )
	);

assign i2c_scl = i2c_scl_oe ? 1'b1: 1'bz;
assign i2c_sda = i2c_sda_oe ? 1'b1: 1'bz;

system system_inst (
		.clk_clk       (clk_main),       //   clk.clk
		.reset_reset_n (reset_n), // reset.reset_n
		.spi_0_MISO    (afe_spi_miso),    // spi_0.MISO
		.spi_0_MOSI    (afe_spi_mosi),    //      .MOSI
		.spi_0_SCLK    (afe_spi_clk),    //      .SCLK
		//.spi_0_SS_n    (<connected-to-spi_0_SS_n>),    //      .SS_n
		.i2c_0_sda_in  (i2c_sda),  // i2c_0.sda_in
		.i2c_0_scl_in  (i2c_scl),  //      .scl_in
		.i2c_0_sda_oe  (i2c_sda_oe),  //      .sda_oe
		.i2c_0_scl_oe  (i2c_scl_oe)   //      .scl_oe
	);

endmodule