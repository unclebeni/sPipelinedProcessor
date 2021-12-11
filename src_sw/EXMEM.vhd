-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity EXMEM is
    port (i_Clk     : in std_logic;
		  i_Rst     : in std_logic;
		  i_WE	: in std_logic;
		  i_PCp4	: in std_logic_vector(31 downto 0);
		  o_PCp4	: out std_logic_vector(31 downto 0);
		  i_Halt    : in std_logic;
         	  o_Halt    : out std_logic;
		  i_MemWrite    : in std_logic;
         	  o_MemWrite    : out std_logic;
		  i_WriteRa    : in std_logic;
         	  o_WriteRa    : out std_logic;
		  i_MemToReg    : in std_logic;
         	  o_MemToReg    : out std_logic;
		  i_RegWrite    : in std_logic;
         	  o_RegWrite    : out std_logic;
		  i_ALUOut	: in std_logic_vector(31 downto 0);
		  o_ALUOut	: out std_logic_vector(31 downto 0);
		  i_RD2	: in std_logic_vector(31 downto 0);
		  o_RD2	: out std_logic_vector(31 downto 0);
		  i_RegDstMux	: in std_logic_vector(4 downto 0);
		  o_RegDstMux	: out std_logic_vector(4 downto 0);
		  i_LuiOp	: in std_logic;
		  o_LuiOp	: out std_logic;
		  i_LuiShift	: in std_logic_vector(31 downto 0);
		  o_LuiShift	: out std_logic_vector(31 downto 0));
end EXMEM;

architecture structural of EXMEM is

component Reg is
    generic(N : integer := 139);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

signal RegInput, RegOutput     : std_logic_vector(138 downto 0);

begin

	Reginput(138 downto 107) <= i_Pcp4;
	RegInput(106) <= i_RegWrite;
	RegInput(105) <= i_MemToReg;
	RegInput(104) <= i_WriteRa;
	RegInput(103) <= i_MemWrite;
	RegInput(102) <= i_LuiOP;
	RegInput(101) <= i_Halt;
	RegInput(100 downto 69) <= i_ALUOut;
	RegInput(68 downto 37) <= i_RD2;
	RegInput(36 downto 5) <= i_LuiShift;
	RegInput(4 downto 0) <= i_RegDstMux;

	IFIDREG: Reg port map(i_CLK => i_Clk, i_RST => i_Rst, i_WE => i_WE, i_D => RegInput, o_R => RegOutput);

	o_PCp4 <= RegOutput(138 downto 107);
	o_RegWrite <= RegOutput(106);
	o_MemToReg <= RegOutput(105);
	o_WriteRa <= RegOutput(104);
	o_MemWrite <= RegOutput(103);
	o_LuiOP <= RegOutput(102);
	o_Halt <= RegOutput(101);
	o_ALUOut <= RegOutput(100 downto 69);
	o_RD2 <= RegOutput(68 downto 37);
	o_LuiShift <= RegOutput(36 downto 5);
	o_RegDstMux <= RegOutput(4 downto 0);

end structural;
