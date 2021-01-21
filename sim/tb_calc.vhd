--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.fxd_arith_pkg.all;
use work.rtpm_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity tb_calc is
end tb_calc;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture sim of tb_calc is

	--==========================================================================
	-- USER CHANGABLE
	constant max_error    : real                  := 1.0e-6;
	constant steps        : natural               := 1e4;
	--==========================================================================

	signal s_clk        : std_logic := '0';
	signal s_reset_n    : std_logic := '1';
	signal s_en         : std_logic;
	signal s_activity   : activity_array_type;
	signal s_p_dyn      : res_fxd_type;
	signal s_p_dyn_real : real;

	signal s_p_dyn_err : real := 0.0;
	signal s_p_dyn_ref: real := 0.0;

begin

	ut : calc
	generic map(
		multiplier => c_multiplier
	)
	port map(
		clk      => s_clk,
		en       => s_en,
		reset_n  => s_reset_n,
		activity => s_activity,
		p_dyn    => s_p_dyn);

	-- concurrent conversion of the fxd output
	s_p_dyn_real <= to_real(s_p_dyn, res_fxd_c);

	-- clk stimulus 
	s_clk <= not s_clk after 10 ns; -- 50MHz

	-- reset
	p_reset : process
	begin
		s_reset_n <= '0';
		s_en      <= '0';
		wait for 20 ns;
		s_reset_n <= '1';
		s_en      <= '1';
		wait;
	end process;

	-- compare fxd arithmetic with real arithmetic and calc error
	p_compare : process (s_p_dyn_real, s_en, s_reset_n, s_activity)
		variable v_p_dyn_ref : real := 0.0;
	begin
		if (s_en and s_reset_n) then
			if (s_p_dyn_real'event) then
				v_p_dyn_ref := 0.0;
				for j in 0 to activity_count-1 loop
					v_p_dyn_ref := v_p_dyn_ref + (real(to_integer(s_activity(j))) * c_multiplier(j));
				end loop;
				s_p_dyn_err <= s_p_dyn_real - v_p_dyn_ref;
				s_p_dyn_ref <= v_p_dyn_ref;
				assert (abs(s_p_dyn_real - v_p_dyn_ref) < max_error) 
				report "Simulation: max conv_error violation" severity failure;
			end if;
		end if;
	end process;

	-- generate random activity inputs
	p_stim : process
		variable seed1, seed2        : integer := 999;
		variable rand, rand2         : real;
		variable rand_nat, rand2_nat : natural;
	begin
		for i in 0 to steps loop
			-- generate random values
			for j in 0 to activity_count - 1 loop
				uniform(seed1, seed2, rand);
				rand_nat  := natural(rand * 1000.0);
				s_activity(j) <= to_unsigned(rand_nat, activity_data_width_c);
			end loop;
			wait for 20 ns;
		end loop;
		report "Simulation: Finished successfully" severity failure;
	end process;

end sim;