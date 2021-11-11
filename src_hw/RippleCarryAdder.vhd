-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- RippleCarryAdder
-------------------------------------------------------------------------

-- RippleCarryAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Ripple Carry Adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity RippleCarryAdder is
	generic(N : integer := 32);
	port(i_A	: in std_logic_vector(N-1 downto 0);
	     i_B	: in std_logic_vector(N-1 downto 0);
	     i_C	: in std_logic;
	     o_S	: out std_logic_vector(N-1 downto 0);
	     o_C	: out std_logic);
end RippleCarryAdder;

architecture structural of RippleCarryAdder is

component FullAdderSid is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     i_C	: in std_logic;
	     o_S	: out std_logic;
	     o_C	: out std_logic);
end component;

signal Cip	: std_logic_vector(N-1 downto 0);

begin
	ADDER0: FullAdderSid port map(i_A => i_A(0), i_B => i_B(0), i_C => i_C, o_S => o_S(0), o_C => Cip(0));

	G_NBit_RCA: for i in 1 to N-1 generate
		ADDERI: FullAdderSid port map(i_A => i_A(i), i_B => i_B(i), i_C => Cip(i-1), o_S => o_S(i), o_C => Cip(i));
	end generate G_NBit_RCA;
	o_C <= Cip(N-1);
end structural;
