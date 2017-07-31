onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_vlg_tst/clk_in
add wave -noupdate /top_vlg_tst/reset_n
add wave -noupdate /top_vlg_tst/i1/pll_inst/locked
add wave -noupdate /top_vlg_tst/clk26
add wave -noupdate /top_vlg_tst/i1/clk_main
add wave -noupdate -divider FT600
add wave -noupdate /top_vlg_tst/ft_clk
add wave -noupdate /top_vlg_tst/ft_rxf_n
add wave -noupdate -radix hexadecimal /top_vlg_tst/treg_ft_data
add wave -noupdate -radix hexadecimal /top_vlg_tst/ft_data
add wave -noupdate -radix hexadecimal /top_vlg_tst/ft_be
add wave -noupdate /top_vlg_tst/ft_oe_n
add wave -noupdate /top_vlg_tst/ft_rd_n
add wave -noupdate /top_vlg_tst/ft_wr_n
add wave -noupdate /top_vlg_tst/ft_txe_n
add wave -noupdate /top_vlg_tst/i1/fsm_inst/write_mode
add wave -noupdate -divider F2A_FIFO
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/aclr
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/wrclk
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/wrreq
add wave -noupdate -radix hexadecimal -childformat {{{/top_vlg_tst/i1/f2a_fifo_inst/data[23]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[22]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[21]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[20]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[19]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[18]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[17]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[16]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[15]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[14]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[13]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[12]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[11]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[10]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[9]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[8]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[7]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[6]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[5]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[4]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[3]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[2]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[1]} -radix hexadecimal} {{/top_vlg_tst/i1/f2a_fifo_inst/data[0]} -radix hexadecimal}} -subitemconfig {{/top_vlg_tst/i1/f2a_fifo_inst/data[23]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[22]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[21]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[20]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[19]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[18]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[17]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[16]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[15]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[14]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[13]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[12]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[11]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[10]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[9]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[8]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[7]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[6]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[5]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[4]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[3]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[2]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[1]} {-height 17 -radix hexadecimal} {/top_vlg_tst/i1/f2a_fifo_inst/data[0]} {-height 17 -radix hexadecimal}} /top_vlg_tst/i1/f2a_fifo_inst/data
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/rdclk
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/rdreq
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/f2a_fifo_inst/q
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/rdempty
add wave -noupdate /top_vlg_tst/i1/f2a_fifo_inst/wrfull
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/f2a_fifo_inst/wrusedw
add wave -noupdate -divider A2F_FIFO
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/a2f_fifo_inst/data
add wave -noupdate /top_vlg_tst/i1/a2f_fifo_inst/rdclk
add wave -noupdate /top_vlg_tst/i1/a2f_fifo_inst/rdreq
add wave -noupdate /top_vlg_tst/i1/a2f_fifo_inst/wrclk
add wave -noupdate /top_vlg_tst/i1/a2f_fifo_inst/wrreq
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/a2f_fifo_inst/q
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/a2f_fifo_inst/rdusedw
add wave -noupdate /top_vlg_tst/i1/a2f_fifo_inst/wrfull
add wave -noupdate -divider AFETX
add wave -noupdate /top_vlg_tst/i1/afe_inst/tx_sclk_2x
add wave -noupdate /top_vlg_tst/i1/afe_inst/tx_clk_2x
add wave -noupdate /top_vlg_tst/i1/afe_inst/tx_fifo_req
add wave -noupdate /top_vlg_tst/afe_tx_clk
add wave -noupdate /top_vlg_tst/afe_tx_sel
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/afe_inst/tx_fifo_data
add wave -noupdate -radix hexadecimal /top_vlg_tst/afe_tx_d
add wave -noupdate /top_vlg_tst/i1/afe_inst/tx_valid_pair
add wave -noupdate -divider AFERX
add wave -noupdate /top_vlg_tst/afe_rx_clk
add wave -noupdate /top_vlg_tst/afe_rx_sel
add wave -noupdate -radix hexadecimal /top_vlg_tst/afe_rx_i
add wave -noupdate -radix hexadecimal /top_vlg_tst/afe_rx_q
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/afe_inst/rx_low_part
add wave -noupdate -radix hexadecimal /top_vlg_tst/afe_rx_d
add wave -noupdate -radix hexadecimal /top_vlg_tst/i1/afe_inst/rx_fifo_data
add wave -noupdate /top_vlg_tst/i1/afe_inst/rx_fifo_clk
add wave -noupdate /top_vlg_tst/i1/afe_inst/rx_fifo_wr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10074768 ps} 0} {{Cursor 2} {420744 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {170454 ps} {771990 ps}
