library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity clock_module is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           en_1K : in  std_logic;
           en_100 : in  std_logic;
           en_10 : in  std_logic;
           en_1 : in  std_logic;
			  
           key_action_imp : in  std_logic;
           key_action_long : in std_logic;
           key_mode_imp : in  std_logic;
           key_minus_imp : in  std_logic;
           key_plus_imp : in  std_logic;
           key_plus_minus : in  std_logic;
           key_enable : in  std_logic;
			  
           de_set : in  std_logic;
           de_dow : in  std_logic_vector (2 downto 0);
           de_day : in  std_logic_vector (5 downto 0);
           de_month : in  std_logic_vector (4 downto 0);
           de_year : in  std_logic_vector (7 downto 0);
           de_hour : in  std_logic_vector (5 downto 0);
           de_min : in  std_logic_vector (6 downto 0);
			  
           led_alarm_act : out  std_logic;
           led_alarm_ring : out  std_logic;
           led_countdown_act : out  std_logic;
           led_countdown_ring : out  std_logic;
           led_switch_act : out  std_logic;
           led_switch_on : out  std_logic;
			  
           lcd_en : out std_logic;
           lcd_rw : out std_logic;
           lcd_rs : out std_logic;
           lcd_data : out std_logic_vector(7 downto 0)
           );
end clock_module;

architecture Behavioral of clock_module is
	
	
	
	component global_fsm
	port (alarm_active_i : in std_logic;
		mode_imp_i     : in std_logic;
		minus_imp_i		: in std_logic;
		act_imp_i		: in std_logic;
		act_long_i		: in std_logic;
		plus_imp_i		: in std_logic;
		plus_minus_i	: in std_logic;
		enable_i			: in std_logic;
		display_state_o  :  out std_logic_vector(3 downto 0);
		alarm_plus_on_o  :  out std_logic;
		alarm_minus_on_o : out std_logic;
		alarm_act_long_o : out std_logic;
		alarm_act_imp_o  : out std_logic;
		sw_act_o 		  : out std_logic;
		sw_plus_o 		  : out std_logic;
		sw_minus_o 		  : out std_logic;
		clock_i  		  : in  std_logic;
		reset_i			  : in std_logic ;
		en_1_i  : in std_logic 
		);
	end component;

	component displaycontroller
		Port (   reset : in  STD_LOGIC;
					clk : in  STD_LOGIC;
					display_state  :  in std_logic_vector(3 downto 0);
					td_sec 	: in std_logic_vector(6 downto 0);
					td_min	: in std_logic_vector(6 downto 0);
					td_hour	: in std_logic_vector(5 downto 0);
					td_dow	: in std_logic_vector(2 downto 0);
					td_day  : in std_logic_vector(5 downto 0);
					td_month: in std_logic_vector(4 downto 0);
					td_year	: in std_logic_vector(7 downto 0);
					dcf_sync : in  STD_LOGIC;
					alarm_enabled : in  STD_LOGIC;
					alarm_snooze : in STD_LOGIC;
					alarm_hour: in std_logic_vector (5 downto 0);
					alarm_min : in std_logic_vector (6 downto 0);
					sw_hour1: in std_logic_vector(3 downto 0);
					sw_hour2: in std_logic_vector(3 downto 0);
					sw_min1: in std_logic_vector(3 downto 0);
					sw_min2: in std_logic_vector(3 downto 0);
					sw_sec1: in std_logic_vector(3 downto 0);
					sw_sec2: in std_logic_vector(3 downto 0);
					sw_ms1: in std_logic_vector(3 downto 0);
					sw_ms2: in std_logic_vector(3 downto 0);
					lap : in  STD_LOGIC;
					d_en: out std_logic;
					d_rw: out std_logic;
					d_rs: out std_logic;
					d_out: out std_logic_vector(7 downto 0)
              );
	 end component; 
	 
