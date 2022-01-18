# Entity: rx_fft 

- **File**: rx_fft-e.vhd
## Diagram

![Diagram](rx_fft-e.svg "Diagram")
## Ports

| Port name       | Direction | Type                | Description |
| --------------- | --------- | ------------------- | ----------- |
| sys_clk_i       | in        | std_ulogic          |             |
| sys_reset_i     | in        | std_ulogic          |             |
| rx_data_i_i     | in        | signed(11 downto 0) |             |
| rx_data_q_i     | in        | signed(11 downto 0) |             |
| rx_data_valid_i | in        | std_ulogic          |             |
| rx_data_first_i | in        | std_ulogic          |             |
| rx_fft_i_o      | out       | signed(11 downto 0) |             |
| rx_fft_q_o      | out       | signed(11 downto 0) |             |
| rx_fft_valid_o  | out       | std_ulogic          |             |
| rx_fft_first_o  | out       | std_ulogic          |             |
