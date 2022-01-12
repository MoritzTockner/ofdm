-------------------------------------------------------------------------------
-- Title      : rx_fft entity
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_fft_wrapper-ae.vhd
-- Author     : Thomas  Bauernfeind
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-08  1.0      plainer Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_fft_wrapper is
  port (
    clk_i          : in  std_ulogic                       := 'X';  -- clk
    reset_n_i      : in  std_ulogic                       := 'X';  -- reset_n
    sink_valid_i   : in  std_ulogic                       := 'X';  -- sink_valid
    sink_ready_o   : out std_ulogic;    -- sink_ready
    sink_error_i   : in  std_ulogic_vector(1 downto 0)    := (others => 'X');  -- sink_error
    sink_sop_i     : in  std_ulogic                       := 'X';  -- sink_sop
    sink_eop_i     : in  std_ulogic                       := 'X';  -- sink_eop
    sink_real_i    : in  std_ulogic_vector(12-1 downto 0);  --std_ulogic_vector(12-1 downto 0) := (others => 'X');  -- sink_real
    sink_imag_i    : in  std_ulogic_vector(12-1 downto 0) := (others => 'X');  -- sink_imag
    source_valid_o : out std_ulogic;    -- source_valid
    source_ready_i : in  std_ulogic                       := 'X';  -- source_ready
    source_error_o : out std_ulogic_vector(1 downto 0);     -- source_error
    source_sop_o   : out std_ulogic;    -- source_sop
    source_eop_o   : out std_ulogic;    -- source_eop
    source_real_o  : out std_ulogic_vector(12-1 downto 0);  -- source_real
    source_imag_o  : out std_ulogic_vector(12-1 downto 0);  -- source_imag
    source_exp_o   : out std_ulogic_vector(5 downto 0)      -- source_exp
    );
end rx_fft_wrapper;

architecture Rtl of rx_fft_wrapper is

  component fft_ofdm is
    port (
      clk          : in  std_logic                     := 'X';  -- clk
      reset_n      : in  std_logic                     := 'X';  -- reset_n
      sink_valid   : in  std_logic                     := 'X';  -- sink_valid
      sink_ready   : out std_logic;     -- sink_ready
      sink_error   : in  std_logic_vector(1 downto 0)  := (others => 'X');  -- sink_error
      sink_sop     : in  std_logic                     := 'X';  -- sink_sop
      sink_eop     : in  std_logic                     := 'X';  -- sink_eop
      sink_real    : in  std_logic_vector(11 downto 0) := (others => 'X');  -- sink_real
      sink_imag    : in  std_logic_vector(11 downto 0) := (others => 'X');  -- sink_imag
      inverse      : in  std_logic_vector(0 downto 0)  := (others => 'X');  -- inverse
      source_valid : out std_logic;     -- source_valid
      source_ready : in  std_logic                     := 'X';  -- source_ready
      source_error : out std_logic_vector(1 downto 0);          -- source_error
      source_sop   : out std_logic;     -- source_sop
      source_eop   : out std_logic;     -- source_eop
      source_real  : out std_logic_vector(11 downto 0);         -- source_real
      source_imag  : out std_logic_vector(11 downto 0);         -- source_imag
      source_exp   : out std_logic_vector(5 downto 0)           -- source_exp
      );
  end component fft_ofdm;

  signal source_real : std_ulogic_vector(11 downto 0);
  signal source_imag : std_ulogic_vector(11 downto 0);

  signal sink_real : std_ulogic_vector(11 downto 0);
  signal sink_imag : std_ulogic_vector(11 downto 0);

begin

  sink_real <= sink_real_i;
  sink_imag <= sink_imag_i;

  source_real_o <= source_real;
  source_imag_o <= source_imag;

  inst_ofdm : component fft_ofdm
    port map (
      clk                             => std_logic(clk_i),      --    clk.clk
      reset_n                         => std_logic(reset_n_i),  --    rst.reset_n
      sink_valid                      => std_logic(sink_valid_i),  --   sink.sink_valid
      std_ulogic(sink_ready)          => sink_ready_o,    --       .sink_ready
      sink_error                      => std_logic_vector(sink_error_i),  --       .sink_error
      sink_sop                        => std_logic(sink_sop_i),  --       .sink_sop
      sink_eop                        => std_logic(sink_eop_i),  --   .sink_eop
      sink_real                       => std_logic_vector(sink_real),  --       .sink_real
      sink_imag                       => std_logic_vector(sink_imag),  --       .sink_imag
      inverse                         => "0",             --       .inverse
      std_ulogic(source_valid)        => source_valid_o,  -- source.source_valid
      source_ready                    => source_ready_i,  --       .source_ready
      std_ulogic_vector(source_error) => source_error_o,  --       .source_error
      std_ulogic(source_sop)          => source_sop_o,    -- start of package
      std_ulogic(source_eop)          => source_eop_o,    --       .source_eop
      std_ulogic_vector(source_real)  => source_real,     --       .source_real
      std_ulogic_vector(source_imag)  => source_imag,     --       .source_imag
      std_ulogic_vector(source_exp)   => source_exp_o
      );

end architecture;
