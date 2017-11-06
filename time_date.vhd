LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity time_date is

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
end time_date;

architecture Behavioral of time_date IS

signal leapyear		: std_logic;

signal sec_ten, min_ten,dow_uni			  : std_logic_vector (2 downto 0):= (others => '0');
signal day_ten,hour_ten				  : std_logic_vector (1 downto 0):= (others => '0');
signal sec_uni, min_uni, hour_uni,day_uni,month_uni,year_ten,year_uni : std_logic_vector (3 downto 0):= (others => '0');
signal month_ten,dcf_valid_i					  : std_logic := '0';
signal y								: std_logic_vector (7 downto 0) := (others => '0');
begin

td_sec 	<= sec_ten   & sec_uni;
td_min 	<= min_ten   & min_uni;
td_hour <= hour_ten  & hour_uni;
td_day 	<= day_ten   & day_uni;
td_dow 	<= dow_uni;
td_month<= month_ten & month_uni;
td_year <= year_ten  & year_uni;
dcf_valid <= dcf_valid_i;


--------------------------------------
--            Leapyear              --
--------------------------------------
l_year: process (clk_10k)
begin
if(clk_10K'EVENT and clk_10K='1') then
y <= year_ten&year_uni;
case y is
	when "00000000" => leapyear <= '1';
	when "00000100" => leapyear <= '1';
	when "00001000" => leapyear <= '1';
	when "00010010" => leapyear <= '1';
	when "00010110" => leapyear <= '1';
	when "00100000" => leapyear <= '1';
	when "00100100" => leapyear <= '1';
	when "00101000" => leapyear <= '1';
	when "00110010" => leapyear <= '1';
	when others => leapyear <= '0';
end case;
end if;
end process;


basic : process (clk_10k)
begin
	if(clk_10K'EVENT and clk_10K='1') then
		if (reset = '1') then
			sec_uni    <= "0000";
			sec_ten   <= "000";
			min_uni    <= "0000";
			min_ten   <= "000";
			hour_uni   <= "0000";
			hour_ten  <= "00";
			day_uni 	<= "0001";
			day_ten	<= "00";
			month_uni  <= "0001";
			month_ten <= '0';
			year_uni   <= "0000";
			year_ten  <= "0000";
			dow_uni     <= "110";
			dcf_valid_i <= '0';
						-- reset 
		elsif de_set ='1' then
			sec_uni    <= "0000";
			sec_ten   <= "000";
			min_uni    <= de_min(3 downto 0);
			min_ten   <= de_min(6 downto 4);
			hour_uni   <= de_hour(3 downto 0);
			hour_ten  <= de_hour(5 downto 4);
			day_uni	<= de_day(3 downto 0);
			day_ten	<= de_day(5 downto 4);
			month_uni  <= de_month(3 downto 0);
			month_ten <= de_month(4);
			year_uni   <= de_year(3 downto 0);
			year_ten  <= de_year(7 downto 4);
			dow_uni     <= de_dow;
			dcf_valid_i <= '1';
						-- DCF77
		else
		  if (en_1 = '1') then
			sec_uni <= std_logic_vector( unsigned(sec_uni)+1);
			if sec_uni ="1001"then
				sec_ten <= std_logic_vector( unsigned(sec_ten)+1);
				sec_uni <= "0000";
			end if;
			if (sec_ten & sec_uni) = "1011001" then
				dcf_valid_i <= '0';
				sec_uni <= "0000";
				sec_ten <= "000";
				min_uni <= std_logic_vector( unsigned(min_uni)+1);
				if min_uni ="1001"then
					min_ten <= std_logic_vector( unsigned(min_ten)+1);
					min_uni <= "0000";
				end if;
				if (min_ten & min_uni) = "1011001" then
					min_uni <= "0000";
					min_ten <= "000";
					hour_uni <= std_logic_vector( unsigned(hour_uni)+1);
					if hour_uni ="1001" then
						hour_ten <= std_logic_vector( unsigned(hour_ten)+1);
						hour_uni <= "0000";
					end if;
					if (hour_ten & hour_uni) = "100011" then
						hour_uni <= "0000";
						hour_ten <= "00";
						dow_uni <= std_logic_vector( unsigned(dow_uni)+1);
						if dow_uni = "111" then
							dow_uni <= "001";
						end if;
						
						day_uni <= std_logic_vector( unsigned(day_uni)+1);
						if day_uni = "1001" then
							day_uni <= "0000";
							day_ten <= std_logic_vector( unsigned(day_ten)+1);
						end if;
                            if (month_ten & month_uni = "00010")then 
								if ((day_ten & day_uni = "101000")  AND (leapyear = '0')) then
									day_ten <= "00";
									day_uni <= "0001";
									month_ten <= '0';
									month_uni <= "0011";
								elsif ((day_ten & day_uni = "101001") AND (leapyear = '1')) then
									day_ten <= "00";
									day_uni <= "0001";
									month_ten <= '0';
									month_uni <= "0011";
								end if;
							end if ;
							if ((day_ten & day_uni = "110000") and ((month_uni = "0100") or (month_uni = "0110") or (month_uni = "1001") or (month_ten & month_uni = "10001"))) 	then
					
								day_ten <= "00";
								day_uni <= "0001";
								month_uni <= std_logic_vector( unsigned(month_uni)+1);
								if month_uni = "1001" then
									month_uni <= "0000";
									month_ten <= '1';
								end if;
							end if;
							if (day_ten & day_uni = "110001") then
								day_ten <= "00";
								day_uni <= "0001";						
								month_uni <= std_logic_vector( unsigned(month_uni)+1);
								if (month_ten & month_uni = "10010") then
									month_uni <= "0001";
									month_ten <= '0';
									year_uni <= std_logic_vector( unsigned(year_uni)+1);
									if year_uni ="1001" then
										year_uni <= "0000";
										year_ten <= std_logic_vector( unsigned(year_ten)+1);
									end if;											
								end if;
							end if;
					end if;
				
				 end if;
			end if;			
		end if;
		end if;
		end if;
end process;



end Behavioral;