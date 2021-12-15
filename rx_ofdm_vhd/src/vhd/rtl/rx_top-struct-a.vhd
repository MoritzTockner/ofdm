-------------------------------------------------------------------------------
-- Title      : RX top architecture
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_top-struct-a.vhd
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

architecture struct of rx_top is

  component rx_input
    port (
      sys_clk_i          : in  std_ulogic;
      sys_reset_i        : in  std_ulogic;
      rx_data_i_i        : in  signed(11 downto 0);
      rx_data_q_i        : in  signed(11 downto 0);
      rx_data_valid_i    : in  std_ulogic;
      rx_data_start_i    : in  std_ulogic;
      delta_freq_i       : in  signed(10 downto 0);
      delta_phase_i      : in  signed(10 downto 0);
      delta_t_i          : in  signed(2 downto 0);
      tracking_valid_i   : in  std_ulogic;
      rx_data_hi_i_o     : out signed(11 downto 0);
      rx_data_hi_q_o     : out signed(11 downto 0);
      rx_data_hi_valid_o : out std_ulogic;
      rx_data_i_o        : out signed(11 downto 0);
      rx_data_q_o        : out signed(11 downto 0);
      rx_data_first_o    : out std_ulogic;
      rx_data_valid_o    : out std_ulogic);
  end component;

  component rx_sync
    port (
      sys_clk_i       : in  std_ulogic;
      sys_reset_i     : in  std_ulogic;
      rx_data_i_i     : in  signed(11 downto 0);
      rx_data_q_i     : in  signed(11 downto 0);
      rx_data_valid_i : in  std_ulogic;
      delta_freq_o    : out signed(10 downto 0);
      rx_data_start_o : out std_ulogic);
  end component;

  component rx_fft
    port (
      sys_clk_i       : in  std_ulogic;
      sys_reset_i     : in  std_ulogic;
      rx_data_i_i     : in  signed(11 downto 0);
      rx_data_q_i     : in  signed(11 downto 0);
      rx_data_valid_i : in  std_ulogic;
      rx_data_first_i : in  std_ulogic;
      rx_fft_i_o      : out signed(11 downto 0);
      rx_fft_q_o      : out signed(11 downto 0);
      rx_fft_valid_o  : out std_ulogic;
      rx_fft_first_o  : out std_ulogic);
  end component;

  component rx_equalize
    port (
      sys_clk_i       : in  std_ulogic;
      sys_reset_i     : in  std_ulogic;
      rx_data_i_i     : in  signed(11 downto 0);
      rx_data_q_i     : in  signed(11 downto 0);
      rx_data_valid_i : in  std_ulogic;
      rx_data_first_i : in  std_ulogic;
      rx_data_i_o     : out signed(11 downto 0);
      rx_data_q_o     : out signed(11 downto 0);
      rx_data_valid_o : out std_ulogic;
      rx_data_first_o : out std_ulogic);
  end component;

  component rx_tracking
    port (
      sys_clk_i       : in std_ulogic;
      sys_reset_i     : in std_ulogic;
      rx_data_i_i     : in signed(11 downto 0);
      rx_data_q_i     : in signed(11 downto 0);
      rx_data_valid_i : in std_ulogic;
      rx_data_first_i : in std_ulogic;
      delta_phase_o   : out signed(10 downto 0);
      delta_t_o       : out signed(2 downto 0);
      tracking_valid_o: out std_ulogic );
  end component;
  
  component rx_demodulation
    port (
      sys_clk_i       : in  std_ulogic;
      sys_reset_i     : in  std_ulogic;
      rx_data_i_i     : in  signed(11 downto 0);
      rx_data_q_i     : in  signed(11 downto 0);
      rx_data_valid_i : in  std_ulogic;
      rx_data_first_i : in  std_ulogic;
      rx_bits_o       : out std_ulogic_vector(1 downto 0);
      rx_bits_valid_o : out std_ulogic);
  end component;

  --signals for wiring
  signal  rx_data_start_s          :  std_ulogic;
  signal  delta_freq_s             :  signed(10 downto 0);
  signal  delta_phase_s            :  signed(10 downto 0);
  signal  delta_t_s                :  signed(2 downto 0);
  signal  tracking_valid_s         :  std_ulogic;
  signal  rx_data_input_i_s        :  signed(11 downto 0);
  signal  rx_data_input_q_s        :  signed(11 downto 0);
  signal  rx_data_input_first_s    :  std_ulogic;
  signal  rx_data_input_valid_s    :  std_ulogic;
  signal  rx_data_input_hi_i_s     :  signed(11 downto 0);
  signal  rx_data_input_hi_q_s     :  signed(11 downto 0);
  signal  rx_data_input_hi_valid_s :  std_ulogic;
  signal  rx_fft_i_s               :  signed(11 downto 0);
  signal  rx_fft_q_s	           :  signed(11 downto 0);
  signal  rx_fft_valid_s           :  std_ulogic;
  signal  rx_fft_first_s           :  std_ulogic;
  signal  rx_data_equalize_i_s     :  signed(11 downto 0);
  signal  rx_data_equalize_q_s	   :  signed(11 downto 0);
  signal  rx_data_equalize_valid_s :  std_ulogic;
  signal  rx_data_equalize_first_s :  std_ulogic;

  
