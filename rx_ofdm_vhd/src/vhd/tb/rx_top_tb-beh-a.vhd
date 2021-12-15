-------------------------------------------------------------------------------
-- Title        : RX Implementation top-level testbench 
-- Project    : DTL3 
-------------------------------------------------------------------------------
-- File          : rx_top_tb-beh-a.vhd
-- Author     : Thomas Bauernfeind
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2021-12-13
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
use std.textio.all;


architecture beh of rx_top_tb is
  file rx_data_f   : text;
  file rx_bits_f   : text;

  
  signal sys_clk_s, sys_reset_s  : std_ulogic := '0';
  signal rx_data_i_s, rx_data_q_s: signed(11 downto 0);
  signal rx_data_valid_s         : std_ulogic;
  signal rx_bits_s               : std_ulogic_vector(1 downto 0);
  signal rx_bits_valid_s         : std_ulogic;


  component rx_top
    port (
      sys_clk_i       : in std_ulogic;
      sys_reset_i     : in std_ulogic;
      rx_data_i_i     : in signed(11 downto 0);
      rx_data_q_i     : in signed(11 downto 0);
      rx_data_valid_i : in std_ulogic;
      rx_bits_o       : out std_ulogic_vector(1 downto 0);
      rx_bits_valid_o : out std_ulogic);
  end component;
  
begin  --beh

  sys_clk_s   <= not(sys_clk_s) after 6250 ps;
  sys_reset_s <= '1' after 100 ns;

  --rx_top instance
  rx_top_1: rx_top
    port map (
      sys_clk_i       => sys_clk_s,
      sys_reset_i     => sys_reset_s,
      rx_data_i_i     => rx_data_i_s,
      rx_data_q_i     => rx_data_q_s,
      rx_data_valid_i => rx_data_valid_s,
      rx_bits_o       => rx_bits_s,
      rx_bits_valid_o => rx_bits_valid_s);
  
  --read rx_data
  rx_data_file_proc: process
    variable line_v : line;
    variable cycle_cnt_v, i_v, q_v : integer := 0;
  begin
    
    file_open(rx_data_f,"rx_data.txt", read_mode);

    while not(endfile(rx_data_f)) loop
      wait until (sys_clk_s='1' and sys_reset_s='1');
      cycle_cnt_v := cycle_cnt_v+1;    
      if (cycle_cnt_v=5) then
        readline(rx_data_f,line_v);
        read(line_v,i_v);
        read(line_v,q_v);
        rx_data_valid_s <= '1';
        rx_data_i_s <= to_signed(i_v,12);
        rx_data_q_s <= to_signed(q_v,12);
        cycle_cnt_v:=0;
      else
        rx_data_valid_s<='0';
      end if;      
    end loop;
    file_close(rx_data_f);
    wait;
  end process;

  --write rx bits
  rx_bits_file_proc: process
    variable line_v : line;
    constant space_c : string := " ";
    variable rx_bits_count_v : integer := 0;
    variable line_count_v    : integer := 0;
    constant rx_bits_count_c : integer := 128*2*21;
    
  begin
    
    file_open(rx_bits_f,"rx_bits.txt", write_mode);

    while (rx_bits_count_v < rx_bits_count_c) loop
      wait until (sys_clk_s='1' and rx_bits_valid_s='1');
      
      write(line_v, to_bitvector(rx_bits_s));
      write(line_v, character(' '));     
      line_count_v   := line_count_v+1;
      rx_bits_count_v := rx_bits_count_v+1;
      
      if (line_count_v=128) then
        writeline(rx_bits_f,line_v);
        line_count_v:=0;
      end if;
    
    end loop;

    file_close(rx_bits_f);
    
    wait;
  end process;

end beh;



