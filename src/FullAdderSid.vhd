-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- FullAdder
-------------------------------------------------------------------------

-- FullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Full Adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdderSid is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     i_C	: in std_logic;
	     o_S	: out std_logic;
	     o_C	: out std_logic);
end FullAdderSid;

architecture structural of FullAdderSid is

component invg is
	port(i_A	: in std_logic;
	     o_F	: out std_logic);
end component;

component andg2 is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     o_F	: out std_logic);
end component;

component org2 is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     o_F	: out std_logic);
end component;

signal A, B, C, nA, nB, nC, xor1, xor1and1, xor1and2, nxor1, xor2, xor2and1, 
xor2and2, coand1, coand2, coor	: std_logic;

begin
	A <= i_A;
	B <= i_B;
	C <= i_C;
	
	NOTA: invg port map(i_A => A, o_F => nA);
	NOTB: invg port map(i_A => B, o_F => nB);
	NOTC: invg port map(i_A => C, o_F => nC);

	MXOR1AND1: andg2 port map(i_A => A, i_B => nB, o_F => xor1and1);
	MXOR1AND2: andg2 port map(i_A => nA, i_B => B, o_F => xor1and2);
	MXOR1OR: org2 port map(i_A => xor1and1, i_B => xor1and2, o_F => xor1);
	MNXOR1: invg port map(i_A => xor1, o_F => nxor1);

	MXOR2AND1: andg2 port map(i_A => xor1, i_B => nC, o_F => xor2and1);
	MXOR2AND2: andg2 port map(i_A => nxor1, i_B => C, o_F => xor2and2);
	MXOR2OR: org2 port map(i_A => xor2and1, i_B => xor2and2, o_F => xor2);

	MCOAND1: andg2 port map(i_A => xor1, i_B => C, o_F => coand1);
	MCOAND2: andg2 port map(i_A => A, i_B => B, o_F => coand2);
	MCOOR: org2 port map(i_A => coand1, i_B => coand2, o_F => coor);

	o_S <= xor2;
	o_C <= coor;

end structural;
