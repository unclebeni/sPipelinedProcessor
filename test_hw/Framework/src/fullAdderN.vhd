------------------------------------------------
--DESCRIPTION: This file contains an implementation of an
--N-bit ripple-carry full adder using structural vhdl.
--
--09/09/21
--
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdderN is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		iC	: in std_logic_vector(N-1 downto 0);   --Needs to be a vector, will normally be initialized to zero but bit 0 will be useful for two's compliment subraction
		oC	: out std_logic_vector(N-1 downto 0);
		oS	: out std_logic_vector(N-1 downto 0));
end fullAdderN;

architecture struct of fullAdderN is

	component fullAdder is
		port(iA               : in std_logic;
       		iB               : in std_logic;
      		iC		: in std_logic;
      		oS		: out std_logic;
       		oC               : out std_logic);
	end component;
	
	
	component xorg2 is

  		port(i_A          : in std_logic;
		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component xorg2;
		
signal carry	: std_logic_vector(N-1 downto 0);

begin

--Instatiate the N invg instances--

loop1 : for i in 0 to 0 generate
	rippleAdder : fullAdder port map(
	iA	=>	iA(i),
	iB	=>	iB(i),
	iC	=>	iC(i),
	oS	=>	oS(i),
	oC	=>	carry(i));
end generate loop1;

loop2 : for i in 1 to N-1 generate
	rippleAdder2 : fullAdder port map(
	iA	=>	iA(i),
	iB	=>	iB(i),
	iC	=>	carry(i-1),
	oS	=>	oS(i),
	oC	=>	carry(i));
end generate loop2;

oC	<= carry;

end struct;
