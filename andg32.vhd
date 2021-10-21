-------------------------------------------------------------------
-- Benito Moeckly
-- 32 BIT WIDE AND GATE:
-- This is a 32 bit and gate for the ALU in our MIPS processor
--
-- CREATED ON: 10.22.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity andg32 is

	   port(i_dataA	: in: std_logic_vector(32-1 downto 0);
		i_dataB	: in: std_logic_vector(32-1 downto 0);
		o_result : in : std_logic_vector(32-1 downto 0);

end decoder;