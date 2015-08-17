----------------------------------------------------------------------------------
-- Company: 	David Harmon & James Thompson
-- Engineer: 
-- 
-- Create Date:    11:36:02 08/13/2015 
-- Design Name: 
-- Module Name:    SimonGameCounters - Behavioral 
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

entity SimonGameCounters is
	port (
		clk		:	in 	std_logic;
		level_counter_en	: in	std_logic;
		grab_random_num	: in	std_logic;
		level_out			: out unsigned(5 downto 0);
		random_value		: out	unsigned(1 downto 0)
	);
end SimonGameCounters;

architecture Behavioral of SimonGameCounters is
signal random_loop : unsigned(1 downto 0);
signal curr_level	 : unsigned(5 downto 0);
begin

PseudoRandomGenerator: process(clk) 
begin
if rising_edge(clk) then
	random_loop <= random_loop + 1;
end if;
end process PseudoRandomGenerator;

GrabRandomNumber: process(grab_random_num)
begin
if grab_random_number = '1' then
	random_value <= random_loop;
else 
	random_value <= 0;
end if;
end process GrabRandomNumber;

IncrementLevel: process(level_counter_en)
begin
if level_counter_en = '1' then
	curr_level <= curr_level + 1;
end if;
end process IncrementLevel;

level_out <= curr_level;

end Behavioral;

