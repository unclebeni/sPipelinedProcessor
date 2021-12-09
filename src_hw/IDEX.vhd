-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IDEX is
    port (i_Clk     : in std_logic;
          i_Rst     : in std_logic;
	  i_WE	: in std_logic;
	  i_Halt    : in std_logic;
	  o_Halt    : out std_logic;
	  i_Instr25t21	: in std_logic_vector(4 downto 0);
	  o_Instr25t21	: out std_logic_vector(4 downto 0);
	  i_Instr15t0	: in std_logic_vector(15 downto 0);
	  o_Instr15t0	: out std_logic_vector(15 downto 0);
	  i_Instr20t16	: in std_logic_vector(4 downto 0);
	  o_Instr20t16	: out std_logic_vector(4 downto 0);
	  i_Rd	: in std_logic_vector(4 downto 0);
	  o_Rd	: out std_logic_vector(4 downto 0);
	  i_Rt	: in std_logic_vector(4 downto 0);
	  o_Rt	: out std_logic_vector(4 downto 0);
	  i_shamt	: in std_logic_vector(4 downto 0);
	  o_shamt	: out std_logic_vector(4 downto 0);
	  i_RD1	: in std_logic_vector(31 downto 0);
	  o_RD1	: out std_logic_vector(31 downto 0);
	  i_RD2	: in std_logic_vector(31 downto 0);
	  o_RD2	: out std_logic_vector(31 downto 0);
	  i_Imm	: in std_logic_vector(31 downto 0);
	  o_Imm	: out std_logic_vector(31 downto 0);
	  i_Branch	: in std_logic;
	  o_Branch	: out std_logic;
	  i_Jump	: in std_logic;
	  o_Jump	: out std_logic;
	  i_ALUSrc	: in std_logic;
	  o_ALUSrc	: out std_logic;
	  i_RegDst	: in std_logic;
	  o_RegDst	: out std_logic;
	  i_MemToReg	: in std_logic;
	  o_MemToReg	: out std_logic;
	  i_RegWrite	: in std_logic;
	  o_RegWrite	: out std_logic;
	  i_MemWrite	: in std_logic;
	  o_MemWrite	: out std_logic;
	  i_WriteRa	: in std_logic;
	  o_WriteRa	: out std_logic;
	  i_LuiOp	: in std_logic;
	  o_LuiOp	: out std_logic;
	  i_ALUOp	: in std_logic_vector(3 downto 0);
	  o_ALUOp	: out std_logic_vector(3 downto 0));
end IDEX;

architecture structural of IDEX is

component Reg is
    generic(N : integer := 151);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

signal RegInput, RegOutput     : std_logic_vector(150 downto 0);

begin

RegInput(150) <= i_Branch;
RegInput(149) <= i_Jump;
RegInput(148 downto 133) <= i_Instr15t0;
RegInput(132) <= i_ALUSrc;
RegInput(131) <= i_RegDst;
RegInput(130) <= i_MemToReg;
RegInput(129) <= i_RegWrite;
RegInput(128) <= i_MemWrite;
RegInput(127) <= i_WriteRa;
RegInput(126) <= i_LuiOp;
RegInput(125 downto 122) <= i_ALUOp;
RegInput(121) <= i_Halt;
RegInput(120 downto 89) <= i_Imm;
RegInput(88 downto 57) <= i_RD1;
RegInput(56 downto 25) <= i_RD2;
RegInput(24 downto 20) <= i_Rd;
RegInput(19 downto 15) <= i_Rt;
RegInput(14 downto 10) <= i_Instr25t21;
RegInput(9 downto 5) <= i_Instr20t16;
RegInput(4 downto 0) <= i_shamt;

IFIDREG: Reg port map(i_CLK => i_Clk, i_RST => i_Rst, i_WE => i_WE, i_D => RegInput, o_R => RegOutput);

o_Branch <= RegOutput(150);
o_Jump <= RegOutput(149);
o_Instr15t0 <= RegOutput(148 downto 133);
o_ALUSrc <= RegOutput(132);
o_RegDst <= RegOutput(131);
o_MemToReg <= RegOutput(130);
o_RegWrite <= RegOutput(129);
o_MemWrite <= RegOutput(128);
o_WriteRa <= RegOutput(127);
o_LuiOp <= RegOutput(126);
o_ALUOp <= RegOutput(125 downto 122);
o_Halt <= RegOutput(121);
o_Imm <= RegOutput(120 downto 89);
o_RD1 <= RegOutput(88 downto 57);
o_RD2 <= RegOutput(56 downto 25);
o_Rd <= RegOutput(24 downto 20);
o_Rt <= RegOutput(19 downto 15);
o_Instr25t21 <= RegOutput(14 downto 10);
o_Instr20t16 <= RegOutput(9 downto 5);
o_shamt <= RegOutput(4 downto 0);

end structural;
