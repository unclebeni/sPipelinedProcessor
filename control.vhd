-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the control unit for our project 1 MIPS processor.
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity operationDecode is

	port(i_opCode  	: in std_logic_vector(5 downto 0);
		i_functCode : in std_logic_vector(5 downto 0);
		o_RegDest 	: out std_logic; -- '1' when using R format instruction
		o_ALUSrc	: out std_logic; -- '1' for immediate value operations
		o_MemtoReg	: out std_logic; -- '1' for load word
		o_RegWrite	: out std_logic; -- '1' for storing to register
		o_MemRead	: out std_logic; -- '1' for reading memory
		o_MemWrite	: out std_logic; -- '1' for store word in memory
		o_branch	: out std_logic; -- '1' for branch and jump operations
		o_WriteRa	: out std_logic; -- '1' when using jal
		o_signed	: out std_logic; -- '1' when adding or subtracting a signed number
		o_bneOp		: out std_logic; -- '1' when bne operation
		o_ALUop		: out std_logic_vector(3 downto 0)); -- ALU op code

end operationDecode;

architecture data of decoder is

begin

o_RegDest<=	"1"
				(i_opCode = "000000" && i_functCode = "100000") else -- add
				(i_opCode = "000000" && i_functCode = "100001") else -- addu
				(i_opCode = "000000" && i_functCode = "100100") else -- and
				(i_opCode = "000000" && i_functCode = "100111") else -- nor
				(i_opCode = "000000" && i_functCode = "100110") else -- xor
				(i_opCode = "000000" && i_functCode = "100101") else -- or
				(i_opCode = "000000" && i_functCode = "101010") else -- slt
				(i_opCode = "000000" && i_functCode = "000000") else -- sll
				(i_opCode = "000000" && i_functCode = "000010") else -- srl
				(i_opCode = "000000" && i_functCode = "000011") else -- sra
				(i_opCode = "000000" && i_functCode = "100010") else -- sub
				(i_opCode = "000000" && i_functCode = "100011") else -- subu
			"0";

o_ALUSrc<=	"1"
				(i_opCode = "001000") else -- addi
				(i_opCode = "001001") else -- addiu
				(i_opCode = "001100") else -- andi
				(i_opCode = "001111") else -- lui
				(i_opCode = "100011") else -- lw
				(i_opCode = "001110") else -- xori
				(i_opCode = "001101") else -- ori
				(i_opCode = "001010") else -- slti
				(i_opCode = "101011") else -- sw
			"0";

o_MemToReg<="1"
				(i_opCode = "100011") else -- lw
			"0";

o_RegWrite<="0"
				(i_opCode = "101011") else -- sw
				(i_opCode = "000100") else -- beq
				(i_opCode = "000101") else -- bne
				(i_opCode = "000010") else -- j
				(i_opCode = "000011") else -- jal
				(i_opCode = "000000" && i_functCode = "001000") -- jr
				(i_opCode = "011111") else --repl.qb
			"1";

o_MemRead <="1"
				(i_opCode = "100011") else -- lw
			"0";

o_MemWrite<="1"
				(i_opCode = "101011") else -- sw
			"0";

o_branch<= 	"1"
				(i_opCode = "000100") else -- beq
				(i_opCode = "000101") else -- bne
			"0";

o_ALUop <=
	"0000" when (i_opCode == "000000" && i_functCode == "100000") else 	-- add 		- add
	"0000" when (i_opCode == "001000") else 							-- addi		- add
	"0000" when (i_opCode == "001001") else 							-- addiu	- add
	"0000" when (i_opCode == "000000" && i_functCode == "100001") else 	-- addu		- add
	"0010" when (i_opCode == "000000" && i_functCode == "100100") else 	-- AND		- AND
	"0010" when (i_opCode == "001100") else  							-- ANDi		- AND
	"0000" when (i_opCode == "001111") else 							-- lui		- add
	"0000" when (i_opCode == "100011") else 							-- lw		- add
	"0101" when (i_opCode == "000000" && i_functCode == "100111") else 	-- NOR		- NOR
	"0100" when (i_opCode == "000000" && i_functCode == "100110") else 	-- XOR		- XOR
	"0100" when (i_opCode == "001110") else 							-- XORI		- XOR
	"0011" when (i_opCode == "000000" && i_functCode == "100101") else 	-- OR		- OR
	"0011" when (i_opCode == "001101") else 							-- ORI		- OR
	"0110" when (i_opCode == "000000" && i_functCode == "101010") else 	-- slt		- slt
	"0110" when (i_opCode == "001010") else 							-- slti		- slt
	"0111" when (i_opCode = "000000" && i_functCode = "000000") else	-- sll		- sl
	"1000" when (i_opCode = "000000" && i_functCode = "000010") else 	-- srl		- sr
	"1001" when (i_opCode = "000000" && i_functCode = "000011") else 	-- sra		- sr + a
	"0000" when (i_opCode = "101011") else 								-- sw		- add
	"0001" when (i_opCode = "000000" && i_functCode = "100010") else 	-- sub		- sub
	"0001" when (i_opCode = "000000" && i_functCode = "100011") else 	-- subu		- sub
	"1010" when (i_opCode = "000100") else 								-- beq	- beq
	"1011" when (i_opCode = "000101") else 								-- bne	- bne
	"XXXX" when others;

o_WriteRa<=	"1"
		 		(i_opCode = "000011") else -- jal
			"0";


o_signed<=	"0"
				(i_opCode == "001001") else -- addiu
				(i_opCode == "000000" && i_functCode == "100001") else -- addu
				(i_opCode == "100011") else --lw
				(i_opCode == "001111") else --lui
				(i_opCode = "101011") else --sw
			"1";

o_bneOp<=	"1"
				(i_opCode = "000101") else -- bne
			"0";

end data;
