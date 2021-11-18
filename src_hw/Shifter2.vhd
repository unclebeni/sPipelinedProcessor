-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- Shifter2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a shifter that shifts a 32bit by 2 bits.
--
-- NOTES:
-- 9/23/21 by Sid::Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter2 is
	port(i_D	: in std_logic_vector(31 downto 0);
	     o_D	: out std_logic_vector(31 downto 0));
end Shifter2;

architecture dataflow of Shifter2 is

begin
	o_D(31) <= i_D(29);
	o_D(30) <= i_D(28);
	o_D(29) <= i_D(27);
	o_D(28) <= i_D(26);
	o_D(27) <= i_D(25);
	o_D(26) <= i_D(24);
	o_D(25) <= i_D(23);
	o_D(24) <= i_D(22);
	o_D(23) <= i_D(21);
	o_D(22) <= i_D(20);
	o_D(21) <= i_D(19);
	o_D(20) <= i_D(18);
	o_D(19) <= i_D(17);
	o_D(18) <= i_D(16);
	o_D(17) <= i_D(15);
	o_D(16) <= i_D(14);
	o_D(15) <= i_D(13);
	o_D(14) <= i_D(12);
	o_D(13) <= i_D(11);
	o_D(12) <= i_D(10);
	o_D(11) <= i_D(9);
	o_D(10) <= i_D(8);
	o_D(9) <= i_D(7);
	o_D(8) <= i_D(6);
	o_D(7) <= i_D(5);
	o_D(6) <= i_D(4);
	o_D(5) <= i_D(3);
	o_D(4) <= i_D(2);
	o_D(3) <= i_D(1);
	o_D(2) <= i_D(0);
	o_D(1) <= '0';
	o_D(0) <= '0';

end dataflow;
