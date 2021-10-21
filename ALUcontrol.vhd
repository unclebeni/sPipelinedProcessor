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

	   port(i_ALUop  	: in std_logic_vector(4 downto 0);
		o_ALUctrl0 	: out std_logic;
	     	o_ALUctrl1	: out std_logic;
	     	o_ALUctrl2	: out std_logic;
		);

end decoder;

architecture data of decoder is

begin

with i_ALUop select
	o_ALUctrl0 <="00000000000000000000000000000001" when "00000";
	o_ALUctrl1 <="00000000000000000000000000000001" when "00000";
	o_ALUctrl2 <="00000000000000000000000000000001" when "00000";

end data;
