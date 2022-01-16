# Entity: rx_fft 

- **File**: rx_fft-beh-a.vhd
## Diagram

![Diagram](rx_fft-beh-a.svg "Diagram")
## Description

 Modul FFT Handling
 use Quartus IP Core.
## Ports

| Port name       | Direction | Type                | Description                         |
| --------------- | --------- | ------------------- | ----------------------------------- |
| sys_clk_i       | in        | std_ulogic          | clk signal                          |
| sys_reset_i     | in        | std_ulogic          | reset signal active high            |
| rx_data_i_i     | in        | signed(11 downto 0) | Inphase Zeitsignal                  |
| rx_data_q_i     | in        | signed(11 downto 0) | Quatrature Zeitsignal               |
| rx_data_valid_i | in        | std_ulogic          | Output-Valid Signal for each Sample |
| rx_data_first_i | in        | std_ulogic          | Sync-Startsignal                    |
| rx_fft_i_o      | out       | signed(11 downto 0) | Inphase Frequenzberich              |
| rx_fft_q_o      | out       | signed(11 downto 0) | Quatratur Frequenzberich            |
| rx_fft_valid_o  | out       | std_ulogic          | Input Valid Signal for FFT Output   |
| rx_fft_first_o  | out       | std_ulogic          | Sync-Startsignal                    |
## Signals

| Name          | Type                          | Description         |
| ------------- | ----------------------------- | ------------------- |
| r             | aRegSet                       | start, last, cnt_in |
| nxr           | aRegSet                       | start, last, cnt_in |
| fft_isready   | std_ulogic                    |                     |
| fft_in_error  | std_ulogic_vector(1 downto 0) |                     |
| fft_out_error | std_ulogic_vector(1 downto 0) |                     |
| end_of_frame  | std_ulogic                    |                     |
| source_real   | signed(11 downto 0)           |                     |
| source_imag   | signed(11 downto 0)           |                     |
| sink_valid    | std_ulogic                    |                     |
| source_exp    | signed(5 downto 0)            |                     |
| rx_fft_valid  | std_ulogic                    |                     |
| rx_fft_first  | std_ulogic                    |                     |
## Constants

| Name           | Type       | Value                                                                                                                                                                                                                                                 | Description                                                                     |
| -------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| reset_active_c | std_ulogic | '0'                                                                                                                                                                                                                                                   |                                                                                 |
| prefetch_c     | natural    | 30                                                                                                                                                                                                                                                    |                                                                                 |
| cInitVarR      | aRegSet    | (      start => '0',<br><span style="padding-left:20px">      last   => '0',<br><span style="padding-left:20px"> --! start,<br><span style="padding-left:20px"> last,<br><span style="padding-left:20px"> cnt_in      cnt_in => (others => '0')     ) | if data_firts_i until 128 samples, Strobe after 128 samples, clount 128 damples |
## Types

| Name    | Type | Description |
| ------- | ---- | ----------- |
| aRegSet |      |             |
## Functions
- LogDualis <font id="function_arguments">(cNumber : natural) </font> <font id="function_return">return natural </font>
## Processes
- outreg: ( sys_reset_i, sys_clk_i )
- Comb: ( R, rx_data_valid_i, rx_data_first_i, fft_isready )
## Instantiations

- fft_inst: work.rx_fft_wrapper
