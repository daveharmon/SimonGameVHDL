----------------------------------------------------------------------------------
-- Company: 	David Harmon & James Thompson
-- Engineer: 
-- 
-- Create Date:    20:12:25 08/11/2015 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( clk   : in STD_LOGIC;
			  onoff : in  STD_LOGIC;	-- input from the switch turns game on or off
           random_receive : in  STD_LOGIC_VECTOR (1 downto 0); -- receive the random number
           level_counter : in  unsigned (5 downto 0); -- the current level
           reg_pattern_receive : in  STD_LOGIC_VECTOR (1 downto 0); -- receive one pattern at a time
           equals : in  STD_LOGIC;										-- result from comparator
           btn0, btn1, btn2, btn3 : in  STD_LOGIC_VECTOR (1 downto 0); -- button inputs
           Random_Grab : out  STD_LOGIC;	-- enable signal to grab a value from random generator
           Increment_Level : out  STD_LOGIC; -- enable signal for level counter, 1 clk cycle
			  new_addition_to_pattern : out  STD_LOGIC_VECTOR (1 downto 0); -- gen'd pattern to pattern
			  get_next_pattern : out STD_LOGIC;	-- increment pattern to the next pattern in the series
           pattern_to_comparator : out  STD_LOGIC_VECTOR (1 downto 0); -- regfile pattern to comparator
           button_to_comparator : out  STD_LOGIC_VECTOR (1 downto 0); -- button pattern to comparator
           pattern_to_display : out  STD_LOGIC_VECTOR (1 downto 0); -- tell the display what to do
			  seg	: out STD_LOGIC_VECTOR(6 downto 0));	-- which segments to light up
end Controller;

architecture Behavioral of Controller is
type state_type is (	game_off, game_on, load_pattern, countdown, 
							get_next_pattern,send_pattern, receive_pattern, 
							win, champion, lose);
signal curr_state, next_state : state_type;

constant MAX_LEVEL : unsinged(5 downto 0) := 5;

signal countdown_value : unsigned(1 downto 0) := 2;
signal patterns_sent : unsigned(5 downto 0) := 0;
signal comparisons_made : unsigned(5 downto) := 0;
begin

SimonGame: process(curr_state, onoff, random_receive, btn0, btn1, btn2, btn3, 
							countdown_value, reg_pattern_receive, button_pressed)
begin

Random_Grab <= '0';
get_next_pattern <= '0';
seg <= "0000000";

case curr_state is
	when game_off =>
		if onoff = '1' then
			next_state <= game_on;
		end if;
		
	when game_on =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		Random_Grab <= '1';
		next_state <= load_pattern;
		
	when load_pattern =>
		new_addition_to_pattern <= random_receive;
		next_state <= countdown;
		
	when countdown =>
		-- flash lights
		countdown_value <= countdown_value - 1;
		if countdown_value < 0 then
			countdown_value <= 2;
			next_state <= get_next_pattern;
		end if;
		
	when get_next_pattern =>	
		get_next_pattern <= '1';
		next_state <= send_pattern;
		
	when send_pattern =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		if patterns_sent = level_counter then
			next_state <= receive_pattern;
		end if;			--does this if statement go before or after below shit? or maybe even in other state (get_next)
		pattern_to_display <= reg_pattern_receive;
		seg <= "1111111";
		patterns_sent <= patterns_sent + 1;
		next_state <= get_next_pattern;
		
	when receive_pattern => -- how to figure out which button is pressed?
		if onoff = '0' then
			next_state <= game_off;
		end if;
		-- wait for any button to be pressed then send that button to
		pattern_to_comparator <= reg_pattern_receive;
		--button_to_compatator <= btn idk
		--if we know somehow we have the button next_state <= compare_pattern;
		
	when compare_pattern =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		
		if equals = '1' and comparisons_made = level_counter then
			next_state <= win;
		elsif equals = '1' then
			next_state <= receive_pattern;
		else equal = '0' then
			next_state <= lose;
		end if;
		
	when win =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		if MAX_LEVEL = level_counter then
			next_state <= champion;
		else
			next_state <= game_on;
		end if;
	when champion =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		-- segs flash & call you chill bro & a fag
	when lose =>
		if onoff = '0' then
			next_state <= game_off;
		end if;
		-- segs flash & calls you a fag
	
end case;
end process SimonGame;

StateUpdate: process(clk)
begin
if rising_edge(clk) then
	curr_state <= next_state;
end if;
end process StateUpdate;

end Behavioral;

