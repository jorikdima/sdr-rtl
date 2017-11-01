

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
    fifoout_blkcnt_i,
	
	//output to FTDI
	clk_i,
	re_i,
    data_o,
    available_o,
    debug    
	);
	
	
	parameter FT_DATA_WIDTH = 32;
	parameter IQ_PAIR_WIDTH = 24;
	parameter QSTART_BIT_INDEX = 16;	
    
    localparam FIFO_WORDS_PER_TRANS = 1024;
    
    parameter ST_IDLE=0, ST_HEADGEN_DUMMY=1, ST_HEADGEN_FIFO=2,  ST_FIFO=3, ST_HEADGEN_CPU=4, ST_CPU=5;
    
    input wire reset_n, loopback;
    
    input wire clk_i;
    output wire cpu_clk_o;
    output wire fifo_clk_o;
    
    input wire re_i;
    output wire fifo_re_o;
    output wire cpu_re_o;
    
    output reg[FT_DATA_WIDTH-1:0] data_o;
    input wire[FT_DATA_WIDTH-1:0] cpu_data_i;
    input wire[IQ_PAIR_WIDTH-1:0] fifo_data_i;
	
    
    input wire fifo_empty_i, fifo_enough_i, fifo_data_incomming_i, cpu_empty_i;
    output reg available_o;
    input wire[3:0] fifoout_blkcnt_i;
    
    
//----------------------------------------------------------------------    
    
    wire[FT_DATA_WIDTH-1:0] fifo_data_32 =
            {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
            {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH/2 - 1:0]}; 
    
    
    
    assign cpu_clk_o = clk_i;    
    assign fifo_clk_o = clk_i;                            
    
    
    
     
    assign fifo_re_o = re_i &  (state[ST_HEADGEN_FIFO] | state[ST_FIFO]);
    assign cpu_re_o = re_i & (state[ST_CPU] | state[ST_HEADGEN_CPU]);
    
    
    // Internal  
    
    reg[FT_DATA_WIDTH-1:0] data_reg;
    
    reg[5:0] state;
    reg[3:0] cpu_fifo_blks_done, fifoout_blkcnt;
    reg[15:0] packet_cnt;
    
    wire have_cpu_packet = cpu_fifo_blks_done != fifoout_blkcnt;
    wire[7:0]  cpu_fifo_words = cpu_data_i[27:20];
    
    
    task set_state;
    input bitnum;
    begin
        state = 6'b000000;
        state[bitnum] = 1;
    end
    endtask
    
    
    output reg [32:0] debug;
    
    
    always @ (posedge clk_i or negedge reset_n)    
    if (~reset_n) begin
        set_state(ST_IDLE);
        cpu_fifo_blks_done <= 4'h0;
        packet_cnt <= 16'h0;
        
        data_o <= {FT_DATA_WIDTH{1'b0}}; 
        available_o <= 1'b0;
        
        debug <= 0;
        end        
    else begin

        
        fifoout_blkcnt <= fifoout_blkcnt_i;
        
        case (1'b1)   // synopsys full_case parallel_case
            state[ST_IDLE]:             
                 if (have_cpu_packet) begin
                    
                    state <= 6'b000000;
                    state[ST_HEADGEN_CPU] <= 1;
                    
                    cpu_fifo_blks_done <= cpu_fifo_blks_done + 4'h1;
                    available_o <= 1'b1;
                    end
                else  if(fifo_enough_i) begin
                    
                    state <= 6'b000000;
                    state[ST_HEADGEN_DUMMY] <= 1;
                    
                    data_o <= FIFO_WORDS_PER_TRANS - 1;
                    
                    available_o <= 1'b1;
                    end            
            
            state[ST_HEADGEN_DUMMY]: 
                if (re_i) begin
                    state <= 6'b000000;
                    state[ST_HEADGEN_FIFO] <= 1;                    
                    end
                    
            state[ST_HEADGEN_FIFO]:
                if (re_i) begin
                    state <= 6'b000000;
                    state[ST_FIFO] <= 1;
                    
                    packet_cnt <= FIFO_WORDS_PER_TRANS - 3;                 
                 end
            
            state[ST_FIFO]: begin
                    data_o <= fifo_data_32;
                    
                    if (packet_cnt == 0) begin
                        state <= 6'b000000;
                        state[ST_IDLE] <= 1;
                        
                        available_o <= 1'b0;
                        end
                    else begin
                        packet_cnt <= packet_cnt - 16'h1;                        
                        end
                end
                
            state[ST_HEADGEN_CPU]:
                if (re_i) begin
                    data_o <= cpu_data_i;
                    if (cpu_fifo_words == 0) begin // have only one word 
                        state <= 6'b000000;
                        state[ST_IDLE] <= 1;
                        
                        available_o <= 1'b0;
                    end
                    else begin
                        state <= 6'b000000;
                        state[ST_CPU] <= 1;
                        packet_cnt <= cpu_fifo_words - 1;
                    end
            
                end
                
            state[ST_CPU]: begin
                    data_o <= cpu_data_i;
                    
                    if (packet_cnt == 0) begin
                        state <= 6'b000000;
                        state[ST_IDLE] <= 1;
                        
                        available_o <= 1'b0;
                        end
                    else begin
                        packet_cnt <= packet_cnt - 16'h1;
                        end
            
                end
        
        endcase
    
    end
    
endmodule
