-------------------------------------------------------------------------------
-- Title      : rx_top entity
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_top-e.vhd
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

entity rx_top is
  port (
   sys_clk_i       : in    std_ulogic;
   sys_reset_i     : in    std_ulogic;
   rx_data_i_i     : in    signed(11 downto 0);
   rx_data_q_i     : in    signed(11 downto 0);
   rx_data_valid_i : in    std_ulogic;
   rx_bits_o       : out    std_ulogic_vector(1 downto 0);
   rx_bits_valid_o : out    std_ulogic
  );
end rx_top;
