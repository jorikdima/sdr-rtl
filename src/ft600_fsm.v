

module ft600_fsm(

//input
reset_n,

clk,
rxf_n,
txe_n,

rd_full,
rd_enough,
wr_enough, // >4kB
wr_req,
wr_empty,

wdata,

//output
rd_n,
oe_n,
wr_n,

rd_req,
rdata,

wr_clk, rd_clk,

//inout
ft_data,
ft_be

);


parameter FT_DATA_WIDTH;
parameter IQ_PAIR_WIDTH;
parameter WR_FIFO_WORDS;
parameter QSTART_BIT_INDEX = 16;


function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

input wire reset_n;
input wire clk, txe_n, rxf_n;

input wire wr_enough, rd_full, wr_empty, rd_enough;
input wire[IQ_PAIR_WIDTH-1:0] wdata;

// output

output wire oe_n, rd_n, rd_req, wr_n;
output reg wr_req;

output wire wr_clk, rd_clk;

output wire [IQ_PAIR_WIDTH-1:0] rdata;

inout wire[FT_DATA_WIDTH-1:0] ft_data;
inout wire[3:0] ft_be;


parameter IDLE=0, WRITE=1, READ=2;
reg [1:0] state;
wire[FT_DATA_WIDTH-1:0] wdata_out;
reg rd_sync;



wire have_wr_chance = ~txe_n & wr_enough;
wire have_rd_chance = ~rxf_n & rd_enough;


//----------Output Logic-----------------------------
assign oe_n = (state == WRITE) ? 1'b1 : 1'b0;
assign wr_n = (state == WRITE) ? 1'b0 : 1'b1;
assign rd_n = (state == READ) ? 1'b0 : 1'b1;
//assign wr_req = (state == WRITE) ? 1 : 0;
assign rd_req = ~rd_n;// & rd_sync;


//----------Seq Logic-----------------------------
always @(posedge clk)
    wr_req = ((state == WRITE) & ~wr_empty) ? 1'b1 : 1'b0;
   
always @(negedge clk)
    rd_sync = ~rd_n;


assign ft_be   = oe_n ? 4'b1111 : 4'bzzzz;

assign wdata_out = {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
                    wdata[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
                    {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
                    wdata[IQ_PAIR_WIDTH/2 - 1:0]};
                    
assign ft_data = oe_n ? wdata_out : {FT_DATA_WIDTH{1'bz}};

                   
assign rd_clk = clk;
assign wr_clk = ~clk;
//assign rdata = ~oe_n ? {ft_data[QSTART_BIT_INDEX + IQ_PAIR_WIDTH/2 - 1:QSTART_BIT_INDEX],
//                             ft_data[IQ_PAIR_WIDTH/2 - 1:0] } : {IQ_PAIR_WIDTH{1'bz}};

assign rdata =    {ft_data[QSTART_BIT_INDEX + IQ_PAIR_WIDTH/2 - 1:QSTART_BIT_INDEX],
                ft_data[IQ_PAIR_WIDTH/2 - 1:0] };
                             
                             
 //==========FSM Logic==========================
always @ (state or rxf_n or txe_n or wr_enough or rd_enough or rd_full or wr_empty)
begin
if (~reset_n)
    begin
        state <= IDLE;                
    end
else
    case (state) 
        IDLE:        
            if (have_wr_chance) // even if we have smth to read wr has priority
                state <= WRITE;
            else if (have_rd_chance)
                state <= READ;

        WRITE:
        //either we have sent all data (which should not happen) or FT is full
        if (txe_n | wr_empty) 
            state <= IDLE;        
        
        READ:
        if (rxf_n | rd_full)  //either FT has sent all data or we're full
            state <= IDLE;
              
    endcase   

end


endmodule