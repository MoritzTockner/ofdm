vlib work


do comp_ip-fft.do
vcom -93 ../src/vhdl/rtl/rx_fft_wrapper-ae.vhd
vcom -93 ../src/vhdl/rtl/rx_fft-e.vhd
vcom -93 ../src/vhdl/beh/rx_fft-beh-a.vhd
vcom -93 ../src/vhdl/tb/tb_fft.vhd

# vsim tb_fft