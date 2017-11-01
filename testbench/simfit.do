onerror { resume }
transcript off
add wave -noreg -logic {/top_vlg_tst/ft_clk}
add wave -noreg -hexadecimal -literal {/top_vlg_tst/ft_data}
add wave -noreg -logic {/top_vlg_tst/ft_oe_n}
add wave -noreg -logic {/top_vlg_tst/ft_rd_n}
add wave -noreg -logic {/top_vlg_tst/ft_rxf_n}
add wave -noreg -logic {/top_vlg_tst/ft_txe_n}
add wave -noreg -logic {/top_vlg_tst/ft_wr_n}
add wave -noreg -hexadecimal -literal {/top_vlg_tst/i1/rpi_d}
add wave -noreg -virtual "reo"  {/top_vlg_tst/i1/rpi_d(17)}
add wave -noreg -virtual "rei"  {/top_vlg_tst/i1/rpi_d(16)}
add wave -noreg -virtual "debug3"  {/top_vlg_tst/i1/rpi_d(15)} {/top_vlg_tst/i1/rpi_d(14)} {/top_vlg_tst/i1/rpi_d(13)} {/top_vlg_tst/i1/rpi_d(12)}
add wave -noreg -virtual "debug2"  {/top_vlg_tst/i1/rpi_d(11)} {/top_vlg_tst/i1/rpi_d(10)} {/top_vlg_tst/i1/rpi_d(9)} {/top_vlg_tst/i1/rpi_d(8)}
add wave -noreg -virtual "debug1"  {/top_vlg_tst/i1/rpi_d(7)} {/top_vlg_tst/i1/rpi_d(6)} {/top_vlg_tst/i1/rpi_d(5)} {/top_vlg_tst/i1/rpi_d(4)}
add wave -noreg -virtual "debug0"  {/top_vlg_tst/i1/rpi_d(3)} {/top_vlg_tst/i1/rpi_d(2)} {/top_vlg_tst/i1/rpi_d(1)} {/top_vlg_tst/i1/rpi_d(0)}
add wave -noreg -virtual "state"  {/top_vlg_tst/i1/\sdr_inst/sel_a2f_inst/state_0 \} {/top_vlg_tst/i1/\sdr_inst/sel_a2f_inst/state_1 \} {/top_vlg_tst/i1/\sdr_inst/sel_a2f_inst/state_3 \}
cursor "Cursor 1" 0fs  
transcript on
