-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IFID is
    port (i_Clk     : in std_logic;
          i_Rst     : in std_logic;
	  i_WE	: in std_logic;
          i_PCp4    : in std_logic_vector(31 downto 0);
          i_Inst    : in std_logic_vector(31 downto 0);
          o_PCp4    : out std_logic_vector(31 downto 0);
          o_Inst    : out std_logic_vector(31 downto 0));
end IFID;

architecture structural of IFID is

component Reg is
    generic(N : integer := 64);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

signal PCp4, Inst   : std_logic_vector(31 downto 0);
signal RegInput, RegOutput     : std_logic_vector(63 downto 0);

begin

PCp4 <= i_PCp4;
Inst <= i_Inst;

RegInput(31 downto 0) <= PCp4;
RegInput(63 downto 32) <= Inst;

IFIDREG: Reg port map(i_CLK => i_Clk, i_RST => i_Rst, i_WE => i_WE, i_D => RegInput, o_R => RegOutput);

o_PCp4 <= RegOutput(31 downto 0);
o_Inst <= RegOutput(63 downto 32);

end structural;
