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

entity calc is
	generic (
		multiplier : multiplier_array_type
	);
	port (
		clk      : in std_logic;
		en       : in std_logic;
		reset_n  : in std_logic;
		activity : in activity_array_type;
		p_dyn    : out res_fxd_type
	);
end calc;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture beh of calc is

	signal s_multiplier : multiplier_fxd_array_type;

begin

	conv_gen : for i in 0 to activity_count - 1 generate
		s_multiplier(i) <= to_fxd(multiplier(i), coeff_fxd_c);
	end generate;

	calculation : process (clk)
		variable v_p_dyn : res_fxd_type;
	begin
		if (clk'event and clk = '1') then
			if (reset_n = '0') then
				v_p_dyn := (others => '0');
			elsif (en = '1') then
				v_p_dyn := (others => '0');
				proc_loop : for i in 0 to activity_count - 1 loop
					v_p_dyn :=
						add_fxd(
							mul_fxd(
								to_fxd(activity(i), coeff_fxd_c), -- 1st factor
								coeff_fxd_c,     -- 1st factor type
								s_multiplier(i), -- 2nd factor
								coeff_fxd_c,     -- 2nd factor type
								coeff_fxd_c      -- result type
							),       -- multiplier with activity
						coeff_fxd_c, -- type of multiply
						v_p_dyn,     -- add 2nd arg for addition
						res_fxd_c, -- add 2nd arg type
						res_fxd_c  -- add result type
						);
				end loop;
			end if;
			p_dyn <= v_p_dyn;
		end if;
	end process;

end beh;