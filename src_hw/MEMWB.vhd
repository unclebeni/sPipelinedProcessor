-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MEMWB is
    port (i_Clk     : in std_logic;
		  i_Rst     : in std_logic;
		  i_WE	: in std_logic;
		  i_Halt    : in std_logic;
          	  o_Halt    : out std_logic;
		  i_WriteRa    : in std_logic;
          	  o_WriteRa    : out std_logic;
		  i_MemToReg    : in std_logic;
          	  o_MemToReg    : out std_logic;
		  i_RegWrite    : in std_logic;
          	  o_RegWrite    : out std_logic;
		  i_LuiOp    : in std_logic;
          	  o_LuiOp    : out std_logic;
		  i_RegDstMux	: in std_logic_vector(4 downto 0);
		  o_RegDstMux	: out std_logic_vector(4 downto 0);
		  i_DMemOut	: in std_logic_vector(31 downto 0);
		  o_DMemOut	: out std_logic_vector(31 downto 0);
		  i_ALUOut	: in std_logic_vector(31 downto 0);
		  o_ALUOut	: out std_logic_vector(31 downto 0);
		  i_LuiShift	: in std_logic_vector(31 downto 0);
		  o_LuiShift	: out std_logic_vector(31 downto 0));
end MEMWB;

architecture structural of MEMWB is

component Reg is
    generic(N : integer := 106);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

signal RegInput, RegOutput     : std_logic_vector(105 downto 0);

begin	

RegInput(105) <= i_LuiOp;
RegInput(104) <= i_RegWrite;
RegInput(103) <= i_MemToReg;
RegInput(102) <= i_WriteRa;
RegInput(101) <= i_Halt;
RegInput(100 downto 69) <= i_DMemOut;
RegInput(68 downto 37) <= i_ALUOut;
RegInput(36 downto 5) <= i_LuiShift;
Reginput(4 downto 0) <= i_RegDstMux;

IFIDREG: Reg port map(i_CLK => i_Clk, i_RST => i_Rst, i_WE => i_WE, i_D => RegInput, o_R => RegOutput);

o_LuiOp <= Regoutput(105);
o_RegWrite <= Regoutput(104);
o_MemToReg <= Regoutput(103);
o_WriteRa <= Regoutput(102);
o_Halt <= Regoutput(101);
o_DMemOut <= RegOutput(100 downto 69);
o_ALUOut <= RegOutput(68 downto 37);
o_LuiShift <= RegOutput(36 downto 5);
o_RegDstMux <= RegOutput (4 downto 0);

end structural;
