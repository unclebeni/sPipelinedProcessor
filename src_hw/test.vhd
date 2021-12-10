
library IEEE;
use IEEE.std_logic_1164.all;
entity test is
	port (iA	: in std_logic;
	      iB	: in std_logic;
	      iC	: in std_logic;
	      o_F	: out std_logic);
end test;

architecture mixed of test is

begin

o_F <= iA = iB;

end mixed;
