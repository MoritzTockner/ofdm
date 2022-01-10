-------------------------------------------------------------------------------
-- Title        : RX Implementation top-level testbench 
-- Project    : DTL3 
-------------------------------------------------------------------------------
-- File          : rx_top_tb-e.vhd
-- Author     : Thomas Bauernfeind
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-10
-- Platform   : 
-- Standard   : VHDL93
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-12-13  1.0      bauernfe	Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fft_tb is
end fft_tb;


architecture beh of fft_tb is
  
  signal sys_clk_s, sys_reset_s  : std_ulogic := '0';
  signal rx_data_i_s, rx_data_q_s: signed(11 downto 0) := (others => '0');
  signal rx_data_valid_s         : std_ulogic := '0';
  signal rx_data_first_s         : std_ulogic := '0';
  signal rx_bits_s               : std_ulogic_vector(1 downto 0) := (others => '0');
  signal rx_fft_i_s, rx_fft_q_s: signed(11 downto 0) := (others => '0');
  signal rx_fft_valid_s, rx_fft_first_s         : std_ulogic := '0';
  
  
begin  --beh

  sys_clk_s   <= not(sys_clk_s) after 6250 ps;
  sys_reset_s <= '1' after 100 ns;

  --rx_top instance
  rx_fft_1: entity work.rx_fft
    port map (
      sys_clk_i       => sys_clk_s,
      sys_reset_i     => sys_reset_s,
      rx_data_i_i     => rx_data_i_s,
      rx_data_q_i     => rx_data_q_s,
      rx_data_valid_i => rx_data_valid_s,
      rx_data_first_i => rx_data_first_s,
      rx_fft_i_o      => rx_fft_i_s,
      rx_fft_q_o      => rx_fft_q_s,
      rx_fft_valid_o  => rx_fft_valid_s,
      rx_fft_first_o  => rx_fft_first_s);
    
 
  Stimuli : process
  begin  -- process Stimuli
   
 
    wait for 125 ns;
    rx_data_valid_s <= '1';
    rx_data_first_s <= '1';
    wait for 12.5 ns;
    rx_data_first_s <= '0';
    wait for 1587.500 ns;
    rx_data_valid_s <= '0';
    

    wait;
  end process;
  
end beh;



