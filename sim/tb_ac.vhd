--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.rtpm_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity tb_ac is
end tb_ac;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture sim of tb_ac is

	signal s_clk     : std_logic := '0';
	signal s_reset_n : std_logic := '1';
	signal s_inp     : std_logic;
	signal s_result  : activity_type;

begin

	uut : ac
	port map(
		clk     => s_clk,
		reset_n => s_reset_n,
		inp     => s_inp,
		result  => s_result);

	s_clk <= not s_clk after 10 ns; -- 50MHz

	-- periodic reset after 1us
	resetting : process
	begin
		s_reset_n <= '0';
		wait for 20 ns;
		s_reset_n <= '1';
		wait;
	end process;

	-- "random" inputs
	stim : process
	begin
		--wait for 10 ns;
		s_inp <= '0';
		wait for 20 ns;
		s_inp <= '1';
		wait for 20 ns;
		s_inp <= '0';
		wait for 20 ns;
		s_inp <= '0';
		wait for 20 ns;
		s_inp <= '1';
		wait for 20 ns;
		s_inp <= '0';
		wait for 20 ns;
	end process;

end sim;