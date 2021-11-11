-------------------------------------------------------------------
-- Benito Moeckly
-- 
-- Shift gate for the lui instruction
--
-- CREATED ON: 11.4.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity luiShifter is

	   port(
           i_data : in std_logic_vector(16-1 downto 0);
           o_out    : out std_logic_vector(32-1 downto 0));

end luiShifter;



architecture struct of luiShifter is

    begin

    o_out(16-1 downto 0)	<= 	(16-1 downto 0 => '0');
    o_out(32-1 downto 16)   <= i_data(16-1 downto 0);

end struct;
