-------------------------------------------------------------------------------
-- Title      : Testbench configuration for behavioral rx_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_top_tb_beh_cfgbeh-c.vhd
-- Author     : Thomas Bauernfeind
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



configuration rx_top_tb_beh_cfgbeh of rx_top_tb is
  for beh
    for rx_top_1 : rx_top
      use configuration work.rx_top_struct_cfgbeh;
    end for;
  end for;
end rx_top_tb_beh_cfgbeh;


