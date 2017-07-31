

module sel_a2f(
		// FIFO/ECPU to FTDI
	//input from FIFO
	a2f_data_i,
	a2f_clk_o,
	a2f_re_o,
	
	//input from ECPU
	cpu2f_data_i,
	cpu2f_clk_o,
	cpu2f_re_o
	
	//output to FTDI
	a2f_data_o,
	a2f_clk_i,
	a2f_re_i
	);
	
	
	parameter FT_DATA_WIDTH = 32;
	parameter IQ_PAIR_WIDTH = 24;
	parameter QSTART_BIT_INDEX = 16;	
	
	assign wdata_out = {{(FT_DATA_WIDTH-(QSTART_BIT_INDEX+IQ_PAIR_WIDTH/2)){1'b0}},
		wdata[IQ_PAIR_WIDTH - 1:IQ_PAIR_WIDTH/2],
		{(QSTART_BIT_INDEX-IQ_PAIR_WIDTH/2){1'b0}},
		wdata[IQ_PAIR_WIDTH/2 - 1:0]}; 
	
endmodule