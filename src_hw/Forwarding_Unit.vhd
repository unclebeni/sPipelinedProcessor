------------------------------------------------
-- DESCRIPTION: This file contains the implementation for
-- Hardware based Pipeline Fowarding Unit
--
-- AUTHOR: Cole Hunt
-- CREATED: 11/18/21
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is

    port(
    i_RS        :
    i_RT        :
    i_EXMEM-RD  :
    i_MEMWB-RD  :
    o_ForwardA  : out -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> ALU A)
                        -- 00 - ID/EX - Comes from RegFile
                        -- 10 - EX/MEM - Forwarded from prior ALU result
                        -- 01 - MEM/WB - Forwarded from memory or earlier ALU result
    o_ForwardB  : out -- Output to Signal 3 to 1 MUX  (ID/EX - luiMUX Output - EX/MEM -> Imm MUX for ALU)
                        -- 00 - ID/EX - Comes from RegFile
                        -- 10 - EX/MEM - Forwarded from prior ALU result
                        -- 01 - MEM/WB - Forwarded from memory or earlier ALU result
    );

end ForwardingUnit;

architecture struct of ForwardingUnit is

end struct;
