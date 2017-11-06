
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

assign ft_data = (~ft_oe_n) ? treg_ft_data : 32'hzzzzzzzz;
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



reg  cmd_sent;

parameter TOFIFO=1'b0, TOCPU=1'b1;
parameter FT_PACKET_WORDS = 1024;
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

string strvar="";

initial                                                
begin             

rx_head_case1[0] = 32'h90200000;
rx_head_case1[1] = 32'hfeedbeef;
rx_head_case1[2] = 32'hdeefb00b;
rx_head_case1[3] = 32'hffc;

rx_head_case2[0] = 32'h20;//32'hfff;

rx_head_case3[0] = 32'h90000000;

rx_head_case4[0] = 32'h90100000;
rx_head_case4[1] = 32'hfeedbeef;

rx_head_sizes[0] = $size(rx_head_case1);
rx_head_sizes[1] = $size(rx_head_case2);
rx_head_sizes[2] = $size(rx_head_case3);
rx_head_sizes[3] = $size(rx_head_case4);

rx_head_correction[0] = 0;
rx_head_correction[1] = 32;//0;
rx_head_correction[2] = FT_PACKET_WORDS-1;
rx_head_correction[3] = FT_PACKET_WORDS-2;

rx_head_cpuonly[0] = 0;
rx_head_cpuonly[0] = 0;
rx_head_cpuonly[0] = 1;
rx_head_cpuonly[0] = 1;
                                     
// code that executes only once                        
// insert code here --> begin                          
ft_clk=0;
clk_sr1 = 0;
clk_sr2 = 0; 
clk26 = 0;


ft_rxf_n = 1;
ft_txe_n = 1;
treg_ft_data = 32'haa0000;
                                                     
// --> end                                             
$display("Running testbench");

#10000 start_testing(cmd_sent);
                     
end        

initial forever #20 ft_clk = ~ ft_clk;
//initial forever #1.25 clk26 = ~ clk26;
initial forever #12.5 clk_sr1 = ~ clk_sr1;
//initial forever #12.5 clk_sr2 = ~ clk_sr2;



task automatic start_testing(output logic result);

reg [31:0] wr_data []; 
reg [31:0] rd_data [];
integer len;
logic res;


/* wr_data = new[3];
len = wr_data.size();
wr_data[0] = 32'h90200000;
wr_data[1] = 32'hfeedbeef;
wr_data[2] = 32'hdeefb00b;

#1000 write(wr_data, len);

$display("Write to CPU ccommand buffer %0d words", len); */



wr_data = new[1024];
len = wr_data.size();
rd_data = new[len];
get_seq_array(wr_data, 1, len-1);
wr_data[0] = 1023;


#1000 write_read_seq(wr_data, len, res); 
$display("Sequentially Write/Read with %0d words, result = %s", len, res?"PASS":"NOT PASS");
	

len = 10;
#1000 write_read_seq(wr_data, len, res);
$display("Sequentially Write/Read with %0d words, result = %s", len, res?"PASS":"NOT PASS");




wr_data = new[1026];
rd_data = new[1026];
len = 1025;
get_seq_array(wr_data, 0, wr_data.size());

#1000 write_read_seq(wr_data, len, res);
$display("Sequentially Write/Read with %0d words, result = %s", len, res?"PASS":"NOT PASS");

len = 1024;
wr_data[0] = len - 1;

#1000 write_read_seq(wr_data, len, res);
$display("Sequentially Write/Read with %0d words, result = %s", len, res?"PASS":"NOT PASS");

len = 1023;
wr_data[0] = len - 1;

#1000 write_read_seq(wr_data, len, res);
$display("Sequentially Write/Read with %0d words, result = %s", len, res?"PASS":"NOT PASS");

endtask

task automatic write_read_seq( input reg [31:0] data[], input integer num, output logic result);
reg [31:0] rdata [];
rdata = new[$size(data)]; 

#1000 write(data, num);
#1000 read(rdata, num);

result = arrays_equal(data, rdata, num);

if (!result)
	begin
	foreach (data[i]) strvar = {strvar, $sformatf("%x, ", data[i])};
    $display("Original data:\n%s", strvar);	 
	foreach (rdata[i]) strvar = {strvar, $sformatf("%x, ", rdata[i])};
    $display("Received data:\n%s", strvar);	
	end
	
endtask

task automatic read( inout reg [31:0] data[], input integer num);
integer pause_cnt = 0;

//$display ("%m %g Read task with num : %d", $time, num);
@(negedge ft_clk);
ft_txe_n <= 1'b0; 

for (int idx = 0 ; idx < num; ) begin
    @(posedge ft_clk);
    if (pause_cnt > 0) begin
        if (--pause_cnt == 0) begin
            @(negedge ft_clk);
            ft_txe_n <= 1'b0;
            end
        end
    else if (~ft_wr_n) begin
        data[idx] = ft_data;
        idx = idx + 1;
        
        if ((idx % FT_PACKET_WORDS) == 0 & idx < num) begin
            pause_cnt = 10;
            @(negedge ft_clk);
            ft_txe_n <= 1'b1;
            end
        end
    else if (pause_cnt > 0 & idx > 0)
        break;
    end
@(negedge ft_clk);
ft_txe_n <= 1'b1;

endtask

task automatic write( inout reg [31:0] data[], input integer num);
integer pause_cnt = 0;	

//$display ("%m %g Write task with num : %d", $time, num);
@(negedge ft_clk);
ft_rxf_n <= 1'b0;
for (int idx = 0 ; idx < num; ) begin
    @(negedge ft_clk) begin        
        if (pause_cnt > 0) begin
            if (--pause_cnt == 0) begin                
                ft_rxf_n <= 1'b0;
                end
            end
        else if (~ft_rd_n | (~ft_oe_n & idx == 0)) begin   
            treg_ft_data <= data[idx++];
			
			if ((idx % FT_PACKET_WORDS) == 0 & idx < num) begin
	            pause_cnt = 10;                
	            ft_rxf_n <= 1'b1;
	            end
			
			end       
        end
    end
@(negedge ft_clk);
ft_rxf_n <= 1'b1;

endtask





function automatic logic arrays_equal( input reg [31:0] arr1[], input reg [31:0] arr2[], input integer num);
for (int i = 0 ; i < num; i++) begin
    if (arr1[i] != arr2[i]) begin
        return 0;
        end
    end
return 1;
endfunction

task automatic get_seq_array( inout reg [31:0] arr[], input integer start_idx, input integer num);
begin    
    for (int i = 0 ; i < num; i++) begin
        arr[start_idx+i] = i;
    end
end
endtask  

endmodule


