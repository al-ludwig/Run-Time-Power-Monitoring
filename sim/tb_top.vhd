--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fxd_arith_pkg.all;
use work.rtpm_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity tb_top is
end tb_top;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture sim of tb_top is

	signal s_clk          : std_logic := '0';
	signal s_en           : std_logic := '0';
	signal s_reset_n      : std_logic := '1';
	signal s_ram_addr     : std_logic_vector(7 downto 0);
	signal s_ram_data_in  : std_logic_vector(15 downto 0);
	signal s_ram_wr       : std_logic;
	signal s_ram_data_out : std_logic_vector(15 downto 0);
	signal s_p_dyn        : res_fxd_type;

	signal s_p_dyn_real : real;

begin

	uut : top
	port map(
		clk          => s_clk,
		en           => s_en,
		reset_n      => s_reset_n,
		ram_addr     => s_ram_addr,
		ram_data_in  => s_ram_data_in,
		ram_wr       => s_ram_wr,
		ram_data_out => s_ram_data_out,
		p_dyn        => s_p_dyn
	);

	s_clk <= not s_clk after 10 ns;
	s_p_dyn_real <= to_real(s_p_dyn, res_fxd_c);

	----------------------------------------------------------------------------
	-- periodic reset after 1us
	p_reset : process
	begin
		s_reset_n <= '0';
		s_en      <= '0';
		wait for 20 ns;
		s_reset_n <= '1';
		s_en      <= '1';
		wait;
	end process;
	----------------------------------------------------------------------------
	p_wr : process
	begin
		wait for 20 ns;
		--write block
		s_ram_addr    <= x"01";
		s_ram_wr      <= '1';
		s_ram_data_in <= x"fac1";
		wait for 40 ns;
		s_ram_addr    <= x"05";
		s_ram_wr      <= '1';
		s_ram_data_in <= x"dde1";
		wait for 40 ns;
		s_ram_addr    <= x"f1";
		s_ram_wr      <= '1';
		s_ram_data_in <= x"00f2";
		wait for 40 ns;

		--read block
		s_ram_addr <= x"01";
		s_ram_wr   <= '0';
		wait for 40 ns;
		s_ram_addr <= x"03";
		s_ram_wr   <= '0';
		wait for 40 ns;
		s_ram_addr <= x"f1";
		s_ram_wr   <= '0';
		wait for 40 ns;
		s_ram_addr <= x"05";
		s_ram_wr   <= '0';
		wait for 40 ns;
	end process;
	----------------------------------------------------------------------------
end sim;