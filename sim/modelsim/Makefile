clean:
	-rd /s /q work
	-del transcript
	-del vsim.wlf
	-del data\*.wlf

do_ac: clean
	vlib work
	vcom -explicit -93 -check_synthesis ..\..\src\activitycounter.vhd -work work
	vcom -explicit -93 -check_synthesis ..\tb_ac.vhd -work work
do_calc: clean
	vlib work
	vcom -explicit -93 -check_synthesis ..\..\src\calc.vhd -work work
	vcom -explicit -93 -check_synthesis ..\tb_calc.vhd -work work

run_ac: do_ac
	vsim -do data/ac.do -do "run 1 us" tb_ac
run_calc: do_calc
	vsim -do data/calc.do -do "run 1 us" tb_calc

save_ac:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim_ac.wlf
save_calc:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim_calc.wlf

view_ac:
	vsim -view data\vsim_ac.wlf -do data\ac.do
view_calc:
	vsim -view data\vsim_calc.wlf -do data\calc.do