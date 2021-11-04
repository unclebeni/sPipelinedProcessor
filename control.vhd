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
		o_ALUop	: out std_logic_vector(3 downto 0)); -- ALU op code

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

with i_opCode select
o_MemRead <=
	"1" when "000111", --lw
	"0" when others;

with i_opCode select
o_MemWrite <=
	"1" when "010010", --sw
	"0" when others;

with i_opCode select
o_branch <=
	"1" when "010101", --beq
	"1" when "010110", --bne
	"0" when others;

with i_opCode select --need to complete this
o_ALUop <=
	"0000" when ("000000" i_opCode , -- add	- add
	"0000" when "001000", -- addi	- add
	"0000" when "001001", -- addiu	- add
	"0000" when "000000", -- addu	- add
	"0010" when "000000", -- AND	- AND
	"0010" when "001100", -- ANDi	- AND
	"0000" when "001111", -- lui	- add
	"0000" when "100011", -- lw		- add
	"0101" when "000000", -- NOR	- NOR
	"0100" when "000000", -- XOR	- XOR
	"0100" when "001110", -- XORI	- XOR
	"0011" when "000000", -- OR		- OR
	"0011" when "001101", -- ORI	- OR
	"0110" when "000000", -- slt	- slt
	"0110" when "001010", -- slti	- slt
	"0111" when "000000", -- sll	- sl
	"1000" when "000000", -- srl	- sr
	"1001" when "000000", -- sra	- sr + a
	"0000" when "101011", -- sw		- add
	"0001" when "000000", -- sub	- sub
	"0001" when "000000", -- subu	- sub
	"1010" when "000100", -- beq	- beq
	"1011" when "000101", -- bne	- bne
	"XXXX" when others;

when i_opCode "000000"

with i_opCode select
o_WriteRa <=
	"1" when "011000", --jal
	"0" when others;

with i_opCode select
o_signed <=
	"0" when "000010", --addiu
	"0" when "000011", --addu
	"0" when "000111", --lw
	"0" when "000110", --lui
	"0" when "010010", --sw
	"1" when others;


end data;
