------------------------------------------------
--DESCRIPTION: This file contains an implementation of an N-bit ones complimenter
--using structural vhdl.
--
--09/09/21
--
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onescompliment_N is
	generic(N : integer := 16); --Generic i/o data width
	port(	i_A	: in std_logic_vector(N-1 downto 0);
		o_F	: out std_logic_vector(N-1 downto 0));
end onescompliment_N;

architecture struct of onescompliment_N is

	component invg is
		port(i_A	: in std_logic;
		     o_F	: out std_logic);
end component;

begin

--Instatiate the N invg instances--

Nbit_onescompliment: for i in 0 to N-1 generate
	onesComp: invg port map(
	i_A	=> i_A(i),
	o_F     => o_F(i));
end generate Nbit_onescompliment;

end struct;
