-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the control unit for our project 1 MIPS processor.
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity control is

	port(i_opCode  	: in std_logic_vector(5 downto 0);
		i_functCode : in std_logic_vector(5 downto 0);
		o_RegDest 	: out std_logic; -- '1' when using R format instruction
		o_ALUSrc	: out std_logic; -- '1' for immediate value operations
		o_MemtoReg	: out std_logic; -- '1' for load word
		o_RegWrite	: out std_logic; -- '1' for storing to register
		o_MemRead	: out std_logic; -- '1' for reading memory
		o_MemWrite	: out std_logic; -- '1' for store word in memory
		o_branch	: out std_logic; -- '1' for branch and jump operations
		o_jump		: out std_logic;
		o_WriteRa	: out std_logic; -- '1' when using jal
		o_signed	: out std_logic; -- '1' when adding or subtracting a signed number
		o_bneOp		: out std_logic; -- '1' when bne operation
		o_halt		: out std_logic;
		o_luiOp		: out std_logic;
		o_jrOp		: out std_logic;
		o_ALUop		: out std_logic_vector(3 downto 0)); -- ALU op code

end control;

architecture data of control is

begin

o_RegDest<=	
		'1' when	(i_opCode = "000000" AND i_functCode = "100000") else -- add
		'1' when	(i_opCode = "000000" AND i_functCode = "100001") else -- addu
		'1' when	(i_opCode = "000000" AND i_functCode = "100100") else -- and
		'1' when	(i_opCode = "000000" AND i_functCode = "100111") else -- nor
		'1' when	(i_opCode = "000000" AND i_functCode = "100110") else -- xor
		'1' when	(i_opCode = "000000" AND i_functCode = "100101") else -- or
		'1' when	(i_opCode = "000000" AND i_functCode = "101010") else -- slt
		'1' when	(i_opCode = "000000" AND i_functCode = "000000") else -- sll
		'1' when	(i_opCode = "000000" AND i_functCode = "000010") else -- srl
		'1' when	(i_opCode = "000000" AND i_functCode = "000011") else -- sra
		'1' when	(i_opCode = "000000" AND i_functCode = "100010") else -- sub
		'1' when	(i_opCode = "000000" AND i_functCode = "100011") else  -- subu
		'0';

o_ALUSrc<=	
		'1' when	(i_opCode = "001000") else -- addi
		'1' when	(i_opCode = "001001") else -- addiu
		'1' when	(i_opCode = "001100") else -- andi
		'1' when	(i_opCode = "001111") else -- lui
		'1' when	(i_opCode = "100011") else -- lw
		'1' when	(i_opCode = "001110") else -- xori
		'1' when	(i_opCode = "001101") else -- ori
		'1' when	(i_opCode = "001010") else -- slti
		'1' when	(i_opCode = "101011") else -- sw
		'0';

o_MemToReg<=
		'1' when	(i_opCode = "100011") else -- lw
		'0';

o_RegWrite<=
		'0' when	(i_opCode = "101011") else -- sw
		'0' when	(i_opCode = "000100") else -- beq
		'0' when	(i_opCode = "000101") else -- bne
		'0' when	(i_opCode = "000010") else -- j
		'1' when	(i_opCode = "000011") else -- jal
		'0' when	(i_opCode = "000000" AND i_functCode = "001000") else -- jr
		'0' when	(i_opCode = "011111") else --repl.qb
		'1' when	(i_opCode = "000000" AND i_functCode = "100000") else -- add
		'1' when	(i_opCode = "000000" AND i_functCode = "100001") else -- addu
		'1' when	(i_opCode = "000000" AND i_functCode = "100100") else -- and
		'1' when	(i_opCode = "000000" AND i_functCode = "100111") else -- nor
		'1' when	(i_opCode = "000000" AND i_functCode = "100110") else -- xor
		'1' when	(i_opCode = "000000" AND i_functCode = "100101") else -- or
		'1' when	(i_opCode = "000000" AND i_functCode = "101010") else -- slt
		'1' when	(i_opCode = "000000" AND i_functCode = "000000") else -- sll
		'1' when	(i_opCode = "000000" AND i_functCode = "000010") else -- srl
		'1' when	(i_opCode = "000000" AND i_functCode = "000011") else -- sra
		'1' when	(i_opCode = "000000" AND i_functCode = "100010") else -- sub
		'1' when	(i_opCode = "000000" AND i_functCode = "100011") else  -- subu
		'1' when 	(i_opCode = "001000") else --addi
		'1' when	(i_opCode = "001001") else -- addiu
		'1' when	(i_opCode = "001100") else -- andi
		'1' when	(i_opCode = "001111") else -- lui
		'1' when	(i_opCode = "100011") else -- lw
		'1' when	(i_opCode = "001110") else -- xori
		'1' when	(i_opCode = "001101") else -- ori
		'1' when	(i_opCode = "001010") else -- slti
		'0';


