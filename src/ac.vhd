library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity ac is
	generic (
		output_width   : natural;
		reset_interval : time;
		clk_freq       : natural
	);
	port (
		clk     : in std_logic;
		reset_n : in std_logic;
		inp     : in std_logic;
		result  : out unsigned (output_width - 1 downto 0)
	);
end ac;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture rtl of ac is

	constant result_max       : unsigned 
			:= to_unsigned(2 ** (output_width - 1) - 1, output_width);
	constant clk_period       : time     
			:= 1 sec / clk_freq;
	constant max_reset_cnt    : natural  
			:= integer(reset_interval / clk_period);
	constant length_reset_cnt : natural  
			:= natural(ceil(log2(real(max_reset_cnt))));

	signal s_inp       : std_logic;
	signal s_reset_cnt : unsigned(length_reset_cnt - 1 downto 0);

begin

	p_count : process (clk)
		variable v_cnt : unsigned(output_width - 1 downto 0);
	begin

		if (clk'event and clk = '1') then
			if (reset_n = '0') then
				v_cnt := (others => '0');

				s_reset_cnt <= (others => '0');
				result      <= (others => '0');
			elsif (reset_n = '1') then
				-- if reset counter not maxed out
				if (v_cnt >= 0 and v_cnt <= result_max) then
					-- if toggle detected increase counter
					if ((inp xor s_inp) = '1') then
						v_cnt := v_cnt + 1;
					end if;
				end if;

				if (s_reset_cnt < max_reset_cnt - 1) then
					--count reset counter
					s_reset_cnt <= s_reset_cnt + 1;
				else
					-- reset counters and output result
					s_reset_cnt <= (others => '0');
					result      <= v_cnt;
					v_cnt := (others => '0');
				end if;
			end if;
			-- save actual inp
			s_inp <= inp;
		end if;
	end process;

end rtl;