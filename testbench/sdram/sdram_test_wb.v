

module sdram_test_wb #(parameter DQ_WIDTH = 16)
	(
	//Internal signals declarations:
input wire clk,
input wire reset_n,


// Wishbone Master Interface
    output  reg         stb_o,
    output   reg        we_o,
    
    output  reg         cyc_o,
    output reg[31:0]    addr_o,
    input [31:0]    data_i,
    output reg[31:0]   data_o,
    input          stall_i,
    input          ack_i
);

 
reg [31:0] read_data;
reg [15:0] cnt;



always @(posedge clk or negedge reset_n)
	if (~reset_n)
		begin
		stb_o <= 1;
		we_o <= 0;
		cyc_o <= 1;
		
		end
	else
		begin
		cnt <= cnt + 1'b1;
		
		we_o <= (cnt < 16'hff) & (cnt > 16'hf)?1:0;
		
		end

always @(posedge clk)
if (~reset_n)
	data_o <= 0;
else if (ack_i)
begin	
	addr_o <= addr_o + 3'h4;
	if (we_o)
		data_o <= data_o + 1'b1;
	else
		read_data <= data_i;
end	   


endmodule