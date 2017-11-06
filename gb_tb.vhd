--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:58:16 01/22/2017
-- Design Name:   
-- Module Name:   E:/Workspace/others work/Ic_Design_Lab/asd/gb_tb.vhd
-- Project Name:  asd
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: global_fsm
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY gb_tb IS
END gb_tb;
 
ARCHITECTURE behavior OF gb_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT global_fsm
    PORT(
         alarm_active_i : IN  std_logic;
         mode_imp_i : IN  std_logic;
         minus_imp_i : IN  std_logic;
         act_imp_i : IN  std_logic;
         act_long_i : IN  std_logic;
         plus_imp_i : IN  std_logic;
         plus_minus_i : IN  std_logic;
         enable_i : IN  std_logic;
         display_state_o : OUT  std_logic_vector(3 downto 0);
         alarm_plus_on_o : OUT  std_logic;
         alarm_minus_on_o : OUT  std_logic;
         alarm_act_long_o : OUT  std_logic;
         alarm_act_imp_o : OUT  std_logic;
         sw_act_o : OUT  std_logic;
         sw_plus_o : OUT  std_logic;
         sw_minus_o : OUT  std_logic;
         clock_i : IN  std_logic;
         reset_i : IN  std_logic;
			en_1_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal alarm_active_i : std_logic := '0';
   signal mode_imp_i : std_logic := '0';
   signal minus_imp_i : std_logic := '0';
   signal act_imp_i : std_logic := '0';
   signal act_long_i : std_logic := '0';
   signal plus_imp_i : std_logic := '0';
   signal plus_minus_i : std_logic := '0';
   signal enable_i : std_logic := '0';
   signal clock_i : std_logic := '0';
   signal reset_i,en_1_i : std_logic := '0';

 	--Outputs
   signal display_state_o : std_logic_vector(3 downto 0):="0000";
   signal alarm_plus_on_o : std_logic:='0';
   signal alarm_minus_on_o : std_logic:='0';
   signal alarm_act_long_o : std_logic:='0';
   signal alarm_act_imp_o : std_logic:='0';
   signal sw_act_o : std_logic:='0';
   signal sw_plus_o : std_logic:='0';
   signal sw_minus_o : std_logic:='0';

   -- Clock period definitions
   constant clock_i_period : time := 100 us;
   signal enable_1,enable_8,enable_2 : std_logic:='0'; 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: global_fsm PORT MAP (
          alarm_active_i => alarm_active_i,
          mode_imp_i => mode_imp_i,
          minus_imp_i => minus_imp_i,
          act_imp_i => act_imp_i,
          act_long_i => act_long_i,
          plus_imp_i => plus_imp_i,
          plus_minus_i => plus_minus_i,
          enable_i => enable_i,
          display_state_o => display_state_o,
          alarm_plus_on_o => alarm_plus_on_o,
          alarm_minus_on_o => alarm_minus_on_o,
          alarm_act_long_o => alarm_act_long_o,
          alarm_act_imp_o => alarm_act_imp_o,
          sw_act_o => sw_act_o,
          sw_plus_o => sw_plus_o,
          sw_minus_o => sw_minus_o,
          clock_i => clock_i,
          reset_i => reset_i,
			 en_1_i => en_1_i
        );

   -- Clock process definitions
   clock_i_process :process
   begin
		clock_i <= '0';
		wait for clock_i_period/2;
		clock_i <= '1';
		wait for clock_i_period/2;
   end process;
	

  enab_8_process : process 
	begin
		enable_i <= '1';
		wait for 100 us;
		enable_i <= '0';
		wait for 900 us;
end process;




   -- Stimulus process
   stim_proc: process
   begin		
   
   -- hold reset state for 100 ns.
   reset_i <= '1';
	wait for 100 us ;
	reset_i <= '0';
   wait for 50 us ;
	
	--date mode 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
   wait for 200 us ;
	
	-- date mode to alarm mode
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
   wait for 200 us ;

	-- alarm mode to time mode
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
   wait for 200 us ;

	-- time mode to SW mode 
	
	minus_imp_i <= '1';
	wait for 100 us ;
	minus_imp_i <= '0';
	wait for  200 us;


	-- sw mode to time mode 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
	wait for 200 us;

	-- time mode to date mode 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
	
	wait for 300 us ;
	
	-- date mode to alarm mode
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
	wait for 300 us ;

   -- alarm mode to setting mode
	act_imp_i <='1';
	wait for 100 us ;
	act_imp_i <='0';
	
	act_long_i <='1';
	wait for 100 us ;
	act_long_i <='0';
	
	wait for 100 us ;
	plus_minus_i <= '1';
	
	wait for 1100 us;
	plus_minus_i <= '0';
	minus_imp_i <= '1';

	wait for 100 us;
	minus_imp_i <= '0';
	
	wait for 300 us;

	-- setting mode to time mode 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';


	wait for 200 us;

	
	-- time mode to SW mode 
	
	minus_imp_i <= '1';
	wait for 100 us ;
	minus_imp_i <= '0';
	wait for  300 us;


	-- sw mode to time mode 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
	wait for 100 us;
	

	
   -- alarm checker?
	alarm_active_i<='1';
	wait for 100 us;	
	act_imp_i <='1';
	wait for 100 us ;
	act_imp_i <='0';
	
	act_long_i <='1';
	wait for 100 us ;
	act_long_i <='0';
   wait for 100 us ;
	alarm_active_i<='0';

		-- time mode to date mode back to time mode. 
	mode_imp_i <= '1';
	wait for 100 us ;
	mode_imp_i <= '0';
	wait for 200 us;
	
	en_1_i <= '1';
	wait for 100 us ;
	en_1_i <= '0';
	
	wait for 100 us;
	en_1_i <= '1';
	wait for 100 us ;
	en_1_i <= '0';
	
	wait for 100 us;
	en_1_i <= '1';
	wait for 100 us ;
	en_1_i <= '0';
	
	wait for 200 us;
			
      -- insert stimulus here 

      wait;
   end process;

END;
