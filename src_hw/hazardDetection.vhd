------------------------------------------------
-- This is the hazard detection logic
-- Assuming working forwarding, the hazard detection has the following reponsibilities:
--      -Should an instruction that consumes data occur after a lw, we need to insert a stall
--      -Should there be a branch operation in the ID/EX register, we stall the PC and stall the IF/ID
--              when the branch operation gets to the EX/MEM register, Flush the IF/ID register and continue
--      -JUMP OPERATIONS???
-- Benito Moeckly 
-- DATE: 11.18.2021
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazardDetection is 
    port(
    i_ID_EX         : in std_logic_vector(32-1 downto 0);
    i_IF_ID         : in std_logic_vector(32-1 downto 0);
    i_EX_MEM        : in std_logic_vector(32-1 downto 0);
   -- i_branchTaken    : in std_logic; 
    o_Flush_IF_ID             : out std_logic;
    o_Stall_IF_ID             : out std_logic;
    o_Stall_ID_EX             : out std_logic;
    o_Stall_ID_EX             : out std_logic;
    o_Stall_PC           : out std_logic;
    o_BRANCHhazard      : out std_logic);

    end hazardDetection;

    architecture mixed of hazardDetection is 

    signal id_ex.rt, id_ex.rd, if_id.rt, if_id.rs, ex_mem.rs, ex_mem.rt    : std_logic_vector(5-1 downto 0 );
    signal id_ex.op, if_id.op, ex_mem.op   : std_logic_vector(6-1);
    signal if_id.consumable : std_logic; -----This will be true when the if_id instruction is an operation that consumes a register value
    signal if_id.rformat : std_logic; --This will be '1' when the if_id instruction is an r format instruction
    signal if_id.immediate : std_logic; -- This will be true if the IF_ID instruction is an immediate instruction that consumes a value

    begin

        id_ex.rt <= i_ID_EX(20 downto 16);
        id_ex.rd <= i_ID_EX(15 downto 11);
        id_ex.op <= i_ID_EX(31 downto 26);

        if_id.rt <= i_IF_ID(20 downto 16);
        if_id.rs <= i_IF_ID(25 downto 21);
        if_id.op <= i_IF_ID(31 downto 26);

        ex_mem.rs <= i_EX_MEM(25 downto 21);
        ex_mem.rt <= i_EX_MEM(20 downto 16);
        ex_mem.op <= i_EX_MEM(31 downto 26);



--First we implement stalling
        --lw case : The ID_EX instruction is a lw and ID/EX.Rt = IF/ID.Rs or ID/EX.Rt = IF/ID.Rt ... when IF/ID is an instruction that consumes a value
        --branch case: when making a branch descision, we need to decide how to handle that....
                        --The hazard is when there is a branch instruction in the ex/mem register and we are taking the branch

-------This logic decides if the if_id operation is and r-format

	if_id.rformat <= '1' when if_id.op = "000000" else '0';

	if_id.immediate <= '1' when if_id.op = "001000" or if_id.op = "001001" or if_id.op = "001100" or if_id.op = "001111" or if_id.op = "100011" or if_id.op = "001110" or
				if_id.op = "001101" or if_id.op = "001010" or if_id.op "101011" else '0';  ---This should cover all of the cases of immediate values that are NOT Branches



        o_Stall_IF_ID <= '1' when id_ex.op = "100011" and if_id.rformat and ((id_ex.rt = if_id.rs) or id_ex.rt = if_id.rt) else --This covers lw case for r format if_id instructions
			 '1' when id_ex.op = "100011" and if_id.immediate and (id_ex.rt = if_id.rs) else '1' when (if_id.op = "00100" or if_id.op = "00101" else '0'; --This should cover the lw case for immediate instructions

	o_Stall_PC <= '1' when if_id.op = "00100" else '1' when if_id.op = "00101" else '0';
						
						
        i_Flush <= '1' when (ex_mem.op = "00100" or ex_mem.op = (00101)) and i_branchTaken = '1' else --When taking the branch, we should flush. 
                        '0'; --base case, no flush
                

    end mixed;
