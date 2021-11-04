-------------------------------------------------------------------------
-- Benito Moeckly
-- CprE Student
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 multiplexer
-- 
--
--
-- NOTES:
-- Created on 09/02/2021
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is 
	port(i_S		: in std_logic;
	     i_D0		: in std_logic;
	     i_D1		: in std_logic;
	     o_O		: out std_logic);
end mux2t1;

architecture struct of mux2t1 is
--Implement and gate, or gate, and inverter gate from the given lab files--
	component andg2 is 

 	port(i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component;
--------------------------------------------------------------
	component org2 is

	 port(i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component;
--------------------------------------------------------------
	component invg is

	port(i_A          : in std_logic;
       		o_F          : out std_logic);

	end component;
--Define some wires for the multiplexer--
	signal s1, s2, s3 : std_logic;
--------------------------------------------------------------
begin
	
 and1: andg2
  port MAP(i_A		=> i_S,
	   i_B		=> i_D1,
	   o_F          => s1);
 invert: invg
  port MAP(i_A 		=> i_S,
 	   o_F		=> s2);
 and2: andg2
  port MAP(i_A		=> s2,
 	   i_B		=>i_D0,
	   o_F		=> s3);
 orgate: org2
  port MAP(i_A		=> s1,
	   i_B		=> s3,
	   o_F		=> o_O);


end struct;
-----------------------------------------

