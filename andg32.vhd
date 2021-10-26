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

end andg32;

architecture struct of andg32 is 

	component andg2 is 
	
	port(i_A	: in std_logic,
	     i_B	: in std_logic,
	     o_F	: out std_logic);

end component;

begin

32bitAnd: for i in 0 to 32-1 generate
	andg: andg2 port map(
	i_A	=> i_dataA(i),
	i_B	=> i_dataB(i),
	o_F	=> o_result(i));
end generate 32bitAnd;

end struct;
