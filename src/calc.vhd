library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.fxd_arith_pkg.all;
use work.rtpm_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity calc is
	generic (
		multiplier  : real;
		input_width : natural
	);
	port (
		clk      : in std_logic;
		en       : in std_logic;
		reset_n  : in std_logic;
		activity : in unsigned (input_width - 1 downto 0);
		p_dyn    : out res_fxd_type
	);
end calc;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture beh of calc is

	constant c_multiplier : coeff_fxd_type := to_fxd(multiplier, coeff_fxd_c);
	signal s_p_dyn        : res_fxd_type;

begin

	p_dyn <= s_p_dyn;

	calculation : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (reset_n = '0') then
				s_p_dyn <= to_fxd(0.0, res_fxd_c);
			elsif (en = '1') then
				s_p_dyn <= mul_fxd(to_fxd(activity, coeff_fxd_c), coeff_fxd_c, c_multiplier, coeff_fxd_c, res_fxd_c);
			end if;
		end if;
	end process;

end beh;