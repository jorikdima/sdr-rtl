onerror { resume }
transcript off
add wave -noreg -logic {/top_vlg_tst/i1/ft_clk}
add wave -noreg -vgroup "TB"  {/top_vlg_tst/ft_data} {/top_vlg_tst/treg_ft_data}
add wave -noreg -vgroup "FT"  {/top_vlg_tst/ft_be} {/top_vlg_tst/ft_data} {/top_vlg_tst/ft_oe_n} {/top_vlg_tst/ft_rxf_n} {/top_vlg_tst/ft_rd_n} {/top_vlg_tst/ft_txe_n} {/top_vlg_tst/ft_wr_n}
add wave -noreg -logic {/top_vlg_tst/i1/\fsm_inst/have_unread_word_a2f \}
add wave -noreg -logic {/top_vlg_tst/i1/\fsm_inst/wr_n_local \}
add wave -noreg -logic {/top_vlg_tst/i1/\fsm_inst/no_more_write \}
add wave -noreg -logic {/top_vlg_tst/i1/a2f_fifo_empty}
cursor "Cursor 1" 400us  
transcript on
