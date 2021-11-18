------------------------------------------------
-- Two-bit branch prediction logic
--
-- Benito Moeckly 
-- DATE: 11.18.2021
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity branchPrediction is 
    port(
    i_enable    : in std_logic
    );
