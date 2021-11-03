-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- MIPSFetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the fetch logic of a MIPS processor.
--
-- NOTES:
-- 9/23/21 by Sid::Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MIPSFetch is
	port(i_PC	: in std_logic_vector(31 downto 0);
	     i_Instr25t0	: in std_logic_vector(25 downto 0);
	     i_ExtendedImm	: in std_logic_vector(31 downto 0);
	     o_instruction	: out std_logic_vector(31 downto 0);
	     o_PC		: out std_logic_vector(31 downto 0);
	     o_PCp8		: out std_logic_vector(31 downto 0);
	     i_CLK	: in std_logic;
	     i_Jump	: in std_logic;
	     i_Branch	: in std_logic;
	     i_ALUResult	: in std_logic);
end MIPSFetch;

architecture structural of MIPSFetch is

component mem is
	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector(9 downto 0);
		data	        : in std_logic_vector(31 downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector(31 downto 0)
	);
end component;

component mux2t1_N is
	generic(N : integer := 32);
  	port(i_S          : in std_logic;
       	     i_D0         : in std_logic_vector(N-1 downto 0);
       	     i_D1         : in std_logic_vector(N-1 downto 0);
       	     o_O          : out std_logic_vector(N-1 downto 0));
end component;

component RippleCarryAdder is
	generic(N : integer := 32);
	port(i_A	: in std_logic_vector(N-1 downto 0);
	     i_B	: in std_logic_vector(N-1 downto 0);
	     i_C	: in std_logic;
	     o_S	: out std_logic_vector(N-1 downto 0);
	     o_C	: out std_logic);
end component;

component Shifter2 is
	port(i_D	: in std_logic_vector(31 downto 0);
	     o_D	: out std_logic_vector(31 downto 0));
end component;

component andg2 is
	port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
end component;

component Reg is
	generic(N : integer := 32);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

signal instrData, instrShift, immShift, jumpAddress, BranchAddress, BranchMux 	: std_logic_vector(31 downto 0);
signal PCp4, four, eight, PCnext, currentPC, sdata, PCin	: std_logic_vector(31 downto 0);
signal nextinstr	: std_logic_vector(9 downto 0);
signal PCp4C, PCp8C, JAddressC, BranchC, BAnd, clock	: std_logic;
signal zero	: std_logic;

begin

	zero <= '0';
	four <= x"00000004";
	PCin <= i_PC;
	clock <= i_CLK;
	eight <= x"00000008";

	instrData(31) <= '0';
	instrData(30) <= '0';
	instrData(29) <= '0';
	instrData(28) <= '0';
	instrData(27) <= '0';
	instrData(26) <= '0';
	instrData(25) <= i_Instr25t0(25);
	instrData(24) <= i_Instr25t0(24);
	instrData(23) <= i_Instr25t0(23);
	instrData(22) <= i_Instr25t0(22);
	instrData(21) <= i_Instr25t0(21);
	instrData(20) <= i_Instr25t0(20);
	instrData(19) <= i_Instr25t0(19);
	instrData(18) <= i_Instr25t0(18);
	instrData(17) <= i_Instr25t0(17);
	instrData(16) <= i_Instr25t0(16);
	instrData(15) <= i_Instr25t0(15);
	instrData(14) <= i_Instr25t0(14);
	instrData(13) <= i_Instr25t0(13);
	instrData(12) <= i_Instr25t0(12);
	instrData(11) <= i_Instr25t0(11);
	instrData(10) <= i_Instr25t0(10);
	instrData(9) <= i_Instr25t0(9);
	instrData(8) <= i_Instr25t0(8);
	instrData(7) <= i_Instr25t0(7);
	instrData(6) <= i_Instr25t0(6);
	instrData(5) <= i_Instr25t0(5);
	instrData(4) <= i_Instr25t0(4);
	instrData(3) <= i_Instr25t0(3);
	instrData(2) <= i_Instr25t0(2);
	instrData(1) <= i_Instr25t0(1);
	instrData(0) <= i_Instr25t0(0);

	InstrShift2 : Shifter2 port map(i_D => instrData, o_D => instrShift);
	ImmShift2 : Shifter2 port map(i_D => instrData, o_D => immShift);

	PCPLUS4	: RippleCarryAdder port map(i_A => PCin, i_B => four, i_C => zero, o_S => PCp4, o_C => PCp4C);
	PCPLUS8	: RippleCarryAdder port map(i_A => i_PC, i_B => eight, i_C => zero, o_S => o_PCp8, o_C => PCp8C);

	JUMPADDER : RippleCarryAdder port map(i_A => instrShift, i_B => PCp4, i_C => zero, o_S => jumpAddress, o_C => JAddressC);
	BRANCHADDER : RippleCarryAdder port map(i_A => PCp4, i_B => immShift, i_C => zero, o_S => BranchAddress, o_C => BranchC);
	
	BRANCHAND : andg2 port map(i_A => i_Branch, i_B => i_ALUResult, o_F => BAnd);

	BRANCHMULTI : mux2t1_N port map(i_S => BAnd, i_D0 => PCp4, i_D1 => BranchAddress, o_O => BranchMux);
	JUMPMULTI : mux2t1_N port map(i_S => i_Jump, i_D0 => BranchMux, i_D1 => jumpAddress, o_O => PCnext);

	PC : Reg port map(i_CLK => clock, i_RST => zero, i_WE => '1', i_D => PCnext, o_R => currentPC);

	o_PC <= currentPC;

	nextinstr(9) <= currentPC(9);
	nextinstr(8) <= currentPC(8);
	nextinstr(7) <= currentPC(7);
	nextinstr(6) <= currentPC(6);
	nextinstr(5) <= currentPC(5);
	nextinstr(4) <= currentPC(4);
	nextinstr(3) <= currentPC(3);
	nextinstr(2) <= currentPC(2);
	nextinstr(1) <= currentPC(1);
	nextinstr(0) <= currentPC(0);

	IMEM : mem port map(clk => clock, addr => nextinstr, data => sdata, we => '0', q => o_instruction);

end structural;
