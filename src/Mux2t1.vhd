-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Mux2:1
-------------------------------------------------------------------------

-- Mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 multiplexer.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2t1 is
	port(i_D0	: in std_logic;
       	     i_D1	: in std_logic;
       	     i_S	: in std_logic;
       	     o_O	: out std_logic);
end Mux2t1;

architecture structure of Mux2t1 is

component org2 is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     o_F	: out std_logic);
end component;

component andg2 is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     o_F	: out std_logic);
end component;

component invg is
	port(i_A	: in std_logic;
	     o_F	: out std_logic);
end component;

signal s_A1	: std_logic;
signal s_A2	: std_logic;
signal s_N	: std_logic;

begin

and1: andg2
	port MAP(i_A => i_D1,
		 i_B => i_S,
		 o_F => s_A1);

not1: invg
	port MAP(i_A => i_S,
		 o_F => s_N);

and2: andg2
	port MAP(i_A => i_D0,
		 i_B => s_N,
		 o_F => s_A2);

or1: org2
	port MAP(i_A => s_A1,
		 i_B => s_A2,
		 o_F => o_O);
end structure;
