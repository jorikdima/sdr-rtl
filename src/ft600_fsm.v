

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


parameter FT_DATA_WIDTH = 32;
parameter IQ_PAIR_WIDTH = 24;
parameter QSTART_BIT_INDEX = 16;


input wire reset_n;
input wire clk, txe_n, rxf_n;

input wire wr_enough, rd_full, wr_empty, rd_enough;
input wire[IQ_PAIR_WIDTH-1:0] wdata;

// output

output wire rd_req;
output reg oe_n, wr_req, rd_n, wr_n;

output wire wr_clk, rd_clk;

output wire [IQ_PAIR_WIDTH-1:0] rdata;

inout wire[FT_DATA_WIDTH-1:0] ft_data;
inout wire[3:0] ft_be;


parameter IDLE=0, WRITE=1, READ=2;
reg [1:0] state, next_state;
wire[FT_DATA_WIDTH-1:0] wdata_out;


assign ft_be   = oe_n ? 4'b1111 : 4'bzzzz;
assign wdata_out = {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
                    wdata[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
                    {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
                    wdata[IQ_PAIR_WIDTH/2 - 1:0]};                    
assign ft_data = oe_n ? wdata_out : {FT_DATA_WIDTH{1'bz}};

                   
assign rd_clk = clk;
assign wr_clk = ~clk;


assign rdata =  {ft_data[QSTART_BIT_INDEX + IQ_PAIR_WIDTH/2 - 1:QSTART_BIT_INDEX],
                ft_data[IQ_PAIR_WIDTH/2 - 1:0] };



wire have_wr_chance = ~txe_n & wr_enough;
wire have_rd_chance = ~rxf_n & rd_enough;
wire no_more_read = rxf_n | rd_full;
wire no_more_write = txe_n | wr_empty;



//----------Seq Logic-----------------------------
    
//----------Output Logic-----------------------------
//assign oe_n = (state == WRITE) ? 1'b1 : 1'b0;
//assign wr_n = (state == WRITE) ? 1'b0 : 1'b1;
//assign rd_n = (state == READ) ? 1'b0 : 1'b1;
assign rd_req = ~rd_n & ~rxf_n;
		  


always @ (posedge clk or negedge reset_n)
    if (~reset_n)
		begin
        state <= IDLE;
		//wr_req = 1'b0;
		end
    else
		begin
        state <= next_state;
		
		wr_req <= ((state == WRITE) & ~wr_empty & ~txe_n) ? 1'b1 : 1'b0;
		
		end
		
always @ (negedge clk or negedge reset_n)
if (~reset_n)
	begin
		wr_n <= 1'b1;
		rd_n <= 1'b1;  
		oe_n <= 1'b1;
	end
else	
    begin
	wr_n <= (state == WRITE & wr_req & ~txe_n) ? 1'b0 : 1'b1;
    rd_n <= (state == READ) ? 1'b0 : 1'b1;
	oe_n <= (state == WRITE) ? 1'b1 : 1'b0;
	//wr_req = ((state == WRITE) & ~wr_empty & ~txe_n) ? 1'b1 : 1'b0;
    end	
		
                             
 //==========FSM Logic==========================
always @ (state or have_wr_chance or have_rd_chance or no_more_write or no_more_read)
begin
    case (state) 
        IDLE:        
            if (have_wr_chance) // even if we have smth to read wr has priority
                next_state <= WRITE;
            else if (have_rd_chance)
                next_state <= READ;

        WRITE:
        //either we have sent all data (which should not happen) or FT is full
        if (no_more_write) 
            next_state <= IDLE;        
        
        READ:
        if (no_more_read)  //either FT has sent all data or we're full
            next_state <= IDLE;
              
    endcase 
end


endmodule