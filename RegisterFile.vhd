-----------------------------------------------
--DESCRIPTION: This file contains an implementation of a
--register register file with read/write funtonality
--CREATED BY: Benito Moeckly, ISU CPRE Undergrad
--09.29.21
------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use work.largebus.Arr;

entity RegisterFile is
	generic(N : integer := 32); --Generic i/o data width
	 port(i_CLK        : in std_logic;     -- Clock input
		i_RST	   : in std_logic;     -- Reset
       		i_RS        : in std_logic_vector(4 downto 0);     -- First source register
       		i_RT         : in std_logic_vector(4 downto 0);     -- Secondary source register
       		i_RD          : in std_logic_vector(4 downto 0); --Destination register for writing 
		i_DI	      : in std_logic_vector(N-1 downto 0); --Write value for register 
		o_Q1  	      : out std_logic_vector(N-1 downto 0); --Data value output 1 (RS)
       		o_Q2          : out std_logic_vector(N-1 downto 0));   -- Data value output 2 (RT)

end RegisterFile;

------------------------------------------------------------------------------------------------

architecture struct of RegisterFile is

------------------------------------------------------------------------------------------------
	component RegFile is

  	 generic(N : integer := 32); --Generic i/o data width
	 port(i_CLK        : in std_logic;     -- Clock input
       		i_RST        : in std_logic;     -- Reset input
       		i_WE         : in std_logic;     -- Write enable input
       		i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       		o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

	end component;
------------------------------------------------------------------------------------------------
	component mux32t1 is 
	port(i_S		: in std_logic_vector(4 downto 0);
	     i_D		: in Arr;
	     o_O		: out std_logic_vector(31 downto 0));
	end component;
------------------------------------------------------------------------------------------------
	component decoder is

	port(i_sel  : in std_logic_vector(4 downto 0);
	     o_Out  : out std_logic_vector(31 downto 0));

	end component;
-------------------------------------------------------------------------------------------------

	signal complex_bus : Arr := (others => x"00000000");
	signal WEbus	: std_logic_vector(31 downto 0);

	begin

register_select : decoder
	port map(
		i_sel => i_RD,
		o_Out => WEbus);


systemProcess : for i in 1 to N-1 generate --This code should keep the address 0 always x"00000000"
	readWrite : RegFile port map(
	i_CLK	=>	i_CLK, --clock
	i_RST	=>	i_RST, --reset
	i_WE	=>	WEbus(i),  --Write enable
	i_D	=>	i_DI,  --Data in
	o_Q	=>	complex_bus(i)); --32 bit data into the complex bus(32x32)
end generate systemProcess;


RA_mux : mux32t1 
	port map(
		i_S	=>  i_RS,
		i_D	=>  complex_bus,
		o_O	=>  o_Q1);
RB_mux : mux32t1 
	port map(
		i_S	=>  i_RT,
		i_D	=>  complex_bus,
		o_O	=>  o_Q2);


end struct;