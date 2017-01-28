// Copyright (C) 2016  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "01/11/2017 09:52:22"
                                                                                
// Verilog Test Bench template for design : top
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module ft600_vlg_tst();
// constants                                           
// general purpose registers

// test vector input registers

reg [3:0] treg_ft_be;
reg ft_clk;
reg [31:0] treg_ft_data;
reg ft_rxf_n;
reg ft_txe_n;
reg reset_n;
// wires                                               

wire [11:0]  afe_rx_d;
wire [3:0]  ft_be;
wire [31:0]  ft_data;
wire ft_oe_n;
wire ft_rd_n;
wire ft_wr_n;

wire rd_clk, rd_data_rdy;
wire [31:0] rdata;


// assign statements (if any)                          
assign ft_be = treg_ft_be;
assign ft_data = treg_ft_data;

ft600 i1 (
// port map - connection between master ports and signals/registers   
    
    .ft_be(ft_be),
    .ft_clk(ft_clk),
    .ft_data(ft_data),
    .ft_oe_n(ft_oe_n),
    .ft_rd_n(ft_rd_n),
    .ft_rxf_n(ft_rxf_n),
    .ft_txe_n(ft_txe_n),
    .ft_wr_n(ft_wr_n),
    .reset_n(reset_n),
    .rdata(rdata),
    .rd_data_rdy(rd_data_rdy),
    .rd_clk(rd_clk)
);


reg [7:0] rxf_n_cnt;

initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin
$display("Running testbench");                           
reset_n = 1'b1;
ft_clk=0;
ft_rxf_n = 1;
treg_ft_data = 0;


// local
rxf_n_cnt = 8'h0;

#1 reset_n = 0;

// --> end                      
end      

initial forever #5 ft_clk = ~ ft_clk;


always @(negedge ft_clk)
begin
rxf_n_cnt <= rxf_n_cnt + 1;
if (rxf_n_cnt == 3)
    ft_rxf_n <= 0;
if (rxf_n_cnt == 8)
    begin
    ft_rxf_n <= 1;
    rxf_n_cnt <= 0;
    end

if (ft_rd_n == 0)
     treg_ft_data = treg_ft_data + 17; 
end
                                              
always  @(posedge ft_clk)
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
                                                                                           
// --> end                                             
end                                                    
endmodule

