.PHONY: run

run:
	@echo ""
	@echo "*********************************************"
	@echo "Activity Counter Simulation"
	@echo "*********************************************"
	@echo ""
	cd ../../src && rm -f *.cf
	cd ../../src && ghdl -a activitycounter.vhd
	ghdl -a --workdir=../../src tb_ac.vhd
	ghdl -e --workdir=../../src tb_ac
	ghdl -r --workdir=../../src tb_ac --stop-time=10us --vcd=tb_ac.vcd
	gtkwave tb_ac.vcd tb_ac_wave.gtkw