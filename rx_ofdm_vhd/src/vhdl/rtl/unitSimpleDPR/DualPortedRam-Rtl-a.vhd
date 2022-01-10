
architecture Rtl of DualPortedRam is

   -- Build a 2-D array type for the RAM
   subtype word_t is std_logic_vector((gDataWidth-1) downto 0);
   type memory_t is array((2**gAddressWidth - 1) downto 0) of word_t;
   -- Declare the RAM signal.
   signal ram : memory_t;
   
   attribute ramstyle : string;
   -- Possible values: MLAB, M10K, logic
   attribute ramstyle of ram : signal is "M10K";
   
begin
   process(iClk)
   begin
      if(rising_edge(iClk)) then -- Port A
         if(iWe = '1') then
            ram(to_integer(unsigned(iAddr_b))) <= iData;
         end if;
         -- Read-during-write on mixed port returns OLD data
         oQ_a <= ram(to_integer(unsigned(iAddr_a)));
         oQ_b <= ram(to_integer(unsigned(iAddr_b)));
      end if;
end process;

end architecture;