--Mastermind (top level design)

library ieee;
use ieee.std_logic_1164.all;

--Entité

entity mastermind is port (

--Clocks
clk0 : in std_logic ; --Horloge rapide (affichage)
clk1 : in std_logic ; --Horloge lente (saisie des données)

--Inputs
switch : in std_logic ;
ok_button : in std_logic ;
button_0 : in std_logic ;
button_1 : in std_logic ;
button_2 : in std_logic ;
button_3 : in std_logic ;

--Outputs
								--Commande décodeurs
deco_comm0 : buffer std_logic ;
deco_comm1 : buffer std_logic ;

								--Commande leds externes
led0 : buffer std_logic ;
led1 : buffer std_logic ;
led2 : buffer std_logic ;
led3 : buffer std_logic ;

								--Commande leds carte
d2 : out std_logic ; --red top
d3 : out std_logic ; --yellow
d4 : out std_logic ;
d5 : out std_logic ;
d6 : out std_logic ;
d7 : out std_logic ;
d8 : out std_logic ; --yellow
d9 : out std_logic ; --red btm

								--Afficheur tentatives
tent0 : buffer std_logic ;
tent1 : buffer std_logic ;
tent2 : buffer std_logic ;

								--Afficheur 7 segements
dig0 : buffer std_logic ;
dig1 : buffer std_logic ;
dig2 : buffer std_logic
) ;
end entity mastermind ;


--Architecture


architecture master_arch of mastermind is
signal button_s : std_logic_vector (3 downto 0) := "0000";
signal button_p : std_logic_vector (3 downto 0) := "0000";

signal ok_p : std_logic := '0' ;

signal r0_set : std_logic_vector (2 downto 0) := "000";
signal r1_set : std_logic_vector (2 downto 0) := "000";
signal r2_set : std_logic_vector (2 downto 0) := "000";
signal r3_set : std_logic_vector (2 downto 0) := "000";

signal r0_play : std_logic_vector (2 downto 0) := "000";
signal r1_play : std_logic_vector (2 downto 0) := "000";
signal r2_play : std_logic_vector (2 downto 0) := "000";
signal r3_play : std_logic_vector (2 downto 0) := "000";

signal r0 : std_logic_vector (2 downto 0);
signal r1 : std_logic_vector (2 downto 0);
signal r2 : std_logic_vector (2 downto 0);
signal r3 : std_logic_vector (2 downto 0);

signal r_tent : std_logic_vector (2 downto 0) := "000";

--signal cnt : std_logic_vector (1 downto 0) := "00";

signal prev_led : std_logic_vector (3 downto 0) := "0000";
 
--Description compteur
	component counter port (
	clk : in std_logic ;
	out0 : buffer std_logic ;
	out1 : buffer std_logic
	);
	end component;

--Description incrémenteur
	component incrementor port (
	clk : in std_logic ;
	inc : in std_logic ;

	out0 : buffer std_logic ;
	out1 : buffer std_logic ;
	out2 : buffer std_logic 
	);
	end component;
	
--Description incrémenteur tentatives
	component incrementor_tent port (
	clk : in std_logic ;
	inc : in std_logic ;

	out0 : buffer std_logic ;
	out1 : buffer std_logic ;
	out2 : buffer std_logic 
	);
	end component;
	
