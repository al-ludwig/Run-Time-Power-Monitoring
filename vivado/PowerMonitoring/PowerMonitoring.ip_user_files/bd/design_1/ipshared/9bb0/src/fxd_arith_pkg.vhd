--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

package fxd_arith_pkg is

	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- type definitions
	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	type fxd_type is record
		ip : natural; -- int part
		fp : natural; -- fraction part
		m  : natural; -- all
	end record;

	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	--function declerations
	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	-- multiply two fxd_type unsigned
	function mul_fxd (
		constant a     : unsigned;
		constant a_fxd : fxd_type;
		constant b     : unsigned;
		constant b_fxd : fxd_type;
		constant c_fxd : fxd_type
	) return unsigned;

	--==========================================================================

	-- add two fxd_type unsigned
	function add_fxd (
		constant a     : unsigned;
		constant a_fxd : fxd_type;
		constant b     : unsigned;
		constant b_fxd : fxd_type;
		constant c_fxd : fxd_type
	) return unsigned;

	--==========================================================================

	-- convert real to fxd_type
	function to_fxd (
		constant input     : real;
		constant out_fxd_c : fxd_type
	) return unsigned;

	--==========================================================================

	-- convert unsigned to fxd_type
	function to_fxd (
		constant input     : unsigned;
		constant out_fxd_c : fxd_type
	) return unsigned;

	--==========================================================================

	-- convert fxd_type to real
	function to_real (
		constant a   : unsigned;
		constant a_c : fxd_type
	) return real;

	--==========================================================================

	function max (
		constant a : natural;
		constant b : natural
	) return natural;
	
	--==========================================================================

end fxd_arith_pkg;

