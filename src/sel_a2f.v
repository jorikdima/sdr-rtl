

module sel_a2f(
    reset_n,
    loopback,
		// FIFO/ECPU to FTDI
	//input from FIFO
	fifo_data_i,
	fifo_clk_o,
	fifo_re_o,
    fifo_empty_i,
    fifo_enough_i,
    fifo_data_incomming_i,
	
	//input from ECPU
	cpu_data_i,
    cpu_empty_i,
	cpu_clk_o,
	cpu_re_o,
    fifoout_wc_i,
	
	//output to FTDI
	clk_i,
	re_i,
    data_o,
    available_o
	);
	

parameter FT_DATA_WIDTH = 32;
parameter IQ_PAIR_WIDTH = 24;
parameter QSTART_BIT_INDEX = 16;	

localparam FIFO_WORDS_PER_TRANS = 1024;

parameter ST_IDLE=0, ST_DUMMY_FIFO=1,  ST_FIFO=2, ST_DUMMY_CPU=3, ST_CPU=4;

input wire reset_n, loopback;

input wire clk_i;
output wire cpu_clk_o;
output wire fifo_clk_o;

input wire re_i;
output reg fifo_re_o;
output reg cpu_re_o;

output reg[FT_DATA_WIDTH-1:0] data_o;
input wire[FT_DATA_WIDTH-1:0] cpu_data_i;
input wire[IQ_PAIR_WIDTH-1:0] fifo_data_i;


input wire fifo_empty_i, fifo_enough_i, fifo_data_incomming_i, cpu_empty_i;
output reg available_o;
input wire[7:0] fifoout_wc_i;


//----------------------------------------------------------------------    

wire[FT_DATA_WIDTH-1:0] fifo_data_32 =
        {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
           fifo_data_i[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
        {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
           fifo_data_i[IQ_PAIR_WIDTH/2 - 1:0]}; 



assign cpu_clk_o = clk_i;    
assign fifo_clk_o = clk_i;                            



// Internal  
    
reg[4:0] state;
reg[7:0] cpu_fifo_wc_done;
reg[10:0] packet_cnt;

wire have_cpu_packet = cpu_fifo_wc_done != fifoout_wc_i;


always @ (posedge clk_i or negedge reset_n)    
if (~reset_n) begin
    state <= 5'b00000;
    state[ST_IDLE] <= 1;
    
    cpu_fifo_wc_done <= 0;

    packet_cnt <= 0;
    
    available_o <= 1'b0;
    fifo_re_o <= 1'b0;
    cpu_re_o <= 1'b0;
    end        
else begin
    
    case (1'b1)   // synopsys full_case parallel_case
        state[ST_IDLE]:                 
            if (have_cpu_packet) begin
                available_o <= 1'b1;
                if (re_i) begin
                    state <= 5'b00000;
                    state[ST_DUMMY_CPU] <= 1;
                    
                    cpu_re_o <= 1'b1;
                    
                    packet_cnt <= fifoout_wc_i - cpu_fifo_wc_done - 1;
                    cpu_fifo_wc_done <= fifoout_wc_i;
                    end
                
                end
            else  if(fifo_enough_i) begin
                available_o <= 1'b1;
                if (re_i) begin
                    state <= 5'b00000;
                    state[ST_DUMMY_FIFO] <= 1;
                    
                    packet_cnt <= FIFO_WORDS_PER_TRANS - 2;
                    data_o <= FIFO_WORDS_PER_TRANS - 1;
                    end
                
                end            
        
        state[ST_DUMMY_FIFO]: begin
            fifo_re_o <= 1'b1;
            if (fifo_re_o) begin
                state <= 5'b00000;
                state[ST_FIFO] <= 1;
                end  
            end
                
        state[ST_FIFO]: begin
            packet_cnt <= packet_cnt - 11'h1;
            data_o <= fifo_data_32;
            
            if (packet_cnt == 1) 
                fifo_re_o <= 1'b0;
            if (packet_cnt == 0) 
                available_o <= 1'b0;
                 
            if (packet_cnt == 11'h7ff) begin
                state <= 5'b00000;
                state[ST_IDLE] <= 1;                
                end                 
            end      
        
        state[ST_DUMMY_CPU]: begin 
            if (packet_cnt == 0)
                cpu_re_o <= 1'b0;
                                
            state <= 5'b00000;
            state[ST_CPU] <= 1;
            end    

            
        state[ST_CPU]: begin
            data_o <= cpu_data_i;            
            packet_cnt <= packet_cnt - 11'h1;           
                
            if (packet_cnt == 0) begin
                state <= 5'b00000;
                state[ST_IDLE] <= 1;
                
                available_o <= 1'b0;
                end
            if (packet_cnt == 1)
                cpu_re_o <= 1'b0;
            end

        default : begin
            state <= 5'b00000;
            state[ST_IDLE] <= 1;
            end
    
    endcase

end


reg [23:0] prev;    
reg debug_en;

always @ (posedge clk_i or negedge reset_n)
if (~reset_n) begin
    debug_en <= 0;
    prev <= 32'h0;
    end
else begin
    if (fifo_re_o) begin
        prev <= fifo_data_i;
        if (fifo_data_i == 24'h005005 & prev != 24'h004004)
            debug_en <= 1;
    
        end
    end
    
endmodule
