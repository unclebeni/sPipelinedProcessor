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
    i_EXMEM_RW  : in std_logic_vector(4 downto 0);

    i_MEMWB_RD  : in std_logic_vector(4 downto 0);
    i_MEMWB_RW  : in std_logic_vector(4 downto 0);

    o_ForwardA  : out std_logic_vector(1 downto 0) -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> ALU A)
                        -- 00 - ID/EX - Comes from RegFile
                        -- 10 - EX/MEM - Forwarded from prior ALU result
                        -- 01 - MEM/WB - Forwarded from memory or earlier ALU result
    o_ForwardB  : out std_logic_vector(1 downto 0) -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> Imm MUX for ALU)
                        -- 00 - ID/EX - Comes from RegFile
                        -- 10 - EX/MEM - Forwarded from prior ALU result
                        -- 01 - MEM/WB - Forwarded from memory or earlier ALU result
    );

end ForwardingUnit;

architecture behavioral of ForwardingUnit is

    -- No Hazard
        o_ForwardA = "00";
        o_ForwardB = "00";

    -- EX Hazard
        if (i_EXMEM_RW
        and (i_EXMEM_RD != 0)
        and (i_EXMEM_RD = i_IDEX_RS)) o_ForwardA = "10";

        if (i_EXMEM_RW
        and (i_EXMEM_RD != 0)
        and (i_EXMEM_RD = i_IDEX_RT)) o_ForwardB = "10";

    -- MEM Hazard
        if (i_MEMWB_RW
        and (i_MEMWB_RD != 0)
        and not(i_EXMEM_RW and (i_EXMEM_RD != 0)
            and (i_EXMEM_RD != i_IDEX_RS))
        and (i_MEMWB_RD = i_IDEX_RS)) o_ForwardA = "01";

        if (i_MEMWB_RW
        and (i_MEMWB_RD != 0)
        and not(i_EXMEM_RW and (i_EXMEM_RD != 0)
            and (i_EXMEM_RD != i_IDEX_RT))
        and (i_MEMWB_RD = i_IDEX_RT)) o_ForwardB = "01";


end behavioral;
