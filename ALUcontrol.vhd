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

	   port(i_ALUop  		: in std_logic_vector(4 downto 0);
		o_ALUShiftDir 		: out std_logic;
	     	o_ALUShirtArithmetic	: out std_logic;
	     	o_ALUAddSub		: out std_logic;
		o_ALUMuxCtrl		: out std_logic_vector(3 downto 0);
		);

end decoder;

architecture data of decoder is

begin

with i_ALUop select
	o_ALUAddSub <=
		"1" when "0000",
		"0" when others;

with i_ALUop select
	o_ALUShiftDir <=
		"1" when "0111",
		"0" when others;

with i_ALUop select
	o_ALUShiftArithmetic <=
		"1" when "0111",
		"0" when others;



end data;
