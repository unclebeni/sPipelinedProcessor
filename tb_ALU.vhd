-------------------------------------------------------------------
-- Benito Moeckly
-- Testbench for my 32 bit barrel shifter
--
-- CREATED ON: 11.4.21
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ALU;

architecture behavior of tb_ALU is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component ALU is
port(
	i_Adata		: in std_logic_vector(32-1 downto 0);
	i_Bdata		: in std_logic_vector(32-1 downto 0);
	i_ALUShiftDir	: in std_logic;
	i_ALUShiftArithmetic	: in std_logic;
	i_ALUAddSub		: in std_logic;
	i_ALUMuxCtrl	: in std_logic_vector(3-1 downto 0);
	i_shamt		:	in std_logic_vector(5-1 downto 0);
	o_equal			: out std_logic;
	o_overflow	:	out std_logic;
	o_result	: out std_logic_vector(32-1 downto 0));
end component; 
--signals

signal s_CLK : std_logic := '0';
signal s_Adata	: std_logic_vector(32-1 downto 0) := (others => '0');
signal s_Bdata	: std_logic_vector(32-1 downto 0) := (others => '0');
signal s_ALUShiftDir	:	std_logic := '0';
signal s_ALUSHiftArithmetic	:	std_logic := '0';
signal s_ALUAddSub	:	std_logic := '0';
signal s_ALUMuxCtrl	:	std_logic_vector(3-1 downto 0) := (others => '0');
signal s_shamt		:	std_logic_vector(5-1 downto 0) := (others => '0');
signal s_equal		:	std_logic := '0';
signal s_overflow	:	std_logic := '0';
signal s_result		:	std_logic_vector(32-1 downto 0) := (others => '0');

begin

DUT0: ALU port map(
	i_Adata		=>	s_Adata,
	i_Bdata		=>	s_Bdata,
	i_ALUShiftDir	=>	s_ALUShiftDir,
	i_ALUShiftArithmetic	=>	s_ALUShiftArithmetic,
	i_ALUAddSub	=>	s_ALUAddSub,
	i_ALUMuxCtrl	=>	s_ALUMuxCtrl,
	i_shamt		=>	s_shamt,
	o_equal		=>	s_equal,			
	o_overflow	=>	s_overflow,
	o_result	=>	s_result);
	
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

s_Adata		<= x"00000000";
s_Bdata		<= x"000000FF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '0';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "00000";

wait for cCLK_PER;


s_Adata		<= x"00000000";
s_Bdata		<= x"000000FF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '0';
s_ALUMuxCtrl	<= "001";
s_shamt		<= "00000";

wait for cCLK_PER;
	
	wait;
	end process;

end behavior;




