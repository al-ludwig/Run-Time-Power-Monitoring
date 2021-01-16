onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider const
add wave -noupdate -color {Spring Green} /rtpm_pkg/max_error
add wave -noupdate -color {Spring Green} -radix symbolic /rtpm_pkg/coeff_fxd_c
add wave -noupdate -color {Spring Green} /rtpm_pkg/res_fxd_c
add wave -noupdate -color {Spring Green} /rtpm_pkg/activity_data_width_c
add wave -noupdate -color {Spring Green} /rtpm_pkg/reset_interval_c
add wave -noupdate -color {Spring Green} /rtpm_pkg/clk_freq_c
add wave -noupdate -divider top
add wave -noupdate -color Gold /tb_top/s_clk
add wave -noupdate -color Gold /tb_top/s_en
add wave -noupdate -color Gold /tb_top/s_reset_n
add wave -noupdate -color Gold /tb_top/s_ram_wr
add wave -noupdate -color {Medium Orchid} -radix unsigned /tb_top/s_ram_addr
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_top/s_ram_data_in
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_top/s_ram_data_out
add wave -noupdate -divider ac
add wave -noupdate -format Event /tb_top/uut/dut_ac/s_inp
add wave -noupdate -color Aquamarine -radix unsigned /tb_top/uut/dut_ac/s_reset_cnt
add wave -noupdate -color Coral -radix unsigned /tb_top/uut/dut_ac/result
add wave -noupdate -divider calc
add wave -noupdate -color Coral -radix unsigned /tb_top/uut/dut_calc/activity
add wave -noupdate -color {Spring Green} /tb_top/uut/dut_calc/multiplier
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_top/uut/dut_calc/p_dyn
add wave -noupdate -divider top_out
add wave -noupdate -color {Medium Orchid} /tb_top/s_p_dyn_real
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {674629 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 67
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {10500 ns}
