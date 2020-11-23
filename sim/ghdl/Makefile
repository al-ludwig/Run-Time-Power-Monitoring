.PHONY: run

run:
	@echo ""
	@echo "*********************************************"
	@echo "Activity Counter Simulation"
	@echo "*********************************************"
	@echo ""
	cd ../../src && ghdl -a activitycounter.vhd
	cd .. && ghdl -a --workdir=../src tb_ac.vhd
	cd .. && ghdl -e --workdir=../src tb_ac
	cd .. && ghdl -r --workdir=../src tb_ac --stop-time=10us --vcd=./ghdl/tb_ac.vcd
	gtkwave tb_ac.vcd tb_ac_wave.gtkw
	cd ../../src && rm -f *.cf