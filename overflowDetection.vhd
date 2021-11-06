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
	i_signOp	: in std_logic;
	i_muxCTL	: in std_logic_vector(3-1 downto 0);
	o_overflow	: out std_logic);
end overflowDetection;  

architecture behavior of overflowDetection is
signal x, y, z: std_logic;
begin

	x <= (i_Asign and i_Bsign) or (not i_Asign and not i_Bsign);
 	y <= not ((i_Asign and i_resultSign) or (i_Bsign and i_resultSign));
	z <= '1' when (i_signOp is "000") and (x and y);
	o_overflow <= z;
	
end behavior;


