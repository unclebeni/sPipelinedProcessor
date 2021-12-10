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
	i_ID_EX_RegWrite	: in std_logic;
	i_ID_EX_MemRead		: in std_logic;
	i_ID_EX_Ra		: in std_logic_vector(5-1 downto 0);
	i_ID_EX_branch  : in std_logic;			--Whether or not there is a branch operation in the ID/EX register
	i_IF_ID_Op	: in std_logic_vector(6-1 downto 0);
	i_IF_ID_Rs	: in std_logic_vector(5-1 downto 0);
	i_IF_ID_Rt	: in std_logic_vector(5-1 downto 0);
	i_ID_EX_jump	: in std_logic;
	i_EX_MEM_MemRead : in std_logic;
	i_branchTaken	: in std_logic;
	o_flush		: out std_logic;
	o_stall	: out std_logic);

    end hazardDetection;

    architecture mixed of hazardDetection is 

	signal Rs_Equal, Rt_Equal, branchEqual, branchNotEqual : std_logic;

    begin


	Rs_Equal <= '1' when i_ID_EX_Ra = i_IF_ID_Rs else '0';
	Rt_Equal <= '1' when i_ID_EX_Ra = i_IF_ID_Rt else '0';
	branchEqual <= '1' when i_IF_ID_Op = "000100" else '0';
	branchNotEqual <= '1' when i_IF_ID_Op = "000101" else '0';
	


	o_stall <= '1' when i_ID_EX_MemRead ='1' and i_ID_EX_RegWrite = '1' and Rs_Equal = '1' else --When a LW Precedes a comsuming op
					'1' when (i_ID_EX_MemRead ='1' and i_ID_EX_RegWrite ='1') and (Rt_Equal ='1') else --When a LW Precedes a consuming op 
					'1' when i_ID_EX_MemRead='1' and (branchEqual='1' or branchNotEqual='1') else --When a LW precedes a branch by one or two cycles
					'1' when i_EX_MEM_MemRead='1' and (branchEqual='1' or branchNotEqual='1') else --When a LW precedes a branch by one or two cycles
					'1' when i_ID_EX_RegWrite='1' and (branchEqual='1' or branchNotEqual='1') --When a Reg Write op precedes a branch one cycle
			else '0';

	o_flush	<= '1' when (i_branchTaken='1' and i_ID_EX_branch='1') or --If the branch is in the ID/EX register and the branch is not taken, we will flush IF/ID
			i_ID_EX_jump='1' else '0';
	
	
    end mixed;
