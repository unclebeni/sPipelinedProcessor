-------------------------------------------------------------------
-- Cole Hunt
-- ALU_CONTROL:
-- This is the alu control unit for our project 1 MIPS processor. It
-- decodes the ALUOp bits from the control and sends ALUctrl signals
-- to the ALU.
--
-- CREATED ON: 10.14.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is

	   port(i_ALUop  				: in std_logic_vector(4 downto 0);
			o_ALUShiftDir 			: out std_logic;
	     	o_ALUShiftArithmetic	: out std_logic;
	     	o_ALUAddSub				: out std_logic;
			o_ALUMuxCtrl			: out std_logic_vector(2 downto 0);
			o_BranchOp				: out std_logic;
		);

end decoder;

architecture data of decoder is

begin

with i_ALUop select
	o_ALUAddSub <=
		"1" when "0000", -- Add
		"0" when "0001", -- Sub
		"X" when others;

with i_ALUop select
	o_ALUShiftDir <=
		"1" when "0111", -- Shift Left
		"0" when "1000", -- Shift Right
		"0" when "1001"; -- Shift Right Arithmetic
		"X" when others;

with i_ALUop select
	o_ALUShiftArithmetic <=
		"1" when "1001", -- Shift Arithmetic
		"0" when others;

with i_ALUop select
	o_ALUMuxCtrl <=
		-- Adder/Subtractor
		"000" when "0000", -- Add
		"000" when "0001", -- Sub

		-- AND
		"001" when "0010",

		-- OR
		"010" when "0011",

		-- OR + INV
		"011" when "0101",

		-- XOR
		"100" when "0100",

		-- Shifter
		"101" when "0111", -- Shift Left
		"101" when "1000", -- Shift Right
		"101" when "1001"; -- Shift Right Arithmetic

		-- Branch Ops
		"110" when "1010" -- Branch Equal
		"111" when "1011" -- Branch Not Equal


end data;
