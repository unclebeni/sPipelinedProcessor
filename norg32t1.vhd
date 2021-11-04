-------------------------------------------------------------------------------
-- Benito Moeckly
-- implementation of a 32 to 1 NOR gate 
-- 
-- 11.4.21
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity norg32t1 is
port(
    i_data  :   in std_logic_vector(32-1 downto 0);
    o_result    :   out std_logic);
end norg32t1;  

architecture struct of norg32t1 is


    component org2 is

        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
      
      end component;
      
    begin

        

    end struct;