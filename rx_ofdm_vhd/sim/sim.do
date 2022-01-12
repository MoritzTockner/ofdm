vlib work


vcom ../syn/fft_ofdm/simulation/fft_ofdm.vhd
vcom ../src/vhdl/rtl/rx_fft_wrapper-ae.vhd
vcom ../src/vhdl/rtl/rx_fft-e.vhd
vcom ../src/vhdl/beh/rx_fft-beh-a.vhd
vcom ../src/vhdl/tb/tb_fft.vhd

do comp_ip-fft.do

set TOP_LEVEL_NAME fft_tb
elab
#vsim fft_tb

if {[file exists wave_tb.do]} {
  do wave_tb.do
}

run -all

