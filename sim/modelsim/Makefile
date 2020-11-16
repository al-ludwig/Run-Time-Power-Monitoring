clean:
	-rd /s /q work
	-del transcript
	-del vsim.wlf
	-del data\vsim.wlf

do: clean
	vlib work
	vcom -explicit -93 -check_synthesis ..\..\src\activitycounter.vhd -work work
	vcom -explicit -93 -check_synthesis ..\tb_ac.vhd -work work

run: do
	vsim -do data/ac.do -do "run 10 us" tb_ac

save:
	-del data\vsim.wlf
	-move vsim.wlf data\vsim.wlf

view:
	vsim -view data\vsim.wlf -do data\ac.do