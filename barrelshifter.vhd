-----------------------------------------------------------------------
-- This file contains an implementation of a 32 bit barrel shifter with
-- variable direction and arithmetic select. 
-----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshifter is
	
	port(i_in	: in std_logic_vector(31 downto 0); -- data input to be shifted
	     i_n	: in std_logic_vector(4 downto 0); -- number of bits to shift
	     i_arithmetic	: in std_logic; -- preserve sign value (for right shift)
	     i_dir	: in std_logic; -- controls direction of shift
	     o_out	: out std_logic_vector(31 downto 0)); -- shifted output

end barrelshifter;

architecture structure of barrelshifter is

component mux2t1 is 
	port(i_S		: in std_logic;
	     i_D0		: in std_logic;
	     i_D1		: in std_logic;
	     o_O		: out std_logic);
end component;
   
component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;
   

component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;


  signal s_and		: std_logic; -- This will help us preserve the leftmost bit in a right shift
  signal s_o  		: std_logic_vector(31 downto 0);
  
  signal s_D1		: std_logic_vector(31 downto 0);
  signal s_D2		: std_logic_vector(31 downto 0);
  signal s_D3		: std_logic_vector(31 downto 0);

  signal s_Row0		: std_logic_vector(31 downto 0);
  signal s_Row1		: std_logic_vector(31 downto 0);
  signal s_Row2		: std_logic_vector(31 downto 0);
  signal s_Row3		: std_logic_vector(31 downto 0);

begin

    
    reverse: for i in 0 to 31 generate
    
       s_D2(31-i) <= i_in(i); 

    end generate reverse;

  nMux1: mux2t1_N
     port map(i_S	        => i_dir,
	      i_D0(31 downto 0)	=> i_in(31 downto 0),
 	      i_D1(31 downto 0)	=> s_D2(31 downto 0),
	      o_O(31 downto 0)  => s_D1(31 downto 0));

  and1: andg2 
     port map(i_A	=> i_arithmetic,
	      i_B	=> s_D1(31),
     	      o_F	=> s_and);
  
  muxRow0: for i in 0 to 30 generate
	
    	MUXROW0: mux2t1 port map(
              i_S      => i_n(0),    
              i_D0     => s_D1(i),  
              i_D1     => s_D1(i+1),  
              o_O      => s_Row0(i));

  end generate muxRow0;

  muxRow0_31: mux2t1 
       port map(i_S      => i_n(0),    
                i_D0     => s_D1(31),  
                i_D1     => s_and,  
                o_O      => s_Row0(31));
	       
  muxRow1: for i in 0 to 29 generate
	
    	MUXROW1: mux2t1 port map(
              i_S      => i_n(1),    
              i_D0     => s_Row0(i),  
              i_D1     => s_Row0(i+2),  
              o_O      => s_Row1(i));

  end generate muxRow1;

  muxRow1_30_31: for i in 30 to 31 generate

        muxRow1_30_31: mux2t1 port map(
		i_S      => i_n(1),    
                i_D0     => s_Row0(i),  
                i_D1     => s_and,  
                o_O      => s_Row1(i));
  end generate muxRow1_30_31;

  muxRow2: for i in 0 to 27 generate
	
    	MUXROW2: mux2t1 port map(
              i_S      => i_n(2),    
              i_D0     => s_Row1(i),  
              i_D1     => s_Row1(i+4),  
              o_O      => s_Row2(i));

  end generate muxRow2;

  muxRow2_28_31: for i in 28 to 31 generate

        MUXROW2_28_31: mux2t1 port map(
		i_S      => i_n(2),    
                i_D0     => s_Row1(i),  
                i_D1     => s_and,  
                o_O      => s_Row2(i));

  end generate muxRow2_28_31;

  muxRow3: for i in 0 to 23 generate
	
    	MUXROW3: mux2t1 port map(
              i_S      => i_n(3),    
              i_D0     => s_Row2(i),  
              i_D1     => s_Row2(i+8),  
              o_O      => s_Row3(i));

  end generate muxRow3;

  muxRow3_24_31: for i in 24 to 31 generate

        MUXROW3_24_31: mux2t1 port map(
		i_S      => i_n(3),    
                i_D0     => s_Row2(i),  
                i_D1     => s_and,  
                o_O      => s_Row3(i));

  end generate muxRow3_24_31;

  muxRow4: for i in 0 to 15 generate
	
    	MUXROW4: mux2t1 port map(
              i_S      => i_n(4),    
              i_D0     => s_Row3(i),  
              i_D1     => s_Row3(i+16),  
              o_O      => s_o(i));

  end generate muxRow4;

  muxRow4_16_31: for i in 16 to 31 generate

        muxRow4_16_31: mux2t1 port map(
		i_S      => i_n(4),    
                i_D0     => s_Row3(i),  
                i_D1     => s_and,  
                o_O      => s_o(i));

  end generate muxRow4_16_31;  


  reverse2: for i in 0 to 31 generate

       s_D3(31-i) <= s_o(i); 

  end generate reverse2;

  N_BIT_MUX2: mux2t1_N
     port map(i_S	        => i_dir,
	      i_D0(31 downto 0)	=> s_o(31 downto 0),
 	      i_D1(31 downto 0)	=> s_D3(31 downto 0),
	      o_O(31 downto 0)  => o_out(31 downto 0));

end structure;
