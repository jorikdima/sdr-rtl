module afe_tx
(
//input
reset_n,

// TX
// input
sclk_2x, fifo_empty, fifo_data, 
// output
fifo_req, fifo_clk,
d, clk_2x, sel
);

parameter IQ_PAIR_WIDTH=24;

input wire reset_n;

// AFE TX
input wire sclk_2x;
output wire clk_2x;
output reg sel;
output wire [IQ_PAIR_WIDTH/2 - 1:0] d;
// AFE TX FIFO
input wire fifo_empty;
input wire[IQ_PAIR_WIDTH - 1:0] fifo_data;
output reg fifo_req;
output wire fifo_clk;
 
  
// TX
reg valid_pair;
wire[IQ_PAIR_WIDTH/2-1:0] output_mask = {(IQ_PAIR_WIDTH/2){valid_pair}};

assign fifo_clk = sel;
assign clk_2x = sclk_2x & reset_n;

assign d = output_mask & (sel ? fifo_data[IQ_PAIR_WIDTH/2 - 1:0] :
                                fifo_data[IQ_PAIR_WIDTH-1:IQ_PAIR_WIDTH/2] );


always @(negedge fifo_clk or negedge reset_n)
if (~reset_n)
    fifo_req <= 0;
else
    fifo_req <= ~fifo_empty;

always @(posedge fifo_clk or negedge reset_n)
if (~reset_n)
    valid_pair <= 0;
else
    valid_pair <= fifo_req & reset_n;

always @(negedge sclk_2x or negedge reset_n)
if (~reset_n)   
   sel <= 0;      
else	
    sel <= ~sel;

endmodule
