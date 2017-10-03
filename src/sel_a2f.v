

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
    enough_o,
    empty_o,
    data_incomming_o
	);
	
	
	parameter FT_DATA_WIDTH = 32;
	parameter IQ_PAIR_WIDTH = 24;
	parameter QSTART_BIT_INDEX = 16;	
    
    parameter ST_IDLE=1, ST_HEADGEN_FIFO=2, ST_HEADGEN_CPU=3, ST_FIFO=4, ST_CPU=5;
    
    input wire reset_n, loopback;
    
    input wire clk_i;
    output wire cpu_clk_o;
    output wire fifo_clk_o;
    
    input wire re_i;
    output wire fifo_re_o, cpu_re_o;
    
    output wire[FT_DATA_WIDTH-1:0] data_o;
    input wire[FT_DATA_WIDTH-1:0] cpu_data_i;
    input wire[IQ_PAIR_WIDTH-1:0] fifo_data_i;
	
    
    input wire fifo_empty_i, fifo_enough_i, fifo_data_incomming_i, cpu_empty_i;
    output wire enough_o, empty_o, data_incomming_o;
    input wire[3:0] fifoout_blkcnt_i;
    
    
//----------------------------------------------------------------------    
    
    wire[FT_DATA_WIDTH-1:0] fifo_data_32 =
            {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
            {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH/2 - 1:0]}; 
    
    
    
    assign cpu_clk_o = clk_i;    
    assign fifo_clk_o = clk_i;                            
    
    
    
    assign data_o = state[ST_FIFO] ? fifo_data_32 : state[ST_HEADGEN_FIFO] ? header : cpu_data_i;
    
    
    assign fifo_re_o = re_i & (state[ST_FIFO] | state[ST_HEADGEN_FIFO]);
    assign cpu_re_o = re_i & (state[ST_CPU] | state[ST_HEADGEN_CPU]);
    
    assign enough_o = fifo_enough_i;
    assign empty_o = fifo_empty_i;
    assign data_incomming_o = fifo_data_incomming_i;
    
    // Internal  
    
    reg[FT_DATA_WIDTH-1:0] data_reg;
    
    reg[4:0] state;
    reg[3:0] cpu_fifo_blks_done;
    reg[FT_DATA_WIDTH-1:0] header;
    reg[15:0] packet_cnt;
    
    
    always @ (posedge clk_i or negedge reset_n)    
    if (~reset_n) begin
        state <= 5'b00000;
        state[ST_IDLE] <= 1;
        cpu_fifo_blks_done <= 4'h0;
        header <= {FT_DATA_WIDTH{1'b0}};
        packet_cnt <= 16'h0;
        end        
    else begin
        case (1'b1) // synopsys full_case parallel_case
            state[ST_IDLE]: 
                if (cpu_fifo_blks_done != fifoout_blkcnt_i) begin
                    state <= 5'b00000;
                    state[ST_HEADGEN_CPU] <= 1;
                    cpu_fifo_blks_done <= cpu_fifo_blks_done + 4'h1;
                    end
                else if(fifo_enough_i) begin
                    state <= 5'b00000;
                    state[ST_HEADGEN_FIFO] <= 1;
                    header[FT_DATA_WIDTH-1:0] <= 32'd4095;
                    end
            
            state[ST_HEADGEN_FIFO]:
                if (re_i) begin
                    state <= 5'b00000;
                    state[ST_FIFO] <= 1;
                    end
            
            state[ST_FIFO]:
                if (re_i) begin
                    if (packet_cnt == 32'd4095) begin
                        state <= 5'b00000;
                        state[ST_IDLE] <= 1;
                        packet_cnt <= 16'h0;
                        end
                    else
                        packet_cnt <= packet_cnt + 16'h1;
                end
                
            state[ST_HEADGEN_CPU]:
                if (re_i) begin
            
                end
        
        endcase
    
    end
    
endmodule