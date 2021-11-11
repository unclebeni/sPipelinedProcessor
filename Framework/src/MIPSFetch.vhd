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
end MIPSFetch;

architecture structural of MIPSFetch is

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

component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component PC is
	generic(N : integer := 32);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

component invg is
	port(i_A          : in std_logic;
             o_F          : out std_logic);
end component;

signal instrData, immData, instrShift, immShift, jumpAddress, BranchAddress, BranchMux 	: std_logic_vector(31 downto 0);
signal PCp4, four, PCnext, currentPC, sdata, PCin	: std_logic_vector(31 downto 0);
signal nextinstr	: std_logic_vector(9 downto 0);
signal PCp4C, JAddressC, BranchC, BAnd, Bxor, clock, HALT, NOTHALT	: std_logic;
signal zero	: std_logic;

begin

	zero <= '0';
	four <= x"00000004";
	PCin <= i_PC;
	clock <= i_CLK;
	HALT <= i_HALT;

	NHALT: invg port map(i_A => HALT, o_F => NOTHALT);

	instrData(31 downto 0) <= i_Instr;

	immData(31 downto 0) <= i_ExtendedImm(31 downto 0);

	ImmShift2 : Shifter2 port map(i_D => immData, o_D => immShift);

	PCPLUS4	: RippleCarryAdder port map(i_A => PCin, i_B => four, i_C => zero, o_S => PCp4, o_C => PCp4C);

	o_PCp4 <= PCp4;

	BRANCHADDER : RippleCarryAdder port map(i_A => PCp4, i_B => immShift, i_C => zero, o_S => BranchAddress, o_C => BranchC);
	
	BRANCHXOR : xorg2 port map(i_A => i_ALUResult, i_B => i_BranchNotEqual, o_F => Bxor);
	BRANCHAND : andg2 port map(i_A => i_Branch, i_B => Bxor, o_F => BAnd);

	BRANCHMULTI : mux2t1_N port map(i_S => BAnd, i_D0 => PCp4, i_D1 => BranchAddress, o_O => BranchMux);

	JUMPMULTI : mux2t1_N port map(i_S => i_Jump, i_D0 => BranchMux, i_D1 => instrData, o_O => PCnext);

	PCREG : PC port map(i_CLK => clock, i_RST => i_PCRST, i_WE => NOTHALT, i_D => PCnext, o_R => currentPC);

	o_PC <= currentPC;

end structural;
