# Entity: fft_ofdm 

- **File**: fft_ofdm.vhd
## Diagram

![Diagram](fft_ofdm.svg "Diagram")
## Ports

| Port name    | Direction | Type                          | Description |
| ------------ | --------- | ----------------------------- | ----------- |
| clk          | in        | std_logic                     |             |
| reset_n      | in        | std_logic                     |             |
| sink_valid   | in        | std_logic                     |             |
| sink_ready   | out       | std_logic                     |             |
| sink_error   | in        | std_logic_vector(1 downto 0)  |             |
| sink_sop     | in        | std_logic                     |             |
| sink_eop     | in        | std_logic                     |             |
| sink_real    | in        | std_logic_vector(11 downto 0) |             |
| sink_imag    | in        | std_logic_vector(11 downto 0) |             |
| inverse      | in        | std_logic_vector(0 downto 0)  |             |
| source_valid | out       | std_logic                     |             |
| source_ready | in        | std_logic                     |             |
| source_error | out       | std_logic_vector(1 downto 0)  |             |
| source_sop   | out       | std_logic                     |             |
| source_eop   | out       | std_logic                     |             |
| source_real  | out       | std_logic_vector(11 downto 0) |             |
| source_imag  | out       | std_logic_vector(11 downto 0) |             |
| source_exp   | out       | std_logic_vector(5 downto 0)  |             |
