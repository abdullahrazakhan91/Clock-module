library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity displaycontroller is
    Port ( reset : in  STD_LOGIC;
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
end displaycontroller;
                                        
ARCHITECTURE display_arch OF displaycontroller IS


--Definitions:


    --Letter Constants

    CONSTANT A :std_logic_vector (7 downto 0) := X"41";
    CONSTANT B :std_logic_vector (7 downto 0) := X"42";
    CONSTANT C :std_logic_vector (7 downto 0) := X"43";
    CONSTANT D :std_logic_vector (7 downto 0) := X"44";
    CONSTANT E :std_logic_vector (7 downto 0) := X"45";
    CONSTANT F :std_logic_vector (7 downto 0) := X"46";
    CONSTANT G :std_logic_vector (7 downto 0) := X"47";
    CONSTANT H :std_logic_vector (7 downto 0) := X"48";
    CONSTANT I :std_logic_vector (7 downto 0) := X"49";
    CONSTANT J :std_logic_vector (7 downto 0) := X"4A";
    CONSTANT K :std_logic_vector (7 downto 0) := X"4B";
    CONSTANT L :std_logic_vector (7 downto 0) := X"4C";
    CONSTANT M :std_logic_vector (7 downto 0) := X"4D";
    CONSTANT N :std_logic_vector (7 downto 0) := X"4E";
    CONSTANT O :std_logic_vector (7 downto 0) := X"4F";
    CONSTANT P :std_logic_vector (7 downto 0) := X"50";
    CONSTANT Q :std_logic_vector (7 downto 0) := X"51";
    CONSTANT R :std_logic_vector (7 downto 0) := X"52";
    CONSTANT S :std_logic_vector (7 downto 0) := X"53";
    CONSTANT T :std_logic_vector (7 downto 0) := X"54";
    CONSTANT U :std_logic_vector (7 downto 0) := X"55";
    CONSTANT V :std_logic_vector (7 downto 0) := X"56";
    CONSTANT W :std_logic_vector (7 downto 0) := X"57";
    CONSTANT X :std_logic_vector (7 downto 0) := X"58";
    CONSTANT Y :std_logic_vector (7 downto 0) := X"59";
    CONSTANT Z :std_logic_vector (7 downto 0) := X"5A";

    CONSTANT a_k :std_logic_vector (7 downto 0) := X"61";
    CONSTANT b_k :std_logic_vector (7 downto 0) := X"62";
    CONSTANT c_k :std_logic_vector (7 downto 0) := X"63";
    CONSTANT d_k :std_logic_vector (7 downto 0) := X"64";
    CONSTANT e_k :std_logic_vector (7 downto 0) := X"65";
    CONSTANT f_k :std_logic_vector (7 downto 0) := X"66";
    CONSTANT g_k :std_logic_vector (7 downto 0) := X"67";
    CONSTANT h_k :std_logic_vector (7 downto 0) := X"68";
    CONSTANT i_k :std_logic_vector (7 downto 0) := X"69";
    CONSTANT j_k :std_logic_vector (7 downto 0) := X"6A";
    CONSTANT k_k :std_logic_vector (7 downto 0) := X"6B";
    CONSTANT l_k :std_logic_vector (7 downto 0) := X"6C";
    CONSTANT m_k :std_logic_vector (7 downto 0) := X"6D";
    CONSTANT n_k :std_logic_vector (7 downto 0) := X"6E";
    CONSTANT o_k :std_logic_vector (7 downto 0) := X"6F";
    CONSTANT p_k :std_logic_vector (7 downto 0) := X"70";
    CONSTANT q_k :std_logic_vector (7 downto 0) := X"71";
    CONSTANT r_k :std_logic_vector (7 downto 0) := X"72";
    CONSTANT s_k :std_logic_vector (7 downto 0) := X"73";
    CONSTANT t_k :std_logic_vector (7 downto 0) := X"74";
    CONSTANT u_k :std_logic_vector (7 downto 0) := X"75";
    CONSTANT v_k :std_logic_vector (7 downto 0) := X"76";
    CONSTANT w_k :std_logic_vector (7 downto 0) := X"77";
    CONSTANT x_k :std_logic_vector (7 downto 0) := X"78";
    CONSTANT y_k :std_logic_vector (7 downto 0) := X"79";
    CONSTANT z_k :std_logic_vector (7 downto 0) := X"7A";
    

    CONSTANT star :std_logic_vector (7 downto 0) := X"2A";
    CONSTANT point :std_logic_vector (7 downto 0) := X"2E";
    CONSTANT slash :std_logic_vector (7 downto 0) := X"2F";
    CONSTANT doublepoint :std_logic_vector (7 downto 0) := X"3A";
    CONSTANT blank :std_logic_vector (7 downto 0) := X"20";
    CONSTANT bcdascii :std_logic_vector (3 downto 0) := X"3";
    

    SIGNAL state : integer range 0 to 31 := 0;
    SIGNAL count : integer range 0 to 31 := 0;
    SIGNAL d_en_enable : std_logic := '1';
    SIGNAL weekdayascii: std_logic_vector(23 downto 0);

--Start

BEGIN

d_en <= clk AND d_en_enable;                        --Double speed
d_rw <= '0';													-- Always write on Display

--convert weekday
week: PROCESS(td_dow,clk)
BEGIN
	CASE td_dow IS
		WHEN "001" => weekdayascii <= M & o_k & n_k;
		WHEN "010" => weekdayascii <= T & u_k & e_k;
		WHEN "011" => weekdayascii <= W & e_k & d_k;
		WHEN "100" => weekdayascii <= T & h_k & u_k;
		WHEN "101" => weekdayascii <= F & r_k & i_k;
		WHEN "110" => weekdayascii <= S & a_k & t_k;
		WHEN "111" => weekdayascii <= S & u_k & n_k;
		WHEN others =>
	END CASE;
END PROCESS week;


--FSM-Process

FSM_Process:  PROCESS(clk)

    BEGIN
    -- -> synchronized, wait for display
    IF rising_edge(clk) THEN
        IF reset = '1' THEN
            state <=0;
            d_en_enable <= '0';
            d_out <= "00000000";
        ELSE
            CASE state IS
                WHEN 0 =>                               -- Initialize
                    d_rs<='0';
                    d_en_enable <= '1';
                    d_out <= X"0C";                    --Display on, Cursor blink off
                    state <= state+1;
                WHEN 1 =>
                    d_out <= X"38";                    --8 Bit 2 Line 5x8 Chars
                    state <= state+1;
                WHEN 2 =>
                    d_out <= X"01";
                    state <= state +1;
                    count<= 0;
                WHEN 3 =>
                    IF count = 18 THEN
                        state <= state+1;
                    ELSE
                        count <= count + 1;
                        d_en_enable <= '0';
                    END IF;
                WHEN 4 =>
                    d_en_enable <= '1';
                    d_out <= X"06";                -- Entry mode
                    state <= state +1;

                -- Display Initialized

                --First Row

                WHEN 5 =>
                    d_en_enable <='1';
                    d_rs <= '0';
                    d_out <= X"87";
                    state <= state +1;
                    count <= 0;
                WHEN 6 =>
                    d_rs <= '1';
                    count <= count+1;
					CASE count IS
						WHEN 0 => d_out <= T;
						WHEN 1 => d_out <= i_k;
						WHEN 2 => d_out <= m_k;
						WHEN 3 => d_out <= e_k;
						WHEN 4 => d_out <= doublepoint;
							state<=state+1;
						WHEN others =>
					END CASE;
                -- Second Row

                WHEN 7 =>
                    d_rs<='0';
                    d_out<= X"C0";
                    state <= state+1;
                    count<= 0;
                WHEN 8 =>
                    d_rs<='1';
                    count <= count+1;
					CASE count IS
						WHEN 0 => d_out <= A;
						WHEN 1|2|3|4|13|14|18=> d_out <= blank;
						WHEN 5 => d_out <= bcdascii & "00" & td_hour(5 downto 4);        --H ASCII Code
						WHEN 6 => d_out <= bcdascii & td_hour (3 downto 0);              --H ASCII Code
						WHEN 7|10 => d_out <= doublepoint;
						WHEN 8 => d_out <= bcdascii & "0" & td_min (6 downto 4);         -- M ASCII Code
						WHEN 9 => d_out <= bcdascii & td_min (3 downto 0);
						WHEN 11 => d_out <= bcdascii & "0" & td_sec (6 downto 4);
						WHEN 12 => d_out <= bcdascii & td_sec (3 downto 0);
						WHEN 15 => IF dcf_sync = '1' THEN d_out <= D; ELSE d_out<= blank; END IF;
						WHEN 16 => IF dcf_sync = '1' THEN d_out <= C; ELSE d_out<= blank; END IF;
						WHEN 17 => IF dcf_sync = '1' THEN d_out <= F; ELSE d_out<= blank; END IF;
						WHEN 19 => d_out <= blank;
						state<=state+1;
						WHEN others =>
					END CASE;

                -- third Row

                WHEN 9 =>
                    d_rs<='0';
                    d_out<= X"94";
                    state <= state+1;
                    count<= 0;
                WHEN 10 =>
                    count <= count +1;
                    d_rs<= '1';
                    CASE count IS
                        WHEN 0 => IF alarm_enabled = '1' THEN IF alarm_snooze ='1' THEN d_out <= Z; else d_out <= star; END IF; ELSE d_out <= blank; END IF;
                        WHEN 1|2|3|15|16|17|18 => d_out <= blank;
								WHEN 19 => d_out <= blank;
								state<=state+1;
                        WHEN others =>
                    END CASE;
                    IF display_state = "1000" THEN						--if stopwatch
                        CASE count IS
                            WHEN 4 => d_out<=S;
                            WHEN 5 => d_out<=t_k;
                            WHEN 6 => d_out<=o_k;
                            WHEN 7 => d_out<=p_k;
                            WHEN 8 => d_out<=blank;
                            WHEN 9 => d_out<=W;
                            WHEN 10 => d_out<=a_k;
                            WHEN 11 => d_out<=t_k;
                            WHEN 12 => d_out<=c_k;
                            WHEN 13 => d_out<=h_k;
                            WHEN 14 => d_out<=doublepoint;
                            WHEN others =>
                        END CASE;
                    ELSIF display_state = "0100" THEN					--if alarm
                        CASE count IS
                            WHEN 4|5|12|13|14 => d_out <= blank;
                            WHEN 6 =>d_out<=A;
                            WHEN 7 =>d_out<=l_k;
                            WHEN 8 =>d_out<=a_k;
                            WHEN 9 =>d_out<=r_k;
                            WHEN 10 =>d_out<=m_k;
                            WHEN 11 =>d_out<=doublepoint;
                            WHEN others =>
                        END CASE;
                    ELSIF display_state = "0010" THEN					--if date
                        CASE count IS
                            WHEN 4|5|11|12|13|14 => d_out <= blank;
                            WHEN 6 => d_out <= D;
                            WHEN 7 => d_out <= a_k;
                            WHEN 8 => d_out <= t_k;
                            WHEN 9 => d_out <= e_k;
                            WHEN 10 => d_out <= doublepoint;
                            WHEN others =>
                    END CASE;
                    ELSE 
                        CASE count IS
                            WHEN 4|5|6|7|8|9|10|11|12|13|14 => d_out <= blank;
                            WHEN others =>
                        END CASE;
                    END IF;

                --Row 4

                WHEN 11 =>
                    d_rs <= '0';
                    d_out <= X"D4";
                    count <= 0;
                    state <= state +1;
                WHEN 12 =>
                    d_rs <= '1';
                    count <= count +1;
                    CASE count IS
                        WHEN 17|18 => d_out <= blank;
                        WHEN 19 => d_out <= blank;
                            state <= 5;
                        WHEN others =>
                    END CASE;
                    IF display_state = "1000" THEN						--if stopwatch
                        CASE count IS
                            WHEN 0 => IF lap = '1' THEN d_out <= L; ELSE d_out <= blank; END IF;
                            WHEN 1 => IF lap = '1' THEN d_out <= a_k; ELSE d_out <= blank; END IF;
                            WHEN 2 => IF lap = '1' THEN d_out <= p_k; ELSE d_out <= blank; END IF;
                            WHEN 3|15|16 => d_out <= blank;
                            --h
                            WHEN 4 => d_out <=bcdascii & sw_hour1(3 downto 0);
                            WHEN 5 => d_out <=bcdascii & sw_hour2(3 downto 0);
                            WHEN 6|9 => d_out <=doublepoint;
                            --m
                            WHEN 7 => d_out <=bcdascii & sw_min1(3 downto 0);
                            WHEN 8 => d_out <=bcdascii & sw_min2(3 downto 0);
                            --s
                            WHEN 10 => d_out <=bcdascii & sw_sec1(3 downto 0);
                            WHEN 11 => d_out <=bcdascii & sw_sec2(3 downto 0);
                            WHEN 12 => d_out <= point;
                            --ms
                            WHEN 13 => d_out <=bcdascii & sw_ms1(3 downto 0);
                            WHEN 14 => d_out <=bcdascii & sw_ms2(3 downto 0);
                            WHEN others =>
                        END CASE;
                    ELSIF display_state = "0010" THEN					--if date
                        CASE count IS
                            WHEN 0|1|2|3|7|16 => d_out <= blank;
                            --Date (Mon,Tue,Wed,Thu,Fri,Sat,Sun) 'in ASCII Code from Time Module
                            WHEN 4 => d_out <= weekdayascii(23 downto 16);
                            WHEN 5 => d_out <= weekdayascii(15 downto 8);
                            WHEN 6 => d_out <= weekdayascii(7 downto 0);
                            --Month
                            WHEN 8 => d_out <= bcdascii & "000" & td_month(4 downto 4);
                            WHEN 9 => d_out <= bcdascii & td_month(3 downto 0);
                            WHEN 10|13 => d_out <= slash;
                            --Day
                            WHEN 11 => d_out <= bcdascii & "00" & td_day(5 downto 4);
                            WHEN 12 => d_out <= bcdascii & td_day(3 downto 0);
                            --Year
                            WHEN 14 => d_out <= bcdascii & td_year(7 downto 4);
                            WHEN 15 => d_out <= bcdascii & td_year(3 downto 0);
                            WHEN others =>
                        END CASE;
                    ELSIF display_state = "0100" THEN					--if alarm
                        CASE count IS
                            WHEN 0|1|2|3|4|5|6|12|13|14|15|16 => d_out <= blank;
                            WHEN 7 => d_out <= bcdascii & "00" & alarm_hour (5 downto 4);         -- M_
                            WHEN 8 => d_out <= bcdascii & alarm_hour(3 downto 0);
                            WHEN 9 => d_out <= doublepoint;
                            WHEN 10 => d_out <= bcdascii & "0" & alarm_min(6 downto 4);
                            WHEN 11 => d_out <= bcdascii & alarm_min (3 downto 0);
                            WHEN others =>
                        END CASE;
                    ELSE
                        CASE count IS
                            WHEN 0|1|2|4|5|6|7|8|9|10|11|12|13|14|15|16 => d_out <= blank;
                            WHEN others =>
                        END CASE;
            END IF;
                WHEN others =>
            END CASE;
        END IF;
        END IF;
    END PROCESS FSM_Process;

END display_arch;
