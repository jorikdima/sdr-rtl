


module wb2fifo(
	// FIFO to read from
	fifoin_data_i,
	fifoin_clk_o,
	fifoin_rd_o,
    fifoin_empty_i,
    fifoin_full_i,
    
	
	//FIFO to write to
	fifoout_data_o,
    fifoout_empty_i,
    fifoout_full_i,
	fifoout_clk_o,
	fifoout_wr_o,
    fifoout_blkcnt_o,


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
localparam WB_ADDR_BITS_USED = 2;

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
output [31:0]       wb_dat_o;   
output reg          wb_ack_o;   
output              wb_err_o;   
output              wb_rty_o; 

input [FT_DATA_WIDTH-1:0]   fifoin_data_i;
output                      fifoin_clk_o;
output                      fifoin_rd_o;
input                       fifoin_empty_i, fifoin_full_i;


//FIFO to write to
output [FT_DATA_WIDTH-1:0]  fifoout_data_o;
input                       fifoout_empty_i, fifoout_full_i;
output                      fifoout_clk_o, fifoout_wr_o;
output reg[3:0]             fifoout_blkcnt_o;



//-----------------------------------------------
assign wb_err_o = 1'b0;
assign wb_rty_o = 1'b0;

assign fifoin_clk_o = wb_clk_i;
assign fifoout_clk_o = wb_clk_i;

assign DATA_ADDR = (wb_adr == 0)?1'b1:1'b0;
assign STATUS_ADDR = (wb_adr == 1)?1'b1:1'b0;



reg[31:0] data;
wire[31:0] status = {28'h0, fifoin_empty_i, fifoin_full_i, fifoout_empty_i, fifoout_full_i};

// generate wishbone signals
wire wb_wacc = wb_cyc_i & wb_stb_i & wb_we_i;
wire wb_racc = wb_cyc_i & wb_stb_i & ~wb_we_i;

wire [WB_ADDR_BITS_USED-1:0] wb_adr = wb_adr_i[2+WB_ADDR_BITS_USED:2];

// generate acknowledge output signal
always @(posedge wb_clk_i)
  wb_ack_o <= #1 wb_cyc_i & wb_stb_i & ~wb_ack_o; // because timing is always honored

// Read from FIFO
assign fifoin_rd_o = wb_racc & DATA_ADDR & ~fifoin_empty_i & ~wb_ack_o;
assign wb_dat_o = (STATUS_ADDR)?status:(DATA_ADDR)?fifoin_data_i:32'h0;


// Save to FIFO
assign fifoout_wr_o = wb_wacc & DATA_ADDR & ~fifoout_full_i & ~wb_ack_o;
assign fifoout_data_o = wb_dat_i;

always @(posedge wb_clk_i)
if (wb_rst_i)
    fifoout_blkcnt_o <= 4'h0;
else if (wb_ack_o & STATUS_ADDR & wb_dat_i[4])
    fifoout_blkcnt_o <= fifoout_blkcnt_o + 4'h1;
    
    
endmodule    