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

architecture structural of tb_MIPSFetch is

constant cCLK_PER	:  time := gCLK_HPER * 2;

component MIPSFetch is
	port(i_PC	: in std_logic_vector(31 downto 0);
	     i_PCRST	: in std_logic;
	     i_Instr	: in std_logic_vector(31 downto 0);
	     i_ExtendedImm	: in std_logic_vector(31 downto 0);
	     o_PC		: out std_logic_vector(31 downto 0);
	     o_PCp4		: out std_logic_vector(31 downto 0);
	     i_HALT	: in std_logic;
	     i_CLK	: in std_logic;
	     i_Jump	: in std_logic;
	     i_Branch	: in std_logic;
	     i_BranchNotEqual	: in std_logic;
	     i_ALUResult	: in std_logic);
end component;

signal iPC, Inst, ImmExt, oPC, oPCp4	: std_logic_vector(31 downto 0);
signal HALT, PCRST, CLK, Jump, Branch, Bne, ALUResult	: std_logic;

begin

FETCHLOGIC: MIPSFetch port map(i_PC => iPC, i_PCRST => PCRST, i_Instr => Inst, i_ExtendedImm => ImmExt, o_PC => oPC, o_PCp4 => oPcp4, i_HALT => HALT, i_CLK => CLK, i_Jump => Jump, i_Branch => Branch, i_BranchNotEqual => Bne, i_ALUResult => ALUResult);

	P_CLK: process
	begin
		CLK <= '1';
		wait for gCLK_HPER;
		CLK <= '0';
		wait for gCLK_HPER;
	end process;

	P_TEST_CASES: process
	begin
		iPC <= x"00400058";
		PCRST <= '0';
		Inst <= x"00000000";
		ImmExt <= x"00000000";
		HALT <= '0';
		Jump <= '0';
		Branch <= '0';
		Bne <= '0';
		ALUResult <= '0';
		wait for cCLK_PER;
		iPC <= x"0040005C";
		Inst <= x"0840000C";
		Jump <= '1';
		wait for cCLK_PER;
		iPC <= x"0040000C";
		Inst <= x"11100003";
		ImmExt <= x"00000003";
		Jump <= '0';
		Branch <= '1';
		Bne <= '0';
		ALUResult <= '1';
		wait for cCLK_PER;
		iPC <= x"0040001C";
		Inst <= x"11180001";
		ImmExt <= x"00000001";
		Branch <= '1';
		Bne <= '1';
		ALUResult <= '1';
		wait for cCLK_PER;
		Branch <= '0';
		wait for cCLK_PER;
		iPC <= x"00400020";
		Inst <= x"11180001";
		ImmExt <= x"00000001";
		Branch <= '1';
		Bne <= '1';
		ALUResult <= '0';
		wait for cCLK_PER;
	end process;

end structural;