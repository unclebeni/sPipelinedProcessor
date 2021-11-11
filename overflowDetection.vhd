----------------------------------------------
--Benito Moeckly
-- Behavioral implementation of overflow detection
--
--Date: 10.3.21
----------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity overflowDetection is
port(
	i_Asign		: in std_logic;
	i_Bsign		: in std_logic;
	i_resultSign	: in std_logic;
	o_overflow	: out std_logic);
end overflowDetection;  

architecture behavior of overflowDetection is
signal x : std_logic;
signal y : std_logic;

begin

	x <= (i_Asign and i_Bsign) or (not i_Asign and not i_Bsign);
	y <= (i_Asign and not i_resultSign) or (i_Bsign and not i_resultSign) or(i_resultSign and not i_Asign) or (i_resultSign and not i_Bsign);
	o_overflow <= x and y;
		

	
end behavior;


