------------------------------------------------
-- This is the hazard detection logic
-- Assuming working forwarding, the hazard detection has the following reponsibilities:
--      -Should an instruction that consumes data occur after a lw, we need to insert a stall
--      -Should there be a branch operation....
--      -Should there be a jump operation....
--      
-- Benito Moeckly 
-- DATE: 11.18.2021
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazardDetection is 
    port(
	i_ID_EX.RegWrite	: std_logic;
	i_ID_EX.MemRead		: std_logic;
	i_ID_EX.Ra		: std_logic(5-1 downto 0);
	i_IF_ID.Op	: std_logic_vector(6-1 downto 0);
	i_IF_ID.Rs	: std_logic_vector(5-1 downto 0);
	i_IF_ID.Rt	: std_logic_vector(5-1 downto 0);
	i_branchTaken	: std_logic;
	o_flush		: std_logic;
	o_stall_PC	: std_logic;
	o_stall_id	: std_logic);

    end hazardDetection;

    architecture mixed of hazardDetection is 


    begin

	o_stall_PC <= '1' when i_ID_EX.MemRead and i_ID_EX.Ra = i_IF_ID.Rs
			else '0';


	o_stall_id <= '1' when i_ID_EX.MemRead and i_ID_EX.Ra = i_IF_ID.Rs
			else '0';

	o_flush	<= '1' when i_branchTaken 
			else '0';

    end mixed;
