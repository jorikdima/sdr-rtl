
module top(
//clk26, clk_sr1, clk_sr2, 

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

wire loopback = 1'b0;
parameter IQ_PAIR_WIDTH = 24;

parameter RPI_DATA_WIDTH=18;
parameter RPI_ADDR_WIDTH=6;

//parameter FT_PACKET_WORDS = 32;

//parameter A2F_FIFO_WORDS = 128;
//parameter F2A_FIFO_WORDS = 128;

//parameter A2F_FIFO_FULL_ENOUGH = FT_PACKET_WORDS;
//parameter F2A_FIFO_FREE_ENOUGH = F2A_FIFO_WORDS - FT_PACKET_WORDS;


//input wire	clk26, clk_sr1, clk_sr2;
wire clk_sr1, clk_sr2;

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



//------------------------------------------------------------

reg[7:0] rst_cnt = 8'h00;

wire error, reset_n, osc, debug_clk;
wire en = reset_n;


sdr sdr_inst(
.clk_sr1(clk_sr1),
.clk_sr2(clk_sr2),
.cpuclk(clk),

.en(en),
.error(error),

// AFE
.afe_tx_d(afe_tx_d),
.afe_tx_clk(afe_tx_clk),
.afe_tx_sel(afe_tx_sel),
.afe_rx_d(afe_rx_d), 
.afe_rx_clk(afe_rx_clk),
.afe_rx_sel(afe_rx_sel),
.afe_spi_clk(afe_spi_clk),
.afe_spi_mosi(afe_spi_mosi),
.afe_spi_miso(afe_spi_miso),
.afe_sen(afe_sen),
.afe_tx_en(afe_tx_en),
.afe_rx_en(afe_rx_en),
.afe_reset(afe_reset),

//FT
.ft_txe_n(ft_txe_n),
.ft_clk(ft_clk),
.ft_rxf_n(ft_rxf_n),
.ft_oe_n(ft_oe_n),
.ft_wr_n(ft_wr_n),
.ft_rd_n(ft_rd_n),

.ft_data(ft_data),
.ft_be(ft_be),
.ft_gpio0(ft_gpio0),

// Si535x
.i2c_clk(i2c_clk),
.i2c_sda(i2c_sda),

// Rpi
.rpi_d(rpi_d),
.rpi_a(),
.rpi_we(rpi_a),
.rpi_oe(rpi_oe),
.rpi_gpio(rpi_gpio),

// Misc
.tx_mux(tx_mux),
.rx_mux(rx_mux),
.tx_led(tx_led),
.rx_led(rx_led)
);



GSR GSR_INST (.GSR (reset_n));
PUR PUR_INST (.PUR (reset_n));
  
// virtual vccio
assign vcc_virt_1 = 1'b1;
assign vcc_virt_2 = 1'b1;


pll pll_inst (.CLKI(ft_clk ), .CLKOP( clk), .CLKOS2( debug_clk), .LOCK( pll_locked));

OSCG #(.DIV (8)) osc_i (.OSC(osc));

assign clk_sr1 = osc;
assign clk_sr2 = osc;


assign rpi_d[6] = error;

assign reset_n = rst_cnt[6];

always @(posedge osc)
if (rst_cnt< 8'hff & pll_locked)
    rst_cnt <= rst_cnt + 8'h1;

endmodule