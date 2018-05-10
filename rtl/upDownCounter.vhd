library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--
-- description: an up/down counter with sliding switch feature
-- input: a clock, reset, and two triggered (indicating to count up or down) signals 
-- output: a set of signals used on 7-segment display
--

entity upDownCounter is
	port(
		clk         : in std_logic; -- input clock
		rst         : in std_logic; -- input reset
		upTrigger   : in std_logic; -- trigger to count up
		downTrigger : in std_logic; -- trigger to count down
		
		sseg        : out std_logic_vector(0 to 6) -- 7 segment display
	);
end entity;

architecture Behavioral of upDownCounter is
	signal counter   : std_logic_vector(3 downto 0);
	signal prev_up   : std_logic := '0'; -- signal storing previous up trigger's state
	signal prev_down : std_logic := '0'; -- signal storing previous down trigger's state
begin

	-- set value of counter
	process(clk, rst) 
	begin
		if(rst = '1') then -- if reset switch is on
			counter <= (others => '0');
		elsif(clk'event and rising_edge(clk)) then 
		
			-- store the previous up and down trigger's state
			prev_up <= upTrigger;
			prev_down <= downTrigger;
		
			if(prev_up = '0' and upTrigger = '1') then 
				counter <= counter + 1; -- count upward
			elsif(prev_down = '0' and downTrigger = '1') then 
				counter <= counter - 1; -- count downward
			end if;
		end if;	
	end process;
	
	-- assign the signals to sseg according to the value of counter
	process(counter)
	begin
		case counter is
			when "0000" => sseg <= "0000001"; -- "0"	
			when "0001" => sseg <= "1001111"; -- "1"
			when "0010" => sseg <= "0010010"; -- "2"
			when "0011" => sseg <= "0000110"; -- "3"
			when "0100" => sseg <= "1001100"; -- "4"
			when "0101" => sseg <= "0100100"; -- "5"
			when "0110" => sseg <= "0100000"; -- "6"
			when "0111" => sseg <= "0001111"; -- "7"
			when "1000" => sseg <= "0000000"; -- "8"
			when "1001" => sseg <= "0000100"; -- "9"
			when "1010" => sseg <= "0000010"; -- a
			when "1011" => sseg <= "1100000"; -- b
			when "1100" => sseg <= "0110001"; -- C
			when "1101" => sseg <= "1000010"; -- d
			when "1110" => sseg <= "0110000"; -- E
			when "1111" => sseg <= "0111000"; -- F
		end case;
	end process;
end Behavioral;
