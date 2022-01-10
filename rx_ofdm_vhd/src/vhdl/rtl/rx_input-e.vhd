-------------------------------------------------------------------------------
-- Title      : rx_input entity
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_input-e.vhd
-- Author     : Thomas  Bauernfeind
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2021-12-13
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
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

entity rx_input is
  port (
   sys_clk_i          : in    std_ulogic;
   sys_reset_i        : in    std_ulogic;
   rx_data_i_i        : in    signed(11 downto 0);
   rx_data_q_i        : in    signed(11 downto 0);
   rx_data_valid_i    : in    std_ulogic;
   rx_data_start_i    : in    std_ulogic; 
   delta_freq_i       : in    signed(10 downto 0); 
   delta_phase_i      : in    signed(10 downto 0);
   delta_t_i          : in    signed(2 downto 0);
   tracking_valid_i   : in    std_ulogic;
   rx_data_hi_i_o     : out   signed(11 downto 0);
   rx_data_hi_q_o     : out   signed(11 downto 0);
   rx_data_hi_valid_o : out   std_ulogic;
   rx_data_i_o        : out   signed(11 downto 0);
   rx_data_q_o        : out   signed(11 downto 0);
   rx_data_first_o    : out   std_ulogic;
   rx_data_valid_o    : out   std_ulogic
  );
end rx_input;
