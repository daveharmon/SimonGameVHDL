----------------------------------------------------------------------------------
-- Company: 	David Harmon & James Thompson
-- Engineer: 
-- 
-- Create Date:    12:00:25 08/13/2015 
-- Design Name: 
-- Module Name:    PatternComparator - Behavioral 
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

entity PatternComparator is
    Port ( pattern_from_reg : in  unsigned (1 downto 0);
           pattern_from_button : in  unsigned (1 downto 0);
           equal : out  STD_LOGIC);
end PatternComparator;

architecture Behavioral of PatternComparator is

begin

ComparePatterns: process(pattern_from_reg, pattern_from_button)
begin
	if pattern_from_reg = pattern_from_button then
		equal <= '1';	-- win
	else 
		equal <= '0';	-- lose
	end if;
end process ComparePatterns;


end Behavioral;

