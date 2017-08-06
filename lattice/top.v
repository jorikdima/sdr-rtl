
module top(
clk26, clk_sr1, clk_sr2, reset_n, 

// virtual vccio
vcc_virt_1, vcc_virt_2,


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
ft_gpio0,

// Si535x
i2c_clk,
i2c_sda,

// Rpi
rpi_d,
rpi_a,
rpi_we,
rpi_oe,
rpi_gpio,

// Misc
tx_mux, rx_mux,
tx_led, rx_led
);


parameter FT_DATA_WIDTH=32;
parameter IQ_PAIR_WIDTH = 24;

parameter RPI_DATA_WIDTH=18;
parameter RPI_ADDR_WIDTH=6;

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


input wire	clk26, clk_sr1, clk_sr2, reset_n;

output wire vcc_virt_1, vcc_virt_2;


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
inout wire ft_gpio0;

// Si535x
inout wire i2c_clk;
inout wire i2c_sda;

// Rpi
inout wire [RPI_DATA_WIDTH-1:0] rpi_d;
input wire [RPI_ADDR_WIDTH-1:0] rpi_a;
input wire rpi_oe, rpi_we;
input wire[1:0] rpi_gpio;

// Misc
output reg tx_mux, rx_mux, tx_led, rx_led;

wire rd_req, ft_rd_clk, ft_wr_clk, ft_wr_req, ft_rd_req;

wire f2a_fifo_empty, f2a_fifo_full, f2a_fifo_req, f2a_fifo_clk;
wire a2f_fifo_wr, a2f_fifo_clk, a2f_fifo_full;
wire f2a_fifo_enough, a2f_fifo_enough, a2f_fifo_empty;

wire [IQ_PAIR_WIDTH-1:0] f2a_fifo_q, afe_wdata;

wire clk, pll_locked, clk_pll, clk_pll_shifted, i2c_sda_oe, i2c_scl_oe;

//wire en = pll_locked & reset_n;
wire en = reset_n;


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
.tx_fifo_data(f2a_fifo_q),
.tx_fifo_req(f2a_fifo_req),
.tx_fifo_clk(f2a_fifo_clk)

);

wire rd_full, rd_enough;
wire f2a_fifo_wren, f2a_fifo_wrclk;
wire a2f_fifo_rden, a2f_fifo_rdclk;
wire[IQ_PAIR_WIDTH-1:0] f2a_fifo_data, a2f_fifo_data;
wire[FT_DATA_WIDTH-1:0] ft_rdata, ft_wdata;
wire[FT_DATA_WIDTH-1:0] cpucmd_fifo_data;
wire cpucmd_fifo_rd, cpucmd_fifo_clk, cpucmd_fifo_empty;


cpucmd_fifo cpucmd_fifo_inst (.Data( ), .WrClock( ), .RdClock(cpucmd_fifo_clk ), .WrEn( ), .RdEn(cpucmd_fifo_rd ), 
    .Reset(1'b0 ), .RPReset(1'b0 ), .Q(cpucmd_fifo_data ), .Empty(cpucmd_fifo_empty ), .Full( ));
    
a2f_fifo a2f_fifo_inst (.Data(afe_wdata ), .WrClock(a2f_fifo_clk ), .RdClock(a2f_fifo_rdclk ), .WrEn(a2f_fifo_wr ), .RdEn(a2f_fifo_rden ), 
    .Reset(1'b0 ), .RPReset( 1'b0), .Q(a2f_fifo_data), .AlmostFull(a2f_fifo_enough ), .Empty(a2f_fifo_empty ), .Full(a2f_fifo_full ));
	
f2a_fifo f2a_fifo_inst (.Data(f2a_fifo_data ), .WrClock(f2a_fifo_wrclk ), .RdClock( f2a_fifo_clk), .WrEn(f2a_fifo_wren ), .RdEn(f2a_fifo_req ), 
    .Reset(1'b0 ), .RPReset(1'b0 ), .Q( f2a_fifo_q), .AlmostEmpty(f2a_fifo_enough ), .Empty( f2a_fifo_empty), .Full(f2a_fifo_full ));	


