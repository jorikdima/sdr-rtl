

module selector(
	// FTDI to FIFO/ECPU
	//input
	f2a_data_i,
	f2a_clk_i,
	f2a_we_i,
	
	//output to FIFO
	f2a_data_o,
	f2a_clk_o,
	f2a_we_o,
	
	//output to ECPU
	f2cpu_data_o,
	f2cpu_clk_o,
	f2cpu_we_o,
/*

	// FIFO/ECPU to FTDI
	//input
	a2f_data_i,
	a2f_clk_i,
	a2f_re_i,
	
	//output to FIFO
	a2f_data_o,
	a2f_clk_o,
	a2f_re_o,
	
	//output to ECPU
	cpu2f_data_o,
	cpu2f_clk_o,
	cpu2f_re_o
*/	
	);
	
	parameter IQ_DATA_WIDTH = 24;
    	
	
	
	// FTDI to FIFO/ECPU
	//input
	input wire[IQ_DATA_WIDTH-1:0] f2a_data_i;
	input wire f2a_clk_i, f2a_we_i;
	
	//output to FIFO
	output wire[IQ_DATA_WIDTH-1:0] f2a_data_o;
	output wire f2a_clk_o, f2a_we_o;
	
	//output to ECPU
	output wire[IQ_DATA_WIDTH-1:0] f2cpu_data_o;
	output wire f2cpu_clk_o, f2cpu_we_o;
	
	
	
	assign f2a_data_o = f2a_data_i;
	assign f2cpu_data_o = f2a_data_i;
	
	assign f2a_clk_o = f2a_clk_i;
	assign f2cpu_clk_o = f2a_clk_i;
	
endmodule