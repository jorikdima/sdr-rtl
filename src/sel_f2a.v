

module sel_f2a(
    reset_n,
    loopback,
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
	
	parameter ST_DECODE=2'h0, ST_FIFO=2'h1, ST_CPU=2'h2;
    parameter TOFIFO=1'b0, TOCPU=1'b1;	
	
	input wire reset_n, loopback;
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
	output reg [FT_DATA_WIDTH-1:0] cpu_data_o;
	output wire cpu_clk_o, cpu_we_o;	
	
	
	assign fifo_data_o = {data_i[QSTART_BIT_INDEX + IQ_PAIR_WIDTH/2 - 1:QSTART_BIT_INDEX],
						data_i[IQ_PAIR_WIDTH/2 - 1:0] };
		
	assign fifo_clk_o = clk_i;
	assign cpu_clk_o = clk_i;
	
    assign full_o = fifo_full_i;
	assign enough_o = fifo_enough_i;
    
// Internal
    reg[15:0] packet_cnt, req_packets;
	reg [1:0] mode;
	reg fifo_we, cpu_we;
    reg [FT_DATA_WIDTH-1:0] data_i_delayed;
    reg cpu_we_local;
	
	assign fifo_we_o = we_i & (fifo_we | loopback);
    assign cpu_we_o = cpu_we & ~loopback;
	

always @ (negedge clk_i or negedge reset_n)
begin
if (~reset_n | loopback) begin
    fifo_we <= 1'b0;
    cpu_we <= 1'b0;
    cpu_data_o <= {(FT_DATA_WIDTH){1'b0}};
    end
else begin
    fifo_we <= mode==ST_FIFO;
    cpu_we <= cpu_we_local;
    cpu_data_o <= data_i_delayed;
    end
end	   
 
always @ (posedge clk_i or negedge reset_n)
begin
if (~reset_n | loopback) begin
   packet_cnt <= 16'h0000;
   req_packets <= 16'h0;
   mode <= ST_DECODE;
   cpu_we_local <= 1'b0;
   data_i_delayed <= {(FT_DATA_WIDTH){1'b0}};
   end
else begin 
    cpu_we_local <= 1'b0;
    data_i_delayed <= data_i;
    
    case (mode)
        ST_DECODE: 
            if (we_i) begin                
                case (data_i[FT_DATA_WIDTH-1])
                    TOFIFO: begin
                        req_packets <= data_i[15:0];                        
                        mode <= ST_FIFO;
                        end
                    TOCPU: begin
                        cpu_we_local <= 1'b1;
                        req_packets <= {{8{1'b0}}, data_i[27:20]}; 
                        if (data_i[27:20] > 0)
                            mode <= ST_CPU;
                        end
                endcase
                packet_cnt <= 16'h0;
                end
        ST_CPU, ST_FIFO: begin
            if (mode == ST_CPU)
                cpu_we_local <= 1'b1;
            if (we_i)
                packet_cnt <= packet_cnt + 16'h1;
            if (packet_cnt + 16'h1 == req_packets) begin
                mode <= ST_DECODE;
                req_packets <= 16'h0;
                end
            end
    endcase
    
    end
end

endmodule