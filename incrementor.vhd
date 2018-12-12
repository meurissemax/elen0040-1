--Incrémentation sur pression bouton
library ieee;
use ieee.std_logic_1164.all ;

entity incrementor is port (
clk : in std_logic ;

inc : in std_logic ;

out0 : buffer std_logic ;
out1 : buffer std_logic ;
out2 : buffer std_logic 
);
end entity incrementor ;

architecture inc_arch of incrementor is
signal prev_numb : std_logic_vector (2 downto 0) :="XXX" ;
begin
	process(clk)
	variable tmp : std_logic_vector (2 downto 0) ;
	begin
	if (rising_edge(clk)) then
		if (inc='1') then
			if (prev_numb = "000") then
				tmp := "001" ;
			
			elsif (prev_numb = "001") then
				tmp := "010" ;
			
			elsif (prev_numb = "010") then
				tmp := "011" ;
			
			elsif (prev_numb = "011") then
				tmp := "100" ;
			
			elsif (prev_numb = "100") then
				tmp := "101" ;
			
			elsif (prev_numb = "101") then
				tmp := "110" ;
			
			elsif (prev_numb = "110") then
				tmp := "111" ;
			
			elsif (prev_numb = "111") then
				tmp := "000" ;
			
			else
				tmp := "000" ;
			end if;
		else 
			tmp := prev_numb;
		end if;
		prev_numb <= tmp ;
		out0 <= tmp(0);
		out1 <= tmp(1);
		out2 <= tmp(2);
	end if;
	end process;
end architecture inc_arch ;