o_MemRead <=
		'1' when	(i_opCode = "100011") else -- lw
		'0';

o_MemWrite<=
		'1' when	(i_opCode = "101011") else -- sw
		'0';

o_branch<=
		'1' when	(i_opCode = "000100") else -- beq
		'1' when	(i_opCode = "000101") else -- bne
		'0';

o_ALUop <=
	"0000" when (i_opCode = "000000" AND i_functCode = "100000") else 	-- add 		- add
	"0000" when (i_opCode = "001000") else 							-- addi		- add
	"1011" when (i_opCode = "001001") else 							-- addiu	- add
	"1011" when (i_opCode = "000000" AND i_functCode = "100001") else 	-- addu		- add
	"0010" when (i_opCode = "000000" AND i_functCode = "100100") else 	-- AND		- AND
	"0010" when (i_opCode = "001100") else  							-- ANDi		- AND
	"0000" when (i_opCode = "100011") else 							-- lw		- add
	"0101" when (i_opCode = "000000" AND i_functCode = "100111") else 	-- NOR		- NOR
	"0100" when (i_opCode = "000000" AND i_functCode = "100110") else 	-- XOR		- XOR
	"0100" when (i_opCode = "001110") else 							-- XORI		- XOR
	"0011" when (i_opCode = "000000" AND i_functCode = "100101") else 	-- OR		- OR
	"0011" when (i_opCode = "001101") else 							-- ORI		- OR
	"0110" when (i_opCode = "000000" AND i_functCode = "101010") else 	-- slt		- slt
	"0110" when (i_opCode = "001010") else 							-- slti		- slt
	"0111" when (i_opCode = "000000" AND i_functCode = "000000") else	-- sll		- sl
	"1000" when (i_opCode = "000000" AND i_functCode = "000010") else 	-- srl		- sr
	"1001" when (i_opCode = "000000" AND i_functCode = "000011") else 	-- sra		- sr + a
	"0000" when (i_opCode = "101011") else 								-- sw		- add
	"0001" when (i_opCode = "000000" AND i_functCode = "100010") else 	-- sub		- sub
	"1100" when (i_opCode = "000000" AND i_functCode = "100011") else 	-- subu		- sub
	"1010" when (i_opCode = "011111") else					-- repl.qb
	"0001" when (i_opCode = "000101") else					--bne		-sub
	"0001" when (i_opCode = "000100") else					--beq		-sub
	"0000";

o_WriteRa<=
		'1' when	(i_opCode = "000011") else -- jal
		'0';


o_signed<=
		'0' when	(i_opCode = "001001") else -- addiuvsim:/tb/MyMips/s_Inst

		'0' when	(i_opCode = "000000" AND i_functCode = "100001") else -- addu
		'1' when	(i_opCode = "100011") else --lw
		'0' when	(i_opCode = "001111") else --lui
		'1' when	(i_opCode = "101011") else --sw
		'0' when	(i_opCode = "001100") else --andi
		'0' when	(i_opCode = "001110") else --ori
		'0' when	(i_opcode = "001101") else --xori
		'1';

o_halt<=
		'1' when 	(i_opCode = "010100") else -- halt
		'0';

o_luiOp<=
		'1' when (i_opCode = "001111") else -- lui
		'0';

o_bneOp<=
		'1' when	(i_opCode = "000101") else -- bne
		'0';


o_jrOp <=
		'1' when (i_opCode = "000000" AND i_functCode = "001000") else
		'0';

o_jump<=
		'1' when 	(i_opCode = "000010") else
		'1' when	(i_opCode = "000011") else
		'1' when	(i_opCode = "000000" AND i_functCode = "001000") else
		'0';

end data;
