setactivelib -work
#Compiling UUT module design files
comp -include C:\work\sdr-rtl\src\sdram.v
comp -include "$dsn\src\TestBench\sdram_tb.v"
asim +access +r sdram_vlg_tst

wave
wave -noreg clk
wave -noreg sdram_dq
wave -noreg sdram_dq_bidir
wave -noreg sdram_addr
wave -noreg sdram_ba
wave -noreg sdram_cs
wave -noreg sdram_ras
wave -noreg sdram_cas
wave -noreg sdram_we
wave -noreg sdram_dqm
wave -noreg addr
wave -noreg wr_req
wave -noreg wr_ack
wave -noreg next_wr_ack
wave -noreg wr_data
wave -noreg rd_req
wave -noreg rd_ack
wave -noreg rd_valid
wave -noreg next_rd_valid
wave -noreg rd_data

run

#End simulation macro
