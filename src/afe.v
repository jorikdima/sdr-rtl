

module afe
(
//input
reset_n, loopback,
// output
tx_en, rx_en, afe_reset,

// RX
// input
rx_sclk_2x, rx_fifo_full, rx_sel, rx_d,
// output
rx_clk_2x, rx_fifo_data, rx_fifo_wr, rx_fifo_clk,

// TX
// input
tx_sclk_2x, tx_fifo_empty, tx_fifo_data, 
// output
tx_fifo_req, tx_fifo_clk,
tx_d, tx_clk_2x, tx_sel
);

parameter IQ_PAIR_WIDTH=24;

input wire reset_n, loopback;

output wire tx_en, rx_en, afe_reset;

// AFE RX
input wire rx_sclk_2x;
output wire rx_clk_2x;
input wire rx_sel;
input wire[IQ_PAIR_WIDTH/2 - 1:0] rx_d;
// AFE RX FIFO
input wire rx_fifo_full;
output wire[IQ_PAIR_WIDTH - 1:0] rx_fifo_data;
output wire rx_fifo_wr;
output wire rx_fifo_clk;

// AFE TX
input wire tx_sclk_2x;
output wire tx_clk_2x;
output wire tx_sel;
output wire[IQ_PAIR_WIDTH/2 - 1:0] tx_d;
// AFE TX FIFO
input wire tx_fifo_empty;
input wire[IQ_PAIR_WIDTH - 1:0] tx_fifo_data;
output wire tx_fifo_req;
output wire tx_fifo_clk;
 
 
 
// local 

wire[IQ_PAIR_WIDTH-1:0] rx_fifo_data_afe;
reg[IQ_PAIR_WIDTH-1:0] lpbck_d;
reg rx_sclk_1x;
wire rx_fifo_wr_afe, rx_fifo_clk_afe, tx_fifo_clk_afe;
reg lpbck_tx_req, lpbck_rx_wr;

assign txrx_reset_n = reset_n & ~loopback;

assign tx_en = ~loopback;
assign rx_en = ~loopback;

afe_rx afe_rx_inst
(
    //input
    .reset_n(txrx_reset_n), 

    // RX
    // input
    .sclk_2x(rx_sclk_2x),
    .fifo_full(rx_fifo_full),
    .sel(rx_sel),
    .d(rx_d),
    // output
    .clk_2x(rx_clk_2x),
    .fifo_data(rx_fifo_data_afe),
    .fifo_wr(rx_fifo_wr_afe),
    .fifo_clk(rx_fifo_clk_afe)
);


afe_tx afe_tx_inst
(
    //input
    .reset_n(txrx_reset_n),

    // TX
    // input
    .sclk_2x(tx_sclk_2x),
    .fifo_empty(tx_fifo_empty),
    .fifo_data(tx_fifo_data),
    // output
    .fifo_req(tx_fifo_req_afe),
    .fifo_clk(tx_fifo_clk_afe),
    .d(tx_d),
    .clk_2x(tx_clk_2x),
    .sel(tx_sel)
);

assign rx_fifo_data = loopback ? lpbck_d : rx_fifo_data_afe;
assign rx_fifo_clk = loopback ? rx_sclk_1x : rx_fifo_clk_afe;
assign rx_fifo_wr = loopback ? lpbck_rx_wr : rx_fifo_wr_afe;
assign tx_fifo_clk = loopback ? rx_sclk_1x : tx_fifo_clk_afe;
assign tx_fifo_req = loopback ? lpbck_tx_req : tx_fifo_req_afe;

always @(negedge rx_sclk_1x or negedge reset_n)
if (~reset_n)
    begin
    lpbck_tx_req <= 1'b0;
    lpbck_rx_wr <= 1'b0;
    lpbck_d <= {IQ_PAIR_WIDTH{1'b0}};
    end
else
    begin
    lpbck_tx_req <= ~tx_fifo_empty & ~rx_fifo_full;
    lpbck_rx_wr <= lpbck_tx_req;
    if (lpbck_tx_req)
        lpbck_d <= tx_fifo_data;
    end

always @(posedge rx_sclk_2x or negedge reset_n)
if (~reset_n)
    rx_sclk_1x <= 1'b0;
else    
    rx_sclk_1x <= ~rx_sclk_1x;

endmodule
