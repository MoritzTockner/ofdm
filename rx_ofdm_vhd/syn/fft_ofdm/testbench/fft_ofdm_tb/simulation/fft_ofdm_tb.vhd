-- fft_ofdm_tb.vh
-- Generated using ACDS version 20.1 720

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fft_ofdm_tb is
end entity fft_ofdm_tb;

architecture rtl of fft_ofdm_tb is
  component fft_ofdm is
    port (
      clk          : in  std_logic                     := 'X';  -- clk
      reset_n      : in  std_logic                     := 'X';  -- reset_n
      sink_valid   : in  std_logic                     := 'X';  -- sink_valid
      sink_ready   : out std_logic;     -- sink_ready
      sink_error   : in  std_logic_vector(1 downto 0)  := (others => 'X');  -- sink_error
      sink_sop     : in  std_logic                     := 'X';  -- sink_sop
      sink_eop     : in  std_logic                     := 'X';  -- sink_eop
      sink_real    : in  std_logic_vector(17 downto 0) := (others => 'X');  -- sink_real
      sink_imag    : in  std_logic_vector(17 downto 0) := (others => 'X');  -- sink_imag
      inverse      : in  std_logic_vector(0 downto 0)  := (others => 'X');  -- inverse
      source_valid : out std_logic;     -- source_valid
      source_ready : in  std_logic                     := 'X';  -- source_ready
      source_error : out std_logic_vector(1 downto 0);          -- source_error
      source_sop   : out std_logic;     -- source_sop
      source_eop   : out std_logic;     -- source_eop
      source_real  : out std_logic_vector(17 downto 0);         -- source_real
      source_imag  : out std_logic_vector(17 downto 0);         -- source_imag
      source_exp   : out std_logic_vector(5 downto 0)           -- source_exp
      );
  end component fft_ofdm;

  component altera_avalon_clock_source is
    generic (
      CLOCK_RATE : positive := 10;
      CLOCK_UNIT : positive := 1000000
      );
    port (
      clk : out std_logic               -- clk
      );
  end component altera_avalon_clock_source;

  component altera_avalon_reset_source is
    generic (
      ASSERT_HIGH_RESET    : integer := 1;
      INITIAL_RESET_CYCLES : integer := 0
      );
    port (
      reset : out std_logic;            -- reset_n
      clk   : in  std_logic := 'X'      -- clk
      );
  end component altera_avalon_reset_source;

  component altera_conduit_bfm is
    port (
      clk            : in  std_logic                    := 'X';  -- clk
      reset          : in  std_logic                    := 'X';  -- reset
      sig_inverse    : out std_logic_vector(0 downto 0);         -- inverse
      sig_sink_eop   : out std_logic_vector(0 downto 0);         -- sink_eop
      sig_sink_error : out std_logic_vector(1 downto 0);         -- sink_error
      sig_sink_imag  : out std_logic_vector(17 downto 0);        -- sink_imag
      sig_sink_ready : in  std_logic_vector(0 downto 0) := (others => 'X');  -- sink_ready
      sig_sink_real  : out std_logic_vector(17 downto 0);        -- sink_real
      sig_sink_sop   : out std_logic_vector(0 downto 0);         -- sink_sop
      sig_sink_valid : out std_logic_vector(0 downto 0)          -- sink_valid
      );
  end component altera_conduit_bfm;

  component altera_conduit_bfm_0002 is
    port (
      clk              : in  std_logic                     := 'X';  -- clk
      reset            : in  std_logic                     := 'X';  -- reset
      sig_source_eop   : in  std_logic_vector(0 downto 0)  := (others => 'X');  -- source_eop
      sig_source_error : in  std_logic_vector(1 downto 0)  := (others => 'X');  -- source_error
      sig_source_exp   : in  std_logic_vector(5 downto 0)  := (others => 'X');  -- source_exp
      sig_source_imag  : in  std_logic_vector(17 downto 0) := (others => 'X');  -- source_imag
      sig_source_ready : out std_logic_vector(0 downto 0);  -- source_ready
      sig_source_real  : in  std_logic_vector(17 downto 0) := (others => 'X');  -- source_real
      sig_source_sop   : in  std_logic_vector(0 downto 0)  := (others => 'X');  -- source_sop
      sig_source_valid : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- source_valid
      );
  end component altera_conduit_bfm_0002;

  signal fft_ofdm_inst_clk_bfm_clk_clk                 : std_logic := '1';  -- fft_ofdm_inst_clk_bfm:clk -> [fft_ofdm_inst:clk, fft_ofdm_inst_rst_bfm:clk, fft_ofdm_inst_sink_bfm:clk, fft_ofdm_inst_source_bfm:clk]
  signal fft_ofdm_inst_sink_bfm_conduit_sink_error     : std_logic_vector(1 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_error -> fft_ofdm_inst:sink_error
  signal fft_ofdm_inst_sink_bfm_conduit_inverse        : std_logic_vector(0 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_inverse -> fft_ofdm_inst:inverse
  signal fft_ofdm_inst_sink_bfm_conduit_sink_eop       : std_logic_vector(0 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_eop -> fft_ofdm_inst:sink_eop
  signal fft_ofdm_inst_sink_bfm_conduit_sink_sop       : std_logic_vector(0 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_sop -> fft_ofdm_inst:sink_sop
  signal fft_ofdm_inst_sink_bfm_conduit_sink_valid     : std_logic_vector(0 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_valid -> fft_ofdm_inst:sink_valid
  signal fft_ofdm_inst_sink_bfm_conduit_sink_real      : std_logic_vector(17 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_real -> fft_ofdm_inst:sink_real
  signal fft_ofdm_inst_sink_sink_ready                 : std_logic;  -- fft_ofdm_inst:sink_ready -> fft_ofdm_inst_sink_bfm:sig_sink_ready
  signal fft_ofdm_inst_sink_bfm_conduit_sink_imag      : std_logic_vector(17 downto 0);  -- fft_ofdm_inst_sink_bfm:sig_sink_imag -> fft_ofdm_inst:sink_imag
  signal fft_ofdm_inst_source_source_imag              : std_logic_vector(17 downto 0);  -- fft_ofdm_inst:source_imag -> fft_ofdm_inst_source_bfm:sig_source_imag
  signal fft_ofdm_inst_source_source_real              : std_logic_vector(17 downto 0);  -- fft_ofdm_inst:source_real -> fft_ofdm_inst_source_bfm:sig_source_real
  signal fft_ofdm_inst_source_bfm_conduit_source_ready : std_logic_vector(0 downto 0);  -- fft_ofdm_inst_source_bfm:sig_source_ready -> fft_ofdm_inst:source_ready
  signal fft_ofdm_inst_source_source_sop               : std_logic;  -- fft_ofdm_inst:source_sop -> fft_ofdm_inst_source_bfm:sig_source_sop
  signal fft_ofdm_inst_source_source_eop               : std_logic;  -- fft_ofdm_inst:source_eop -> fft_ofdm_inst_source_bfm:sig_source_eop
  signal fft_ofdm_inst_source_source_valid             : std_logic;  -- fft_ofdm_inst:source_valid -> fft_ofdm_inst_source_bfm:sig_source_valid
  signal fft_ofdm_inst_source_source_exp               : std_logic_vector(5 downto 0);  -- fft_ofdm_inst:source_exp -> fft_ofdm_inst_source_bfm:sig_source_exp
  signal fft_ofdm_inst_source_source_error             : std_logic_vector(1 downto 0);  -- fft_ofdm_inst:source_error -> fft_ofdm_inst_source_bfm:sig_source_error
  signal fft_ofdm_inst_rst_bfm_reset_reset             : std_logic;  -- fft_ofdm_inst_rst_bfm:reset -> [fft_ofdm_inst:reset_n, fft_ofdm_inst_rst_bfm_reset_reset:in]
  signal fft_ofdm_inst_rst_bfm_reset_reset_ports_inv   : std_logic;  -- fft_ofdm_inst_rst_bfm_reset_reset:inv -> [fft_ofdm_inst_sink_bfm:reset, fft_ofdm_inst_source_bfm:reset]

begin

  fft_ofdm_inst : component fft_ofdm
    port map (
      clk          => fft_ofdm_inst_clk_bfm_clk_clk,      --    clk.clk
      reset_n      => fft_ofdm_inst_rst_bfm_reset_reset,  --    rst.reset_n
      sink_valid   => fft_ofdm_inst_sink_bfm_conduit_sink_valid(0),  --   sink.sink_valid
      sink_ready   => fft_ofdm_inst_sink_sink_ready,      --       .sink_ready
      sink_error   => fft_ofdm_inst_sink_bfm_conduit_sink_error,  --       .sink_error
      sink_sop     => fft_ofdm_inst_sink_bfm_conduit_sink_sop(0),  --       .sink_sop
      sink_eop     => fft_ofdm_inst_sink_bfm_conduit_sink_eop(0),  --       .sink_eop
      sink_real    => fft_ofdm_inst_sink_bfm_conduit_sink_real,  --       .sink_real
      sink_imag    => fft_ofdm_inst_sink_bfm_conduit_sink_imag,  --       .sink_imag
      inverse      => fft_ofdm_inst_sink_bfm_conduit_inverse,  --       .inverse
      source_valid => fft_ofdm_inst_source_source_valid,  -- source.source_valid
      source_ready => fft_ofdm_inst_source_bfm_conduit_source_ready(0),  --       .source_ready
      source_error => fft_ofdm_inst_source_source_error,  --       .source_error
      source_sop   => fft_ofdm_inst_source_source_sop,    --       .source_sop
      source_eop   => fft_ofdm_inst_source_source_eop,    --       .source_eop
      source_real  => fft_ofdm_inst_source_source_real,   --       .source_real
      source_imag  => fft_ofdm_inst_source_source_imag,   --       .source_imag
      source_exp   => fft_ofdm_inst_source_source_exp     --       .source_exp
      );

  fft_ofdm_inst_clk_bfm : component altera_avalon_clock_source
    generic map (
      CLOCK_RATE => 80000000,
      CLOCK_UNIT => 1
      )
    port map (
      clk => fft_ofdm_inst_clk_bfm_clk_clk  -- clk.clk
      );

--fft_ofdm_inst_clk_bfm_clk_clk   <= not(fft_ofdm_inst_clk_bfm_clk_clk) after 6250 ps;

  fft_ofdm_inst_rst_bfm : component altera_avalon_reset_source
    generic map (
      ASSERT_HIGH_RESET    => 0,
      INITIAL_RESET_CYCLES => 50
      )
    port map (
      reset => fft_ofdm_inst_rst_bfm_reset_reset,  -- reset.reset_n
      clk   => fft_ofdm_inst_clk_bfm_clk_clk       --   clk.clk
      );

  -- -- fft_ofdm_inst_sink_bfm : component altera_conduit_bfm
  -- -- port map (
  -- -- clk               => fft_ofdm_inst_clk_bfm_clk_clk,               --     clk.clk
  -- -- reset             => fft_ofdm_inst_rst_bfm_reset_reset_ports_inv, --   reset.reset
  -- -- sig_inverse       => fft_ofdm_inst_sink_bfm_conduit_inverse,      -- conduit.inverse
  -- -- sig_sink_eop      => fft_ofdm_inst_sink_bfm_conduit_sink_eop,     --        .sink_eop
  -- -- sig_sink_error    => fft_ofdm_inst_sink_bfm_conduit_sink_error,   --        .sink_error
  -- -- sig_sink_imag     => fft_ofdm_inst_sink_bfm_conduit_sink_imag,    --        .sink_imag
  -- -- sig_sink_ready(0) => fft_ofdm_inst_sink_sink_ready,               --        .sink_ready
  -- -- sig_sink_real     => fft_ofdm_inst_sink_bfm_conduit_sink_real,    --        .sink_real
  -- -- sig_sink_sop      => fft_ofdm_inst_sink_bfm_conduit_sink_sop,     --        .sink_sop
  -- -- sig_sink_valid    => fft_ofdm_inst_sink_bfm_conduit_sink_valid    --        .sink_valid
  -- -- );

  fft_ofdm_inst_sink_bfm_conduit_inverse    <= "0";
--fft_ofdm_inst_sink_bfm_conduit_sink_eop <= "0";
  fft_ofdm_inst_sink_bfm_conduit_sink_error <= "00";
--fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "0"; --fft_ofdm_inst_sink_sink_ready;

  Stimuli : process
  begin  -- process Stimuli

    wait for 6.25 ns;
    wait for 50*12.5 ns; -- reset
    fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "0";
    fft_ofdm_inst_sink_bfm_conduit_sink_eop       <= "0";
    fft_ofdm_inst_sink_bfm_conduit_sink_imag      <= (others => '0');
    fft_ofdm_inst_sink_bfm_conduit_sink_real      <= (others => '0');
    fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "0";
    fft_ofdm_inst_source_bfm_conduit_source_ready <= "1";
    for k in 0 to 26 loop
      wait for 40*16*12.5 ns; -- sync

      fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "1";
      fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "1";
      wait for 12.5 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "0";
      fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "0";
      wait for (40-1) * 12.5 ns;
      
      for n in 0 to 128-1-2 loop-- 127-2 loop
        fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "1";
        wait for 12.5 ns;
        fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "0";
        wait for (40-1) * 12.5 ns;
      end loop;

      fft_ofdm_inst_sink_bfm_conduit_sink_eop       <= "1";
      fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "1";
      wait for 12.5 ns;
      
      fft_ofdm_inst_sink_bfm_conduit_sink_eop       <= "0";
      fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "0";
      
      --fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "1";
      --wait for 12.5 ns;
      
      --fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "0";
      --fft_ofdm_inst_sink_bfm_conduit_sink_eop       <= "1";
      --fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "1";
      wait for (40-1)*12.5 ns;
      
      fft_ofdm_inst_sink_bfm_conduit_sink_eop       <= "0";
      fft_ofdm_inst_sink_bfm_conduit_sink_valid       <= "0";
      
      wait for (40)*(16)*12.5 ns; -- pre

    end loop;
  
    
    wait for 200 ns;
    
    fft_ofdm_inst_sink_bfm_conduit_sink_imag      <= (others => '1');
    fft_ofdm_inst_sink_bfm_conduit_sink_real      <= (others => '1');
    wait for 2 ns;
    fft_ofdm_inst_sink_bfm_conduit_sink_valid     <= "1";
    fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "1";
    fft_ofdm_inst_source_bfm_conduit_source_ready <= "1";
    wait for 2 ns;
    fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "0";
    wait for (126 * (2 ns));

    fft_ofdm_inst_sink_bfm_conduit_sink_eop   <= "1";
    wait for 2 ns;
    fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "0";
    fft_ofdm_inst_sink_bfm_conduit_sink_eop   <= "0";
    --fft_ofdm_inst_sink_bfm_conduit_sink_sop <= "1";
    wait for 2 ns;
    fft_ofdm_inst_sink_bfm_conduit_sink_sop   <= "0";
    wait for 14 ns;
    wait for (500 * (2 ns));
    for k in 0 to 26 loop
      wait for (500 * (2 ns));
      fft_ofdm_inst_sink_bfm_conduit_sink_imag      <= "010000000000000000";  --(others => '1');
      fft_ofdm_inst_sink_bfm_conduit_sink_real      <= "001000000000000000";
      wait for 2 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_valid     <= "1";
      fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "1";
      fft_ofdm_inst_source_bfm_conduit_source_ready <= "1";
      wait for 2 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_sop       <= "0";
      wait for (126 * (2 ns));

      fft_ofdm_inst_sink_bfm_conduit_sink_eop   <= "1";
      wait for 2 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_valid <= "0";
      fft_ofdm_inst_sink_bfm_conduit_sink_eop   <= "0";
      --fft_ofdm_inst_sink_bfm_conduit_sink_sop <= "1";
      wait for 2 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_sop   <= "0";
      wait for 14 ns;
      wait for 2 ns;
      fft_ofdm_inst_sink_bfm_conduit_sink_sop   <= "0";
    end loop;
    wait;
  end process;

  fft_ofdm_inst_source_bfm : component altera_conduit_bfm_0002
    port map (
      clk                 => fft_ofdm_inst_clk_bfm_clk_clk,    --     clk.clk
      reset               => fft_ofdm_inst_rst_bfm_reset_reset_ports_inv,  --   reset.reset
      sig_source_eop(0)   => fft_ofdm_inst_source_source_eop,  -- conduit.source_eop
      sig_source_error    => fft_ofdm_inst_source_source_error,  --        .source_error
      sig_source_exp      => fft_ofdm_inst_source_source_exp,  --        .source_exp
      sig_source_imag     => fft_ofdm_inst_source_source_imag,  --        .source_imag
      sig_source_ready    => open,  --fft_ofdm_inst_source_bfm_conduit_source_ready, --        .source_ready
      sig_source_real     => fft_ofdm_inst_source_source_real,  --        .source_real
      sig_source_sop(0)   => fft_ofdm_inst_source_source_sop,  --        .source_sop
      sig_source_valid(0) => fft_ofdm_inst_source_source_valid  --        .source_valid
      );

  fft_ofdm_inst_rst_bfm_reset_reset_ports_inv <= not fft_ofdm_inst_rst_bfm_reset_reset;

end architecture rtl;  -- of fft_ofdm_tb
