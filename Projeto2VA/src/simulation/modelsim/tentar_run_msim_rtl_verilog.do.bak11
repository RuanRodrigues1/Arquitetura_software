transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/ULA.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/regfile.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/PC.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/mux2x1.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/extensor_de_sinal.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/mips_processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/ULA_CTRL.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/d_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/i_mem.v}

vlog -vlog01compat -work work +incdir+C:/Users/davip/Desktop/Projeto\ MIPS\ -\ AOC {C:/Users/davip/Desktop/Projeto MIPS - AOC/tb_mips_processor.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_mips_processor

add wave *
view structure
view signals
run -all
