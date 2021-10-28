------------------------------------------------
--DESCRIPTION: This file contains an implementation of an
--N-bit add/sub machine
--
--09/09/21
--
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Add_Sub is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		nAdd_Sub	: in std_logic;
		oSum	: out std_logic_vector(N-1 downto 0));
end Add_Sub;

architecture struct of Add_Sub is

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component onescompliment_N is
	generic(N : integer := 32); --Generic i/o data width
	port(	i_A	: in std_logic_vector(N-1 downto 0);
		o_F	: out std_logic_vector(N-1 downto 0));
end component;

component fullAdderN is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		iC	: in std_logic_vector(N-1 downto 0);
		oC	: out std_logic_vector(N-1 downto 0);
		oS	: out std_logic_vector(N-1 downto 0));
end component;

signal invertedB : std_logic_vector(N-1 downto 0); --not sure what to make the size be, not sure if i need this
signal selectedB : std_logic_vector(N-1 downto 0);
signal carryIn : std_logic_vector(N-1 downto 0);
signal carryOut : std_logic_vector(N-1 downto 0);

begin

	carryIn(0) <= nAdd_Sub;
--invert the second input first
invert: onescompliment_N
	port map (
		i_A	=> iB,
		o_F	=> invertedB);--NEED a signal here--

--select between original second input and inverted input with the mux. Set the (0) bit of the carry in to the value of the select for two's compliment

selectOp: mux2t1_N
	port map(i_S	=> nAdd_Sub,
		 i_D0	=> iB,
		 i_D1	=> invertedB,--inverted iB--
		 o_O	=> selectedB); --need another signal here

--add the first input and selected input. Carry in is the nAdd_Sub value
add: fullAdderN
	port map(iA	=> iA,
		 iB	=> selectedB,--the selected iB value (negative or positive
		 iC	=> carryIn,
		 oC	=> carryOut,
		 oS	=> oSum);

end struct;