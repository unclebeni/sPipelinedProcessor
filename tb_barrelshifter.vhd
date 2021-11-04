-------------------------------------------------------------------
-- Benito Moeckly
-- Testbench for my 32 bit barrel shifter
--
-- CREATED ON: 11.4.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_barrelshifter is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_barrelshifter;

architecture behavior of tb_barrelshifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
component barrel_shifter is
	port(i_in	: in std_logic_vector(31 downto 0);
	     i_n	: in std_logic_vector(4 downto 0);
	     i_arithmetic	: in std_logic;
	     i_ctrl	: in std_logic;
	     o_out	: out std_logic_vector(31 downto 0));
end component;
-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero

signal s_CLK : std_logic := '0';
signal s_in : std_logic_vector(32-1 downto 0) := (others => '0');
signal s_out  : std_logic_vector(32-1 downto 0) := (others => '0');
signal s_n	:	std_logic_vector(4 downto 0)  := (others => '0');
signal s_arithmetic : std_logic := '0';
signal s_ctrl	:	std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading. --
  DUT0: barrel_shifter
  port map(
		i_in => s_in,
		i_n  => s_n,
		i_arithmetic => s_arithmetic,
		i_ctrl   => s_ctrl,
	  o_out =>  s_out);

            
  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
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

    s_in <=  x"0000FFFF";
    s_n  <=  "10000";
    s_arithmetic	<= '0';
    s_ctrl <= '0';
    
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
