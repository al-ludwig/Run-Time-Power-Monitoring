onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TOP
add wave -noupdate -color Gold /tb_ac/s_clk
add wave -noupdate /tb_ac/s_reset_n
add wave -noupdate /tb_ac/s_inp
add wave -noupdate -color Cyan -radix unsigned /tb_ac/s_result
add wave -noupdate -divider Internal
add wave -noupdate -color Coral -radix unsigned /tb_ac/uut/s_reset_cnt
add wave -noupdate -divider Generics
add wave -noupdate -color Plum /tb_ac/uut/output_width
add wave -noupdate -color Plum /tb_ac/uut/reset_interval
add wave -noupdate -color Plum /tb_ac/uut/clk_freq
add wave -noupdate -divider Constants
add wave -noupdate -color Plum /tb_ac/uut/clk_period
add wave -noupdate -color Plum /tb_ac/uut/max_reset_cnt
add wave -noupdate -color Plum /tb_ac/uut/length_reset_cnt
add wave -noupdate -color Plum -radix unsigned /tb_ac/uut/result_max
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
configure wave -valuecolwidth 78
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
WaveRestoreZoom {0 ps} {1050 ns}
