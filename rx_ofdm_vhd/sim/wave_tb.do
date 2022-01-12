onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_tb/sys_clk_s
add wave -noupdate /fft_tb/sys_reset_s
add wave -noupdate -format Analog-Step -height 84 -max 1006.9999999999999 -min -748.0 -radix decimal /fft_tb/rx_data_i_s
add wave -noupdate -format Analog-Step -height 84 -max 1024.0 -min -787.0 -radix decimal /fft_tb/rx_data_q_s
add wave -noupdate /fft_tb/rx_data_valid_s
add wave -noupdate /fft_tb/rx_data_first_s
add wave -noupdate /fft_tb/State
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87770246 ps} 0}
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
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {87548150 ps} {89596150 ps}
