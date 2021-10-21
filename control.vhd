-------------------------------------------------------------------
-- Benito Moeckly
-- CONTROL:
-- This is the control unit for our project 1 MIPS processor.
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is

	   port(i_opCode  	: in std_logic_vector(5 downto 0);
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

end decoder;

architecture data of decoder is

begin

with i_opCode select
o_RegDest <="1" when "000000", --add
	    "1" when "000100", --and
	    "1" when "001000", --nor
	    "1" when "001001", --xor
	    "1" when "001011", --or
	    "1" when "001101", --set on less than  
	    "1" when "001111", --shift left logical
	    "1" when "010000", --shift right logical
	    "1" when "010001", --shift right arithmetic
	    "1" when "010011", --subtract
	    "0" when "010101", --beq
	    "0" when "010110", --bne     
	    "0" when others;

with i_opCode select
o_ALUSrc <=
	"1" when "000001", --addi
	"1" when "000010", --addiu
	"1" when "000101", --andi
	"1" when "000110", --lui
	"1" when "000111", --lw
	"1" when "001010", --xori
	"1" when "001100", --ori
	"1" when "001110", --slti
	"1" when "010010", --sw
	"0" when others;

with i_opCode select
o_MemToReg <=
	"1" when "000111" --load word
	"0" when others;

with i_opCode select
o_RegWrite <=
	"0" when "010010", --store word
	"0" when "010101", --beq
	"0" when "010110", --bne
	"0" when "010111", --j
	"0" when "011000", --jal
	"0" when "011001", --jr
	"0" when "011010", --repl. qb
	"1" when others;

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
	"0000" when "000000",
	"XXXX" when others;

with i_opCode select
o_WriteRa <=
	"1" when "011000", --jal
	"0" when others";

with i_opCode select
o_signed <=
	"0" when "000010", --addiu
	"0" when "000011", --addu
	"0" when "000111", --lw
	"0" when "000110", --lui
	"0" when "010010", --sw
	"1" when others;


end data;
