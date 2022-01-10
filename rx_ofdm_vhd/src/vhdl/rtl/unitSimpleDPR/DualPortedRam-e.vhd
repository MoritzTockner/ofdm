LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DualPortedRam is
   generic (
      gDataWidth     : natural := 32;
      gAddressWidth   : natural := 4
   );

   port (
      iClk     : in std_logic;
      iAddr_a  : in std_logic_vector((gAddressWidth - 1) downto 0);
      iAddr_b  : in std_logic_vector((gAddressWidth - 1) downto 0);
      iData    : in std_logic_vector((gDataWidth - 1) downto 0);
      iWe      : in std_logic;
      oQ_a     : out std_logic_vector((gDataWidth - 1) downto 0);
      oQ_b     : out std_logic_vector((gDataWidth - 1) downto 0)
);

end entity;