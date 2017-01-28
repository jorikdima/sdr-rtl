

module afe
(
//input
reset_n, 
// output
spi_clk, spi_sdo, spi_sdio, sen, tx_en, rx_en, reset,

// RX
rx_d, rx_sclk_2x, rx_clk_2x, rx_sel,
rx_fifo_full, rx_fifo_data, rx_fifo_wr, rx_fifo_clk,

// TX
tx_fifo_empty, tx_fifo_data, tx_fifo_req, tx_fifo_clk,
tx_d, tx_sclk_2x, tx_clk_2x, tx_sel
);

parameter IQ_PAIR_WIDTH;

input wire reset_n;

output reg spi_clk, spi_sdo, spi_sdio, sen, tx_en, rx_en, reset;

// AFE RX
input wire rx_sclk_2x;
output wire rx_clk_2x;
input wire rx_sel;
input wire [IQ_PAIR_WIDTH/2 - 1:0] rx_d;
// AFE RX FIFO
input wire rx_fifo_full;
output wire[IQ_PAIR_WIDTH - 1:0] rx_fifo_data;
output wire rx_fifo_wr;
output reg rx_fifo_clk;

// AFE TX
input wire tx_sclk_2x;
output wire tx_clk_2x;
output reg tx_sel;
output wire [IQ_PAIR_WIDTH/2 - 1:0] tx_d;
// AFE TX FIFO
input wire tx_fifo_empty;
input wire[IQ_PAIR_WIDTH - 1:0] tx_fifo_data;
output reg tx_fifo_req;
output wire tx_fifo_clk;
 
 
// RX 
reg[IQ_PAIR_WIDTH/2-1:0] rx_low_part;

assign rx_clk_2x = rx_sclk_2x & reset_n;
assign rx_fifo_wr = ~rx_fifo_full & reset_n;
assign rx_fifo_data = {rx_d, rx_low_part};

always @(negedge rx_sclk_2x or negedge reset_n)
if (~reset_n) 
    begin
    rx_low_part <= 0;
    rx_fifo_clk <= 0;
    end
else
    if (rx_sel)
        begin
        rx_fifo_clk <= 0;
        rx_low_part <= rx_d;
        end
    else
        rx_fifo_clk <= 1;
    
	 
 
// TX
reg tx_valid_pair;
wire[IQ_PAIR_WIDTH/2-1:0] tx_output_mask = {IQ_PAIR_WIDTH/2{tx_valid_pair}};

assign tx_fifo_clk = tx_sel;
assign tx_clk_2x = tx_sclk_2x & reset_n;

assign tx_d = tx_output_mask & (tx_sel ? tx_fifo_data[IQ_PAIR_WIDTH/2 - 1:0] :
                                tx_fifo_data[IQ_PAIR_WIDTH-1:IQ_PAIR_WIDTH/2] );


always @(negedge tx_fifo_clk)
    tx_fifo_req = ~tx_fifo_empty;

always @(posedge tx_fifo_clk or negedge reset_n)
   if (~reset_n)
	    tx_valid_pair <= 0;
	else
	    tx_valid_pair <= tx_fifo_req & reset_n;

always @(negedge tx_sclk_2x or negedge reset_n)
if (~reset_n)   
   tx_sel <= 0;      
else	
    tx_sel = ~tx_sel;



endmodule