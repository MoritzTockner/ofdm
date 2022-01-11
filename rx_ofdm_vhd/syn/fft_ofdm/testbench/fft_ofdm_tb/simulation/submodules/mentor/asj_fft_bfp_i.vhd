-- (C) 2001-2020 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--  version		: $Version:	1.0 $ 
--  revision		: $Revision: #1 $ 
--  designer name  	: $Author: psgswbuild $ 
--  company name   	: altera corp.
--  company address	: 101 innovation drive
--                  	  san jose, california 95134
--                  	  u.s.a.
-- 
--  copyright altera corp. 2003
-- 
-- 
--  $Header: //acds/rel/20.1std/ip/dsp/altera_fft_ii/src/rtl/lib/old_arch/asj_fft_bfp_i.vhd#1 $ 
--  $log$ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all; 
use work.fft_pack.all;



entity asj_fft_bfp_i is
    generic (
    	mpr : integer := 18;
    	fpr : integer :=4;
    	arch : integer :=1;
    	rbuspr : integer :=72 -- 4*mpr
		);
    port (
global_clock_enable : in std_logic;
         clk   		: in std_logic;
         --reset 		: in std_logic;
         real_bfp_0_in : in std_logic_vector(mpr-1 downto 0); 
         real_bfp_1_in : in std_logic_vector(mpr-1 downto 0); 
         real_bfp_2_in : in std_logic_vector(mpr-1 downto 0); 
         real_bfp_3_in : in std_logic_vector(mpr-1 downto 0); 
         imag_bfp_0_in : in std_logic_vector(mpr-1 downto 0); 
         imag_bfp_1_in : in std_logic_vector(mpr-1 downto 0); 
         imag_bfp_2_in : in std_logic_vector(mpr-1 downto 0); 
         imag_bfp_3_in : in std_logic_vector(mpr-1 downto 0); 
         bfp_factor : in std_logic_vector(2 downto 0);
         real_bfp_0_out : out std_logic_vector(mpr-1 downto 0); 
         real_bfp_1_out : out std_logic_vector(mpr-1 downto 0); 
         real_bfp_2_out : out std_logic_vector(mpr-1 downto 0); 
         real_bfp_3_out : out std_logic_vector(mpr-1 downto 0); 
         imag_bfp_0_out : out std_logic_vector(mpr-1 downto 0); 
         imag_bfp_1_out : out std_logic_vector(mpr-1 downto 0); 
         imag_bfp_2_out : out std_logic_vector(mpr-1 downto 0); 
         imag_bfp_3_out : out std_logic_vector(mpr-1 downto 0)
		     );
end asj_fft_bfp_i;

architecture input_bfp of asj_fft_bfp_i is
	
	function sgn_ex(inval : std_logic_vector; w : integer; b : integer) return std_logic_vector is
	-- sign extend input std_logic_vector of width w by b bits
	variable temp :   std_logic_vector(w+b-1 downto 0);
	begin
		temp(w+b-1 downto w-1):=(w+b-1 downto w-1 => inval(w-1));
		temp(w-2 downto 0) := inval(w-2 downto 0);
	return temp;
	end	sgn_ex;
	
	function int2ustd(value : integer; width : integer) return std_logic_vector is 
	-- convert integer to unsigned std_logicvector
	variable temp :   std_logic_vector(width-1 downto 0);
	begin
	if (width>0) then 
			temp:=conv_std_logic_vector(conv_unsigned(value, width ), width);
	end if ;
	return temp;
	end int2ustd;
	
  
	component asj_fft_mult_sl 
		port
		(
global_clock_enable : in std_logic;
			dataa		: in std_logic_vector (15 downto 0);
			datab		: in std_logic_vector (5 downto 0);
			clock		: in std_logic ;
			result		: out std_logic_vector (21 downto 0)
		);
	end component;
	
	constant full : integer :=1;
	
  signal lut_in  : std_logic_vector(2 downto 0);
	signal cur_val : std_logic_vector(3 downto 0);
	type pre_bfp_input_bus is array (0 to 3) of std_logic_vector(mpr-1 downto 0);
	signal r_array_in, i_array_in : pre_bfp_input_bus;
	type bfp_input_bus is array (0 to 3) of std_logic_vector(mpr-1 downto 0);
	signal r_array_out, i_array_out : bfp_input_bus;
	signal scale : std_logic_vector(fpr downto 0);
	type result_array is array (0 to 3) of std_logic_vector(mpr+5 downto 0);
	signal result_r,result_i : result_array;
	
	signal r_array_temp1 : bfp_input_bus;
	signal i_array_temp1 : bfp_input_bus;
	signal r_array_temp2 : bfp_input_bus;
	signal i_array_temp2 : bfp_input_bus;
	signal r_array_temp4 : bfp_input_bus;
	signal i_array_temp4 : bfp_input_bus;
	
	-- Takes last calculated scaling from bpf_o and applies it to next block read from memory
	-- before permutation
	
	begin
	
	
	-- Quad output engine requires use of 4 parallel inputs in BFP Procesor
	gen_4_input_bfp_i : if(arch<3) generate	
	-- Unscaled Input
		r_array_in(0) <= real_bfp_0_in;
		r_array_in(1) <= real_bfp_1_in;
		r_array_in(2) <= real_bfp_2_in;
		r_array_in(3) <= real_bfp_3_in;
		i_array_in(0) <= imag_bfp_0_in;
		i_array_in(1) <= imag_bfp_1_in;
		i_array_in(2) <= imag_bfp_2_in;
		i_array_in(3) <= imag_bfp_3_in;
	-- Scaled Output	
		real_bfp_0_out <= r_array_out(0);
		real_bfp_1_out <= r_array_out(1);
		real_bfp_2_out <= r_array_out(2);
		real_bfp_3_out <= r_array_out(3);
		imag_bfp_0_out <= i_array_out(0);
		imag_bfp_1_out <= i_array_out(1);
		imag_bfp_2_out <= i_array_out(2);
		imag_bfp_3_out <= i_array_out(3);
	end generate gen_4_input_bfp_i;
	-- Single output engine requires use of single set of complex inputs in BFP Procesor
	-- Let synthesis take care of the rest...
	gen_1_input_bfp_i : if(arch>=3) generate	
	-- Unscaled Input
			r_array_in(0) <= real_bfp_0_in;
		r_array_in(1) <= (others=>'0');
		r_array_in(2) <= (others=>'0');
		r_array_in(3) <= (others=>'0');
		i_array_in(0) <= imag_bfp_0_in;
		i_array_in(1) <= (others=>'0');
		i_array_in(2) <= (others=>'0');
		i_array_in(3) <= (others=>'0');
	-- Scaled Output	
		real_bfp_0_out <= r_array_out(0);
		real_bfp_1_out <= (others=>'0');
		real_bfp_2_out <= (others=>'0');
		real_bfp_3_out <= (others=>'0');
		imag_bfp_0_out <= i_array_out(0);
		imag_bfp_1_out <= (others=>'0');
		imag_bfp_2_out <= (others=>'0');
		imag_bfp_3_out <= (others=>'0');
	end generate gen_1_input_bfp_i;
	
	
