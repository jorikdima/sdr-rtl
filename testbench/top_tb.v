
// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "01/18/2017 09:28:50"
                                                                                
// Verilog Test Bench template for design : top
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module top_vlg_tst();
// constants                                           
// general purpose registers

// test vector input registers
reg [11:0] afe_rx_d;
reg afe_rx_sel;
reg clk_sr1, clk_sr2, clk26;
wire [3:0] ft_be;
reg [3:0]  treg_ft_be;
reg ft_clk;
wire [31:0] ft_data;
reg [31:0] treg_ft_data;
reg ft_rxf_n;
reg ft_txe_n;
reg reset_n;

// wires                                               
wire afe_rx_clk;
wire afe_tx_clk;
wire [11:0]  afe_tx_d;
wire afe_tx_sel;
wire ft_oe_n;
wire ft_rd_n;
wire ft_wr_n;
wire afe_reset;
wire afe_rx_en;	  

wire afe_sen;
wire afe_spi_clk;
wire afe_spi_mosi;
wire afe_spi_miso;
wire afe_tx_en;

// assign statements (if any)                          

assign ft_data = (oe_local & ~ft_rxf_n) ? treg_ft_data : 32'hzzzzzzzz;
top i1 (
// port map - connection between master ports and signals/registers   
	.afe_rx_clk(afe_rx_clk),
	.afe_rx_d(afe_rx_d),
	.afe_rx_sel(afe_rx_sel),
	.afe_tx_clk(afe_tx_clk),
	.afe_tx_d(afe_tx_d),
	.afe_tx_sel(afe_tx_sel),
	.clk_sr1(clk_sr1),
	.clk_sr2(clk_sr2), 
	.clk26(clk26),
	.ft_be(ft_be),
	.ft_clk(ft_clk),
	.ft_data(ft_data),
	.ft_oe_n(ft_oe_n),
	.ft_rd_n(ft_rd_n),
	.ft_rxf_n(ft_rxf_n),
	.ft_txe_n(ft_txe_n),
	.ft_wr_n(ft_wr_n),
	.afe_reset(afe_reset),
	.reset_n(reset_n),
	.afe_rx_en(afe_rx_en),
	.afe_sen(afe_sen),
	.afe_spi_clk(afe_spi_clk),
	.afe_spi_mosi(afe_spi_mosi),
	.afe_spi_miso(afe_spi_miso),
	.afe_tx_en(afe_tx_en)
);


reg [15:0] rxf_n_cnt, txe_n_cnt;
reg[11:0] afe_rx_i, afe_rx_q;
reg inited, rd_local, wr_local, oe_local, cmd_sent;
integer rxf_rnd, txe_rnd;  


parameter TOFIFO=1'b0, TOCPU=1'b1;
wire [31:0] cmd;

reg cmd_type; 
reg[15:0] cmd_fifo_num; 
reg[2:0] cmd_cpu_id;
reg[7:0] cmd_cpu_num;
 
assign cmd[27:20] = cmd_cpu_num;
assign cmd[31] = cmd_type;
assign cmd[15:0] = cmd_fifo_num;
assign cmd[30:28] = cmd_cpu_id;


initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
reset_n = 1;
ft_clk=0;
clk_sr1 = 0;
clk_sr2 = 0; 
clk26 = 0;
ft_rxf_n = 1;
ft_txe_n = 1;
treg_ft_data = 32'haa0000;

// local
rxf_n_cnt = 0;
txe_n_cnt = 0;

afe_rx_sel = 0;
afe_rx_i = 0;
afe_rx_q = 0;

inited = 0;
rxf_rnd = $random%10;
txe_rnd = $random%10; 

rd_local = 0;
oe_local = 0;
wr_local = 0;
cmd_sent = 0;

#1 	reset_n = 0;
inited = 1;
ft_rxf_n = 0;
ft_txe_n = 0;

#9 reset_n = 1;
                                                       
// --> end                                             
$display("Running testbench");                       
end        

parameter FT_PACKET_WORDS = 4096;

initial forever #5 ft_clk = ~ ft_clk;
initial forever #1.25 clk26 = ~ clk26;
initial forever #12.5 clk_sr1 = ~ clk_sr1;
initial forever #12.5 clk_sr2 = ~ clk_sr2;
	
//  TO SDR	(F2A)
always @ (posedge ft_rd_n or posedge ft_rxf_n)
begin
	rxf_n_cnt <= 0;
	rxf_rnd <= $random%10;
end

always @(posedge ft_clk)
begin
    rd_local <= ~ft_rd_n;
    oe_local <= ~ft_oe_n;
    wr_local <= ~ft_wr_n;
end

always @(negedge ft_rxf_n)
begin
    cmd_sent <= 1'b0;    
    if (cmd_type == TOCPU) begin        
        cmd_type <= TOFIFO;
        cmd_fifo_num <= 16'd4095; 
	end
    else begin        
        cmd_type <= TOCPU;
        cmd_cpu_id <= 1;
        cmd_cpu_num <= 0;
    end
    treg_ft_data <= cmd;
end
	
always @(negedge ft_clk)
begin		 
	if (rxf_n_cnt <= (FT_PACKET_WORDS / 2 + rxf_rnd))
		begin
		rxf_n_cnt <= rxf_n_cnt + 1;
	    ft_rxf_n <= 1;			  
		end
	else if (rxf_n_cnt < (FT_PACKET_WORDS * 3 / 2 + rxf_rnd))  
		begin
	    ft_rxf_n <= 0;	  
		if (rd_local) 
			rxf_n_cnt = rxf_n_cnt + 1;
		end
	else
	    ft_rxf_n <= 1;	
	
	if (rd_local & ~ft_rxf_n)
    begin
        if (~cmd_sent) 
            begin
            cmd_sent <= 1'b1;
            treg_ft_data <= 0;
            end
        else        
            treg_ft_data <= treg_ft_data + 17'h10001;        
    end
end


// FROM SDR


always @ (posedge ft_wr_n or posedge ft_txe_n)
	begin
	txe_n_cnt <= 0;
	txe_rnd <= $random%10;
	end
	
always @(negedge ft_clk)
begin    
    if (txe_n_cnt < (FT_PACKET_WORDS / 2 + txe_rnd))  
		begin		
		txe_n_cnt <= txe_n_cnt + 1;
        ft_txe_n <= 1;
		end
    else if (txe_n_cnt < (FT_PACKET_WORDS * 3 / 2 + txe_rnd)) 
		begin
        ft_txe_n <= 0; 
		if (~ft_wr_n)  
			txe_n_cnt <= txe_n_cnt + 1;
		end
    else
        ft_txe_n <= 1;	     
end


// AFE
always @(posedge afe_rx_clk)
begin
    afe_rx_i = afe_rx_i + 1;
    afe_rx_q = afe_rx_q + 1;

    afe_rx_sel = ~afe_rx_sel;
    if (afe_rx_sel)
        afe_rx_d <= afe_rx_i;
    else
        afe_rx_d <= afe_rx_q;
    
end

                                            
                                                    
endmodule

