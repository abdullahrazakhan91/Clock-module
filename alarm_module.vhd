----------------------------------------------------------------------------------
-- Company:  Project Lab IC Design
-- Engineer: Haider Sultan
-- 
-- Create Date:    14:02:35 02/01/2017 
-- Design Name: 
-- Module Name:    alarm_module - Behavioral 
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

entity alarm_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en_1 : in  STD_LOGIC;
           en_100 : in  STD_LOGIC;
           td_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           td_min : in  STD_LOGIC_VECTOR (6 downto 0);
			  td_sec : in  STD_LOGIC_VECTOR (6 downto 0);
           alarm_plus : in  STD_LOGIC;
           alarm_minus : in  STD_LOGIC;
           alarm_act_imp : in  STD_LOGIC;
           alarm_act_long : in  STD_LOGIC;
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC;
           snooze_sig : out  STD_LOGIC;
           al_hour : out  STD_LOGIC_VECTOR (5 downto 0);
           al_min : out  STD_LOGIC_VECTOR (6 downto 0));
end alarm_module;

architecture Behavioral of alarm_module is

COMPONENT set_time
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         alarm_plus : IN  std_logic;
         alarm_minus : IN  std_logic;
         al_hour : OUT  std_logic_vector(5 downto 0);
         al_min : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;

	COMPONENT counter_secs
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         reset_count : IN  std_logic;
         en_1 : IN  std_logic;
         enable_count : IN  std_logic;
         time_1min : OUT  std_logic
        );
    END COMPONENT;

	COMPONENT clk_2Hz_converter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         en_100 : IN  std_logic;
         snooze_sig : IN  std_logic;
         clk_2Hz : OUT  std_logic
        );
    END COMPONENT;
	
	COMPONENT fsm_alarm
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         td_hour : IN  std_logic_vector(5 downto 0);
         td_min : IN  std_logic_vector(6 downto 0);
			td_sec : IN  std_logic_vector(6 downto 0);
         alarm_act_imp : IN  std_logic;
         alarm_act_long : IN  std_logic;
         time_1min : IN  std_logic;
         clk_2Hz : IN  std_logic;
         al_hour : IN  std_logic_vector(5 downto 0);
         al_min : IN  std_logic_vector(6 downto 0);
         reset_count : OUT  std_logic;
         enable_count : OUT  std_logic;
         led_alarm_ring : OUT  std_logic;
         led_alarm_act : OUT  std_logic;
         snooze_sig : OUT  std_logic
        );
    END COMPONENT;

	signal al_hour_bcd : std_logic_vector(5 downto 0);
   signal al_min_bcd : std_logic_vector(6 downto 0);
	signal reset_count : std_logic := '0';
   signal enable_count : std_logic := '0';
   signal time_1min : std_logic :='0';	
   signal snooze_sig_sig : std_logic := '0';
   signal clk_2Hz : std_logic :='0';
   signal led_alarm_ring_sig : std_logic := '0';
   signal led_alarm_act_sig : std_logic := '0';

begin

module1: set_time PORT MAP (
          clk => clk,
          reset => reset,
          alarm_plus => alarm_plus,
          alarm_minus => alarm_minus,
          al_hour => al_hour_bcd,
          al_min => al_min_bcd
        );

module2: counter_secs PORT MAP (
          clk => clk,
          reset => reset,
          reset_count => reset_count,
          en_1 => en_1,
          enable_count => enable_count,
          time_1min => time_1min
        );
		
module3: clk_2Hz_converter PORT MAP (
          clk => clk,
          reset => reset,
          en_100 => en_100,
          snooze_sig => snooze_sig_sig,
          clk_2Hz => clk_2Hz
        );

module4: fsm_alarm PORT MAP (
          clk => clk,
          reset => reset,
          td_hour => td_hour,
          td_min => td_min,
			 td_sec => td_sec,
          alarm_act_imp => alarm_act_imp,
          alarm_act_long => alarm_act_long,
          time_1min => time_1min,
          clk_2Hz => clk_2Hz,
          al_hour => al_hour_bcd,
          al_min => al_min_bcd,
          reset_count => reset_count,
          enable_count => enable_count,
          led_alarm_ring => led_alarm_ring_sig,
          led_alarm_act => led_alarm_act_sig,
          snooze_sig => snooze_sig_sig
        );

al_hour <= al_hour_bcd;
al_min <= al_min_bcd;
snooze_sig <= snooze_sig_sig;
led_alarm_act <= led_alarm_act_sig;
led_alarm_ring<= led_alarm_ring_sig;

end Behavioral;
