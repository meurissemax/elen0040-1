library ieee;
use ieee.std_logic_1164.all;

entity display is port (

clk : in std_logic ;

r0 : in std_logic_vector (2 downto 0);
r1 : in std_logic_vector (2 downto 0);
r2 : in std_logic_vector (2 downto 0);
r3 : in std_logic_vector (2 downto 0);

dec_comm0 : out std_logic ;
dec_comm1 : out std_logic ;

dig0 : out std_logic ;
dig1 : out std_logic ;
dig2 : out std_logic 
);
end entity display;

architecture display_arch of display is

signal cnt_line : std_logic_vector (1 downto 0);

component counter port (
clk : in std_logic ;
out0 : out std_logic ;
out1 : out std_logic 
);
end component;
begin

--Unité de comptage
counter0 : counter port map (clk,cnt_line(0),cnt_line(1));

process (clk)
variable tmp_dec : std_logic_vector (1 downto 0);
variable tmp_dig : std_logic_vector (2 downto 0);
begin
	if rising_edge (clk) then
		tmp_dec := cnt_line;
		if tmp_dec = "00" then
		
			tmp_dig := r0;
			
		end if;
			
		if tmp_dec = "01" then
					
			tmp_dig := r1;
			
		end if;
			
		if tmp_dec = "10" then
					
			tmp_dig := r2;
			
		end if;
			
		if tmp_dec = "11" then
					
			tmp_dig := r3;
			
		end if;
		dec_comm0 <= tmp_dec(0);
		dec_comm1 <= tmp_dec(1);
		
		dig0 <= tmp_dig(0);
		dig1 <= tmp_dig(1);
		dig2 <= tmp_dig(2);
	end if;
end process;
end architecture display_arch;