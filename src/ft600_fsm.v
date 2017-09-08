

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
    wr_incomming,  // writing to FIFO right now
	
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
	rdata,
    
    error
);


parameter FT_DATA_WIDTH = 32;

input wire reset_n;
input wire clk, txe_n, rxf_n;

input wire wr_enough, rd_full, wr_empty, rd_enough, wr_incomming;
input wire[FT_DATA_WIDTH-1:0] wdata;

// output

output reg error;

output wire rd_req;
output reg oe_n, rd_n, wr_n, wr_req;

output wire wr_clk, rd_clk;

output wire [FT_DATA_WIDTH-1:0] rdata;

inout wire[FT_DATA_WIDTH-1:0] ft_data;
inout wire[3:0] ft_be;


parameter [2:0] IDLE=0, WRITE=1, READ=2;
reg[2:0] state, next_state;
reg rd_n_local, wr_local, wr_local_delayed;

assign ft_be   = oe_n ? 4'b1111 : 4'bzzzz;
reg[FT_DATA_WIDTH-1:0] wdata_out;
//assign ft_data = oe_n ? wdata_out : {FT_DATA_WIDTH{1'bz}};
assign ft_data = oe_n ? wdata : {FT_DATA_WIDTH{1'bz}};
                   
assign rd_clk = clk;
assign wr_clk = ~clk;


assign rdata =  ft_data;

reg have_unread_word_a2f, wr_empty_delayed;

wire have_wr_chance = ~txe_n & (wr_enough | (~wr_incomming & (~wr_empty | have_unread_word_a2f)));
wire have_rd_chance = ~rxf_n & rd_enough;
wire no_more_read = rxf_n | rd_full;
wire no_more_write = txe_n | (wr_empty );


always @ (posedge clk or negedge reset_n)
if (~reset_n)
    wr_empty_delayed <= 1'b0;
else begin
    wr_empty_delayed <= wr_empty;
end

always @ (posedge clk or negedge reset_n)
if (~reset_n)
    have_unread_word_a2f <= 1'b0; 
else if (txe_n & wr_local)
    have_unread_word_a2f <= 1'b1;
else if (~txe_n & ~wr_n)
    have_unread_word_a2f <= 1'b0;

//----------Output Logic-----------------------------

always @ (posedge clk or negedge reset_n)
if (~reset_n) begin
    state <= 3'b000;
    state[IDLE] <= 1;    
    error <= 1'b0;    
    end
else begin
    state <= next_state;
    if (next_state == 3'b000 | next_state == 3'b111 | next_state == 3'b110 | next_state == 3'b101 | next_state == 3'b011)
        error <= 1;
    end
    

always @ (state or have_wr_chance or have_rd_chance or no_more_write or no_more_read)
begin        
    next_state = 3'b000;
    case (1'b1) // synopsys full_case parallel_case
    state[IDLE]:        
        if (have_wr_chance) // even if we have smth to read wr has priority
            next_state[WRITE] = 1;            
        else if (have_rd_chance)            
            next_state[READ] = 1;
        else
            next_state[IDLE] = 1;
            
    state[WRITE]:        
        //either we have sent all data (which should not happen) or FT is full
        if (no_more_write) 
            next_state[IDLE] = 1;
        else 
            next_state[WRITE] = 1;

    state[READ]: 
        if (no_more_read)  //either FT has sent all data or we're full
            next_state[IDLE] = 1;
        else
            next_state[READ] = 1;        
    endcase   
end


assign rd_req = ~rd_n & ~rxf_n;

always @ (posedge clk or negedge reset_n)
if (~reset_n) begin
    wr_local <= 1'b0;
	wr_req <= 1'b0;
    end
else begin
    wr_local <= (state[WRITE] & ~txe_n & ~wr_empty) ? 1'b1 : 1'b0;
	wr_req <= state[WRITE] & ~txe_n & ~wr_empty;
    end
    
always @ (negedge clk or negedge reset_n)
if (~reset_n)
	begin
		wr_n <= 1'b1;
        
        wr_local_delayed <= 1'b0;
		rd_n <= 1'b1;
        rd_n_local <= 1'b1;
		oe_n <= 1'b1;
	end
else	
    begin
	    
    wr_n <= (~have_unread_word_a2f & (~wr_local | wr_empty)) | txe_n;
    
    oe_n <= (state[READ]) ? 1'b0 : 1'b1;
    
    rd_n_local <= (state[READ]) ? 1'b0 : 1'b1;
    rd_n <= rd_n_local | (~state[READ]);
    end	
		
                             
endmodule