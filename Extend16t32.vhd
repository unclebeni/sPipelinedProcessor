-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- Extend16t32
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of 16 to 32 bit extender.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Extend16t32 is
	port(i_D	: in std_logic_vector(15 downto 0);
	     i_SignZero	: in std_logic;
	     o_D	: out std_logic_vector(31 downto 0));
end Extend16t32;

architecture behavioral of Extend16t32 is

signal s_extended	: std_logic_vector(31 downto 0);
signal s_Sign	: std_logic;
signal s_extend	: std_logic_vector(15 downto 0);

begin

	s_Sign <= i_D(15);

	with i_SignZero and s_Sign select
		s_extend <= x"0000" when '0',
		x"FFFF" when '1',
		x"0000" when others;
	
	s_extended(31) <= s_extend(15);
	s_extended(30) <= s_extend(14);
	s_extended(29) <= s_extend(13);
	s_extended(28) <= s_extend(12);
	s_extended(27) <= s_extend(11);
	s_extended(26) <= s_extend(10);
	s_extended(25) <= s_extend(9);
	s_extended(24) <= s_extend(8);
	s_extended(23) <= s_extend(7);
	s_extended(22) <= s_extend(6);
	s_extended(21) <= s_extend(5);
	s_extended(20) <= s_extend(4);
	s_extended(19) <= s_extend(3);
	s_extended(18) <= s_extend(2);
	s_extended(17) <= s_extend(1);
	s_extended(16) <= s_extend(0);
	s_extended(15) <= i_D(15);
	s_extended(14) <= i_D(14);
	s_extended(13) <= i_D(13);
	s_extended(12) <= i_D(12);
	s_extended(11) <= i_D(11);
	s_extended(10) <= i_D(10);
	s_extended(9) <= i_D(9);
	s_extended(8) <= i_D(8);
	s_extended(7) <= i_D(7);
	s_extended(6) <= i_D(6);
	s_extended(5) <= i_D(5);
	s_extended(4) <= i_D(4);
	s_extended(3) <= i_D(3);
	s_extended(2) <= i_D(2);
	s_extended(1) <= i_D(1);
	s_extended(0) <= i_D(0);

	o_D <= s_extended;

end behavioral;