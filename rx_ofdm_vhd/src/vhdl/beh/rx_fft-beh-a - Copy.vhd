-------------------------------------------------------------------------------
-- Title      : rx_fft behaviral
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_fft-beh-a.vhd
-- Author     : 
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-08
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
    stop_fft  => '0'
    );


  signal r, nxr        : aRegSet;
  signal fft_isready   : std_ulogic;
  signal fft_in_error  : std_ulogic_vector(1 downto 0) := "00";
  signal fft_out_error : std_ulogic_vector(1 downto 0);
  signal end_of_frame  : std_ulogic;
  signal chip_cnt      : unsigned(5 downto 0);

  signal source_exp : std_ulogic_vector(5 downto 0);
  signal rx_fft_i   : std_ulogic_vector(12 downto 0);
  signal rx_fft_q   : std_ulogic_vector(12 downto 0);
begin  -- beh

  outreg : process(sys_reset_i, sys_clk_i)
  begin
    if sys_reset_i = reset_active_c then
      --out2_o <= (others => '0');
      end_of_frame <= '1';
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
        if 
      when others =>
        null;
    end case;

  end process Comb;  --Combo

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
      sink_real                       => rx_data_i_i & "000000",  --       .sink_real
      sink_imag                       => rx_data_q_i & "000000",  --       .sink_imag
      --fftpts_in                       => std_logic_vector(to_unsigned(2**7, 8)),  --       .fftpts_in
      inverse                         => "0",            --       .inverse
      std_ulogic(source_valid)        => rx_fft_valid_o,  -- source.source_valid
      source_ready                    => '1',            --       .source_ready
      std_ulogic_vector(source_error) => fft_out_error,  --       .source_error
      std_ulogic(source_sop)          => rx_fft_first_o,  -- start of package
      std_ulogic(source_eop)          => open,           --       .source_eop
      std_ulogic_vector(source_real)  => rx_fft_i,       --       .source_real
      std_ulogic_vector(source_imag)  => rx_fft_q,       --       .source_imag
      --std_ulogic_vector(fftpts_out)   => open            --       .fftpts_out
      std_ulogic_vector(source_exp)   => source_exp
      );

end beh;  -- of rx_fft
