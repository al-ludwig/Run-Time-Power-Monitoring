library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.fxd_arith_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity tb_fxd_arith_pkg is
end tb_fxd_arith_pkg;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture sim of tb_fxd_arith_pkg is

	--==========================================================================
	-- change sim constants
	constant max_error   : real     := 1.0e-12;
	constant steps       : natural  := 1e4;
	constant coeff_fxd_c : fxd_type := (32, 96, 128);
	constant res_fxd_c   : fxd_type := (32, 96, 128);
	--==========================================================================

	subtype coeff_fxd_type is unsigned (coeff_fxd_c.m - 1 downto 0);
	subtype res_fxd_type is unsigned (res_fxd_c.m - 1 downto 0);

	signal small_fxd  : coeff_fxd_type;
	signal small_real : real := 0.0;

	signal norm_fxd  : coeff_fxd_type;
	signal norm_real : real := 0.0;

	signal res_fxd    : res_fxd_type;
	signal res_real   : real := 0.0;
	signal res_back   : real := 0.0;
	signal conv_error : real := 0.0;

begin

	p : process

		variable seed1, seed2  : integer := 999;
		variable rand, rand_sm : real;

	begin

		for i in 0 to steps loop
			-- generate random values
			uniform(seed1, seed2, rand);
			uniform(seed1, seed2, rand_sm);
			small_real <= rand * 1.0e-12;
			norm_real  <= rand_sm * 1.0e6;

			-- to_fxd test
			wait for 0 ns;
			small_fxd <= to_fxd(small_real, coeff_fxd_c); -- test t_fxd
			norm_fxd  <= to_fxd(norm_real, coeff_fxd_c);

			-- multiplikation
			wait for 0 ns;
			res_fxd <=
				mul_fxd(small_fxd, coeff_fxd_c, norm_fxd, coeff_fxd_c, res_fxd_c);
			res_real <= small_real * norm_real;

			-- convert result back to real
			wait for 0 ns;
			res_back <= to_real(res_fxd, res_fxd_c);

			-- compare fxd and real result
			wait for 0 ns;
			conv_error <= res_real - res_back;

			-- assert if max_error violated
			assert (conv_error < max_error) report "Simulation: max conv_error violation" severity failure;

			wait for 1 ns;
		end loop;
		report "Simulation: Finished successfully" severity failure;
	end process;
end sim;