--Description afficheur
	component display port (
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
	end component;

--Description contrôleur leds carte
	component led_cont port (
	switch : in std_logic ;

	d2 : out std_logic ; --red top
	d3 : out std_logic ; --yellow
	d4 : out std_logic ;
	d5 : out std_logic ;
	d6 : out std_logic ;
	d7 : out std_logic ;
	d8 : out std_logic ; --yellow
	d9 : out std_logic   --red btm
	);
	end component;

begin

--	--Unité de comptage
--	counter_unit : counter port map (clk0,cnt(0),cnt(1));
	
	--Unités d'incrémentation
	inc_s0 : incrementor port map (clk1,button_s(0),r0_set(0),r0_set(1),r0_set(2));
	inc_s1 : incrementor port map (clk1,button_s(1),r1_set(0),r1_set(1),r1_set(2));
	inc_s2 : incrementor port map (clk1,button_s(2),r2_set(0),r2_set(1),r2_set(2));
	inc_s3 : incrementor port map (clk1,button_s(3),r3_set(0),r3_set(1),r3_set(2));
	
	inc_p0 : incrementor port map (clk1,button_p(0),r0_play(0),r0_play(1),r0_play(2));
	inc_p1 : incrementor port map (clk1,button_p(1),r1_play(0),r1_play(1),r1_play(2));
	inc_p2 : incrementor port map (clk1,button_p(2),r2_play(0),r2_play(1),r2_play(2));
	inc_p3 : incrementor port map (clk1,button_p(3),r3_play(0),r3_play(1),r3_play(2));
	
	--Unité d'incrémentation tentatives
	inc_tent : incrementor_tent port map (clk1,ok_p,r_tent(0),r_tent(1),r_tent(2));
	
	--Unité d'affichage
	display_unit : display port map (clk0,r0,r1,r2,r3,deco_comm0,deco_comm1,dig0,dig1,dig2);
	
	--Unité de gestion des leds de la carte
	led_cont_unit : led_cont port map (switch,d2,d3,d4,d5,d6,d7,d8,d9);

	
--	--Processus d'affichage du mode actuel
--	showmode : process(switch)
--	begin
--	if switch = '1' then --Mode Set
--		d2 <= '1'; --Allumage leds carte
--		d3 <= '1';
--		d8 <= '1';
--		d9 <= '1';
--		d4 <= '0';
--		d5 <= '0';
--		d6 <= '0';
--		d7 <= '0';
--	else 						--Mode Play
--		d2 <= '0'; --Allumage leds carte
--		d3 <= '0';
--		d8 <= '0';
--		d9 <= '0';
--		d4 <= '1';
--		d5 <= '1';
--		d6 <= '1';
--		d7 <= '1';
--	end if ;
--	end process showmode;
	
--	--Processus d'attribution des boutons
	attrib : process(switch,clk1)
	begin
		if rising_edge(clk1) then
			if switch = '1' then
				button_s(0)<=button_0;
				button_s(1)<=button_1;
				button_s(2)<=button_2;
				button_s(3)<=button_3;
				
				button_p <= "0000";
				
			elsif switch ='0' then
				button_p(0)<=button_0;
				button_p(1)<=button_1;
				button_p(2)<=button_2;
				button_p(3)<=button_3;
				
				button_s <= "0000";
				
			end if;
		end if;
	end process attrib ;
	
	--Processus d'attribution des registres
	reg : process(switch,clk0)
	begin
		if rising_edge(clk0) then
			if switch='1' then
				r0 <= r0_set;
				r1 <= r1_set;
				r2 <= r2_set;
				r3 <= r3_set;
			elsif switch='0' then
				r0 <= r0_play;
				r1 <= r1_play;
				r2 <= r2_play;
				r3 <= r3_play;
			end if;
		end if;
	end process reg;
	
	--Processus de validation
	valid : process(ok_button,switch,clk1)
	begin
	if rising_edge(clk1) then
			if switch = '1' then
				ok_p <= '0';
			elsif switch ='0' then
				ok_p <= ok_button ;
			end if;
		end if;
	end process valid;
	
	--Processus de contrôle
	control : process(ok_p,clk1)
	variable tmp0 : std_logic ;
	variable tmp1 : std_logic ;
	variable tmp2 : std_logic ;
	variable tmp3 : std_logic ;
	begin
		if(rising_edge (clk1))then
			if (r_tent /= "101") then
				tmp0 := prev_led(0);
				tmp1 := prev_led(1);
				tmp2 := prev_led(2);
				tmp3 := prev_led(3);
				if (r0_set /= r0_play) then
					tmp0 := '1';
				else
					tmp0 := '0';
				end if;
				if (r1_set /= r1_play) then
					tmp1 := '1';
				else
					tmp1 := '0';
				end if;
				if (r2_set /= r2_play) then
					tmp2 := '1';
				else
					tmp2 := '0';
				end if;
				if (r3_set /= r3_play) then
					tmp3 := '1';
				else
					tmp3 := '0';
				end if;
			else
				tmp0 := '1';
				tmp1 := '1';
				tmp2 := '1';
				tmp3 := '1';
			end if;

			if (ok_p='0') then
				led0<=prev_led(0);
				led1<=prev_led(1);
				led2<=prev_led(2);
				led3<=prev_led(3);
			elsif (ok_p='1') then
				prev_led(0)<=tmp0;
				prev_led(1)<=tmp1;
				prev_led(2)<=tmp2;
				prev_led(3)<=tmp3;
				led0<=tmp0;
				led1<=tmp1;
				led2<=tmp2;
				led3<=tmp3;
			end if;
		end if;
	end process control;
	
--	--Processus d'affichage 7 segments
--	display : process(switch,clk0)
--	variable tmp0 : std_logic ;
--	variable tmp1 : std_logic ;
--	variable tmp2 : std_logic ;
--	begin
--		if (rising_edge (clk0)) then
--		deco_comm0 <= cnt(0) ;
--		deco_comm1 <= cnt(1) ;
--		
--			if switch='1' then			
--				
--				if (cnt="00") then
--					tmp0:=r0_set(0);
--					tmp1:=r0_set(1);
--					tmp2:=r0_set(2);
--				elsif (cnt="01") then
--					tmp0:=r1_set(0);
--					tmp1:=r1_set(1);
--					tmp2:=r1_set(2);
--				elsif (cnt="10") then
--					tmp0:=r2_set(0);
--					tmp1:=r2_set(1);
--					tmp2:=r2_set(2);
--				elsif (cnt="11") then
--					tmp0:=r3_set(0);
--					tmp1:=r3_set(1);
--					tmp2:=r3_set(2);
--				end if;
--			else
--			
--				if (cnt="00") then
--					tmp0:=r0_play(0);
--					tmp1:=r0_play(1);
--					tmp2:=r0_play(2);
--				elsif (cnt="01") then
--					tmp0:=r1_play(0);
--					tmp1:=r1_play(1);
--					tmp2:=r1_play(2);
--				elsif (cnt="10") then
--					tmp0:=r2_play(0);
--					tmp1:=r2_play(1);
--					tmp2:=r2_play(2);
--				elsif (cnt="11") then
--					tmp0:=r3_play(0);
--					tmp1:=r3_play(1);
--					tmp2:=r3_play(2);
--				end if;
--			end if; --if mode
--			
--			dig0<=tmp0;
--			dig1<=tmp1;
--			dig2<=tmp2;
--			
--		end if; --if rising edge
--	end process display;
	
	--Processus affichage tentatives
	display_tent : process (switch,clk0)
	begin
	if rising_edge (clk0) then
		if switch = '0' then
			tent0 <= r_tent(0);
			tent1 <= r_tent(1);
			tent2 <= r_tent(2);
		elsif switch = '1' then
			tent0 <= '0';
			tent1 <= '0';
			tent2 <= '0';
		end if;
	end if;
	end process display_tent;
end architecture master_arch;