

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

reg rx_sclk_1x;
wire rx_fifo_wr_afe, rx_fifo_clk_afe, tx_fifo_clk_afe;

wire txrx_reset_n = reset_n & ~loopback;

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


wire fifos_ok = ~tx_fifo_empty & ~rx_fifo_full;
wire lpbck_rx_wr = fifo_ok_delayed | (rxfifo_full_delayed & fifos_ok);
reg fifo_ok_delayed, rxfifo_full_delayed;

assign rx_fifo_data = loopback ? tx_fifo_data : rx_fifo_data_afe;
assign rx_fifo_clk = loopback ? rx_sclk_1x : rx_fifo_clk_afe;
assign rx_fifo_wr = loopback ? lpbck_rx_wr : rx_fifo_wr_afe;
assign tx_fifo_clk = loopback ? rx_sclk_1x : tx_fifo_clk_afe;
assign tx_fifo_req = loopback ? fifos_ok : tx_fifo_req_afe;

always @(posedge rx_sclk_1x or negedge reset_n)
if (~reset_n) begin
    fifo_ok_delayed <= 1'b0;
    rxfifo_full_delayed <= 1'b0;
    end
else begin
    fifo_ok_delayed <= fifos_ok;
    rxfifo_full_delayed <= rx_fifo_full;
    end

always @(posedge rx_sclk_2x or negedge reset_n)
if (~reset_n)
    rx_sclk_1x <= 1'b0;
else    
    rx_sclk_1x <= ~rx_sclk_1x;
    
    
    
reg [23:0] prev;    
reg debug_en;

always @ (posedge tx_fifo_clk or negedge reset_n)
if (~reset_n) begin
    debug_en <= 0;
    prev <= 32'h0;
    end
else begin
    debug_en <= (rx_fifo_wr & rx_fifo_data <= 24'h00a00a & rx_fifo_data >= 24'h0);
        
    end
    

endmodule
