clean:
	-rd /s /q work
	-del transcript
	-del vsim.wlf
	-del data\*.wlf

do_ac: clean
	vlib work
	vcom -explicit -2008 -check_synthesis ..\..\src\activitycounter.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\tb_ac.vhd -work work
do_calc: clean
	vlib work
	vcom -explicit -2008 -check_synthesis ..\..\src\calc.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\tb_calc.vhd -work work
do_arith: clean
	vlib work
	vcom -explicit -2008 -check_synthesis ..\..\src\fxd_arith.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\tb_fxd_arith.vhd -work work
do_top: clean
	vlib work
	vcom -explicit -2008 -check_synthesis ..\..\src\activitycounter.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\..\src\calc.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\..\src\Single_port_RAM_VHDL.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\..\src\top.vhd -work work
	vcom -explicit -2008 -check_synthesis ..\tb_top.vhd -work work

run_ac: do_ac
	vsim -do data/ac.do -do "run 1 us" tb_ac
run_calc: do_calc
	vsim -do data/calc.do -do "run 1 us" tb_calc
run_arith: do_arith
	vsim -do data/arith.do -do "run 100 ms" tb_fxd_arith
run_top: do_top
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