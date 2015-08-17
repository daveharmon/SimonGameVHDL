----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:27 08/13/2015 
-- Design Name: 
-- Module Name:    SimonGame - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SimonGame is
	port (
			clk							: 	in	std_logic;
			onoff							: 	in	std_logic;
			btn0, btn1, btn2, btn3	:	in	std_logic);
end SimonGame;

architecture Behavioral of SimonGame is

	-- Component declarations
	COMPONENT Controller
	PORT(
			clk   : in STD_LOGIC;
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
	END COMPONENT;
	
	COMPONENT PatternComparator
	PORT(
			pattern_from_reg : in  unsigned (1 downto 0);
         pattern_from_button : in  unsigned (1 downto 0);
         equal : out  STD_LOGIC  );
	END COMPONENT;
	
	COMPONENT RegFile
	PORT(
			clk					: in 	std_logic;
			w_en, r_en, clr	: in	std_logic;
			w_data				: in 	std_logic_vector(1 downto 0);
			eq						: out std_logic;
			r_data				: out std_logic_vector(1 downto 0) );
	END COMPONENT;
	
	COMPONENT SimonGameCoutners
	PORT(
			clk		:	in 	std_logic;
			level_counter_en	: in	std_logic;
			grab_random_num	: in	std_logic;
			level_out			: out unsigned(5 downto 0);
			random_value		: out	unsigned(1 downto 0) );
	END COMPONENT;
	
	COMPONENT debouncer
	PORT(
			clk, switch			: in STD_LOGIC;
			dbswitch				: out std_logic );
	END COMPONENT;
	
	COMPONENT mux7seg
	PORT(
			clk : in  STD_LOGIC;											-- runs on a slow (100 Hz or so) clock
			y0, y1, y2, y3 : in  STD_LOGIC_VECTOR (3 downto 0);	-- digits
         seg : out  STD_LOGIC_VECTOR(0 to 6);						-- segments (a...g)
         an : out  STD_LOGIC_VECTOR (3 downto 0) );				-- anodes
	END COMPONENT;
begin

Control: Controller
		Port Map (
			clk => clk	,		-- 100 MHz clk from nexsys 2 board
			onoff => onoff	,	-- on & off switch
         random_receive	=> open,
         level_counter	=> open,
         reg_pattern_receive => open,
         equals	=> open,
         btn0 => btn0,
			btn1 => btn1,
			btn2 => btn2,
			btn3 => btn3,
         Random_Grab => open,
         Increment_Level => open,
			new_addition_to_pattern => open,
			get_next_pattern => open,
         pattern_to_comparator => open,
         button_to_comparator => open,
         pattern_to_display => open,
			seg => open 
		);
		
BlockRegFile: RegFile
		Port Map (
			clk => clk		,
			w_en => open	,
			r_en => open	,
			w_data => open	,
			eq	=> open		,
			r_data => open	);
			
PatternComparator: PatternComparator
		Port Map (
			pattern_from_reg => open ,
         pattern_from_button => open ,
         equal => open );
			
Counters: SimonGameCounters
		Port Map (
			clk	=> clk,
			level_counter_en => open,
			grab_random_num => open,
			level_out	=> open,
			random_value => open	);

display: mux7seg
		Port Map ( clk => clk ,			-- runs off the 1000 Hz clock
			y3 => "0000",
			y2 =>	"0000",
         y1 => rx_data(7 downto 4), 		
         y0 => rx_data(3 downto 0),	-- least significant digit
         seg => segments,
        	an => anodes );
				
debouncer: debouncer
		Port Map (
			clk	=> clk	,
			switch => open	,
			dbswitch => open );

end Behavioral;

