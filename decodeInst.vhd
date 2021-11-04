-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the instruction decoder of  
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity decodeInst is

	   port(
    		i_toDecode	:	in std_logic_vector(26-1 downto 0);
		i_RegDest	:	in std_logic;
		i_MemtoReg	:	in std_logic;
		o_RT		:	in std_logic_vector(5-1 downto 0);
		o_RS		:	in std_logic_vector(5-1 downto 0);
		o_RD		:	in std_logic_vector(5-1 downto 0);
		o_Imm		:	in std_logic_vector(16-1 downto 0));
			
       
end decodeInst;


architecture behavior of barrelshifter is

begin

	with i_RegDest select
	o_RD <=	
	i_toDecode(15 downto 11) when "1", --RD is bits 15-11 for R-format instrcutions
	"XXXXX" when others;

	with i_RegDest select
	o_RT <=
	i_toDecode(20 downto 16) when "1",
	"XXXXX" when others;

	with i_RegDest select
	o_Imm <=
	i_toDecode(16-1 downto 0) when "0",
	"XXXXXXXXXXXXXXXX" when others;
    
	o_RS	<=	i_toDecode(25 downto 21);
    
	

end behavior;
