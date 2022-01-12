-------------------------------------------------------------------------------
-- Title        : RX Implementation top-level testbench 
-- Project    : DTL3 
-------------------------------------------------------------------------------
-- File          : rx_top_tb-e.vhd
-- Author     : Thomas Bauernfeind
-- Company    : 
-- Created    : 2021-12-13
-- Last update: 2022-01-12
-- Platform   : 
-- Standard   : VHDL93
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-12-13  1.0      bauernfe        Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity fft_tb is
end fft_tb;


architecture beh of fft_tb is

    signal sys_clk_s, sys_reset_s         : std_ulogic                    := '0';
    signal rx_data_i_s, rx_data_q_s       : signed(11 downto 0)           := (others => '0');
    signal rx_data_valid_s                : std_ulogic                    := '0';
    signal rx_data_first_s                : std_ulogic                    := '0';
    signal rx_bits_s                      : std_ulogic_vector(1 downto 0) := (others => '0');
    signal rx_fft_i_s, rx_fft_q_s         : signed(11 downto 0)           := (others => '0');
    signal rx_fft_valid_s, rx_fft_first_s : std_ulogic                    := '0';

    file rx_data_f : text;
    file rx_bits_f : text;

    type State_type is (INPUT_STAGE, CALCULATION_STAGE, OUTPUT_STAGE);  -- Define the states
    signal State : State_Type := INPUT_STAGE;


begin  --beh

    sys_clk_s <= not(sys_clk_s) after 6250 ps;

    sys_reset_s <= '1' after 100 ns;

   -- rx_top instance
    rx_fft_1 : entity work.rx_fft
        port map (
            sys_clk_i       => sys_clk_s,
            sys_reset_i     => sys_reset_s,
            rx_data_i_i     => rx_data_i_s,
            rx_data_q_i     => rx_data_q_s,
            rx_data_valid_i => rx_data_valid_s,
            rx_data_first_i => rx_data_first_s,
            rx_fft_i_o      => rx_fft_i_s,
            rx_fft_q_o      => rx_fft_q_s,
            rx_fft_valid_o  => rx_fft_valid_s,
            rx_fft_first_o  => rx_fft_first_s);


    Stimuli : process
        variable line_v                : line;
        variable cycle_cnt_v, i_v, q_v : integer := 40-1;

    begin  -- process Stimuli
        wait for 200 ns;

        wait until (sys_clk_s = '1' and sys_reset_s = '1');
        file_open(rx_data_f, "./fft_in.txt", read_mode);
        rx_data_first_s <= '1';

        while not(endfile(rx_data_f)) loop
            -- wait until (sys_clk_s = '1' and sys_reset_s = '1');
            cycle_cnt_v := cycle_cnt_v+1;
            if (cycle_cnt_v = 40) then
                readline(rx_data_f, line_v);
                read(line_v, i_v);
                read(line_v, q_v);
                rx_data_valid_s <= '1';
                rx_data_i_s     <= to_signed(i_v, 12);
                rx_data_q_s     <= to_signed(q_v, 12);
                cycle_cnt_v     := 0;
            else
                rx_data_valid_s <= '0';
                rx_data_first_s <= '0';
            end if;
            wait until (sys_clk_s = '1' and sys_reset_s = '1');
        end loop;
        file_close(rx_data_f);

        rx_data_valid_s <= '0';
        rx_data_first_s <= '0';

        State <= CALCULATION_STAGE;

        wait until (rising_edge(sys_clk_s) and sys_reset_s = '1' and rx_fft_first_s = '1' and rx_fft_valid_s = '1');
        State <= OUTPUT_STAGE;

        file_open(rx_data_f, "./fft_out.txt", write_mode);
        for I in 0 to 127-1 loop
            write(line_v,  to_integer(rx_fft_i_s));
            write(line_v, string'(" "));
            write(line_v,  to_integer(rx_fft_q_s));
            writeline(rx_data_f, line_v);
            wait until (rising_edge(sys_clk_s) and sys_reset_s = '1' and rx_fft_valid_s = '1');
            
        end loop;
        file_close(rx_data_f);




        -------------------------------------------------------------------------
--         wait for 200 ns;
-- 	wait until (sys_clk_s = '1' and sys_reset_s = '1');
--         file_open(rx_data_f, "./fft_in.txt", read_mode);
--         rx_data_first_s <= '1';

--         while not(endfile(rx_data_f)) loop
--             -- wait until (sys_clk_s = '1' and sys_reset_s = '1');
--             cycle_cnt_v := cycle_cnt_v+1;
--             if (cycle_cnt_v = 40) then
--                 readline(rx_data_f, line_v);
--                 read(line_v, i_v);
--                 read(line_v, q_v);
--                 rx_data_valid_s <= '1';
--                 rx_data_i_s     <= to_signed(i_v, 12);
--                 rx_data_q_s     <= to_signed(q_v, 12);
--                 cycle_cnt_v     := 0;
--             else
                
                
--             end if;
--             wait until (sys_clk_s = '1' and sys_reset_s = '1');
-- 	rx_data_first_s <= '0';
-- rx_data_valid_s <= '0';
--         end loop;
--         file_close(rx_data_f);

--         rx_data_valid_s <= '0';
--         rx_data_first_s <= '0';

--         State <= CALCULATION_STAGE;

--         wait until (rising_edge(sys_clk_s) and sys_reset_s = '1' and rx_fft_first_s = '1' and rx_fft_valid_s = '1');
--         State <= OUTPUT_STAGE;

--         file_open(rx_data_f, "./fft_out.txt", write_mode);
--         for I in 0 to 127 loop
--             write(line_v,  to_integer(rx_fft_i_s));
--             write(line_v, string'(" "));
--             write(line_v,  to_integer(rx_fft_q_s));
--             writeline(rx_data_f, line_v);
--             wait until (rising_edge(sys_clk_s) and sys_reset_s = '1' and rx_fft_valid_s = '1');
            
--         end loop;
--         file_close(rx_data_f);

        ---------------------------------------------------------------------------------------------------------------
        wait for 10000 ns;

        assert false report "Finished successfully" severity failure;
        wait;

    end process;



end beh;
