clean:
	-rd /s /q work
	-del transcript
	-del vsim.wlf
	-del data\*.wlf

do: clean
	vlib work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\fxd_arith_pkg.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\rtpm_pkg.vhd -work work

	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\ac.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\calc.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\sp_ram.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\..\src\top.vhd -work work

	vcom -explicit -2008 -quiet -check_synthesis ..\tb_ac.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_calc.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_top.vhd -work work
	vcom -explicit -2008 -quiet -check_synthesis ..\tb_fxd_arith_pkg.vhd -work work

run_ac: do
	vsim -do data/ac.do -do "run 2 us" tb_ac

run_calc: do
	vsim -do data/calc.do -do "run 1 us" tb_calc

run_arith: do
	vsim -do data/arith.do -do "run 100 ms" tb_fxd_arith_pkg

run_top: do
	vsim -do data/top.do -do "run 10 us" tb_top

save_ac:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim_ac.wlf

save_calc:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim_calc.wlf

save_arith:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim_arith.wlf

save_top:
	-del data/vsim.wlf
	-move vsim.wlf data/vsim_top.wlf

view_ac:
	vsim -view data\vsim_ac.wlf -do data\ac.do

view_calc:
	vsim -view data\vsim_calc.wlf -do data\calc.do

view_arith:
	vsim -view data\vsim_arith.wlf -do data\arith.do

view_top:
	vsim -view data/vsim_top.wlf 