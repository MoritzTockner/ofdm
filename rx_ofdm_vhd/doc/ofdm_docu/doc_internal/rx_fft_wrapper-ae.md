# Entity: rx_fft_wrapper 

- **File**: rx_fft_wrapper-ae.vhd
## Diagram

![Diagram](rx_fft_wrapper-ae.svg "Diagram")
## Ports

| Port name      | Direction | Type                             | Description |
| -------------- | --------- | -------------------------------- | ----------- |
| clk_i          | in        | std_ulogic                       |             |
| reset_n_i      | in        | std_ulogic                       |             |
| sink_valid_i   | in        | std_ulogic                       |             |
| sink_ready_o   | out       | std_ulogic                       |             |
| sink_error_i   | in        | std_ulogic_vector(1 downto 0)    |             |
| sink_sop_i     | in        | std_ulogic                       |             |
| sink_eop_i     | in        | std_ulogic                       |             |
| sink_real_i    | in        | std_ulogic_vector(12-1 downto 0) |             |
| sink_imag_i    | in        | std_ulogic_vector(12-1 downto 0) |             |
| source_valid_o | out       | std_ulogic                       |             |
| source_ready_i | in        | std_ulogic                       |             |
| source_error_o | out       | std_ulogic_vector(1 downto 0)    |             |
| source_sop_o   | out       | std_ulogic                       |             |
| source_eop_o   | out       | std_ulogic                       |             |
| source_real_o  | out       | std_ulogic_vector(12-1 downto 0) |             |
| source_imag_o  | out       | std_ulogic_vector(12-1 downto 0) |             |
| source_exp_o   | out       | std_ulogic_vector(5 downto 0)    |             |
## Signals

| Name        | Type                           | Description |
| ----------- | ------------------------------ | ----------- |
| source_real | std_ulogic_vector(11 downto 0) |             |
| source_imag | std_ulogic_vector(11 downto 0) |             |
| sink_real   | std_ulogic_vector(11 downto 0) |             |
| sink_imag   | std_ulogic_vector(11 downto 0) |             |
## Instantiations

- inst_ofdm: component fft_ofdm
