-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the control unit for our project 1 MIPS processor.
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshifter is

	   port(
        i_in    :   in std_logic_vector(32-1 downto 0);
        i_n     :   in std_logic_vector(32-1 downto 0);
        i_arithmetic    :   in std_logic;
        o_output    : out std_logic_vector(32-1 downto 0));
       
end barrelshifter;
