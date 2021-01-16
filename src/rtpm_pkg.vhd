library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.fxd_arith_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

package rtpm_pkg is
	----------------------------------------------------------------------------
	--constant definitions
	constant max_error             : real     := 1.0e-12;
	constant coeff_fxd_c           : fxd_type := (32, 96, 128);
	constant res_fxd_c             : fxd_type := (32, 96, 128);
	constant activity_data_width_c : natural  := 8;

	constant reset_interval_c : time    := 500 ns;
	constant clk_freq_c       : natural := 50e6;

	----------------------------------------------------------------------------
	--subtype definitions
	subtype coeff_fxd_type is unsigned (coeff_fxd_c.m - 1 downto 0);
	subtype res_fxd_type is unsigned (res_fxd_c.m - 1 downto 0);
	----------------------------------------------------------------------------
	-- type definitions

	----------------------------------------------------------------------------
	--function declerations

	--##########################################################################
	--USER CHANGABLE CONSTANTS

	--##########################################################################
	--component declerations for the top entities

	component ac
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
	end component;

	component calc
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