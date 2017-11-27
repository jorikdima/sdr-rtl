
module sdr(
clk26, clk_sr1, clk_sr2, cpuclk,

en, error,

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
tx_led, rx_led,

debug
);


parameter FT_DATA_WIDTH=32;

wire loopback = 1'b1;
parameter IQ_PAIR_WIDTH = 24;

parameter RPI_DATA_WIDTH=18;
parameter RPI_ADDR_WIDTH=6;

//parameter FT_PACKET_WORDS = 32;

//parameter A2F_FIFO_WORDS = 128;
//parameter F2A_FIFO_WORDS = 128;

//parameter A2F_FIFO_FULL_ENOUGH = FT_PACKET_WORDS;
//parameter F2A_FIFO_FREE_ENOUGH = F2A_FIFO_WORDS - FT_PACKET_WORDS;


input wire	clk26, clk_sr1, clk_sr2, en, cpuclk;
output wire error;

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
input wire ft_gpio0;

// Si535x
inout wire i2c_clk;
inout wire i2c_sda;

// Rpi
inout wire [RPI_DATA_WIDTH-1:0] rpi_d;
input wire [RPI_ADDR_WIDTH-1:0] rpi_a;
input wire rpi_oe, rpi_we;
input wire[1:0] rpi_gpio;

// Misc
output wire tx_mux, rx_mux, tx_led, rx_led;

output wire[31:0] debug;

wire rd_req, ft_rd_clk, ft_wr_clk, ft_wr_req, ft_rd_req;

wire f2a_fifo_empty, f2a_fifo_full, f2a_fifo_req, f2a_fifo_clk;
wire a2f_fifo_wr, a2f_fifo_clk, a2f_fifo_full;
wire f2a_fifo_enough, a2f_fifo_enough, a2f_fifo_empty;

wire [IQ_PAIR_WIDTH-1:0] f2a_fifo_q, afe_wdata;

wire clk, pll_locked, clk_pll, i2c_sda_oe, i2c_scl_oe;




afe #(.IQ_PAIR_WIDTH (IQ_PAIR_WIDTH))
afe_inst(
.reset_n(en), 
.loopback(loopback),
// AFE RX input
.rx_sclk_2x(clk_sr2),
.rx_d(afe_rx_d),
.rx_sel(afe_rx_sel),
.rx_fifo_full(a2f_fifo_full),
// AFE RX output
.rx_clk_2x(afe_rx_clk),
.rx_fifo_data(afe_wdata),
.rx_fifo_wr(a2f_fifo_wr),
.rx_fifo_clk(a2f_fifo_clk),

// AFE TX input
.tx_sclk_2x(clk_sr1),
.tx_fifo_empty(f2a_fifo_empty),
.tx_fifo_data(f2a_fifo_q),

// AFE TX output
.tx_clk_2x(afe_tx_clk),
.tx_sel(afe_tx_sel),
.tx_d(afe_tx_d),
.tx_fifo_req(f2a_fifo_req),
.tx_fifo_clk(f2a_fifo_clk)
);

wire rd_full, rd_enough;
wire f2a_fifo_wren, f2a_fifo_wrclk;
wire a2f_fifo_rden, a2f_fifo_rdclk;
wire[IQ_PAIR_WIDTH-1:0] f2a_fifo_data, a2f_fifo_data;
wire[FT_DATA_WIDTH-1:0] ft_rdata, ft_wdata;


wire a2f_available;

wire [FT_DATA_WIDTH-1:0] cpuout_fifo_data;
wire [FT_DATA_WIDTH-1:0] cpuin_fifo_data;
wire cpuout_fifo_rdclk, cpuout_fifo_rd;
wire cpuin_fifo_wr, cpuin_fifo_wrclk;

