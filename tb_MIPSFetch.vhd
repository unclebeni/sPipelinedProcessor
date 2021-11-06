-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_MIPSFetch is
	generic(gCLK_HPER   : time := 10 ns); 
end tb_MIPSFetch;

architecture mixed of tb_MIPSFetch is

constant cCLK_PER	:  time := gCLK_HPER * 2;

component MIPSFetch is
	port(i_PC	: in std_logic_vector(31 downto 0);
	     i_Instr25t0	: in std_logic_vector(25 downto 0);
	     i_ExtendedImm	: in std_logic_vector(31 downto 0);
	     o_PC		: out std_logic_vector(31 downto 0);
	     o_PCp8		: out std_logic_vector(31 downto 0);
	     i_CLK	: in std_logic;
	     i_Jump	: in std_logic;
	     i_Branch	: in std_logic;
	     i_BranchNotEqual	: in std_logic;
	     i_ALUResult	: in std_logic);
end component;

signal PC, imm, oPC, oPCp8	: std_logic_vector(31 downto 0);
signal instr25t0	: std_logic_vector(25 downto 0);
signal clk, jump, branch, bne, aluresult	: std_logic;

begin

FETCHLOGIC: MIPSFetch port map(i_PC => PC, i_Instr25t0 => instr25t0, i_ExtendedImm => imm, o_PC => oPC, o_PCp8 => oPCp8, i_CLK => clk, i_Jump => jump, i_Branch => branch, i_BranchNotEqual => bne, i_ALUResult => aluresult);

	P_CLK: process
	begin
		clk <= '1';
		wait for gCLK_HPER;
		clk <= '0';
		wait for gCLK_HPER;
	end process;

	P_TEST_CASES: process
	begin
		wait for gCLK_HPER;
		PC <= x"00000000";
		imm <= x"00000000";
		instr25t0 <= "00000000000000000000000000";
		jump <= '0';
		branch <= '0';
		bne <= '0';
		aluresult <= '0';
		wait for cCLK_PER;
		PC <= x"00000004";
		wait for cCLK_PER;
		PC <= x"00000008";
		wait for cCLK_PER;
		PC <= x"0000000C";
		wait for cCLK_PER;
		PC <= x"00000010";
		wait for cCLK_PER;
		PC <= x"00000014";
	end process;

end mixed;