--	 
	 component time_date
		port(	clk_10k : in std_logic;
				reset	: in std_logic;
				en_1	:	in std_logic;
				de_set 	: in std_logic;
				de_min  : in std_logic_vector(6 downto 0);
				de_hour : in std_logic_vector(5 downto 0);
				de_dow  : in std_logic_vector(2 downto 0);
				de_day  : in std_logic_vector(5 downto 0);
				de_month: in std_logic_vector(4 downto 0);
				de_year : in std_logic_vector(7 downto 0);
		

				td_sec 	: out std_logic_vector(6 downto 0);
				td_min	: out std_logic_vector(6 downto 0);
				td_hour	: out std_logic_vector(5 downto 0);
				td_dow	: out std_logic_vector(2 downto 0);
				td_day  : out std_logic_vector(5 downto 0);
				td_month: out std_logic_vector(4 downto 0);
				td_year	: out std_logic_vector(7 downto 0);

				dcf_valid : out std_logic);
	 end component;
--	 
--	 
	 component alarm_module
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
			  
	end component;
--	
	component StopWatch_Module
    Port (  clk: in STD_LOGIC;
           reset: in STD_LOGIC;
			  plus: in STD_LOGIC;
			  minus: in STD_LOGIC;
			  action: in STD_LOGIC;
			  lap_disp : out STD_LOGIC;
           msec_units, msec_tens: out STD_LOGIC_VECTOR (3 downto 0);
			  sec_units, sec_tens : out STD_LOGIC_VECTOR (3 downto 0);
			  min_units, min_tens: out STD_LOGIC_VECTOR (3 downto 0);
			  hour_units, hour_tens: out STD_LOGIC_VECTOR (3 downto 0));
			end component;
--fsm-io-signal
signal sx_display_fsm_o   : std_logic_vector(3 downto 0);
signal sx_alarm_plus_on_o : std_logic;
signal sx_sw_act_o : std_logic;
signal sx_alarm_minus_on_o : std_logic;
signal sx_alarm_act_long_o : std_logic;
signal sx_alarm_act_imp_o : std_logic;
signal sx_sw_plus_o : std_logic;
signal sx_sw_minus_o : std_logic;
--alarm-io_signals
signal sx_snooze : std_logic;
signal sx_led_alarm_act,sx_led_alarm_ring :std_logic;
signal sx_alarm_hour : STD_LOGIC_VECTOR (5 downto 0);
signal sx_alarm_min  : STD_LOGIC_VECTOR (6 downto 0);
-- time and date signals  
signal sx_dcf_valid :std_logic;
signal sx_td_sec :std_logic_vector(6 downto 0);
signal sx_td_min :std_logic_vector(6 downto 0);
signal sx_td_hour :std_logic_vector(5 downto 0);
signal sx_td_dow :std_logic_vector(2 downto 0);
signal sx_td_day :std_logic_vector(5 downto 0);
signal sx_td_month :std_logic_vector(4 downto 0);
signal sx_td_year :std_logic_vector(7 downto 0);

--- stop_watch signal
signal					sx_sw_hour1 :  std_logic_vector(3 downto 0);
signal					sx_sw_hour2 :  std_logic_vector(3 downto 0);
signal					sx_sw_min1  :  std_logic_vector(3 downto 0);
signal					sx_sw_min2  :  std_logic_vector(3 downto 0);
signal					sx_sw_sec1  :  std_logic_vector(3 downto 0);
signal					sx_sw_sec2  :  std_logic_vector(3 downto 0);
signal					sx_sw_ms1   :  std_logic_vector(3 downto 0);
signal					sx_sw_ms2   :  std_logic_vector(3 downto 0);
signal 					sx_lap,sx_led_switch_act,sx_led_switch_on :std_logic;

--display_signals
signal 					sx_d_en :  std_logic;
signal 					sx_d_rw:  std_logic;
signal 					sx_d_rs:  std_logic;
signal 					sx_d_out:  std_logic_vector(7 downto 0);

	
begin



time_and_date_module : time_date port map (	
				clk_10k => clk,
				reset	=> reset,
				en_1	=>	en_1,
				de_set 	=> de_set,
				de_min  => de_min,
				de_hour => de_hour,
				de_dow  => de_dow,
				de_day  => de_day,
				de_month=> de_month,
				de_year => de_year,
		

				td_sec 	=> sx_td_sec,
				td_min	=> sx_td_min,
				td_hour	=> sx_td_hour,
				td_dow	=> sx_td_dow,
				td_day  => sx_td_day,
				td_month=> sx_td_month,
				td_year	=> sx_td_year,

				dcf_valid => sx_dcf_valid);
