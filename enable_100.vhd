----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Syed Bukhari
-- 
-- Create Date:    20:19:25 01/13/2017 
-- Design Name: 
-- Module Name:    enable_100 - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity enable_100 is
    Port ( clk : in  STD_LOGIC;
           sw_pause : in  STD_LOGIC;
           sw_on : in  STD_LOGIC;
           enable : out  STD_LOGIC);
end enable_100;

architecture Behavioral of enable_100 is

signal counter : std_logic_vector (6 downto 0) := (others => '0');

begin

process (clk)
begin
	if (clk = '1' and clk'event) then
		enable <= '0';
		if (sw_on = '0') then
			counter <= "0000000";
			enable <= '0';
		else
			if (sw_pause = '1') then
				counter <= counter;
			else
				if (counter = "1100011") then
					counter <= "0000000";
					enable <= '1';
				else
					counter <= counter + "0000001";
				end if;
			end if;
		end if;
	end if;
end process;

end Behavioral;

