onerror {exit -code 1}
vlib work
vlog -work work tentar.vo
vlog -work work Waveform.vwf.vt
vsim -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.mips_processor_vlg_vec_tst
vcd file -direction tentar.msim.vcd
vcd add -internal mips_processor_vlg_vec_tst/*
vcd add -internal mips_processor_vlg_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
