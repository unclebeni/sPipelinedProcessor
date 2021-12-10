-----------------------------
-- Benito Moeckly
-- Control Signal Multiplexer 
-- This will help us manage control signals in a stall and/or flush 
--
------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity controlMux is
	port (i_S	: in std_logic;

	      i_dBranch	: in std_logic;

	      i_dJump	: in std_logic;

	      i_dALUSrc	: in std_logic;

	      i_dRegDst : in std_logic;

	      i_dMemToReg : in std_logic;

	      i_dRegWrite : in std_logic;

	      i_dMemWrite : in std_logic;

	      i_dWriteRa  : in std_logic;

	      i_dLuiOp	  : in std_logic;

	      o_Branch	: out std_logic;
	      o_Jump	: out std_logic;
	      o_ALUSrc  : out std_logic;
	      o_RegDst	: out std_logic;
	      o_MemToReg : out std_logic;
	      o_RegWrite : out std_logic;
	      o_MemWrite : out std_logic;
              o_WriteRa  : out std_logic;
	      o_LuiOp	 : out std_logic);	
end controlMux;

architecture structural of controlMux is 

 component mux2t1_N is
  generic(N : integer := 9); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

signal zeros : std_logic_vector(9-1 downto 0);
signal input : std_logic_vector(9-1 downto 0);
signal output : std_logic_vector(9-1 downto 0);

begin

	
  input(0) <= i_dBranch; input(1) <= i_dJump; input(2) <= i_dALUSrc; input(3) <= i_dRegDst; input(4) <= i_dMemToReg;
  input(5) <= i_dRegWrite; input(6) <= i_dMemWrite; input(7) <= i_dWriteRa; input(8) <= i_dLuiOp;

  zeros <= ((9-1 downto 0) => '0'); 

  G_multiplexer : mux2t1_N port(
	i_S	<= i_S,
	i_D0	<= input,
	i_D1	<= zeros,
	o_O	<= output);

  output(0) => o_Branch; output(1) => o_Jump; output(2) => o_ALUSrc; output(3) => o_RegDst; output(4) => o_MemToReg;
  output(5) => o_RegWrite; output(6) => o_MemWrite; output(7) => o_WriteRa; input(8) => o_LuiOp;


end structural;
