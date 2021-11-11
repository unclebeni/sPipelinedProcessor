-------------------------------------------------------------------------
-- Benito Moeckly
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- fullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a structural adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is

  port(iA               : in std_logic;
       iB               : in std_logic;
       iC		: in std_logic;
       oS		: out std_logic;
       oC               : out std_logic);

end fullAdder;

architecture behavior of fullAdder is

component andg2 is

 	port(i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component;

component org2 is

	 port(i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component;

component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

signal s_1, s_2, s_3 : std_logic;

begin

g1xor2 : xorg2
port MAP(i_A	=> iA,
	 i_B	=> iB,
	 o_F	=> s_1);
g2xor : xorg2
port MAP(i_A	=> s_1,
	 i_B	=> iC,
	 o_F	=> oS); 	--This should complete the sum output
g3and2 : andg2
port MAP(i_A	=> s_1,
	 i_B	=> iC,
	 o_F	=> s_2);
g4and2 : andg2
port MAP(i_A	=> iA,
	 i_B	=> iB,
	 o_F	=> s_3);
g5or2 : org2
port MAP(i_A	=> s_2,
	 i_B	=> s_3,
	 o_F	=> oC);		--this should complete the carry output


end behavior;