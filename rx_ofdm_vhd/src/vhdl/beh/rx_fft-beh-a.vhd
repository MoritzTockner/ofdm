-------------------------------------------------------------------------------
-- Title      : rx_fft behaviral
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_fft-beh-a.vhd
-- Author     : 
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-12
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
  constant prefetch_c     : natural    := 30;  -- load entries into Buffer befor

  type aRegSet is record
    start  : std_ulogic;
    last   : std_ulogic;
    cnt_in : unsigned(12-1 downto 0);

    --start_buff : std_ulogic;
    --valid_buff : std_ulogic;

    --start_fft : std_ulogic;
    --stop_fft  : std_ulogic;

    --cnt_prefetch : unsigned(LogDualis(prefetch_c)-1 downto 0);

    --cnt_out : unsigned(12-1 downto 0);
  end record aRegSet;

  constant cInitVarR : aRegSet := (
    start => '0',
    last   => '0',
    cnt_in => (others => '0')

    --start_buff => '0',
    --valid_buff => '0',

    --start_fft => '0',
    --stop_fft  => '0',

    --cnt_prefetch => (others => '0'),

    --cnt_out => (others => '0')
    );

  signal r, nxr        : aRegSet;
  signal fft_isready   : std_ulogic;
  signal fft_in_error  : std_ulogic_vector(1 downto 0) := "00";
  signal fft_out_error : std_ulogic_vector(1 downto 0);
  signal end_of_frame  : std_ulogic;
  --signal chip_cnt      : unsigned(5 downto 0);
  signal source_real   : signed(11 downto 0);
  signal source_imag   : signed(11 downto 0);

  signal source_exp : signed(5 downto 0);

  -- buffer output data
  --signal sink_real : std_ulogic_vector(12-1 downto 0);
  --signal sink_imag : std_ulogic_vector(12-1 downto 0);

  -- fft output data
  --signal rx_fft_i : std_ulogic_vector(12-1 downto 0);
  --signal rx_fft_q : std_ulogic_vector(12-1 downto 0);

  -- concatenate buffer data
  --signal buff_in  : std_ulogic_vector((2*12)-1 downto 0);
  --signal buff_out : std_ulogic_vector((2*12)-1 downto 0);

begin  -- beh

  outreg : process(sys_reset_i, sys_clk_i)
  begin
    if sys_reset_i = reset_active_c then
      r <= cInitVarR;
    elsif sys_clk_i'event and sys_clk_i = '1' then
      r <= nxr;
    end if;
  end process outreg;

  ---------------------------------------------------------------------------
  -- Comb
  ---------------------------------------------------------------------------
  Comb : process (R, rx_data_valid_i, rx_data_first_i, fft_isready)
  begin
    -- Set the defaults.

    nxr <= r;

    if rx_data_first_i = '1' then
      nxr.start <= '1';
    end if;

    if rx_data_valid_i = '1' then
      if r.last <= '1' then
        nxr.last <= '0';
      end if;
      
      if r.cnt_in = to_unsigned(128-1, r.cnt_in'length) then
        nxr.cnt_in <= to_unsigned(0, r.cnt_in'length);
        nxr.last   <= '1';
      else
        nxr.cnt_in <= r.cnt_in + 1;
        nxr.last <= '0';
      end if;
    end if;

  end process Comb;  --Combo

  end_of_frame <= r.last and rx_data_valid_i;

  fft_inst : entity work.rx_fft_wrapper
    port map (
      clk_i     => sys_clk_i,
      reset_n_i => sys_reset_i,

      sink_valid_i => rx_data_valid_i,

      sink_ready_o => fft_isready,
      sink_error_i => fft_in_error,

      sink_sop_i => rx_data_first_i,

      sink_eop_i => end_of_frame,

      sink_real_i => std_ulogic_vector(rx_data_i_i),
      sink_imag_i => std_ulogic_vector(rx_data_q_i),

      source_valid_o => rx_fft_valid_o,

      source_ready_i => '1',
      source_error_o => fft_out_error,

      source_sop_o => rx_fft_first_o,
      source_eop_o => open,

      signed(source_real_o) => source_real,
      signed(source_imag_o) => source_imag,
      signed(source_exp_o)  => source_exp);


  
  rx_fft_i_o <= Shift_Left(signed(source_real), to_integer(signed(source_exp)));
  
  rx_fft_q_o <= Shift_Left(signed(source_imag), to_integer(signed(source_exp)));

end beh;  -- of rx_fft
