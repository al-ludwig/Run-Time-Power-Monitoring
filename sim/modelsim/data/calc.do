onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /tb_calc/s_clk
add wave -noupdate -color Gold /tb_calc/s_reset_n
add wave -noupdate -color Gold /tb_calc/s_en
add wave -noupdate -radix unsigned /tb_calc/s_activity
add wave -noupdate -color {Medium Orchid} -radix hexadecimal /tb_calc/s_p_dyn
add wave -noupdate -color {Medium Orchid} /tb_calc/s_p_dyn_real
add wave -noupdate -divider Generic
add wave -noupdate -color {Slate Blue} /tb_calc/uut/multiplier
add wave -noupdate -color {Slate Blue} /tb_calc/uut/input_width
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {39037 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {262500 ps}
