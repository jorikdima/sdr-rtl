

`timescale 1 ns/ 1 ns
module afe_vlg_tst();

reg reset_n;
/*
// AFE RX
input wire rx_clk_i;
output reg rx_clk_2x;
input wire rx_sel;
input wire [11:0] rx_d;*/

// AFE TX
reg tx_sclk_2x;
wire tx_clk_2x;
wire tx_sel;
wire [11:0] tx_d;
// AFE TX FIFO
reg tx_fifo_empty;
reg[31:0] tx_fifo_data;
wire tx_fifo_req;
wire tx_fifo_clk;



afe afe_inst
(
//input
.reset_n(reset_n), 

// RX
//rx_d, rx_clk_2x, rx_sel, rx_clk_i,

// TX
.tx_fifo_empty(tx_fifo_empty),
.tx_fifo_data(tx_fifo_data),
.tx_fifo_req(tx_fifo_req),
.tx_fifo_clk(tx_fifo_clk),
.tx_d(tx_d),
.tx_sclk_2x(tx_sclk_2x),
.tx_clk_2x(tx_clk_2x),
.tx_sel(tx_sel)
);


initial
begin
reset_n = 0;
tx_sclk_2x = 0;
tx_fifo_empty = 0;
tx_fifo_data = 0;

#50 reset_n = 1;

end

initial forever #6.25 tx_sclk_2x = ~tx_sclk_2x;


endmodule