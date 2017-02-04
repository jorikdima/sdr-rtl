
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

// RPi
rpi_addr,
rpi_data,
rpi_oe,
rpi_we,
rpi_gpio,


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

usb_typec_sw,

// Si535x
i2c_clk,
i2c_sda
);


parameter FT_DATA_WIDTH=32;
parameter IQ_PAIR_WIDTH = 24;

parameter SDRAM_DQ_WIDTH = 32;


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
output wire [SDRAM_DQ_WIDTH/8-1:0]sdram_dqm;
output wire                      sdram_ras_n;
output wire                      sdram_we_n;
output wire                      sdram_clk;

// Si535x
output reg i2c_clk;
output reg i2c_sda;

// RPi
input wire[5:0] rpi_addr;
output reg[17:0]  rpi_data;
input wire rpi_oe, rpi_we;
input wire[1:0] rpi_gpio;


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

output reg usb_typec_sw;


wire rd_req, ft_rd_clk, ft_wr_clk, ft_wr_req, ft_rd_req;

wire f2a_fifo_empty, f2a_fifo_full, f2a_fifo_req, f2a_fifo_clk;
wire a2f_fifo_wr, a2f_fifo_clk, a2f_fifo_full;
wire f2a_fifo_enough, a2f_fifo_enough, a2f_fifo_empty;

wire [IQ_PAIR_WIDTH-1:0] ft_rdata, f2a_fifo_data, afe_wdata, ft_wdata;

wire clk, pll_locked, clk_pll, clk_pll_shifted, i2c_sda_oe, i2c_scl_oe;

wire mem_wr_req, mem_wr_ack, mem_next_wr_ack;
wire mem_rd_req, mem_rd_ack, mem_rd_valid, mem_next_rd_valid;
wire [23:0] mem_addr;
wire [SDRAM_DQ_WIDTH-1:0] mem_wr_data, mem_rd_data;
wire stb, we, cyc, ack, stall;

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

sdram //#(.DQ_WIDTH (SDRAM_DQ_WIDTH))
sdram_inst (
    .clk_i(clk_pll),
	.rst_i(~en),
// SDRAM interface
    .sdram_cke_o(sdram_cke),
	.sdram_data_io(sdram_dq), 
	.sdram_addr_o(sdram_addr), 
	.sdram_ba_o(sdram_ba), 
	.sdram_cs_o(sdram_cs_n),
	.sdram_ras_o(sdram_ras_n), 
	.sdram_cas_o(sdram_cas_n), 
	.sdram_we_o(sdram_we_n), 
	.sdram_dqm_o(sdram_dqm),

    .stb_i(stb),
    .we_i(we),
    .sel_i(4'b1111),
    .cyc_i(cyc),
    .addr_i(mem_addr),
    .data_i(mem_wr_data),
    .data_o(mem_rd_data),
    .stall_o(stall),
    .ack_o(ack)

/*
	// read/write address
    .addr(mem_addr),

	// write port
	.wr_req(mem_wr_req), 		// write request 
	.wr_ack(mem_wr_ack), 	// write acknowledgement 
	.next_wr_ack(mem_next_wr_ack),
	.wr_data(mem_wr_data),

	// read port
	.rd_req(mem_rd_req), 
	.rd_ack(mem_rd_ack), 
	.rd_valid(mem_rd_valid), 
	.next_rd_valid(mem_next_rd_valid),
    .rd_data(mem_rd_data)
	*/
);

/*
sdram_test sdram_test_inst(
    .clk(clk_pll),
	.reset_n(~en),
    .addr(mem_addr),
	.wr_req(mem_wr_req),
	.wr_data(mem_wr_data),
	.wr_ack(mem_wr_ack),
    .next_wr_ack(mem_next_wr_ack),
	.rd_req(mem_rd_req),
    .rd_ack(mem_rd_ack), 
	.rd_valid(mem_rd_valid), 
	.next_rd_valid(mem_next_rd_valid),
    .rd_data(mem_rd_data)	
);
*/
sdram_test_wb sdram_test_inst(
    .clk(clk_pll),
	.reset_n(~en),
    .stb_o(stb),
    .we_o(we),
    
    .cyc_o(cyc),
    .addr_o(mem_addr),
    .data_i(mem_rd_data),
    .data_o(mem_wr_data),
    .stall_i(stall),
    .ack_i(ack)	
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


// stub
reg [5:0] rpi_addr_reg;
reg[17:0]  rpi_data_reg;
reg rpi_oe_reg, rpi_we_reg;
reg[1:0] rpi_gpio_reg;
always @(posedge clk)
	begin
		if (afe_spi_miso & rpi_we & rpi_oe)
			begin
		rpi_addr_reg <= rpi_addr + rpi_addr_reg;
		rpi_data <= rpi_data + rpi_addr_reg;
		i2c_clk <= afe_spi_miso & rpi_gpio[0];
		i2c_sda <= afe_spi_miso & rpi_gpio[1];
		end
	end

endmodule