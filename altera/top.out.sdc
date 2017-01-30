## Generated SDC file "top.out.sdc"

## Copyright (C) 2016  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.1 Build 200 11/30/2016 SJ Lite Edition"

## DATE    "Fri Jan 27 18:07:09 2017"

##
## DEVICE  "10M08SAU169C8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {ft_clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports { ft_clk }]
create_clock -name {clk_sr1} -period 12.500 -waveform { 0.000 6.250 } [get_ports {clk_sr1 }]
create_clock -name {clk_sr2} -period 12.500 -waveform { 0.000 6.250 } [get_ports {clk_sr2 }]
create_clock -name {afe:afe_inst|rx_fifo_clk} -period 25.000 -waveform { 0.000 12.500 } [get_nets {afe_inst|rx_fifo_clk}]
create_clock -name {afe:afe_inst|tx_fifo_clk} -period 25.000 -waveform { 0.000 12.500 } [get_nets {afe_inst|tx_fifo_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ft_clk}] -rise_to [get_clocks {ft_clk}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {ft_clk}] -fall_to [get_clocks {ft_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ft_clk}] -rise_to [get_clocks {ft_clk}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {ft_clk}] -fall_to [get_clocks {ft_clk}]  0.070  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[0]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[1]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[2]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[3]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[4]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[5]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[6]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[7]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[8]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[9]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[10]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[11]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[12]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[13]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[14]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[15]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[16]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[17]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[18]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[19]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[20]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[21]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[22]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[23]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[24]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[25]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[26]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[27]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[28]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[29]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[30]}]
set_input_delay -add_delay -rise -min -clock [get_clocks {ft_clk}]  3.000 [get_ports {ft_data[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_oci_break:the_system_nios2_gen2_0_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_oci_debug:the_system_nios2_gen2_0_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[33]}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_oci_debug:the_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[0]}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_oci_debug:the_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[34]}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_ocimem:the_system_nios2_gen2_0_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_tck:the_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_sysclk:the_system_nios2_gen2_0_cpu_debug_slave_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_debug_slave_wrapper:the_system_nios2_gen2_0_cpu_debug_slave_wrapper|system_nios2_gen2_0_cpu_debug_slave_sysclk:the_system_nios2_gen2_0_cpu_debug_slave_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*system_nios2_gen2_0_cpu:*|system_nios2_gen2_0_cpu_nios2_oci:the_system_nios2_gen2_0_cpu_nios2_oci|system_nios2_gen2_0_cpu_nios2_oci_debug:the_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_go}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_jd9:dffpipe12|dffe13a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_kd9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_id9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe13|dffe14a*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] 100.000
set_max_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] 100.000


#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] -100.000
set_min_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] -100.000


#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

set_net_delay -max 2.000 -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}]
set_net_delay -max 2.000 -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}]
