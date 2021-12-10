------------------------------------------------
-- This is the hazard detection logic
-- Assuming working forwarding, the hazard detection has the following reponsibilities:
--      -Should an instruction that consumes data occur after a lw, we need to insert a stall
--      -Should there be a branch operation that gets taken in the ID stage
--		-We will need to flush the operation in the id stage and let the IF replace it in due time
--      -Should there be a jump operation....
--      
-- Benito Moeckly 
-- DATE: 11.18.2021
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazardDetection is 
    port(
	i_ID_EX.RegWrite	: in std_logic;
	i_ID_EX.MemRead		: in std_logic;
	i_ID_EX.Ra		: in std_logic(5-1 downto 0);
	i_ID_EX.branch  : in std_logic;			--Whether or not there is a branch operation in the ID/EX register
	i_IF_ID.Op	: in std_logic_vector(6-1 downto 0);
	i_IF_ID.Rs	: in std_logic_vector(5-1 downto 0);
	i_IF_ID.Rt	: in std_logic_vector(5-1 downto 0);
	i_ID_EX.jump	: in std_logic;
	i_branchTaken	: in std_logic;
	o_flush		: out std_logic;
	o_stall	: out std_logic);

    end hazardDetection;

    architecture mixed of hazardDetection is 


    begin


	o_stall <= '1' when i_ID_EX.MemRead and i_ID_EX.RegWrite and i_ID_EX.Ra = i_IF_ID.Rs else --When a LW Precedes a comsuming op
					'1' when i_ID_EX.MemRead and i_ID_EX.RegWrite and i_ID_EX.Ra = i_IF_ID.Rt else --When a LW Precedes a consuming op 
					'1' when i_ID_EX.MemRead and (i_IF_ID.Op = "000100" or i_IF_ID.Op = "00101") else --When a LW precedes a branch by one or two cycles
					'1' when i_EX_MEM.MemRead and (i_IF_ID.OP = "00100" or i_IF_ID.Op = "00101") else --When a LW precedes a branch by one or two cycles
					'1' when i_ID_EX.RegWrite and (i_IF_ID.Op = "00100" or i_IF_ID.Op = "00101") --When a Reg Write op precedes a branch one cycle
			else '0';

	o_flush	<= '1' when i_branchTaken and i_ID_EX.branch else --If the branch is in the ID/EX register and the branch is not taken, we will flush IF/ID
			'1' when i_ID_EX.jump else 
			else '0';
	
	
    end mixed;
