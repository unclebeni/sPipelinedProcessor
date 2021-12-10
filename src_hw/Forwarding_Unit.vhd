------------------------------------------------
-- DESCRIPTION: This file contains the implementation for
-- Behavioral based Pipeline Fowarding Unit
--
-- AUTHOR: Cole Hunt
-- CREATED: 11/18/21
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is

    port(
    i_IDEX_RS   : in std_logic_vector(4 downto 0);
    i_IDEX_RT   : in std_logic_vector(4 downto 0);

    i_EXMEM_RD  : in std_logic_vector(4 downto 0);
    i_EXMEM_RW  : in std_logic;

    i_MEMWB_RD  : in std_logic_vector(4 downto 0);
    i_MEMWB_RW  : in std_logic;

    o_ForwardA  : out std_logic_vector(1 downto 0); -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> ALU A)
                                                    -- 00 - ID/EX - Comes from RegFile
                                                    -- 10 - EX/MEM - Forwarded from prior ALU result
                                                    -- 01 - MEM/WB - Forwarded from memory or earlier ALU result

    o_ForwardB  : out std_logic_vector(1 downto 0)  -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> Imm MUX for ALU)
                                                    -- 00 - ID/EX - Comes from RegFile
                                                    -- 10 - EX/MEM - Forwarded from prior ALU result
                                                    -- 01 - MEM/WB - Forwarded from memory or earlier ALU result
    );

end ForwardingUnit;

architecture behavior of ForwardingUnit is



    begin

        o_ForwardA <=
                        -- EX Hazard
                        "10" when (i_EXMEM_RW = '1'
                        and (i_EXMEM_RD /= "00000")
                        and (i_EXMEM_RD = i_IDEX_RS)) else

                        --MEM Hazard
                        "01" when (i_MEMWB_RW = '1'
                        and (i_MEMWB_RD /= "00000")
                        and not(i_EXMEM_RW = '1' and (i_EXMEM_RD /= "00000")
                            and (i_EXMEM_RD /= i_IDEX_RS))
                        and (i_MEMWB_RD = i_IDEX_RS)) else

                        -- No Hazard
                        "00";

        o_ForwardB <=
                        -- EX Hazard
                        "10" when (i_EXMEM_RW = '1'
                        and (i_EXMEM_RD /= "00000")
                        and (i_EXMEM_RD = i_IDEX_RT)) else

                        --MEM Hazard
                        "01" when (i_MEMWB_RW = '1'
                        and (i_MEMWB_RD /= "00000")
                        and not(i_EXMEM_RW = '1' and (i_EXMEM_RD /= "00000")
                            and (i_EXMEM_RD /= i_IDEX_RT))
                        and (i_MEMWB_RD = i_IDEX_RT)) else

                        -- No Hazard
                        "00";

end behavior;