wire[7:0] cpuout_wc, fifoout_wcadd;
wire fifoout_wcen;

    
a2f_fifo a2f_fifo_inst (.Data(afe_wdata ), .WrClock(a2f_fifo_clk ), .RdClock(a2f_fifo_rdclk ), .WrEn(a2f_fifo_wr ), .RdEn(a2f_fifo_rden ), 
    .Reset(~en ), .RPReset(1'b0), .Q(a2f_fifo_data), .AlmostFull(a2f_fifo_enough ), .Empty(a2f_fifo_empty ), .Full(a2f_fifo_full ));
	
f2a_fifo f2a_fifo_inst (.Data(f2a_fifo_data ), .WrClock(f2a_fifo_wrclk ), .RdClock( f2a_fifo_clk), .WrEn(f2a_fifo_wren ), .RdEn(f2a_fifo_req ), 
    .Reset(~en ), .RPReset(1'b0 ), .Q( f2a_fifo_q), .AlmostEmpty(f2a_fifo_enough ), .Empty( f2a_fifo_empty), .Full(f2a_fifo_full ));	


sel_f2a #(.FT_DATA_WIDTH (FT_DATA_WIDTH), .IQ_PAIR_WIDTH(IQ_PAIR_WIDTH), .QSTART_BIT_INDEX(16))
sel_f2a_inst
(
    .reset_n(en),
    .loopback(1'b0),
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
	.cpu_data_o(cpuin_fifo_data),
	.cpu_clk_o(cpuin_fifo_wrclk),
	.cpu_we_o(cpuin_fifo_wr)
);

sel_a2f #(.FT_DATA_WIDTH (FT_DATA_WIDTH), .IQ_PAIR_WIDTH(IQ_PAIR_WIDTH), .QSTART_BIT_INDEX(16))
sel_a2f_inst
(
    .reset_n(en),
    .loopback(1'b0),
		// FIFO/ECPU to FTDI
	//input from FIFO
	.fifo_data_i(a2f_fifo_data),
	.fifo_clk_o(a2f_fifo_rdclk),
	.fifo_re_o(a2f_fifo_rden),
    .fifo_empty_i(a2f_fifo_empty),
    .fifo_enough_i(a2f_fifo_enough),
    .fifo_data_incomming_i(a2f_fifo_wr),
	
	//input from ECPU
	.cpu_data_i(cpuout_fifo_data),
    .cpu_empty_i(cpuout_fifo_empty),
	.cpu_clk_o(cpuout_fifo_rdclk),
	.cpu_re_o(cpuout_fifo_rd),
    .fifoout_wc_i(cpuout_wc),
    	
	//output to FTDI
	.data_o(ft_wdata),
	.clk_i(ft_wr_clk),
	.re_i(ft_wr_req),
    
    .available_o(a2f_available)
);

ft600_fsm #(.FT_DATA_WIDTH (FT_DATA_WIDTH))
fsm_inst
(
    .clk(ft_clk),
    .reset_n(en),

    .rxf_n(ft_rxf_n),
    .wr_n(ft_wr_n),
    
    .wdata(ft_wdata),
    .wr_available(a2f_available),
    
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
    .ft_be(ft_be),
    
    .error(error)
);

wire[7:0] gpioPIO_OUT;

wire            wb_clk_i;
wire            wb_rst_i;
wire [31:0]	    wb_adr_i;  
wire [31:0]	    wb_dat_i;
wire		    wb_we_i;   
wire		    wb_cyc_i;   
wire		    wb_stb_i;   
wire [3:0]	    wb_sel_i;   
wire [2:0]	    wb_cti_i;
wire [1:0]	    wb_bte_i;
wire		    wb_lock_i;
wire [31:0]     wb_dat_o;   
wire		    wb_ack_o;   
wire		    wb_err_o;   
wire		    wb_rty_o; 


ecpu ecpu_u ( 
.clk_i(cpuclk),
.reset_n(en)
, .spiMISO_MASTER(afe_spi_miso) // 
, .spiMOSI_MASTER(afe_spi_mosi) // 
, .spiSS_N_MASTER(afe_sen) // [1-1:0]
, .spiSCLK_MASTER(afe_spi_clk) // 
, .i2cm_ocSDA(i2c_sda) // 
, .i2cm_ocSCL(i2c_clk) // 
, .gpioPIO_OUT(gpioPIO_OUT) // [1-1:0]
, .fifoclk(wb_clk_i) // 
, .fiforst(wb_rst_i) // 
, .fifomem_adr(wb_adr_i) // [32-1:0]
, .fifomem_master_data(wb_dat_o) // [32-1:0]
, .fifomem_slave_data(wb_dat_i) // [32-1:0]
, .fifomem_strb(wb_stb_i) // 
, .fifomem_cyc(wb_cyc_i) // 
, .fifomem_ack(wb_ack_o) // 
, .fifomem_err(wb_err_o) // 
, .fifomem_rty(wb_rty_o) // 
, .fifomem_sel(wb_sel_i) // [3:0] 
, .fifomem_we(wb_we_i) // 
, .fifomem_bte(wb_bte_i) // [1:0] 
, .fifomem_cti(wb_cti_i) // [2:0] 
, .fifomem_lock(wb_lock_i) // 
);


cpu2sdr cpu2sdr_inst 
(
    .reset_n(en ), 
    // Commands from Host    
    .InData(cpuin_fifo_data), 
    .InClk(cpuin_fifo_wrclk), 
    .InWr(cpuin_fifo_wr), 
    
// Replies from CPU    
    .OutData(cpuout_fifo_data),
    .OutClk(cpuout_fifo_rdclk),
    .OutRd(cpuout_fifo_rd), 
    .OutWc(cpuout_wc),
    
 // Wishbone interface
    .wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wb_adr_i  (wb_adr_i),
    .wb_dat_i  (wb_dat_o),
    .wb_we_i   (wb_we_i),
    .wb_cyc_i  (wb_cyc_i),
    .wb_stb_i  (wb_stb_i),
    .wb_sel_i  (wb_sel_i),
    .wb_cti_i  (wb_cti_i),
    .wb_bte_i  (wb_bte_i),
    .wb_lock_i (wb_lock_i),
    .wb_dat_o  (wb_dat_i),
    .wb_ack_o  (wb_ack_o),
    .wb_err_o  (wb_err_o),
    .wb_rty_o (wb_rty_o) 	
    );
   

  

assign tx_led = gpioPIO_OUT[0];



endmodule