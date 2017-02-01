onerror { resume }
transcript off
add wave -noreg -logic {/top_vlg_tst/reset_n}
add wave -noreg -logic {/top_vlg_tst/ft_clk}
add wave -noreg -vgroup "FT"  {/top_vlg_tst/i1/fsm_inst/state} {/top_vlg_tst/ft_be} {/top_vlg_tst/ft_data} {/top_vlg_tst/ft_oe_n} {/top_vlg_tst/ft_rxf_n} {/top_vlg_tst/ft_rd_n} {/top_vlg_tst/ft_txe_n} {/top_vlg_tst/ft_wr_n}
add wave -noreg -vgroup "F2A_FIFO"  {/top_vlg_tst/i1/f2a_fifo_inst/WrClock} {/top_vlg_tst/i1/f2a_fifo_inst/WrEn} {/top_vlg_tst/i1/f2a_fifo_inst/Data} {/top_vlg_tst/i1/f2a_fifo_inst/WCNT} {/top_vlg_tst/i1/f2a_fifo_inst/RdClock} {/top_vlg_tst/i1/f2a_fifo_inst/RdEn} {/top_vlg_tst/i1/f2a_fifo_inst/Q} {/top_vlg_tst/i1/f2a_fifo_inst/Empty} {/top_vlg_tst/i1/f2a_fifo_inst/Full}
add wave -noreg -vgroup "AFE:TX"  {/top_vlg_tst/i1/afe_inst/reset_n} {/top_vlg_tst/i1/afe_inst/tx_sclk_2x} {/top_vlg_tst/i1/afe_inst/tx_fifo_empty} {/top_vlg_tst/i1/afe_inst/tx_fifo_req} {/top_vlg_tst/i1/afe_inst/tx_fifo_clk} {/top_vlg_tst/i1/afe_inst/tx_fifo_data} {/top_vlg_tst/i1/afe_inst/tx_valid_pair} {/top_vlg_tst/i1/afe_inst/tx_output_mask} {/top_vlg_tst/i1/afe_inst/tx_clk_2x} {/top_vlg_tst/i1/afe_inst/tx_d} {/top_vlg_tst/i1/afe_inst/tx_sel}
add wave -noreg -vgroup "AFE:RX"  {/top_vlg_tst/i1/afe_inst/rx_clk_2x} {/top_vlg_tst/i1/afe_inst/rx_fifo_clk} {/top_vlg_tst/i1/afe_inst/rx_fifo_full} {/top_vlg_tst/i1/afe_inst/rx_fifo_wr} {/top_vlg_tst/i1/afe_inst/rx_fifo_data} {/top_vlg_tst/i1/afe_inst/rx_sclk_2x} {/top_vlg_tst/i1/afe_inst/rx_sel} {/top_vlg_tst/i1/afe_inst/rx_d}
cursor "Cursor 1" 628213ps  
transcript on
