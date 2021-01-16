onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {small number}
add wave -noupdate /tb_fxd_arith_pkg/coeff_fxd_c
add wave -noupdate -color Coral /tb_fxd_arith_pkg/small_real
add wave -noupdate -color Magenta -height 20 -radix hexadecimal /tb_fxd_arith_pkg/small_fxd
add wave -noupdate -divider {normal number}
add wave -noupdate /tb_fxd_arith_pkg/coeff_fxd_c
add wave -noupdate -color Coral /tb_fxd_arith_pkg/norm_real
add wave -noupdate -color Magenta -radix hexadecimal /tb_fxd_arith_pkg/norm_fxd
add wave -noupdate -divider {Mult result}
add wave -noupdate -color Green -radix symbolic -childformat {{/tb_fxd_arith_pkg/res_fxd_c.ip -radix symbolic} {/tb_fxd_arith_pkg/res_fxd_c.fp -radix symbolic} {/tb_fxd_arith_pkg/res_fxd_c.m -radix symbolic}} -subitemconfig {/tb_fxd_arith_pkg/res_fxd_c.ip {-color Green -height 15 -radix symbolic} /tb_fxd_arith_pkg/res_fxd_c.fp {-color Green -height 15 -radix symbolic} /tb_fxd_arith_pkg/res_fxd_c.m {-color Green -height 15 -radix symbolic}} /tb_fxd_arith_pkg/res_fxd_c
add wave -noupdate -color Magenta -height 20 -radix hexadecimal /tb_fxd_arith_pkg/res_fxd
add wave -noupdate -color Coral /tb_fxd_arith_pkg/res_real
add wave -noupdate -color Turquoise /tb_fxd_arith_pkg/res_back
add wave -noupdate -color Turquoise /tb_fxd_arith_pkg/conv_error
add wave -noupdate -divider <NULL>
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9988041 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 217
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
WaveRestoreZoom {0 ps} {4658 ps}
