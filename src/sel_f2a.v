

module sel_f2a(
    reset_n,
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
	
	
	input wire reset_n;
	// FTDI to FIFO/ECPU
	//input
	input wire[FT_DATA_WIDTH-1:0] data_i;
	input wire clk_i, we_i;
	output wire full_o, enough_o;
	
	//output to FIFO
	output wire[IQ_PAIR_WIDTH-1:0] fifo_data_o;
	output wire fifo_clk_o;
    output wire fifo_we_o;
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
	
	//assign fifo_we_o = we_i;
    assign fifo_we_o = we_i & fifo_we;
    reg fifo_we;
// Internal
    reg[15:0] packet_cnt, req_packets;
	reg mode;
	
	
	initial 
	begin
		packet_cnt <= 16'h0000;
		req_packets <= 16'hffff;
		mode <= TOFIFO;
    end
	
always @ (negedge clk_i or negedge reset_n)
begin
if (~reset_n)
    fifo_we <= 1'b0;
else
    fifo_we <= mode==TOFIFO & packet_cnt > 0;
end	   
 
always @ (posedge clk_i or negedge reset_n)
begin
if (~reset_n) begin
   packet_cnt <= 16'h0000;
   req_packets <= 16'hffff;
   mode <= TOFIFO;
   end
else if (we_i) begin
   if (packet_cnt == 16'h0000) begin
       // decode
       mode <= data_i[FT_DATA_WIDTH-1];
       req_packets <= data_i[15:0];       
	   end
   if (packet_cnt == req_packets)
	   packet_cnt <= 16'h0000;
   else
	   packet_cnt <= packet_cnt + 16'h1;
   end
end



	
endmodule