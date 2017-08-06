

module ft600_fsm(

//input
reset_n,

// FT600 interface
	// input
	clk,
	rxf_n,
	txe_n,

	// output
	rd_n,
	oe_n,
	wr_n,

	//inout
	ft_data,
	ft_be,


// A2F interface
	// input
	wdata,
	wr_enough, // >4kB
	wr_empty,
	
	// output
	wr_req,
	wr_clk,

// F2A interface
	// input
	rd_full,
	rd_enough,

	// output
	rd_req,
	rd_clk,
	rdata
);


parameter FT_DATA_WIDTH = 32;

input wire reset_n;
input wire clk, txe_n, rxf_n;

input wire wr_enough, rd_full, wr_empty, rd_enough;
input wire[FT_DATA_WIDTH-1:0] wdata;

// output

output wire rd_req, wr_req;
output reg oe_n, rd_n, wr_n;

output wire wr_clk, rd_clk;

output wire [FT_DATA_WIDTH-1:0] rdata;

inout wire[FT_DATA_WIDTH-1:0] ft_data;
inout wire[3:0] ft_be;


parameter IDLE=0, WRITE=1, READ=2;
reg [1:0] state, next_state;
reg rd_n_local;
wire[FT_DATA_WIDTH-1:0] wdata_out;


assign ft_be   = oe_n ? 4'b1111 : 4'bzzzz;
assign wdata_out = wdata;                    
assign ft_data = oe_n ? wdata_out : {FT_DATA_WIDTH{1'bz}};

                   
assign rd_clk = clk;
assign wr_clk = clk;


assign rdata =  ft_data;

wire have_wr_chance = ~txe_n & wr_enough;
wire have_rd_chance = ~rxf_n & rd_enough;
wire no_more_read = rxf_n | rd_full;
wire no_more_write = txe_n | wr_empty;


initial 
begin
    state <= IDLE; 
    next_state <= IDLE;
    
    wr_n <= 1'b1;
    rd_n <= 1'b1;
    rd_n_local <= 1'b1;
    oe_n <= 1'b1;  
end

//----------Seq Logic-----------------------------
    
//----------Output Logic-----------------------------

assign rd_req = ~rd_n & ~rxf_n;
assign wr_req = ~wr_n & ~txe_n;
		  
always @ (posedge clk or negedge reset_n)
if (~reset_n)
    begin
    state <= IDLE; 
    //next_state <= IDLE;    
    end
else
    begin
    state <= next_state;    
    end
		
always @ (negedge clk or negedge reset_n)
if (~reset_n)
	begin
		wr_n <= 1'b1;
		rd_n <= 1'b1;
        rd_n_local <= 1'b1;
		oe_n <= 1'b1;        
	end
else	
    begin
	wr_n <= (state == WRITE & ~txe_n & ~wr_empty) ? 1'b0 : 1'b1;
    rd_n_local <= (state == READ) ? 1'b0 : 1'b1;
    oe_n <= (state == READ) ? 1'b0 : 1'b1;	
    rd_n <= rd_n_local | (state != READ);	
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
            else
                next_state <= IDLE;

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