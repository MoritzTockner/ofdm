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


-- $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
-- $Revision: #7 $
-- $Date: 2010/08/05 $
-- $Author: klong $
-------------------------------------------------------------------------------
-- =head1 NAME
-- altera_conduit_bfm
-- =head1 SYNOPSIS
-- Bus Functional Model (BFM) for a Standard Conduit BFM
-------------------------------------------------------------------------------
-- =head1 DESCRIPTION
-- This is a Bus Functional Model (BFM) VHDL package for a Standard Conduit Master.
-- This package provides the API that will be used to get the value of the sampled
-- input/bidirection port or set the value to be driven to the output ports.
-- This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
-- Generation parameters:
-- output_name:                  altera_conduit_bfm_0002
-- role:width:direction:         source_eop:1:input,source_error:2:input,source_exp:6:input,source_imag:12:input,source_ready:1:output,source_real:12:input,source_sop:1:input,source_valid:1:input
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;









package altera_conduit_bfm_0002_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_0002_out_trans_t is record
      sig_source_ready_out     : std_logic_vector(0 downto 0);
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_0002_out_trans_t;

   -- input signal register
   signal reset_in                 : std_logic;
   signal sig_source_eop_in        : std_logic_vector(0 downto 0);
   signal sig_source_error_in      : std_logic_vector(1 downto 0);
   signal sig_source_exp_in        : std_logic_vector(5 downto 0);
   signal sig_source_imag_in       : std_logic_vector(11 downto 0);
   signal sig_source_real_in       : std_logic_vector(11 downto 0);
   signal sig_source_sop_in        : std_logic_vector(0 downto 0);
   signal sig_source_valid_in      : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- get source_eop value
   procedure get_source_eop               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get source_error value
   procedure get_source_error             (signal_value : out std_logic_vector(1 downto 0));
   
   -- get source_exp value
   procedure get_source_exp               (signal_value : out std_logic_vector(5 downto 0));
   
   -- get source_imag value
   procedure get_source_imag              (signal_value : out std_logic_vector(11 downto 0));
   
   -- set source_ready value
   procedure set_source_ready             (signal_value : in std_logic_vector(0 downto 0));
   
   -- get source_real value
   procedure get_source_real              (signal_value : out std_logic_vector(11 downto 0));
   
   -- get source_sop value
   procedure get_source_sop               (signal_value : out std_logic_vector(0 downto 0));
   
   -- get source_valid value
   procedure get_source_valid             (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API
   procedure event_reset_asserted;

   procedure event_source_eop_change;   

   procedure event_source_error_change;   

   procedure event_source_exp_change;   

   procedure event_source_imag_change;   

   procedure event_source_real_change;   

   procedure event_source_sop_change;   

   procedure event_source_valid_change;   

end altera_conduit_bfm_0002_vhdl_pkg;

package body altera_conduit_bfm_0002_vhdl_pkg is
   
   procedure get_source_eop               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_source_eop_in;
   
   end procedure get_source_eop;
   
   procedure get_source_error             (signal_value : out std_logic_vector(1 downto 0)) is
   begin

      signal_value := sig_source_error_in;
   
   end procedure get_source_error;
   
   procedure get_source_exp               (signal_value : out std_logic_vector(5 downto 0)) is
   begin

      signal_value := sig_source_exp_in;
   
   end procedure get_source_exp;
   
   procedure get_source_imag              (signal_value : out std_logic_vector(11 downto 0)) is
   begin

      signal_value := sig_source_imag_in;
   
   end procedure get_source_imag;
   
   procedure set_source_ready             (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_source_ready_out := signal_value;
      
   end procedure set_source_ready;
   
   procedure get_source_real              (signal_value : out std_logic_vector(11 downto 0)) is
   begin

      signal_value := sig_source_real_in;
   
   end procedure get_source_real;
   
   procedure get_source_sop               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_source_sop_in;
   
   end procedure get_source_sop;
   
   procedure get_source_valid             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := sig_source_valid_in;
   
   end procedure get_source_valid;
   
   procedure event_reset_asserted is
   begin
   
      wait until (reset_in'event and reset_in = '1');
      
   end event_reset_asserted;
   procedure event_source_eop_change is
   begin

      wait until (sig_source_eop_in'event);

   end event_source_eop_change;
   procedure event_source_error_change is
   begin

      wait until (sig_source_error_in'event);

   end event_source_error_change;
   procedure event_source_exp_change is
   begin

      wait until (sig_source_exp_in'event);

   end event_source_exp_change;
   procedure event_source_imag_change is
   begin

      wait until (sig_source_imag_in'event);

   end event_source_imag_change;
   procedure event_source_real_change is
   begin

      wait until (sig_source_real_in'event);

   end event_source_real_change;
   procedure event_source_sop_change is
   begin

      wait until (sig_source_sop_in'event);

   end event_source_sop_change;
   procedure event_source_valid_change is
   begin

      wait until (sig_source_valid_in'event);

   end event_source_valid_change;

end altera_conduit_bfm_0002_vhdl_pkg;

