-------------------------------------------------------------------------------
-- Title      : rx_fft behaviral
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_fft-beh-a.vhd
-- Author     : 
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-10
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
  function LogDualis(cNumber : natural) return natural is
    -- Initialize explicitly (will have warnings for uninitialized variables 
    -- from Quartus synthesis otherwise).
    variable vClimbUp : natural := 1;
    variable vResult  : natural := 0;
  begin
    while vClimbUp < cNumber loop
      vClimbUp := vClimbUp * 2;
      vResult  := vResult+1;
    end loop;
    return vResult;
  end LogDualis;

  constant reset_active_c : std_ulogic := '0';
  --signal sig1             : integer;
  --signal sig2             : std_ulogic_vector(out2_o'range);

  constant prefetch_c : natural := 30;  -- load entries into Buffer befor
  -- starting fft 
  type aState is (Init, error);

  type aRegSet is record
    state : aState;

    start_fft : std_ulogic;
    stop_fft  : std_ulogic;

    cnt_prefetch : unsigned(LogDualis(prefetch_c)-1 downto 0);

  end record aRegSet;

  constant cInitVarR : aRegSet := (
    state     => Init,
    start_fft => '0',
    stop_fft  => '0',

    cnt_prefetch => (others => '0')
    );


  signal r, nxr        : aRegSet;
  signal fft_isready   : std_ulogic;
  signal fft_in_error  : std_ulogic_vector(1 downto 0) := "00";
  signal fft_out_error : std_ulogic_vector(1 downto 0);
  signal end_of_frame  : std_ulogic;
  signal chip_cnt      : unsigned(5 downto 0);

  signal source_exp : std_ulogic_vector(5 downto 0);
  signal rx_fft_i   : std_ulogic_vector(12-1 downto 0);
  signal rx_fft_q   : std_ulogic_vector(12-1 downto 0);
begin  -- beh

 outreg : process(sys_reset_i, sys_clk_i)
  begin
    if sys_reset_i = reset_active_c then
      --out2_o <= (others => '0');
      end_of_frame <= '0';
      r            <= cInitVarR;
    elsif sys_clk_i'event and sys_clk_i = '1' then

      r          <= nxr;
      rx_fft_i_o <= signed(rx_fft_i);
      rx_fft_q_o <= signed(rx_fft_q);
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

  ---------------------------------------------------------------------------
  -- Comb
  ---------------------------------------------------------------------------
  Comb : process (R)
  begin
    -- Set the defaults.

    nxr <= r;

    case (r.State) is

      -------------------------------------------------------------------------------------------
      --        R.IFStat
      when Init =>
        -- wait for filling Buffer

      when others =>
        null;
    end case;

  end process Comb;  --Combo

  fifo_inst : entity work.DualPortedRam
    generic map (
      gDataWidth    => 2*12,
      gAddressWidth => LogDualis(128))
    port map (
      iClk    => sys_clk_i,
      iAddr_a => (others => '0'),
      iAddr_b => (others => '0'),
      iData   => (others => '0'),
      iWe     => '0',
      oQ_a    => open,
      oQ_b    => open);

  fft_inst : entity work.rx_fft_wrapper
    port map (
      clk_i          => sys_clk_i,        --    clk.clk
      reset_n_i      => sys_reset_i,      --    rst.reset_n
      sink_valid_i   => '1', --rx_data_valid_i,  --   sink.sink_valid --TODO
      sink_ready_o   => fft_isready,      --       .sink_ready --TODO
      sink_error_i   => fft_in_error,     --       .sink_error
      sink_sop_i     => rx_data_first_i,  --       .sink_sop
      sink_eop_i     => end_of_frame,     -- .sink_eop
      sink_real_i    => std_ulogic_vector(rx_data_i_i),      --       .sink_real
      sink_imag_i    => std_ulogic_vector(rx_data_q_i),      --       .sink_imag
      source_valid_o => open, --rx_fft_valid_o,   -- source.source_valid
      source_ready_i => '1',              --       .source_ready
      source_error_o => fft_out_error,    --       .source_error
      source_sop_o   => open, --rx_fft_first_o,   -- start of package
      source_eop_o   => open,             --       .source_eop
      source_real_o  => rx_fft_i,         --       .source_real
      source_imag_o  => rx_fft_q,         --       .source_imag
      source_exp_o   => source_exp);

end beh;  -- of rx_fft
