-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the entire control unit for our project 1 processor
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


entity FourToOneMux

    port(
        i_Sel     :   in std_logic_vector(3-1 downto 0);
        i_D1, i_D2, i_D3, i_D4,i_D5, i_D6, i_D7, i_D8   :   in std_logic(32-1 downto 0);
        o_output  :     out std_logic_vector(32-1 downto 0)
    )
end FourToOneMux;

architecture multiplex of FourToOneMux is
begin
o_output    <=
    i_D1    when i_Sel == "000" else
    i_D2    when i_Sel == "001" else
    i_D3    when i_Sel == "010" else
    i_D4    when i_Sel == "011" else
    i_D5    when i_Sel == "100" else
    i_D6    when i_Sel == "101" else
    i_D7    when i_Sel == "110" else
    i_D8    when i_Sel == "111" else
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
end FourToOneMux;