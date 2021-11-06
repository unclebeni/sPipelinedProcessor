-------------------------------------------------------------------
-- Cole Hunt
-- Testbench for ALUcontrol
--
-- CREATED ON: 11.6.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_ALUcontrol is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ALUcontrol;

architecture behavior of tb_ALUcontrol is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component ALUcontrol is
port(i_ALUop			: in std_logic_vector(3 downto 0);
	o_ALUShiftDir		: out std_logic;
	o_ALUShiftArithmetic    : out std_logic;
        o_ALUAddSub		: out std_logic;
        o_ALUMuxCtrl		: out std_logic_vector(2 downto 0);
	o_unsigned		: out std_logic);
end component; 
--signals

signal s_CLK			: std_logic := '0';
signal s_ALUop			: std_logic_vector(3 downto 0) := (others => '0');	
signal s_ALUShiftDir		: std_logic := '0';
signal s_ALUSHiftArithmetic	: std_logic := '0';
signal s_ALUAddSub		: std_logic := '0';
signal s_ALUMuxCtrl		: std_logic_vector(2 downto 0) := (others => '0');
signal s_unsigned		: std_logic := '0';

begin

DUT0: ALU port map(
	i_ALUop			=> s_ALUop
	o_ALUShiftDir		=> s_ALUShiftDir,
	o_ALUShiftArithmetic	=> s_ALUShiftArithmetic,
	o_ALUAddSub		=> s_ALUAddSub,
	o_ALUMuxCtrl		=> s_ALUMuxCtrl,
	o_unsinged		=> s_unsigned);
	
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

s_ALUop	<= "0000"; -- add

wait for cCLK_PER;

s_ALUop	<= "0001"; -- sub

wait for cCLK_PER;

s_ALUop <= "0010"; -- AND

wait for cCLK_PER;

s_ALUop <= "0011"; -- OR

wait for cCLK_PER;

s_ALUop <= "0100"; -- XOR

wait for cCLK_PER;

s_ALUop <= "0101"; -- NOR

wait for cCLK_PER;

s_ALUop <= "0110"; -- slt

wait for cCLK_PER;

s_ALUop <= "0111"; -- shiftLeft

wait for cCLK_PER;

s_ALUop <= "1000"; -- shiftRight

wait for cCLK_PER;

s_ALUop <= "1001"; -- ShiftRightA

wait for cCLK_PER;

s_ALUop <= "1010"; -- repl.qb

wait for cCLK_PER;

s_ALUop <= "1011"; -- addu

wait for cCLK_PER;

s_ALUop <= "1100"; -- subu

wait for cCLK_PER;

	wait;
	end process;

end behavior;




