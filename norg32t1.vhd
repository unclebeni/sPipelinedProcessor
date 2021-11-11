-------------------------------------------------------------------------------
-- Benito Moeckly
-- implementation of a 32 to 1 NOR gate 
-- 
-- 11.4.21
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity norg32t1 is
port(
    i_data  :   in std_logic_vector(32-1 downto 0);
    o_result    :   out std_logic);
end norg32t1;  

architecture data of norg32t1 is

begin
	o_result <= not (i_data(0) or i_data(1) or i_data(2) or i_data(3) or i_data(4) or i_data(5) or i_data(6) or i_data(7) or
 			i_data(8) or i_data(9) or i_data(10) or i_data(11) or i_data(12) or i_data(13) or i_data(14) or i_data(15) or
			i_data(16) or i_data(17) or i_data(18) or i_data(19) or i_data(20) or i_data(21) or i_data(22) or i_data(23) or 
			i_data(24) or i_data(25) or i_data(26) or i_data(27) or i_data(28) or i_data(29) or i_data(30) or i_data(31)); 
		
    end data;
