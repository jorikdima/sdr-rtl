

module sdram_test #(parameter DQ_WIDTH = 16)
	(
	//Internal signals declarations:
input wire clk,
input wire reset_n,

output reg [23:0]addr,
output reg wr_req,
input wire wr_ack,
input wire next_wr_ack,
output reg [DQ_WIDTH-1:0]wr_data,
output reg rd_req,
input wire rd_ack,
input wire rd_valid,
input wire next_rd_valid,
input wire [DQ_WIDTH-1:0]rd_data

);

 
reg [DQ_WIDTH-1:0] read_data;
reg [15:0] cnt;

always @(posedge clk or negedge reset_n)
	if (~reset_n)
		begin
		rd_req <= 0;
		wr_req <= 0;
        cnt	<= 0;
		end
	else
		begin
		cnt <= cnt + 1'b1;
		
		rd_req <= cnt[15];
		wr_req <= ~cnt[15];
		end

always @(posedge clk)
if (wr_ack)
begin	
	wr_data <= wr_data + 1'b1;
end	   

always @(posedge clk)
if (wr_ack | rd_ack)
begin	
	addr <= addr + 3'h4;
	
end	

always @(posedge clk)
if (rd_valid)
begin		
	read_data <= rd_data;
end

endmodule