lut_in <= bfp_factor;

-----------------------------------------------------------------------------------------------------
-- Block floating point scaling  (4-bit)
gen_4bit_bfp : if(fpr=4) generate
-- Barrel shifter straight up with appropriate use of DC's 
-- to yield minimization by synthesis when possible. 
-----------------------------------------------------------------------------------------------------
-- Block floating point scaling  (4-bit) with pipeline

apply_gain:process(clk,global_clock_enable,lut_in,i_array_in,r_array_in)is
	begin
if((rising_edge(clk) and global_clock_enable='1'))then
			case lut_in(2 downto 0) is
				when "000" =>
						for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-1 downto 0);
							i_array_out(k) <= i_array_in(k)(mpr-1 downto 0);
						end loop;
				when "001" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-2 downto 0) & '0';
							i_array_out(k) <= i_array_in(k)(mpr-2 downto 0) & '0';
						end loop;
				when "010" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-3 downto 0) & "00";
							i_array_out(k) <= i_array_in(k)(mpr-3 downto 0) & "00";
						end loop;
				when "011" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-4 downto 0) & "000";
							i_array_out(k) <= i_array_in(k)(mpr-4 downto 0) & "000";
						end loop;
				when "100" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-5 downto 0) & "0000";
							i_array_out(k) <= i_array_in(k)(mpr-5 downto 0) & "0000";
						end loop;
				when others =>
					for k in 0 to 3 loop
							r_array_out(k) <= (mpr-1 downto 0 => 'X');
							i_array_out(k) <= (mpr-1 downto 0 => 'X');
						end loop;
			end case;
		end if;
	end process apply_gain;
end generate gen_4bit_bfp;

-----------------------------------------------------------------------------------------------------
-- Block floating point scaling  (5-bit)
-- FFT currently only supports 4-bit but this can be quite easily extended
gen_5bit_bfp : if(fpr=5) generate
-----------------------------------------------------------------------------------------------------
-- Block floating point scaling  (5-bit) with pipeline
apply_gain:process(clk,global_clock_enable,lut_in,i_array_in,r_array_in)is
	begin
if((rising_edge(clk) and global_clock_enable='1'))then
		  case lut_in(2 downto 0) is
				when "000" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-1 downto 0);
							i_array_out(k) <= i_array_in(k)(mpr-1 downto 0);
						end loop;
				when "001" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-2 downto 0) & '0';
							i_array_out(k) <= i_array_in(k)(mpr-2 downto 0) & '0';
						end loop;
				when "010" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-3 downto 0) & "00";
							i_array_out(k) <= i_array_in(k)(mpr-3 downto 0) & "00";
						end loop;
				when "011" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-4 downto 0) & "000";
							i_array_out(k) <= i_array_in(k)(mpr-4 downto 0) & "000";
						end loop;
				when "100" =>
					for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-5 downto 0) & "0000";
							i_array_out(k) <= i_array_in(k)(mpr-5 downto 0) & "0000";
						end loop;
				when "101" =>
				for k in 0 to 3 loop
							r_array_out(k) <= r_array_in(k)(mpr-6 downto 0) & "00000";
							i_array_out(k) <= i_array_in(k)(mpr-6 downto 0) & "00000";
						end loop;
				when others =>
					for k in 0 to 3 loop
							r_array_out(k) <= (mpr-1 downto 0 => 'X');
							i_array_out(k) <= (mpr-1 downto 0 => 'X');
						end loop;
						
			end case;
		end if;
	end process apply_gain;
end generate gen_5bit_bfp;

end;
