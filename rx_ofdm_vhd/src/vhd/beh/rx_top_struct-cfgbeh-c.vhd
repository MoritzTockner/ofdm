--#------------------------------------------------------------------
--# File name=       rx_top_struct-cfgbeh-c.vhd
--# CCASE_USER=      "inserted automatically at check-in"
--# CCASE_VERSION=   "inserted automatically at check-in"
--# CCASE_DATE=      "inserted automatically at check-in"
--# CCASE_HWPROJECT= "inserted automatically at check-in"
--# Comments=         
--#
--# Copyright(c) Infineon AG 2021 all rights reserved
--#------------------------------------------------------------------

configuration rx_top_struct_cfgbeh of rx_top is
  for struct
    for rx_input_1 : rx_input
      use entity work.rx_input(beh);
    end for;
    for rx_sync_1 : rx_sync
      use entity work.rx_sync(beh);
    end for;
    for rx_fft_1 : rx_fft
      use entity work.rx_fft(beh);
    end for;
    for rx_equalize_1 : rx_equalize
      use entity work.rx_equalize(beh);
    end for;
    for rx_tracking_1 : rx_tracking
      use entity work.rx_tracking(beh);
    end for;
    for rx_demodulation_1 : rx_demodulation
      use entity work.rx_demodulation(beh);
    end for;
  end for;
end rx_top_struct_cfgbeh;


