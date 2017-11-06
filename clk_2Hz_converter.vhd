----------------------------------------------------------------------------------
-- Company:  Project Lab IC Design
-- Engineer: Haider Sultan
-- 
-- Create Date:    14:01:09 02/01/2017 
-- Design Name: 
-- Module Name:    clk_2Hz_converter - Behavioral 
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

entity clk_2Hz_converter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en_100 : in  STD_LOGIC;
           snooze_sig : in  STD_LOGIC;
           clk_2Hz : out  STD_LOGIC);
end clk_2Hz_converter;

architecture Behavioral of clk_2Hz_converter is

signal clk_2Hz_sig : STD_LOGIC := '0';
signal count : integer := 0;

begin

process(clk)

begin
if clk'EVENT and clk = '1' then

	if reset = '1' then
		clk_2Hz_sig <= '0';
		count <= 0;
	elsif snooze_sig = '1' then
			
			if en_100 = '1' then
				count <= count + 1;
			end if;
			
			if count > 49 and en_100 = '1' then
					count <= 0;
			end if;
			
			if count < 25 then
				clk_2Hz_sig <= '1';
			else
				clk_2Hz_sig <= '0';
			end if;
	else
		clk_2Hz_sig <= '0';
		count <= 0;
	end if; -- reset

end if; -- EVENT'clk
end process; --clk

clk_2Hz <= clk_2Hz_sig;

end Behavioral;

