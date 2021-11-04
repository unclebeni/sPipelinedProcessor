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
	i_ALUMuxCtrl	: in std_logic_vector(3-1 downto 0);
	i_areEqual		: in std_logic;
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
	 o_result : in : std_logic_vector(32-1 downto 0));

end component;

component org32 is

	port(i_dataA	: in: std_logic_vector(32-1 downto 0);
	 i_dataB	: in: std_logic_vector(32-1 downto 0);
	 o_result : in : std_logic_vector(32-1 downto 0));

end component;

component xorg32 is

	port(i_dataA	: in: std_logic_vector(32-1 downto 0);
	 i_dataB	: in: std_logic_vector(32-1 downto 0);
	 o_result : in : std_logic_vector(32-1 downto 0));

end component;

component FourToOneMux

    port(
        i_Sel     :   in std_logic_vector(3-1 downto 0);
        i_D1, i_D2, i_D3, i_D4,i_D5, i_D6, i_D7, i_D8   :   in std_logic(32-1 downto 0);
        o_output  :     out std_logic_vector(32-1 downto 0));
end component;



--define signals

signal s_adderOUT : std_logic_vector(32-1 downto 0);
signal s_andOUT : std_logic_vector(32-1 downto 0);
signal s_orOUT	:	std_logic_vector(32-1 downto 0);
signal s_xorOUT	:	std_logic_vector(32-1 downto 0);
signal s_shifterOUT	:	std_logic_vector(32-1 downto 0);
signal s_equal		:	std_logic_vector(32-1 downto 0);
signal s_NOTequal	:	std_logic_vector(32-1 downto 0);
signal s_invOR		:	std_logic_vector(32-1 downto 0);

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

------Decide output depending on the ALU op code

mux 	: FourToOneMux     port map(
	i_Sel     :   =>	ALUMuxCtrl,
	i_D1	  :	  =>	s_adderOUT, 
	i_D2	  :	  =>	s_andOUT, 
	i_D3	  :	  =>	s_orOUT, 
	i_D4	  :	  =>	s_invOR,
	i_D5      :	  =>    s_xorOUT, 
	i_D6	  :	  =>	s_shifterOUT, 
	i_D7	  :	  =>	s_equal, 
	i_D8	  :	  =>	s_NOTequal,
	o_output  :	   =>);


end struct;
		

