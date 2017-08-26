
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
	//.clk_sr1(clk_sr1),
	//.clk_sr2(clk_sr2), 
	//.clk26(clk26),
	.ft_be(ft_be),
	.ft_clk(ft_clk),
	.ft_data(ft_data),
	.ft_oe_n(ft_oe_n),
	.ft_rd_n(ft_rd_n),
	.ft_rxf_n(ft_rxf_n),
	.ft_txe_n(ft_txe_n),
	.ft_wr_n(ft_wr_n),
	.afe_reset(afe_reset),
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
parameter FT_PACKET_WORDS = 4096;
wire [31:0] cmd;

reg cmd_type; 
reg[15:0] cmd_fifo_num; 
reg[2:0] cmd_cpu_id;
reg[7:0] cmd_cpu_num;
 

assign cmd[31] = cmd_type;
assign cmd[30:28] = cmd_cpu_id;
assign cmd[27:20] = cmd_cpu_num;
assign cmd[15:0] = cmd_fifo_num;


integer rx_head_idx, rx_head_idx_idx;
reg [31:0] rx_head_case1 [0:3]; //= '{32'h90200000,32'hfeedbeef,32'hdeefb00b, 32'hffc};
reg [31:0] rx_head_case2 [0:0]; //= '{32'hfff};
reg [31:0] rx_head_case3 [0:0]; //= '{32'h90000000};
reg [31:0] rx_head_case4 [0:1]; //= '{32'h90100000, 32'hfeedbeef};

integer rx_head_sizes[0:3] ;//= '{$size(rx_head_case1), $size(rx_head_case2), $size(rx_head_case3), $size(rx_head_case4)};
integer rx_head_correction[0:3]; //= '{0, 0, FT_PACKET_WORDS-1, FT_PACKET_WORDS - 2};
integer rx_head_cpuonly[0:3];// = '{0,0,1,1};
integer rx_head_corr;

initial                                                
begin             

rx_head_case1[0] = 32'h90200000;
rx_head_case1[1] = 32'hfeedbeef;
rx_head_case1[2] = 32'hdeefb00b;
rx_head_case1[3] = 32'hffc;

rx_head_case2[0] = 32'hfff;
rx_head_case3[0] = 32'h90000000;

rx_head_case4[0] = 32'h90100000;
rx_head_case4[1] = 32'hfeedbeef;

rx_head_sizes[0] = $size(rx_head_case1);
rx_head_sizes[1] = $size(rx_head_case2);
rx_head_sizes[2] = $size(rx_head_case3);
rx_head_sizes[3] = $size(rx_head_case4);

rx_head_correction[0] = 0;
rx_head_correction[1] = 0;
rx_head_correction[2] = FT_PACKET_WORDS-1;
rx_head_correction[3] = FT_PACKET_WORDS-2;

rx_head_cpuonly[0] = 0;
rx_head_cpuonly[0] = 0;
rx_head_cpuonly[0] = 1;
rx_head_cpuonly[0] = 1;
                                     
// code that executes only once                        
// insert code here --> begin                          
ft_clk=0;
//clk_sr1 = 0;
//clk_sr2 = 0; 
//clk26 = 0;
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


rx_head_idx = 100;
rx_head_idx_idx = 0;
cmd_sent = 0;

inited = 1;
ft_rxf_n = 0;
ft_txe_n = 0;

                                                       
// --> end                                             
$display("Running testbench"); 
                     
end        

initial forever #10 ft_clk = ~ ft_clk;
//initial forever #1.25 clk26 = ~ clk26;
//initial forever #12.5 clk_sr1 = ~ clk_sr1;
//initial forever #12.5 clk_sr2 = ~ clk_sr2;
	
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
    rx_head_idx = rx_head_idx + 1;
    if (rx_head_idx >= $size(rx_head_sizes))
        rx_head_idx =0;

    treg_ft_data <= get_header(rx_head_idx, 0);
    rx_head_idx_idx <= 1;
    cmd_sent <= 1'b0;    
    rx_head_corr <= 0;
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
        if (~cmd_sent) begin            
            if (rx_head_idx_idx == rx_head_sizes[rx_head_idx]) begin
                cmd_sent <= 1'b1;
                if (rx_head_cpuonly[rx_head_idx])
                    ft_rxf_n <= 1;	
                else begin
                    treg_ft_data <= 0;
                    rxf_n_cnt <= rxf_n_cnt + rx_head_correction[rx_head_idx];        
                end
            end
            else
                treg_ft_data <= get_header(rx_head_idx, rx_head_idx_idx);
                            
            rx_head_idx_idx <= rx_head_idx_idx + 1; 
              
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
      

function[31:0]  get_header;
input integer idx, idx_idx;
begin 
    case (idx)
    0:
        get_header = rx_head_case1[idx_idx];
    1:
        get_header = rx_head_case2[idx_idx];
    2:
        get_header = rx_head_case3[idx_idx];
    3:
        get_header = rx_head_case4[idx_idx];
    endcase
end
endfunction      

endmodule