sel_f2a #(.FT_DATA_WIDTH (FT_DATA_WIDTH), .IQ_PAIR_WIDTH(IQ_PAIR_WIDTH), .QSTART_BIT_INDEX(16))
sel_f2a_inst
(
    .reset_n(en),
    // FTDI interface
    // input
	.data_i(ft_rdata),
	.clk_i(ft_rd_clk),
	.we_i(ft_rd_req),
	// output
	.full_o(rd_full),
	.enough_o(rd_enough),
	
	// FIFO interface
	// input 
	.fifo_full_i(f2a_fifo_full),
	.fifo_enough_i(f2a_fifo_enough),
	// output
	.fifo_data_o(f2a_fifo_data),
	.fifo_clk_o(f2a_fifo_wrclk),
	.fifo_we_o(f2a_fifo_wren),
	
	
	// ECPU interface
	.cpu_data_o(),
	.cpu_clk_o(),
	.cpu_we_o()
);

sel_a2f #(.FT_DATA_WIDTH (FT_DATA_WIDTH), .IQ_PAIR_WIDTH(IQ_PAIR_WIDTH), .QSTART_BIT_INDEX(16))
sel_a2f_inst
(
    .reset_n(en),
		// FIFO/ECPU to FTDI
	//input from FIFO
	.fifo_data_i(a2f_fifo_data),
	.fifo_clk_o(a2f_fifo_rdclk),
	.fifo_re_o(a2f_fifo_rden),
	
	//input from ECPU
	.cpu_data_i(cpucmd_fifo_data),
    .cpu_empty_i(cpucmd_fifo_empty),
	.cpu_clk_o(cpucmd_fifo_clk),
	.cpu_re_o(cpucmd_fifo_rd),
    	
	//output to FTDI
	.data_o(ft_wdata),
	.clk_i(ft_wr_clk),
	.re_i(ft_wr_req)
);

ft600_fsm #(.FT_DATA_WIDTH (FT_DATA_WIDTH))
fsm_inst
(
    .clk(ft_clk),
    .reset_n(en),

    .rxf_n(ft_rxf_n),
    .wr_n(ft_wr_n),
    
    .wdata(ft_wdata),
    .wr_enough(a2f_fifo_enough),
    .wr_empty(a2f_fifo_empty),
    
    .rd_full(rd_full),
    .rd_enough(rd_enough),
    
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


//rpll pll_inst (.CLKI(clk26 ), .CLKOP(clk ), .CLKOS(clk_pll ), .CLKOS2( clk_pll_shifted), .LOCK(pll_locked ));


/*
ecpu ecpu_u ( 
.clk_i(clk_pll),
.reset_n(en)
, .spiMISO_MASTER(afe_spi_miso) // 
, .spiMOSI_MASTER(afe_spi_mosi) // 
, .spiSS_N_MASTER(afe_sen) // [1-1:0]
, .spiSCLK_MASTER(afe_spi_clk) // 
, .i2cm_ocSDA(i2c_sda) // 
, .i2cm_ocSCL(i2c_clk) // 
, .gpioPIO_BOTH_IN(gpioPIO_BOTH_IN) // [1-1:0]
, .gpioPIO_BOTH_OUT(gpioPIO_BOTH_OUT) // [1-1:0]
, .memory_passthruclk(memory_passthruclk) // 
, .memory_passthrurst(memory_passthrurst) // 
, .memory_passthrumem_adr(memory_passthrumem_adr) // [32-1:0]
, .memory_passthrumem_master_data(memory_passthrumem_master_data) // [32-1:0]
, .memory_passthrumem_slave_data(memory_passthrumem_slave_data) // [32-1:0]
, .memory_passthrumem_strb(memory_passthrumem_strb) // 
, .memory_passthrumem_cyc(memory_passthrumem_cyc) // 
, .memory_passthrumem_ack(memory_passthrumem_ack) // 
, .memory_passthrumem_err(memory_passthrumem_err) // 
, .memory_passthrumem_rty(memory_passthrumem_rty) // 
, .memory_passthrumem_sel(memory_passthrumem_sel) // [3:0] 
, .memory_passthrumem_we(memory_passthrumem_we) // 
, .memory_passthrumem_bte(memory_passthrumem_bte) // [1:0] 
, .memory_passthrumem_cti(memory_passthrumem_cti) // [2:0] 
, .memory_passthrumem_lock(memory_passthrumem_lock) // 
);
  */
// virtual vccio
assign vcc_virt_1 = 1;
assign vcc_virt_2 = 1;

	
assign rpi_d = {{3{rpi_a}}, rpi_we, rpi_oe};
//assign i2c_clk = afe_spi_miso & rpi_gpio[0];
//assign i2c_sda = afe_spi_miso & rpi_gpio[1];
assign ft_gpio0 = rpi_d[0];

endmodule