--
--
--
globalfsm_module : global_fsm port map(
							alarm_active_i   => sx_led_alarm_ring,
							mode_imp_i       => key_mode_imp,
							minus_imp_i		  => key_minus_imp,
							act_imp_i		  => key_action_imp,
							act_long_i		  => key_action_long ,
							plus_imp_i		  => key_plus_imp,
							plus_minus_i	  => key_plus_minus,
							enable_i			  => key_enable,
							display_state_o  => sx_display_fsm_o,
							alarm_plus_on_o  => sx_alarm_plus_on_o,
							alarm_minus_on_o => sx_alarm_minus_on_o,
							alarm_act_long_o => sx_alarm_act_long_o,
							alarm_act_imp_o  => sx_alarm_act_imp_o,
							
							sw_act_o 		  => sx_sw_act_o,
							sw_plus_o 		  => sx_sw_plus_o,
							sw_minus_o 		  => sx_sw_minus_o,
							
							clock_i  		  => clk,
							reset_i			  => reset ,
							en_1_i  			  => en_1 
							);
display_module	:		displaycontroller Port map (
							
							  reset => reset,
					clk => clk,
					display_state  =>  sx_display_fsm_o,
					td_sec 	=> sx_td_sec,
					td_min	=> sx_td_min,
					td_hour	=> sx_td_hour,
					td_dow	=> sx_td_dow,
					td_day  => sx_td_day,
					td_month=> sx_td_month,
					td_year	=> sx_td_year,
					dcf_sync => sx_dcf_valid,
					alarm_enabled => sx_led_alarm_act,
					alarm_snooze => sx_snooze,
					alarm_hour=> sx_alarm_hour,
					alarm_min => sx_alarm_min,
					sw_hour1=> sx_sw_hour1,
					sw_hour2=> sx_sw_hour2,
					sw_min1=> sx_sw_min1,
					sw_min2=> sx_sw_min2,
					sw_sec1=> sx_sw_sec1,
					sw_sec2=> sx_sw_sec2,
					sw_ms1=> sx_sw_ms1,
					sw_ms2=> sx_sw_ms2,
					lap => sx_lap,
					d_en=> lcd_en,
					d_rw=> lcd_rw,
					d_rs=> lcd_rs,
					d_out=> lcd_data
                     );
--							
	
StopWatch : StopWatch_Module 
	PORT MAP(
	  clk => clk,
	  reset => reset,
	  plus => sx_sw_plus_o,
	  minus => sx_sw_minus_o,
	  action => sx_sw_act_o,
	  lap_disp => sx_lap,
	  msec_units => sx_sw_ms2,
	  msec_tens => sx_sw_ms1,
	  sec_units => sx_sw_sec2,
	  sec_tens => sx_sw_sec1,
	  min_units => sx_sw_min2,
	  min_tens => sx_sw_min1,
	  hour_units => sx_sw_hour2,
	  hour_tens => sx_sw_hour1
	);


--	
alarm :		alarm_module
	 Port map (
			     clk            => clk,
           reset             => reset,
           en_1              => en_1,
           en_100            => en_100,
           td_hour           => sx_td_hour,
           td_min            => sx_td_min,
			  td_sec   		     => sx_td_sec,
           alarm_plus 		  => sx_alarm_plus_on_o,
           alarm_minus		  => sx_alarm_minus_on_o,
           alarm_act_imp     => sx_alarm_act_imp_o,
           alarm_act_long    => sx_alarm_act_long_o,
           led_alarm_act     => sx_led_alarm_act,
           led_alarm_ring    => sx_led_alarm_ring,
           snooze_sig        => sx_snooze,
           al_hour           => sx_alarm_hour,
           al_min            => sx_alarm_min);
			  
			  led_alarm_act <= sx_led_alarm_act;
           led_alarm_ring <= sx_led_alarm_ring;
--			  
--			  
--           led_countdown_act <= '0';
--           led_countdown_ring <= '0';
--           led_switch_act <= '0';
--           led_switch_on <= '0';
			  
end Behavioral;

