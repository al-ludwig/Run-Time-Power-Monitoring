onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/s_clk
add wave -noupdate /tb_top/s_en
add wave -noupdate /tb_top/s_reset_n
add wave -noupdate /tb_top/s_RAM_ADDR
add wave -noupdate /tb_top/s_RAM_DATA_IN
add wave -noupdate /tb_top/s_RAM_WR
add wave -noupdate /tb_top/s_RAM_DATA_OUT
add wave -noupdate /tb_top/s_p_dyn
add wave -noupdate /tb_top/s_activity
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
configure wave -valuecolwidth 179
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
WaveRestoreZoom {8845 ns} {10061 ns}
