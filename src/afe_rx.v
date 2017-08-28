module afe_rx
(
//input
reset_n, 

// RX
// input
sclk_2x, fifo_full, sel, d,
// output
clk_2x, fifo_data, fifo_wr, fifo_clk
);

parameter IQ_PAIR_WIDTH=24;

input wire reset_n;

// AFE RX
input wire sclk_2x;
output wire clk_2x;
input wire sel;
input wire [IQ_PAIR_WIDTH/2 - 1:0] d;
// AFE RX FIFO
input wire fifo_full;
output wire[IQ_PAIR_WIDTH - 1:0] fifo_data;
output wire fifo_wr;
output reg fifo_clk;

 
// RX 
reg[IQ_PAIR_WIDTH/2-1:0] low_part;

assign clk_2x = sclk_2x & reset_n;
assign fifo_wr = ~fifo_full & reset_n;
assign fifo_data = {d, low_part};

always @(negedge sclk_2x or negedge reset_n)
if (~reset_n) 
    begin
    low_part <= {IQ_PAIR_WIDTH/2{1'b0}};
    fifo_clk <= 0;
    end
else
    if (sel)
        begin
        fifo_clk <= 0;
        low_part <= d;
        end
    else
        fifo_clk <= 1;
    
endmodule
