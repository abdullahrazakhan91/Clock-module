----------------------------------------------------------------------------------
-- Company:  Project Lab IC Design
-- Engineer: Haider Sultan
-- 
-- Create Date:    14:00:21 02/01/2017 
-- Design Name: 
-- Module Name:    counter_secs - Behavioral 
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

entity counter_secs is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           reset_count : in  STD_LOGIC;
           en_1 : in  STD_LOGIC;
           enable_count : in  STD_LOGIC;
           time_1min : out  STD_LOGIC);
end counter_secs;

architecture Behavioral of counter_secs is

signal time_1min_sig : STD_LOGIC := '0';
signal count : integer := 0;

begin
process(clk)

begin
if clk'EVENT and clk = '1' then

	if reset = '1' or reset_count = '1' then
		count <= 0;
		time_1min_sig <= '0';
	else
	
		if enable_count = '1' and en_1= '1' then
				count <= count + 1;
		end if;
		if count > 59 then
			time_1min_sig <= '1';
			--count <= 0;
		else 
			time_1min_sig <= '0';
		end if; --reset
	end if;
	
end if; -- if EVENT'clk
end process; -- process(clk)

time_1min <= time_1min_sig;

end Behavioral;
