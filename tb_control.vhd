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

architecture behavior of tb_control is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component ALUcontrol is
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
		o_ALUop		: out std_logic_vector(3 downto 0)); -- ALU op code
end component;
--signals

signal s_CLK		: std_logic := '0';
signal s_opCode  	: std_logic_vector(5 downto 0)
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
	o_branch	=> s_branch,
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
	i_opCode <= "000000";	-- add
	i_functCode <= "100000"
	wait for cCLK_PER;

	-- 3
	i_opCode <= "001000";	-- addi
	i_functCode <= "100000"
	wait for cCLK_PER;

	-- 4
	i_opCode <= "001001";	-- addiu
	i_functCode <= "100000"
	wait for cCLK_PER;

	-- 5
	i_opCode <= "000000";	-- addu
	i_functCode <= "100001"
	wait for cCLK_PER;

	-- 6
	i_opCode <= "000000";	-- and
	i_functCode <= "100100"
	wait for cCLK_PER;

	-- 7
	i_opCode <= "001100";	-- andi
	i_functCode <= "100100"
	wait for cCLK_PER;

	-- 8
	i_opCode <= "001111";	-- lui
	i_functCode <= "100100"
	wait for cCLK_PER;

	-- 9
	i_opCode <= "100011";	-- lw
	i_functCode <= "100100"
	wait for cCLK_PER;

	-- 10
	i_opCode <= "000000";	-- nor
	i_functCode <= "100111"
	wait for cCLK_PER;

	-- 11
	i_opCode <= "000000";	-- xor
	i_functCode <= "100110"
	wait for cCLK_PER;

	-- 12
	i_opCode <= "001110";	-- xori
	i_functCode <= "100110"
	wait for cCLK_PER;

	-- 13
	i_opCode <= "000000";	-- or
	i_functCode <= "100101"
	wait for cCLK_PER;

	-- 14
	i_opCode <= "001101";	-- ori
	i_functCode <= "100101"
	wait for cCLK_PER;

	-- 15
	i_opCode <= "000000";	-- slt
	i_functCode <= "101010"
	wait for cCLK_PER;

	-- 16
	i_opCode <= "001010";	-- slti
	i_functCode <= "101010"
	wait for cCLK_PER;

	-- 17
	i_opCode <= "000000";	-- sll
	i_functCode <= "000000"
	wait for cCLK_PER;

	-- 18
	i_opCode <= "000000";	-- srl
	i_functCode <= "000010"
	wait for cCLK_PER;

	-- 19
	i_opCode <= "000000";	-- sra
	i_functCode <= "000011"
	wait for cCLK_PER;

	-- 20
	i_opCode <= "101011";	-- sw
	i_functCode <= "000011"
	wait for cCLK_PER;

	-- 21
	i_opCode <= "000000";	-- sub
	i_functCode <= "100010"
	wait for cCLK_PER;

	-- 22
	i_opCode <= "000000";	-- subu
	i_functCode <= "100011"
	wait for cCLK_PER;

	-- 23
	i_opCode <= "000100";	-- beq
	i_functCode <= "100011"
	wait for cCLK_PER;

	-- 24
	i_opCode <= "000101";	-- bne
	i_functCode <= "100011"
	wait for cCLK_PER;

	-- 25
	i_opCode <= "000010";	-- j
	i_functCode <= "100011"
	wait for cCLK_PER;

	-- 26
	i_opCode <= "000011";	-- jal
	i_functCode <= "100011"
	wait for cCLK_PER;

	-- 27
	i_opCode <= "000000";	-- jr
	i_functCode <= "001000"
	wait for cCLK_PER;

	-- 28
	i_opCode <= "011111";	-- repl.qb
	i_functCode <= "001000"
	wait for cCLK_PER;

	i_opCode <= "111111";	-- junk opCode
	i_functCode <= "100000"
	wait for cCLK_PER;

	i_opCode <= "000000";	-- junk functCode
	i_functCode <= "111111"
	wait for cCLK_PER;

	wait;
	end process;

end behavior;




