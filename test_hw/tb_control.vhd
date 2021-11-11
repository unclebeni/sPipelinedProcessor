-------------------------------------------------------------------
-- Cole Hunt
-- Testbench for ALUcontrol
--
-- CREATED ON: 11.6.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_control is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_control;

architecture mixed of tb_control is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component control
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
		o_bneOp		: out std_logic; -- '1' when bne operation
		o_halt		: out std_logic;
		o_luiOp		: out std_logic;
		o_jump		: out std_logic;
		o_jrOp		: out std_logic;
		o_ALUop		: out std_logic_vector(3 downto 0)); -- ALU op code
end component;
--signals

signal s_CLK		: std_logic := '0';
signal s_opCode  	: std_logic_vector(5 downto 0);
signal s_functCode 	: std_logic_vector(5 downto 0) := (others => '0');
signal s_RegDest 	: std_logic := '0';
signal s_ALUSrc		: std_logic := '0';
signal s_MemtoReg	: std_logic := '0';
signal s_RegWrite	: std_logic := '0';
signal s_MemRead	: std_logic := '0';
signal s_MemWrite	: std_logic := '0';
signal s_branch		: std_logic := '0';
signal s_WriteRa	: std_logic := '0';
signal s_signed		: std_logic := '0';
signal s_bneOp		: std_logic := '0';
signal s_halt		: std_logic := '0';
signal s_luiOp		: std_logic := '0';
signal s_jump		: std_logic := '0';
signal s_jrOp		: std_logic := '0';
signal s_ALUop		:  std_logic_vector(3 downto 0) := (others => '0');

begin

DUT0: control port map(
	i_opCode	=> s_opCode,
	i_functCode	=> s_functCode,
	o_RegDest	=> s_RegDest,
	o_ALUSrc	=> s_ALUSrc,
	o_MemtoReg	=> s_MemtoReg,
	o_RegWrite	=> s_RegWrite,
	o_MemRead	=> s_MemRead,
	o_MemWrite	=> s_MemWrite,
	o_branch	=> s_branch,
	o_WriteRa	=> s_WriteRa,
	o_signed	=> s_signed,
	o_bneOp		=> s_bneOp,
	o_halt		=> s_halt,
	o_luiOp		=> s_luiOp,
	o_jump		=> s_jump,
	o_jrOp		=> s_jrOp,
	o_ALUop		=> s_ALUop);

 P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- Testbench process
  P_TB: process
  begin

	-- 2
	s_opCode <= "000000";	-- add
	s_functCode <= "100000";
	wait for cCLK_PER;

	-- 3
	s_opCode <= "001000";	-- addi
	s_functCode <= "100000";
	wait for cCLK_PER;

	-- 4
	s_opCode <= "001001";	-- addiu
	s_functCode <= "100000";
	wait for cCLK_PER;

	-- 5
	s_opCode <= "000000";	-- addu
	s_functCode <= "100001";
	wait for cCLK_PER;

	-- 6
	s_opCode <= "000000";	-- and
	s_functCode <= "100100";
	wait for cCLK_PER;

	-- 7
	s_opCode <= "001100";	-- andi
	s_functCode <= "100100";
	wait for cCLK_PER;

	-- 8
	s_opCode <= "001111";	-- lui
	s_functCode <= "100100";
	wait for cCLK_PER;

	-- 9
	s_opCode <= "100011";	-- lw
	s_functCode <= "100100";
	wait for cCLK_PER;

	-- 10
	s_opCode <= "000000";	-- nor
	s_functCode <= "100111";
	wait for cCLK_PER;

	-- 11
	s_opCode <= "000000";	-- xor
	s_functCode <= "100110";
	wait for cCLK_PER;

	-- 12
	s_opCode <= "001110";	-- xori
	s_functCode <= "100110";
	wait for cCLK_PER;

	-- 13
	s_opCode <= "000000";	-- or
	s_functCode <= "100101";
	wait for cCLK_PER;

	-- 14
	s_opCode <= "001101";	-- ori
	s_functCode <= "100101";
	wait for cCLK_PER;

	-- 15
	s_opCode <= "000000";	-- slt
	s_functCode <= "101010";
	wait for cCLK_PER;

	-- 16
	s_opCode <= "001010";	-- slti
	s_functCode <= "101010";
	wait for cCLK_PER;

	-- 17
	s_opCode <= "000000";	-- sll
	s_functCode <= "000000";
	wait for cCLK_PER;

	-- 18
	s_opCode <= "000000";	-- srl
	s_functCode <= "000010";
	wait for cCLK_PER;

	-- 19
	s_opCode <= "000000";	-- sra
	s_functCode <= "000011";
	wait for cCLK_PER;

	-- 20
	s_opCode <= "101011";	-- sw
	s_functCode <= "000011";
	wait for cCLK_PER;

	-- 21
	s_opCode <= "000000";	-- sub
	s_functCode <= "100010";
	wait for cCLK_PER;

	-- 22
	s_opCode <= "000000";	-- subu
	s_functCode <= "100011";
	wait for cCLK_PER;

	-- 23
	s_opCode <= "000100";	-- beq
	s_functCode <= "100011";
	wait for cCLK_PER;

	-- 24
	s_opCode <= "000101";	-- bne
	s_functCode <= "100011";
	wait for cCLK_PER;

	-- 25
	s_opCode <= "000010";	-- j
	s_functCode <= "100011";
	wait for cCLK_PER;

	-- 26
	s_opCode <= "000011";	-- jal
	s_functCode <= "100011";
	wait for cCLK_PER;

	-- 27
	s_opCode <= "000000";	-- jr
	s_functCode <= "001000";
	wait for cCLK_PER;

	-- 28
	s_opCode <= "011111";	-- repl.qb
	s_functCode <= "001000";
	wait for cCLK_PER;

	s_opCode <= "111111";	-- junk opCode
	s_functCode <= "100000";
	wait for cCLK_PER;

	s_opCode <= "000000";	-- junk functCode
	s_functCode <= "111111";
	wait for cCLK_PER;

	wait;
	end process;

end mixed;




