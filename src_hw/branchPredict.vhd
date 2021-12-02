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
    i_taken		: in std_logic;
    i_enable    	: in std_logic;
    o_preditction	: out std_logic;
    );

	end branchPrediction;

architecture struct of branchPrediction is

--I think we will need a flipflop component to store the state of the branch prediction unit
component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;




begin

end struct;
