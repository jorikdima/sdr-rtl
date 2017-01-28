vsim -t 1ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -L sys -voptargs="+acc"  ft600_vlg_tst

add wave *
view structure
view signals
run 1 us
