-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity CompareEqual is
	port(i_A	: in std_logic_vector(31 downto 0);
	     i_B	: in std_logic_vector(31 downto 0);
	     o_Eq	: out std_logic);
end CompareEqual;

architecture Structural of CompareEqual is

component Add_Sub is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		nAdd_Sub	: in std_logic;
		o_overflow	: out std_logic;
		o_carryout	: out std_logic;
		oSum	: out std_logic_vector(N-1 downto 0));
end component;

component norg32t1 is
port(
    i_data  :   in std_logic_vector(32-1 downto 0);
    o_result    :   out std_logic);
end component;

signal s_overflow, s_carryout, s_Eq	: std_logic;
signal s_AddOut	: std_logic_vector(31 downto 0);

begin

ADDSUB: Add_Sub port map(iA => i_A, iB => i_B, nAdd_Sub => '1', o_overflow => s_overflow, o_carryout => s_carryout, oSum => s_AddOut);

EQUATOR: norg32t1 port map(i_data => s_AddOut, o_result => s_Eq);

o_Eq <= s_Eq;

end structural;
