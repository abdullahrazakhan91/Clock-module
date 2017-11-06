--abdullah raza Khan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 


entity global_fsm is
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
		
end global_fsm;

architecture Behavioral of global_fsm is


type mode is (Time_display_mode,date_display_mode,alarm_display_mode,alarm_setting_mode,stop_watch_mode);
signal current_state,next_state : mode;
signal date_back    : std_logic :='0';
signal date_mode_cnt : std_logic :='0';
signal counter: std_logic_vector (1 downto 0):="00";

begin

date_back<= counter(1);

data_back_counter: process (en_1_i,current_state)
	
	begin
	
	if current_state=date_display_mode then
		if rising_edge(en_1_i) then
                counter <= counter + "01";
		end if;		
	else 
		counter <="00";
		end if;

end process ;


more_fsm :process (clock_i)
	begin
		if clock_i ='1' and clock_i'event then
			if reset_i='1' then
				current_state<= time_display_mode;
			else
				current_state<= next_state;
			end if;
		end if ;
	end process;
	

mode_selection: process (current_state,mode_imp_i,act_imp_i,plus_minus_i,date_back ,enable_i,alarm_active_i,minus_imp_i,act_long_i,plus_imp_i,minus_imp_i)		
variable display_state_v: std_logic_vector (3 downto 0):="0001";
variable alarm_plus_on_v :std_logic:='0';
variable alarm_minus_on_v :std_logic:='0';
variable alarm_act_long_v :std_logic:='0';
variable alarm_act_imp_V :std_logic:='0';
variable sw_act_v :std_logic:='0';
variable sw_plus_v :std_logic:='0';
variable sw_minus_v :std_logic:='0';
	begin
	
		
		case current_state is 
				
			when time_display_mode =>
			
					if mode_imp_i ='1' then
						next_state <= date_display_mode;
					elsif minus_imp_i ='1' or plus_imp_i ='1' or plus_minus_i ='1' then
						next_state <= stop_watch_mode;
					else
						next_state <= current_state;
					end if;
				
								
					display_state_v := "0001";
			
       			alarm_plus_on_v  :='0';
					alarm_minus_on_v :='0';
					alarm_act_long_v :=act_long_i;
					alarm_act_imp_v  :='0';
					
					sw_act_v 		  :='0';
					sw_plus_v 		  :='0';
					sw_minus_v 		  :='0';
					sw_act_v			  :='0';
					
					
			when date_display_mode =>
			
					if mode_imp_i ='1' then
						next_state <= Alarm_display_mode;
					elsif date_back ='1' then
						next_state <= time_display_mode;
					else	
					   next_state <= current_state;
					end if;
				
				
					display_state_v  := "0010";
					
					alarm_plus_on_v  :='0';
					alarm_minus_on_v :='0';
					alarm_act_long_v :=act_long_i;
					alarm_act_imp_v  :='0';
					
					sw_act_v 		  :='0';
					sw_plus_v 		  :='0';
					sw_minus_v 		  :='0';
					
			when Alarm_display_mode =>
			
					if act_imp_i ='1' or act_long_i ='1' or minus_imp_i ='1' or plus_imp_i ='1' or plus_minus_i ='1' then
						next_state <= Alarm_setting_mode;
					elsif mode_imp_i ='1' then
						next_state <= time_display_mode;
					else	
					   next_state <= current_state;
					end if;
				
					display_state_v  := "0100";
					
					alarm_plus_on_v  :=plus_imp_i;
					alarm_minus_on_v :=minus_imp_i;
					alarm_act_long_v :=act_long_i;
					alarm_act_imp_v  :=act_imp_i;
					
					sw_act_v 		  :='0';
					sw_plus_v 		  :='0';
					sw_minus_v 		  :='0';
							
			when Alarm_setting_mode =>
			
					if mode_imp_i ='1' then
						next_state <= time_display_mode;
					else	
					   next_state <= current_state;
					end if;

					display_state_v  := "0100";
					
				
					alarm_act_long_v :=act_long_i;
					alarm_act_imp_v  :=act_imp_i;
					if  plus_minus_i = '1' THEN 
						alarm_plus_on_v := enable_i;
			         		alarm_minus_on_v  :='0';
	           		 elsif plus_minus_i ='0' THEN
						alarm_minus_on_v := enable_i;
						alarm_plus_on_v  :='0';
             	end if;
					
					sw_act_v 		  :='0';
					sw_plus_v 		  :='0';
					sw_minus_v 		  :='0';
							
			when stop_watch_mode =>
			
			
			if mode_imp_i ='1' then
						next_state <= time_display_mode;
					else	
					   next_state <= current_state;
					end if;
				
			
    				display_state_v  := "1000";
					
					alarm_plus_on_v  :='0';
					alarm_minus_on_v :='0';
					alarm_act_long_v :=act_long_i;
					alarm_act_imp_v  :='0';
					
					sw_act_v	    	  :=act_imp_i;
					sw_plus_v 		  :=plus_imp_i;
					sw_minus_v 		  :=minus_imp_i;
					
			end case;
			
			if  alarm_active_i='1' then
	           alarm_act_long_o  <=act_long_i;
				  alarm_act_imp_o   <=act_imp_i;
			     
				  sw_act_o	    	  <='0';
				  sw_plus_o 		  <=sw_plus_v;
				  sw_minus_o 		  <=sw_minus_v;
      	     display_state_o   <=display_state_v;

				  alarm_minus_on_o  <=alarm_minus_on_v;
				  alarm_plus_on_o   <=alarm_plus_on_v;
				  
				  
			else
				  alarm_act_long_o <=alarm_act_long_v;
				  alarm_act_imp_o  <=alarm_act_imp_v;
			     display_state_o <=display_state_v;

				  sw_act_o	    	  <=sw_act_v;
				  sw_plus_o 		  <=sw_plus_v;
				  sw_minus_o 		  <=sw_minus_v;
				  
				  alarm_minus_on_o <=alarm_minus_on_v;
				  alarm_plus_on_o  <=alarm_plus_on_v;
				  
			end if;

		end process;
	
end Behavioral;

