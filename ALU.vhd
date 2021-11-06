----------------------------------------------
--Benito Moeckly
-- Implementation of a mips ALU unit. 
--
--Date: 10/25/21
----------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
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
end ALU;  

architecture struct of ALU is

--define components
component Add_Sub is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		nAdd_Sub	: in std_logic;
		o_overflow	: out std_logic;
		o_carryout	: out std_logic;
		oSum	: out std_logic_vector(N-1 downto 0));
end component;

component andg32 is

	port(i_dataA	: in  std_logic_vector(32-1 downto 0);
	 i_dataB	: in  std_logic_vector(32-1 downto 0);
	 o_result : out  std_logic_vector(32-1 downto 0));

end component;

component org32 is

	port(i_dataA	: in std_logic_vector(32-1 downto 0);
	 i_dataB	: in std_logic_vector(32-1 downto 0);
	 o_result : out  std_logic_vector(32-1 downto 0));

end component;

component andg2 is
	port( i_A	: in std_logic;
	 	i_B	: in std_logic;
		o_F	: out std_logic);
end component;



component xorg32 is

	port(i_dataA	: in std_logic_vector(32-1 downto 0);
	 i_dataB	: in std_logic_vector(32-1 downto 0);
	 o_result : out std_logic_vector(32-1 downto 0));

end component;

component MuxForALU

 port(
        i_Sel     :   in std_logic_vector(3-1 downto 0);
        i_D1	:	in std_logic_vector(32-1 downto 0);
	i_D2 	:	in std_logic_vector(32-1 downto 0);
	i_D3	:	in std_logic_vector(32-1 downto 0);
	i_D4	:	in std_logic_vector(32-1 downto 0);
	i_D5	:	in std_logic_vector(32-1 downto 0);
	i_D6	:	in std_logic_vector(32-1 downto 0);
	i_D7	:	in std_logic_vector(32-1 downto 0);
	i_D8   	:	in std_logic_vector(32-1 downto 0);
        o_output  :     out std_logic_vector(32-1 downto 0));
   
end component;

component barrelshifter is
	
	port(i_in	: in std_logic_vector(31 downto 0); -- data input to be shifted
	     i_n	: in std_logic_vector(4 downto 0); -- number of bits to shift
	     i_arithmetic	: in std_logic; -- preserve sign value (for right shift)
	     i_dir	: in std_logic; -- controls direction of shift
	     o_out	: out std_logic_vector(31 downto 0)); -- shifted output

end component;

component norg32t1 is
port(
    i_data  :   in std_logic_vector(32-1 downto 0);
    o_result    :   out std_logic);
end component;  


--define signals

signal s_adderOUT : std_logic_vector(32-1 downto 0);
signal s_andOUT : std_logic_vector(32-1 downto 0);
signal s_orOUT	:	std_logic_vector(32-1 downto 0);
signal s_xorOUT	:	std_logic_vector(32-1 downto 0);
signal s_shifterOUT	:	std_logic_vector(32-1 downto 0);
signal s_lessThanBit	:	std_logic;
signal s_slt		:	std_logic_vector(32-1 downto 0);
signal s_invOR		:	std_logic_vector(32-1 downto 0);
signal s_rplQB		:	std_logic_vector(32-1 downto 0);
signal s_equal_one_bit	:	std_logic;
signal s_overflow	:	std_logic;

begin
	
full32adder : Add_Sub port map(
	iA	=>	i_Adata,
	iB	=>	i_Bdata,
	nAdd_Sub	=>	i_ALUAddSub,
	o_overflow	=>	s_overflow,
	o_carryout	=>	o_carryout,	
	oSum	=>	s_adderOUT);

full32andg	:	andg32 port map(
	i_dataA	=>	i_Adata,
	i_dataB	=>	i_Bdata,
	o_result	=>	s_andOUt);

full32org	:	org32 port map(
	i_dataA	=>	i_Adata,
	i_dataB	=>	i_Bdata,
	o_result	=>	s_orOUT
);

full32xorg	:	xorg32	port map(
	i_dataA	=>	i_Adata,
	i_dataB	=>	i_Bdata,
	o_result	=>	s_xorOUT
);

equalLogic	:	norg32t1 port map(
	i_data	=>	s_adderOUT,
	o_result =>	o_equal
);

--Barrel shifter


shifter		:	barrelshifter port map(
	i_in	=>	i_Bdata,
        i_n	=>	i_shamt(4 downto 0),
        i_arithmetic	=>	i_ALUShiftArithmetic,
        i_dir	=>	i_ALUShiftDir,
        o_out	=>	s_shifterOUT);

--SLT LOGIC:

s_lessThanBit	<=	s_adderOUT(31);

s_slt(0)	<=	s_lessThanBit;
s_slt(31 downto 1)	<= 	(31 downto 1 => '0');

--RPLQB logic

s_rplQB(7 downto 0) 	<=	i_Adata(7 downto 0);
s_rplQB(15 downto 8) 	<=	i_Adata(7 downto 0);
s_rplQB(23 downto 16) 	<=	i_Adata(7 downto 0);
s_rplQB(31 downto 24) 	<=	i_Adata(7 downto 0);

--overflow logic

overflow : andg2
	 port map(
	i_A          => s_overflow,
        i_B          => i_signed,
        o_F          => o_overflow);



------Decide output depending on the ALU op code

mux 	: MuxForALU     port map(
	i_Sel        	  =>	i_ALUMuxCtrl,
	i_D1	  	  =>	s_adderOUT, 
	i_D2	  	  =>	s_andOUT, 
	i_D3	  	  =>	s_orOUT, 
	i_D4	  	  =>	s_invOR,
	i_D5      	  =>    s_xorOUT, 
	i_D6	  	  =>	s_shifterOUT, 
	i_D7	  	  =>	s_slt, 
	i_D8	  	  =>	s_rplQB,
	o_output  	  =>	o_result);




end struct;
		