begin --struct

  rx_input_1: rx_input
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_data_i_i,
      rx_data_q_i     => rx_data_q_i,
      rx_data_valid_i => rx_data_valid_i,
      rx_data_start_i => rx_data_start_s, 
      delta_freq_i    => delta_freq_s,
      delta_phase_i   => delta_phase_s,
      delta_t_i       => delta_t_s,
      tracking_valid_i=> tracking_valid_s,
      rx_data_i_o     => rx_data_input_i_s,
      rx_data_q_o     => rx_data_input_q_s,
      rx_data_first_o => rx_data_input_first_s,
      rx_data_valid_o => rx_data_input_valid_s);

  rx_sync_1: rx_sync
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_data_input_hi_i_s,
      rx_data_q_i     => rx_data_input_hi_q_s,
      rx_data_valid_i => rx_data_input_hi_valid_s,
      delta_freq_o    => delta_freq_s,
      rx_data_start_o => rx_data_start_s);

  
  rx_fft_1: rx_fft
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_data_input_i_s,
      rx_data_q_i     => rx_data_input_q_s,
      rx_data_valid_i => rx_data_input_valid_s,
      rx_data_first_i => rx_data_input_first_s,
      rx_fft_i_o      => rx_fft_i_s,
      rx_fft_q_o      => rx_fft_q_s,
      rx_fft_valid_o  => rx_fft_valid_s,
      rx_fft_first_o  => rx_fft_first_s);

  rx_equalize_1: rx_equalize
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_fft_i_s,
      rx_data_q_i     => rx_fft_q_s,
      rx_data_valid_i => rx_fft_valid_s,
      rx_data_first_i => rx_fft_first_s,
      rx_data_i_o     => rx_data_equalize_i_s,
      rx_data_q_o     => rx_data_equalize_q_s,
      rx_data_valid_o => rx_data_equalize_valid_s,
      rx_data_first_o => rx_data_equalize_first_s);

  
  rx_tracking_1: rx_tracking
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_data_equalize_i_s,
      rx_data_q_i     => rx_data_equalize_q_s,
      rx_data_valid_i => rx_data_equalize_valid_s,
      rx_data_first_i => rx_data_equalize_first_s,
      delta_phase_o   => delta_phase_s,
      delta_t_o       => delta_t_s,
      tracking_valid_o=> tracking_valid_s);

  rx_demodulation_1: rx_demodulation
    port map (
      sys_clk_i       => sys_clk_i,
      sys_reset_i     => sys_reset_i,
      rx_data_i_i     => rx_data_equalize_i_s,
      rx_data_q_i     => rx_data_equalize_q_s,
      rx_data_valid_i => rx_data_equalize_valid_s,
      rx_data_first_i => rx_data_equalize_first_s,
      rx_bits_o       => rx_bits_o,
      rx_bits_valid_o => rx_bits_valid_o);

  
end struct;  -- of rx_top

