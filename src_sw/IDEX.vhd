-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

enitity IDEX is
    port (

    );
end IDEX;

architecture structural of IDEX is

component Reg is
    generic(N : integer := 32);
	port(i_CLK	: in std_logic;
	     i_RST	: in std_logic;
	     i_WE	: in std_logic;
	     i_D	: in std_logic_vector(N-1 downto 0);
	     o_R	: out std_logic_vector(N-1 downto 0));
end component;

begin



end structural;