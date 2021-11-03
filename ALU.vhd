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
	i_ALuShiftArithmetic	: in std_logic;
	i_ALUAddSub		: in std_logic;
	i_ALUMuxCtrl	: in std_logic(3-1 downto 0);
	o_result	: out std_logic_vector(32-1 downto 0));
end ALU;  --Should be good here

architecture struct of ALU is

--define components
component Add_Sub is
	generic(N : integer := 32); --Generic i/o data width
	port(	iA	: in std_logic_vector(N-1 downto 0);
		iB	: in std_logic_vector(N-1 downto 0);
		nAdd_Sub	: in std_logic;
		oSum	: out std_logic_vector(N-1 downto 0));
end component;

component andg32 is

	port(i_dataA	: in: std_logic_vector(32-1 downto 0);
	 i_dataB	: in: std_logic_vector(32-1 downto 0);
	 o_result : in : std_logic_vector(32-1 downto 0);

end component;

component org32 is

	port(i_dataA	: in: std_logic_vector(32-1 downto 0);
	 i_dataB	: in: std_logic_vector(32-1 downto 0);
	 o_result : in : std_logic_vector(32-1 downto 0);

end component;

component xorg32 is

	port(i_dataA	: in: std_logic_vector(32-1 downto 0);
	 i_dataB	: in: std_logic_vector(32-1 downto 0);
	 o_result : in : std_logic_vector(32-1 downto 0);

end component;

--define signals

signal s_adderOUT : std_logic_vector(32-1 downto 0);
signal s_andOUT : std_logic_vector(32-1 downto 0);
signal s_orOUT	:	std_logic_vector(32-1 downto 0);
signal s_xorOUT	:	std_logic_vector(32-1 downto 0);


begin

--map ports

full32adder : Add_Sub port map(
	iA	=>	i_Adata,
	iB	=>	i_Bdata,
	nAdd_Sub	=>	i_ALUAddSub,
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
	o_result	=>	s_xorOUT);
);



--TODO: CREATE AND IMPLEMENT THE SHIFTER AND SLT FUNCTION



end struct;
		

