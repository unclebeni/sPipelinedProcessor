-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- Decoder
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 5:32-bit decoder.
--
-- NOTES:
-- 9/23/21 by Sid::Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Decoder is
	port(i_WE	: in std_logic;
	     i_D	: in std_logic_vector(4 downto 0);	
	     o_D	: out std_logic_vector(31 downto 0));
end Decoder;

architecture dataflow of Decoder is

signal D: std_logic_vector(31 downto 0);

begin
	o_D <= D;
	D <= x"00000001" when i_D = "00000" else
		x"00000002" when i_D = "00001" else
		x"00000004" when i_D = "00010" else
		x"00000008" when i_D = "00011" else
		x"00000010" when i_D = "00100" else
		x"00000020" when i_D = "00101" else
		x"00000040" when i_D = "00110" else
		x"00000080" when i_D = "00111" else
		x"00000100" when i_D = "01000" else
		x"00000200" when i_D = "01001" else
		x"00000400" when i_D = "01010" else
		x"00000800" when i_D = "01011" else
		x"00001000" when i_D = "01100" else
		x"00002000" when i_D = "01101" else
		x"00004000" when i_D = "01110" else
		x"00008000" when i_D = "01111" else
		x"00010000" when i_D = "10000" else
		x"00020000" when i_D = "10001" else
		x"00040000" when i_D = "10010" else
		x"00080000" when i_D = "10011" else
		x"00100000" when i_D = "10100" else
		x"00200000" when i_D = "10101" else
		x"00400000" when i_D = "10110" else
		x"00800000" when i_D = "10111" else
		x"01000000" when i_D = "11000" else
		x"02000000" when i_D = "11001" else
		x"04000000" when i_D = "11010" else
		x"08000000" when i_D = "11011" else
		x"10000000" when i_D = "11100" else
		x"20000000" when i_D = "11101" else
		x"40000000" when i_D = "11110" else
		x"80000000" when i_D = "11111";

end dataflow;