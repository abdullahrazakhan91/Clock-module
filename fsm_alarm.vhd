----------------------------------------------------------------------------------
-- Company:  Project Lab IC Design
-- Engineer: Haider Sultan
-- 
-- Create Date:    14:01:44 02/01/2017 
-- Design Name: 
-- Module Name:    fsm_alarm - Behavioral 
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

entity fsm_alarm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           td_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           td_min : in  STD_LOGIC_VECTOR (6 downto 0);
			  td_sec : in  STD_LOGIC_VECTOR (6 downto 0);
           alarm_act_imp : in  STD_LOGIC;
           alarm_act_long : in  STD_LOGIC;
			  time_1min : in STD_LOGIC;
			  clk_2Hz : in STD_LOGIC;
			  al_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           al_min : in  STD_LOGIC_VECTOR (6 downto 0);
			  reset_count : out STD_LOGIC;
			  enable_count : out STD_LOGIC;			  
           led_alarm_ring : out  STD_LOGIC;
           led_alarm_act : out  STD_LOGIC;
			  snooze_sig: out STD_LOGIC);
end fsm_alarm;

architecture Behavioral of fsm_alarm is 

TYPE state IS (alarm_inactive, alarm_active, alarm_ring, alarm_snooze);

SIGNAL current_state, next_state : state;

begin

p1: process(current_state, td_hour, td_min, alarm_act_imp, alarm_act_long, time_1min, clk_2Hz, al_hour, al_min)
begin

	case current_state is
	
	when alarm_inactive =>
		if alarm_act_imp = '1' then
			next_state <= alarm_active;
		else
			next_state <= alarm_inactive;
		end if;
		
		reset_count <= '1';
		enable_count <= '0';
		led_alarm_ring <= '0';
		led_alarm_act 	<= '0';
		snooze_sig <= '0';
		
	when alarm_active =>
		if alarm_act_imp = '1' then
			next_state <= alarm_inactive;
		elsif (al_hour = td_hour) and (al_min = td_min) and (td_sec = "0000000") then
			next_state <= alarm_ring;
		else
			next_state <= alarm_active;
		end if;

		reset_count <= '1';
		enable_count <= '0';
		led_alarm_ring <= '0';
		led_alarm_act	<= '1';
		snooze_sig <= '0';
		
	when alarm_ring =>
		if time_1min = '1' then
			reset_count <= '1';
			enable_count <= '0';
		else
			reset_count <= '0';
			enable_count <= '1';
		end if;
		
		if alarm_act_imp = '1' then
			reset_count <= '1';
			next_state <= alarm_snooze;
		elsif (alarm_act_long = '1')  or (time_1min = '1') then
			next_state <= alarm_active;
		else
			next_state <= alarm_ring;
		end if;
		led_alarm_ring <= '1';
		led_alarm_act 	<= '1';
		snooze_sig <= '0';
		
	when alarm_snooze =>
		if time_1min = '1' then
			reset_count <= '1';
			enable_count <= '0';
		else
			reset_count <= '0';
			enable_count <= '1';
		end if;
		
		if alarm_act_long = '1' then
			next_state <= alarm_active;
		elsif time_1min = '1' then
			next_state <= alarm_ring;
		else
			next_state <= alarm_snooze;
		end if;
		
		led_alarm_ring <= clk_2Hz;
		led_alarm_act <= '1';
		snooze_sig <= '1';
		
	end case;
end process; --p1



p2: process(clk)
begin
	if clk'EVENT AND clk='1' then
		if reset = '1' then
			current_state <= alarm_inactive;
		else
			current_state <= next_state;
		end if;
	end if; -- clk
end process; -- p2

end Behavioral;

