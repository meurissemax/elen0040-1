--Compteur 2 bits
library ieee;
use ieee.std_logic_1164.all;

entity counter is port (

clk : in std_logic ;
out0 : buffer std_logic ;
out1 : buffer std_logic 
);
end entity counter;

architecture count_arch of counter is 
signal prev_cont : std_logic_vector (1 downto 0) := "XX";

begin
	process (clk)
	variable tmp : std_logic_vector (1 downto 0) ;
	begin
	if (rising_edge(clk)) then
		if (prev_cont = "00") then
			tmp := "01" ;
		elsif (prev_cont = "01") then
			tmp := "10" ;
		elsif (prev_cont = "10") then
			tmp := "11" ;
		elsif (prev_cont = "11") then
			tmp := "00" ;
		else
			tmp := "00" ;
		end if;
		prev_cont<=tmp ;
		out0 <= tmp(0);
		out1 <= tmp(1);
	end if;
	end process;
end architecture count_arch;