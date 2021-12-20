-------------------------------------------------------------------------------
-- Title      : rx_fft behaviral
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_fft-beh-a.vhd
-- Author     : 
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2021-12-20
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-12-13  1.0      bauernfe        Created
-------------------------------------------------------------------------------


architecture beh of rx_fft is

  constant reset_active_c : std_ulogic := '0';
  --signal sig1             : integer;
  --signal sig2             : std_ulogic_vector(out2_o'range);

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
      fftpts_in    : in  std_logic_vector(7 downto 0)  := (others => 'X');  -- fftpts_in
      inverse      : in  std_logic_vector(0 downto 0)  := (others => 'X');  -- inverse
      source_valid : out std_logic;     -- source_valid
      source_ready : in  std_logic                     := 'X';  -- source_ready
      source_error : out std_logic_vector(1 downto 0);          -- source_error
      source_sop   : out std_logic;     -- source_sop
      source_eop   : out std_logic;     -- source_eop
      source_real  : out std_logic_vector(17 downto 0);         -- source_real
      source_imag  : out std_logic_vector(17 downto 0);         -- source_imag
      fftpts_out   : out std_logic_vector(7 downto 0)           -- fftpts_out
      );
  end component fft_ofdm;

  signal fft_isready   : std_ulogic;
  signal fft_in_error  : std_ulogic_vector(1 downto 0) := "00";
  signal fft_out_error : std_ulogic_vector(1 downto 0);
  signal end_of_frame  : std_ulogic;
  signal chip_cnt      : unsigned(5 downto 0);

  signal rx_fft_i : std_ulogic_vector(17 downto 0);
  signal rx_fft_q : std_ulogic_vector(17 downto 0);
begin  -- beh

  outreg : process(sys_reset_i, sys_clk_i)
  begin
    if sys_reset_i = reset_active_c then
      --out2_o <= (others => '0');
      end_of_frame <= '1';
    elsif sys_clk_i'event and sys_clk_i = '1' then

      rx_fft_i_o <= signed(rx_fft_i(17 downto 6));
      rx_fft_q_o <= signed(rx_fft_q(17 downto 6));
      if rx_data_valid_i = '1' and fft_isready = '1' then

        if chip_cnt = 2**5 -1 then
          chip_cnt <= chip_cnt;
        else
          chip_cnt <= chip_cnt + 1;
        end if;

      --out2_o <= sig2;
      end if;
    end if;
  end process outreg;


  u0 : component fft_ofdm
    port map (
      clk                             => std_logic(sys_clk_i),    --    clk.clk
      reset_n                         => std_logic(sys_reset_i),  --    rst.reset_n
      sink_valid                      => std_logic(rx_data_valid_i),  --   sink.sink_valid
      std_ulogic(sink_ready)          => fft_isready,    --       .sink_ready
      sink_error                      => std_logic_vector(fft_in_error),  --       .sink_error
      sink_sop                        => std_logic(rx_data_first_i),  --       .sink_sop
      sink_eop                        => std_logic(end_of_frame),     --
                                        --.sink_eop
      sink_real                       => std_logic_vector(rx_data_i_i & "000000"),  --       .sink_real
      sink_imag                       => std_logic_vector(rx_data_q_i & "000000"),  --       .sink_imag
      fftpts_in                       => std_logic_vector(to_unsigned(2**7, 8)),  --       .fftpts_in
      inverse                         => "0",            --       .inverse
      std_ulogic(source_valid)        => rx_fft_valid_o,  -- source.source_valid
      source_ready                    => '1',            --       .source_ready
      std_ulogic_vector(source_error) => fft_out_error,  --       .source_error
      std_ulogic(source_sop)          => rx_fft_first_o,  -- start of package
      std_ulogic(source_eop)          => open,           --       .source_eop
      std_ulogic_vector(source_real)  => rx_fft_i,       --       .source_real
      std_ulogic_vector(source_imag)  => rx_fft_q,       --       .source_imag
      std_ulogic_vector(fftpts_out)   => open            --       .fftpts_out
      );

end beh;  -- of rx_fft
