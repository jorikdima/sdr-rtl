


module wb2fifo(
	// FIFO to read from
	fifo_data_i,
	fifo_clk_o,
	fifo_rd_o,
    fifo_empty_i,
    fifo_full_i,
    
	
	//FIFO to write to
	cpu_data_o,
    cpu_empty_i,
	cpu_clk_o,
	cpu_wr_o,


    // Wishbone interface
    wb_clk_i  ,
    wb_rst_i  ,
    wb_adr_i  ,
    wb_dat_i  ,
    wb_we_i   ,
    wb_cyc_i  ,
    wb_stb_i  ,
    wb_sel_i  ,
    wb_cti_i  ,
    wb_bte_i  ,
    wb_lock_i ,
    wb_dat_o  ,
    wb_ack_o  ,
    wb_err_o  ,
    wb_rty_o  	
	);


parameter FT_DATA_WIDTH = 32;
localparam WB_ADDR_BITS_USED = 6;

input               wb_clk_i;    
input               wb_rst_i;
input [31:0]        wb_adr_i;  
input [31:0]        wb_dat_i;
input               wb_we_i;   
input               wb_cyc_i;   
input               wb_stb_i;   
input [3:0]	        wb_sel_i;   
input [2:0]	        wb_cti_i;
input [1:0]	        wb_bte_i;
input               wb_lock_i;
output reg [31:0]   wb_dat_o;   
output reg          wb_ack_o;   
output              wb_err_o;   
output              wb_rty_o; 

input [FT_DATA_WIDTH-1:0]   fifo_data_i;
output                      fifo_clk_o, fifo_rd_o;
input                       fifo_empty_i, fifo_full_i;


//FIFO to write to
output [FT_DATA_WIDTH-1:0]  cpu_data_o;
input                       cpu_empty_i;
output                      cpu_clk_o, cpu_wr_o;


assign wb_err_o = 1'b0;
assign wb_rty_o = 1'b0;
assign rst =	~wb_rst_i;


reg[31:0] tmp1 = 32'h5c5c5c5c;
reg[31:0] tmp2 = 32'hfeedbeef;

// generate wishbone signals
wire wb_wacc = wb_cyc_i & wb_stb_i & wb_we_i;
wire [WB_ADDR_BITS_USED-1:0] wb_adr = wb_adr_i[2+WB_ADDR_BITS_USED:2];

// generate acknowledge output signal
always @(posedge wb_clk_i)
  wb_ack_o <= #1 wb_cyc_i & wb_stb_i & ~wb_ack_o; // because timing is always honored

// assign DAT_O
always @(posedge wb_clk_i)
begin
  case (wb_adr) // synopsis parallel_case
    0: wb_dat_o <= #1 tmp1;
    1: wb_dat_o <= #1 tmp2;    
  endcase
end


// generate registers
always @(posedge wb_clk_i or negedge rst)
if (!rst)
begin
    tmp1 <= #1 32'h5c5c5c5c;
    tmp2 <= #1 32'hfeedbeef;
end
else
if (wb_wacc)
  case (wb_adr) // synopsis parallel_case
     0 : tmp1 <= #1 wb_dat_i;
     1 : tmp2 <= #1 wb_dat_i;
     
     default: ;
  endcase                   


endmodule    