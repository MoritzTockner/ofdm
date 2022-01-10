onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/clk_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/reset_n_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_eop_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_error_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_imag
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_imag_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_ready_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_real
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_real_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_sop_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/sink_valid_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_eop_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_error_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_exp_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_imag
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_imag_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_ready_i
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_real
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_real_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_sop_o
add wave -noupdate /fft_tb/rx_fft_1/fft_inst/source_valid_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {989718 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 308
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
WaveRestoreZoom {0 ps} {4867896 ps}
