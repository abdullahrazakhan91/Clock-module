----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Syed Bukhari
-- 
-- Create Date:    13:10:27 01/22/2016 
-- Design Name: 
-- Module Name:    count_second - Behavioral 
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


entity count_second is

Port(clk: IN std_logic;
         sw_on: IN std_logic;
			carry_in: IN std_logic;
         carry_out: OUT std_logic;
         units_digits: OUT std_logic_vector(3 downto 0);
			tens_digits: OUT std_logic_vector(3 downto 0));
			
end count_second;

architecture Behavioral of count_second is
signal units_digits_reg, tens_digits_reg : std_logic_vector (3 downto 0) := (others => '0');
begin

process (clk)

begin
	if (clk = '1' and clk'event) then
		carry_out <= '0';
		if (sw_on = '0') then
			units_digits_reg <= X"0";
			units_digits <= X"0";
			tens_digits_reg <= X"0";
			tens_digits <= X"0";
			carry_out <= '0';
		else
			if (carry_in = '1') then
				if (units_digits_reg = X"9") then
						units_digits_reg <= X"0";
						units_digits <= X"0";
					if (tens_digits_reg = X"5") then
						tens_digits_reg <= X"0";
						tens_digits <= X"0";
						carry_out <= '1';
					else
						tens_digits_reg <= tens_digits_reg + X"1";
						tens_digits <= tens_digits_reg + X"1";
					end if;
				else
					units_digits_reg <= units_digits_reg + X"1";
					units_digits <= units_digits_reg + X"1";
				end if;
			else
				units_digits_reg <= units_digits_reg;
				units_digits <= units_digits_reg;
				tens_digits_reg <= tens_digits_reg;
				tens_digits <= tens_digits_reg;
			end if;
		end if;
	end if;
end process;


end Behavioral;

