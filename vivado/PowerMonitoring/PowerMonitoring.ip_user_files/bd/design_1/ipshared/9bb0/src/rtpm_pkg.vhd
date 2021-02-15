--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.fxd_arith_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

package rtpm_pkg is

	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	--USER CHANGABLE CONSTANTS

	constant activity_count        : natural := 5;
	constant activity_data_width_c : natural := 20;

	constant coeff_fxd_c : fxd_type := (32, 96, 128);
	constant res_fxd_c   : fxd_type := (4, 28, 32);

	constant reset_interval_c : natural    := 1e7; -- 0.5s
	constant clk_freq_c       : natural := 50e6;

	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	subtype coeff_fxd_type is unsigned (coeff_fxd_c.m - 1 downto 0);
	subtype res_fxd_type is unsigned (res_fxd_c.m - 1 downto 0);

	type multiplier_array_type is array (activity_count - 1 downto 0) of real;
	type multiplier_fxd_array_type is array (activity_count - 1 downto 0) of coeff_fxd_type;
	subtype activity_type is unsigned (activity_data_width_c - 1 downto 0);
	type activity_array_type is array (activity_count - 1 downto 0) of activity_type;

	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	--USER CHANGABLE CONSTANTS
	
	constant c_multiplier : multiplier_array_type := (
		-- 0.00034304350587, 
		-- 0.00093211239945,
		-- 0.00000645664374,
		-- 0.00023676654456,
		-- 0.00012432524569
		-- 0.000001,
		-- 0.000001,
		-- 0.000001,
		-- 0.000001,
		-- 0.000001
		0.0000001,
		0.0000001,
		0.0000001,
		0.0000001,
		0.0000001
		);

	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	--==========================================================================

	component ac
		port (
			clk     : in std_logic;
			reset_n : in std_logic;
			inp     : in std_logic;
			result  : out activity_type
		);
	end component;

	component calc
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
	end component;

	component sp_ram
		port (
			RAM_ADDR     : in std_logic_vector(7 downto 0);
			RAM_DATA_IN  : in std_logic_vector(15 downto 0);
			RAM_WR       : in std_logic;
			RAM_CLOCK    : in std_logic;
			RAM_DATA_OUT : out std_logic_vector(15 downto 0);
			RAM_RESTN    : in std_logic
		);
	end component;

	component top
		port (
			clk          : in std_logic;
			en           : in std_logic;
			reset_n      : in std_logic;
			RAM_ADDR     : in std_logic_vector(7 downto 0);
			RAM_DATA_IN  : in std_logic_vector(15 downto 0);
			RAM_WR       : in std_logic;
			RAM_DATA_OUT : out std_logic_vector(15 downto 0);
			p_dyn        : out res_fxd_type
		);
	end component;

end;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

package body rtpm_pkg is
end rtpm_pkg;