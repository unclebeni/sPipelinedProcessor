-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- Register
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit register.
--
-- NOTES:
-- 9/16/21 by Sid::Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
	generic(N : integer := 32);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end PC;

architecture structural of PC is
	
component dffg is
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic;
	     o_Q	: out std_logic);
end component dffg;

component PCff is
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic;
	     o_Q	: out std_logic);
end component PCff;

begin
	N_Bit_REGpt1: for i in 0 to 21 generate
	DFFGI: dffg port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_WE,
		i_D	=> i_D(i),
		o_Q	=> o_R(i));
	end generate N_BIT_REGpt1;

	FF22: PCff port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_WE,
		i_D	=> i_D(22),
		o_Q	=> o_R(22));

	N_Bit_REGpt2: for i in 23 to 31 generate
	DFFGI: dffg port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_WE,
		i_D	=> i_D(i),
		o_Q	=> o_R(i));
	end generate N_BIT_REGpt2;
end structural;
