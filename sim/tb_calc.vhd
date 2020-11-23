--------------------------------------------------------------------------------
-- filename : tb_calc.vhd
-- project  : run-time-power-monitoring
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_calc is
end tb_calc;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture behaviour of tb_calc is

  constant input_data_width : natural := 8;

  signal s_clk      : std_logic := '0';
  signal s_reset_n  : std_logic := '1';
  signal s_en       : std_logic;
  signal s_activity : unsigned (input_data_width - 1 downto 0);
  signal s_p_dyn    : real;

begin

  uut : entity work.calc(beh)
    generic map(
      vdd_squared => 1.21,
      frequency   => 50e+6,
      capacitance => 8.0e-12,
      input_width => 8)
    port map(
      clk      => s_clk,
      en       => s_en,
      reset_n  => s_reset_n,
      activity => s_activity,
      p_dyn    => s_p_dyn);

  -- clk stimulus 
  s_clk <= not s_clk after 10 ns; -- 50MHz

  -- periodic reset after 1us
  p_reset : process
  begin
    s_reset_n <= '0';
    s_en      <= '0';
    wait for 20 ns;
    s_reset_n <= '1';
    s_en      <= '1';
    wait for 980 ns;
  end process;

  -- inputs
  p_stim : process
  begin
    s_activity <= to_unsigned(28, 8);
    wait for 20 ns;
    s_activity <= to_unsigned(56, 8);
    wait for 20 ns;
    s_activity <= to_unsigned(80, 8);
    wait for 20 ns;
    s_activity <= to_unsigned(13, 8);
    wait for 20 ns;
    s_activity <= to_unsigned(34, 8);
    wait for 20 ns;
    s_activity <= to_unsigned(89, 8);
    wait for 20 ns;
  end process;

end behaviour;