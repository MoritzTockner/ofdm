onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rx_top_tb/sys_clk_s
add wave -noupdate /rx_top_tb/sys_reset_s
add wave -noupdate -format Analog-Step -height 84 -max 1382.0 -min -1683.0 /rx_top_tb/rx_data_i_s
add wave -noupdate -format Analog-Step -height 84 -max 1365.0 -min -1351.0 /rx_top_tb/rx_data_q_s
add wave -noupdate /rx_top_tb/rx_data_valid_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1697158 ns} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {5250 us}
