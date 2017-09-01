

module sel_a2f(
    reset_n,
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
    cpu_data_incomming_i,
	
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
    
    parameter FROMFIFO=1'b0, FROMCPU=1'b1;
    
    input wire reset_n;
    
    input wire clk_i;
    output wire cpu_clk_o;
    output wire fifo_clk_o;
    
    input wire re_i;
    output wire fifo_re_o, cpu_re_o;
    
    output wire[FT_DATA_WIDTH-1:0] data_o;
    input wire[FT_DATA_WIDTH-1:0] cpu_data_i;
    input wire[IQ_PAIR_WIDTH-1:0] fifo_data_i;
	
    input wire cpu_empty_i;
    
    assign cpu_clk_o = clk_i;
    assign fifo_clk_o = clk_i;
    
	wire[FT_DATA_WIDTH-1:0] fifo_data_32 =
            {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
            {(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
               fifo_data_i[IQ_PAIR_WIDTH/2 - 1:0]}; 
                            
    assign data_o = fifo_data_32;
    
    assign fifo_re_o = re_i;
    
    input wire fifo_empty_i, fifo_enough_i, cpu_data_incomming_i, fifo_data_incomming_i;
    output wire enough_o, empty_o, data_incomming_o;
    
    assign enough_o = fifo_enough_i;
    assign empty_o = fifo_empty_i;
    assign data_incomming_o = cpu_data_incomming_i | fifo_data_incomming_i;
    
    // Internal  
    
    reg[FT_DATA_WIDTH-1:0] data_reg;
    
   

/*
always @ (negedge clk_i or negedge reset_n)
begin
if (~reset_n) begin

    end
else begin
    if (re_i)
        packet_cnt <= packet_cnt + 16'h0001;
    data_reg <= (cpu_empty_i)? fifo_data_32: cpu_data_i;
    end
    
end	


always @ (posedge clk_i or negedge reset_n)
begin
if (~reset_n)
    mode <= FROMFIFO;
else begin
    if (re_i & packet_zero)
        mode <= (cpu_empty_i)?FROMFIFO:FROMCPU;
    
    end
    
end	
*/
	
endmodule