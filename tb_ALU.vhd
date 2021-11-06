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
	i_signed	:	in std_logic;
	o_equal			: out std_logic;
	o_carryout	:	out std_logic;
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
signal s_carryout	:	std_logic := '0';
signal s_signed		:	std_logic := '0';

begin

DUT0: ALU port map(
	i_Adata		=>	s_Adata,
	i_Bdata		=>	s_Bdata,
	i_ALUShiftDir	=>	s_ALUShiftDir,
	i_ALUShiftArithmetic	=>	s_ALUShiftArithmetic,
	i_ALUAddSub	=>	s_ALUAddSub,
	i_ALUMuxCtrl	=>	s_ALUMuxCtrl,
	i_shamt		=>	s_shamt,
	i_signed	=>	s_signed,
	o_equal		=>	s_equal,
	o_carryout	=>	s_carryout,			
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

--00000000 && 000000FF
s_Adata		<= x"00000000";
s_Bdata		<= x"000000FF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '0';
s_ALUMuxCtrl	<= "001";
s_shamt		<= "00000";

wait for cCLK_PER;
	
--FFFFFFFF - 0000FFFF 
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"0000FFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "00000";

wait for cCLK_PER;

--FFFFFFFF & 0000FFFF should be 0000FFFF
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"0000FFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "001";
s_shamt		<= "00000";

wait for cCLK_PER;

--AAAAAAAA ^ 55555555 should be FFFFFFFF (1010 ^ 0101 = 1111)
s_Adata		<= x"AAAAAAAA";
s_Bdata		<= x"55555555";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "010";
s_shamt		<= "00000";

wait for cCLK_PER;

--FFFFFFFF - FFFFFFFF should be zero, should output '1' for equal
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"0000FFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "010";
s_shamt		<= "00000";

wait for cCLK_PER;

--FFFFFFFF - FFFFFFFF should be zero, should output '1' for equal
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"0000FFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "00000";

wait for cCLK_PER;

--FFFFFFFF - FFFFFFFF should be zero, should output '1' for equal bit
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"0000FFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "00000";

wait for cCLK_PER;

-- FFFFFFFF << 32 should be 00000000
--Already tested the barrel shifter but can't be too safe >:}
s_Adata		<= x"FFFFFFFF";
s_Bdata		<= x"FFFFFFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "101";
s_shamt		<= "11111";

wait for cCLK_PER;

-- 0000001 - 1FFFFFF0, should tell me that A<B and output 00000001
s_Adata		<= x"00000001";
s_Bdata		<= x"1FFFFFF0";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "110";
s_shamt		<= "11111";

wait for cCLK_PER;

-- A = 000000AA... should RPL.QB to AAAAAAAA
s_Adata		<= x"000000AA";
s_Bdata		<= x"FFFFFFF0";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "111";
s_shamt		<= "11111";

wait for cCLK_PER;

--------------------Now for some overflow tests-----------------------------------------
-- Adding a big negative to a big negative should give overflow
s_Adata		<= x"80000000";
s_Bdata		<= x"80000000";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '0';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "11111";
s_signed	<= '1';

wait for cCLK_PER;

--adding a big positive to a big positive should give an overflow
s_Adata		<= x"7FFFFFFF";
s_Bdata		<= x"7FFFFFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '0';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "11111";
s_signed	<= '1';

wait for cCLK_PER;

--Subtractive a large negative by a large positive should produce overflow
s_Adata		<= x"80000000";
s_Bdata		<= x"7FFFFFFF";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "11111";
s_signed	<= '1';

wait for cCLK_PER;

-----The following tests hopefully do NOT have overflow

--sub small negative by small negative resulting in a positive
s_Adata		<= x"FFFFFF23";
s_Bdata		<= x"FFFF2345";
s_ALUShiftDir	<= '0';	
s_ALUShiftArithmetic	<= '0';
s_ALUAddSub	<= '1';
s_ALUMuxCtrl	<= "000";
s_shamt		<= "11111";
s_signed	<= '1';

wait for cCLK_PER;




	wait;
	end process;

end behavior;




