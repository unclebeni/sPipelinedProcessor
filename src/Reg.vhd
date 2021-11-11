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

entity Reg is
	generic(N : integer := 32);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end Reg;

architecture structural of Reg is
	
component dffg is
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic;
	     o_Q	: out std_logic);
end component dffg;

begin
	N_Bit_REG: for i in 0 to N-1 generate
	DFFGI: dffg port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_WE,
		i_D	=> i_D(i),
		o_Q	=> o_R(i));
	end generate N_BIT_REG;
end structural;