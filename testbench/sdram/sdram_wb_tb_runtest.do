setactivelib -work
#Compiling UUT module design files
comp -include C:\work\sdr-rtl\src\sdram.v
comp -include "$dsn\src\TestBench\sdram_wb_tb.v"
asim +access +r sdram_wb_tb

wave
wave -noreg clk_i
wave -noreg rst_i
wave -noreg stb_i
wave -noreg we_i
wave -noreg sel_i
wave -noreg cyc_i
wave -noreg addr_i
wave -noreg data_i
wave -noreg data_o
wave -noreg stall_o
wave -noreg ack_o
wave -noreg sdram_cke_o
wave -noreg sdram_cs_o
wave -noreg sdram_ras_o
wave -noreg sdram_cas_o
wave -noreg sdram_we_o
wave -noreg sdram_dqm_o
wave -noreg sdram_addr_o
wave -noreg sdram_ba_o
wave -noreg sdram_data_io
wave -noreg sdram_data_io_bidir

run

#End simulation macro
