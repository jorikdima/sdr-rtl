

module sel_f2a(
		// FTDI to FIFO/ECPU
	// FTDI interface
	// input
	data_i,
	clk_i,
	we_i,
	// output
	full_o,
	enough_o,
	
	// FIFO interface
	// input 
	fifo_full_i,
	fifo_enough_i,
	// output
	fifo_data_o,
	fifo_clk_o,
	fifo_we_o,
	
	
	// ECPU interface
	cpu_data_o,
	cpu_clk_o,
	cpu_we_o
	
	);
	
	
	parameter FT_DATA_WIDTH = 32;
	parameter IQ_PAIR_WIDTH = 24;
	parameter QSTART_BIT_INDEX = 16;	
	
	parameter TOFIFO=0, TOCPU=1;
	
	
	// FTDI to FIFO/ECPU
	//input
	input wire[FT_DATA_WIDTH-1:0] data_i;
	input wire clk_i, we_i;
	output wire full_o, enough_o;
	
	//output to FIFO
	output wire[IQ_PAIR_WIDTH-1:0] fifo_data_o;
	output wire fifo_clk_o, fifo_we_o;
	input wire fifo_full_i, fifo_enough_i;
	
	//output to ECPU
	output wire[FT_DATA_WIDTH-1:0] cpu_data_o;
	output wire cpu_clk_o, cpu_we_o;	
	
	
	assign fifo_data_o = {data_i[QSTART_BIT_INDEX + IQ_PAIR_WIDTH/2 - 1:QSTART_BIT_INDEX],
						data_i[IQ_PAIR_WIDTH/2 - 1:0] };
	assign cpu_data_o = data_i;
	
	assign fifo_clk_o = clk_i;
	assign cpu_clk_o = clk_i;
	
    assign full_o = fifo_full_i;
	assign enough_o = fifo_enough_i;
	
	assign fifo_we_o = we_i;

// Internal
    reg state;
	
	
	initial 
	begin
		state <= TOFIFO;
		
    end

	
endmodule