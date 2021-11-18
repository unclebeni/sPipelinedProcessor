------------------------------------------------
-- Two-bit branch prediction logic
--
-- Benito Moeckly 
-- DATE: 11.18.2021
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazardDetection is 
    port(
    i_currentInst   : in std_logic_vector(32-1 downto 0);
    i_incomingInst  : in std_logic_vector(32-1 downto 0);
    o_RAWhazard     : out std_logic;
    o_instruction_out : out std_logic_vector(32-1 downto 0);
    o_BRANCHhazard  : out std_logic);

    end hazardDetection;

    architecture behavior of hazardDetection is 

    begin



        end behavior;