package body fxd_arith_pkg is

	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- function bodies
	--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	--==========================================================================
	-- multiply 2 fxd_type unsigned arguments
	--==========================================================================

	function mul_fxd (
		constant a     : unsigned;
		constant a_fxd : fxd_type;
		constant b     : unsigned;
		constant b_fxd : fxd_type;
		constant c_fxd : fxd_type
	) return unsigned is

		variable mres_c : fxd_type;
		variable mres   : unsigned (a_fxd.m + b_fxd.m - 1 downto 0);
		variable c      : unsigned (c_fxd.m - 1 downto 0);

	begin
		mres_c := (a_fxd.ip + b_fxd.ip, a_fxd.fp + b_fxd.fp, a_fxd.m + b_fxd.m);
		mres   := (others => '0');
		c      := (others => '0');

		-- multiplication
		mres := a * b;

		-- set output c
		-- integer part
		if (c_fxd.ip >= mres_c.ip) then -- c.ip > m.ip
			c(c_fxd.fp + mres_c.ip - 1 downto c_fxd.fp) :=
			mres(mres_c.m - 1 downto mres_c.fp);
		elsif (c_fxd.ip < mres_c.ip) then -- c.ip < m.ip
			-- overflow warning
			if (mres(mres_c.m - 1 downto mres_c.m - (mres_c.ip - c_fxd.ip)) /= 0) then
				-- report "MUL_FXD: Integer part of result c_fxd type too short!" severity failure;
			end if;
			c(c_fxd.m - 1 downto c_fxd.fp) :=
			mres(mres_c.fp + c_fxd.ip - 1 downto mres_c.fp);
		end if;

		-- fraction part
		if (c_fxd.fp >= mres_c.fp) then -- no overflow
			c(c_fxd.fp - 1 downto c_fxd.fp - mres_c.fp) :=
			mres(mres_c.fp - 1 downto 0);
		elsif (c_fxd.fp < mres_c.fp) then
			-- overflow warning
			if (mres(mres_c.fp - 1 - c_fxd.fp downto 0) /= 0) then
				-- report "MUL_FXD: Fraction part of result c_fxd type too short. Loosing precision!" severity warning;
			end if;
			c(c_fxd.fp - 1 downto 0) :=
			mres(mres_c.fp - 1 downto mres_c.fp - c_fxd.fp);
		end if;

		return c;
	end mul_fxd;

	--==========================================================================
	-- add 2 fxd_type unsigned arguments
	--==========================================================================

	function add_fxd (
		constant a     : unsigned;
		constant a_fxd : fxd_type;
		constant b     : unsigned;
		constant b_fxd : fxd_type;
		constant c_fxd : fxd_type
	) return unsigned is
		constant mres_c : fxd_type := ( 
			max(a_fxd.ip, b_fxd.ip) + 1,
			max(a_fxd.fp, b_fxd.fp), 
			max(a_fxd.ip, b_fxd.ip) + max(a_fxd.fp, b_fxd.fp) + 1);
		variable mres   : unsigned (mres_c.m - 1 downto 0);
		variable c      : unsigned (c_fxd.m - 1 downto 0);

	begin
		mres   := (others => '0');
		c      := (others => '0');

		-- addition
		if (a_fxd.fp >= b_fxd.fp) then
			mres := resize(a, mres_c.m) + shift_left(resize(b, mres_c.m), (a_fxd.fp - b_fxd.fp));
		elsif (a_fxd.fp < b_fxd.fp) then
			mres := resize(b, mres_c.m) + shift_left(resize(a, mres_c.m), (b_fxd.fp - a_fxd.fp));
		end if;

		-- set output c
		-- integer part
		if (c_fxd.ip >= mres_c.ip) then -- c.ip > m.ip
			c(c_fxd.fp + mres_c.ip - 1 downto c_fxd.fp) :=
			mres(mres_c.m - 1 downto mres_c.fp);
		elsif (c_fxd.ip < mres_c.ip) then -- c.ip < m.ip
			-- overflow warning
			if (mres(mres_c.m - 1 downto mres_c.m - (mres_c.ip - c_fxd.ip)) /= 0) then
				-- report "ADD_FXD: Integer part of result c_fxd type too short!" severity failure;
			end if;
			c(c_fxd.m - 1 downto c_fxd.fp) :=
			mres(mres_c.fp + c_fxd.ip - 1 downto mres_c.fp);
		end if;

		-- fraction part
		if (c_fxd.fp >= mres_c.fp) then -- no overflow
			c(c_fxd.fp - 1 downto c_fxd.fp - mres_c.fp) :=
			mres(mres_c.fp - 1 downto 0);
		elsif (c_fxd.fp < mres_c.fp) then
			-- overflow warning
			if (mres(mres_c.fp - 1 - c_fxd.fp downto 0) /= 0) then
				-- report "ADD_FXD: Fraction part of result c_fxd type too short. Loosing precision!" severity warning;
			end if;
			c(c_fxd.fp - 1 downto 0) := 
			mres(mres_c.fp - 1 downto mres_c.fp - c_fxd.fp);
		end if;

		return c;
	end add_fxd;

	--==========================================================================
	-- convert real number to unsigned fxd_Type
	--==========================================================================

	function to_fxd (
		constant input     : real;
		constant out_fxd_c : fxd_type
	) return unsigned is

		constant max_shift : integer := 16;
		variable rest      : integer;
		variable lp_cyc    : integer;

		variable result : unsigned (out_fxd_c.m - 1 downto 0);
		variable tmp    : real;
		variable int    : integer;

	begin
		result := (others => '0');
		rest   := out_fxd_c.fp mod max_shift;
		lp_cyc := out_fxd_c.fp / max_shift;

		tmp := input * real(2) ** rest; -- shift left
		int := integer(floor(tmp));     -- extract msbs
		tmp := tmp - real(int);         -- subtract temporary real

		-- fill result array with msbs
		result(out_fxd_c.m - 1 downto out_fxd_c.m - (rest + out_fxd_c.ip)) :=
		to_unsigned(int, (rest + out_fxd_c.ip));

		if (out_fxd_c.fp >= max_shift) then
			for i in 0 to lp_cyc - 1 loop
				tmp := tmp * real(2) ** max_shift; -- shift left
				int := integer(floor(tmp));        -- extract msbs
				tmp := tmp - real(int);            -- subtract temporary real
				-- fill result array with msbs
				result(out_fxd_c.m - (rest + out_fxd_c.ip) - 1 - (max_shift * i) downto out_fxd_c.m - (rest + out_fxd_c.ip) - max_shift * (i + 1)) := to_unsigned(int, max_shift);
			end loop;
		end if;

		return result;
	end to_fxd;

	--==========================================================================
	-- convert unsigned number to unsigned fxd_Type
	--==========================================================================

	function to_fxd (
		constant input     : unsigned;
		constant out_fxd_c : fxd_type
	) return unsigned is

		variable result : unsigned (out_fxd_c.m - 1 downto 0);

	begin
		result := (others => '0');

		-- fill result array with msbs
		result(out_fxd_c.m - 1 downto out_fxd_c.fp) := resize(input, out_fxd_c.ip);
		if (input'length > out_fxd_c.ip) then
			-- report "to_fxd (unsigned): Integer part of result type out_fxd_c too short." severity warning;
		end if;

		return result;
	end to_fxd;

	--==========================================================================
	-- convert unsigned fxd_Type to real number
	--==========================================================================

	function to_real (
		constant a   : unsigned;
		constant a_c : fxd_type
	) return real is

		variable result : real;
		variable value  : real;

	begin
		result := 0.0;
		value  := 2.0 ** (a_c.ip - 1);

		for i in a_c.m - 1 downto 0 loop
			if (a(i) = '1') then
				result := result + value;
			end if;
			value := value / 2.0;
		end loop;

		return result;
	end to_real;

	--==========================================================================
	-- convert unsigned fxd_Type to real number
	--==========================================================================

	function max (
		constant a : natural;
		constant b : natural
	) return natural is
	begin
		if (a >= b) then
			return a;
		else
			return b;
		end if;
	end max;

end fxd_arith_pkg;