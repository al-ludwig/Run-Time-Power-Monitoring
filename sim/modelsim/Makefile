clean:
	-rd /s /q work
	-del transcript
	-del vsim.wlf
	-del data\*.wlf
################################################################################
sel_lib: 
	vlib work
################################################################################
do_base_files:
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\fxd_arith_pkg.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\rtpm_pkg.vhd -work work
################################################################################
do_arith_files:
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_fxd_arith_pkg.vhd -work work

do_arith: clean sel_lib do_base_files do_arith_files

run_arith: do_arith
	vsim -do data/arith.do -do "run 100 ms" tb_fxd_arith_pkg
################################################################################
do_ac_files:
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\ac.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_ac.vhd -work work

do_ac: clean sel_lib do_base_files do_ac_files

run_ac: do_ac
	vsim -do data/ac.do -do "run 2 us" tb_ac
################################################################################
do_calc_files:
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\calc.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_calc.vhd -work work

do_calc: clean sel_lib do_base_files do_calc_files

run_calc: do_calc
	vsim -do data/calc.do -do "run 100 ms" tb_calc
################################################################################
do_top_files:
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\sp_ram.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\top.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_top.vhd -work work

do_top: clean sel_lib do_base_files do_arith_files do_ac_files do_calc_files do_top_files

run_top: do_top
	vsim -do data/top.do -do "run 10 us" tb_top
################################################################################
do: clean sel_lib do_base_files do_arith_files do_ac_files do_calc_files do_top_files