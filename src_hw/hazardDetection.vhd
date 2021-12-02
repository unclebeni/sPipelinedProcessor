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
    i_FetchInst         : in std_logic_vector(32-1 downto 0);
    i_DecodeInst        : in std_logic_vector(32-1 downto 0);
    i_ExectuteInst      : in std_logic_vector(32-1 downto 0);
    i_branchNotTaken    : in std_logic; 
    o_RAWhazard         : out std_logic;
    o_instruction_out   : out std_logic_vector(32-1 downto 0);
    o_Flush             : out std_logic;
    o_Stall             : out std_logic;  
    o_SecondStall       : out std_logic;
    o_BRANCHhazard      : out std_logic);

    end hazardDetection;

    architecture behavior of hazardDetection is 



    begin

    ---First I want to cover all of the RAW Hazards and implement stalls as needed.

            
            


            o_Stall <= 
                             --^^^CASE 1: Both Instructions are R format (opcode 000000), currentInst Rd = incomingInst rt
                 --^^^CASE 2: Instructions are R format, currentINST Rd = incomingINST rs^^^
                 --^^^CASE 3: 
            '0'; --Base case, no stall.

    end behavior;
