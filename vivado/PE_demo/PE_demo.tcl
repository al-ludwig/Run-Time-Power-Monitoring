start_gui
open_project C:/Users/Alexander/Documents/Master_Embedded/SoC_Lab/Run-Time-Power-Monitoring/vivado/PE_demo/PE_demo.xpr
update_compile_order -fileset sources_1
open_run synth_1 -name synth_1
set_operating_conditions -process maximum
read_saif {C:/Users/Alexander/Documents/Master_Embedded/SoC_Lab/Run-Time-Power-Monitoring/vivado/PE_demo/PE_demo.sim/sim_1/synth/func/xsim/PE_demo_func.saif}
report_power -name {power_1}