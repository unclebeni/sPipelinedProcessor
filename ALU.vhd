----------------------------------------------
--Benito Moeckly
-- Implementation of a mips ALU unit. 
--
--Date: 10/25/21
----------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
port(
	i_ALU_CTRL	: in std_logic_vector(4-1 downto 0);
	i_Adata		: in std_logic_vector(32-1 downto 0);
	i_Bdata		: in std_logic_vector(32-1 downto 0));
end ALU;  --I'm sure I need to add some more control bits to this.

architecture struct of ALU is

--define components
--define signals

begin

--map ports


end struct;
		

