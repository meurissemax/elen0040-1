--Gestion leds

library ieee;
use ieee.std_logic_1164.all;

entity led_cont is port (
switch : in std_logic ;

--Commande leds carte
d2 : out std_logic ; --red top
d3 : out std_logic ; --yellow
d4 : out std_logic ;
d5 : out std_logic ;
d6 : out std_logic ;
d7 : out std_logic ;
d8 : out std_logic ; --yellow
d9 : out std_logic   --red btm
);
end entity;

architecture led_cont_arch of led_cont is
begin
	showmode : process(switch)
	begin
	if switch = '1' then --Mode Set
		d2 <= '1'; --Allumage leds carte
		d3 <= '1';
		d8 <= '1';
		d9 <= '1';
		d4 <= '0';
		d5 <= '0';
		d6 <= '0';
		d7 <= '0';
	else 						--Mode Play
		d2 <= '0'; --Allumage leds carte
		d3 <= '0';
		d8 <= '0';
		d9 <= '0';
		d4 <= '1';
		d5 <= '1';
		d6 <= '1';
		d7 <= '1';
	end if ;
	end process showmode;
end architecture led_cont_arch;