--------------------------------------------------------------------------------
-- filename : calc.vhd
-- project  : run-time-power-monitoring
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity calc is
  generic (
    vdd_squared : REAL;
    frequency   : natural;
    capacitance : REAL;
    input_width : natural
  );
  port (
    clk      : in std_logic;
    en       : in std_logic;
    reset_n  : in std_logic;
    activity : in unsigned (input_width - 1 downto 0);
    p_dyn    : out real
  );
end calc;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture beh of calc is -- behavoral model, not SYNTHESISABLE
  signal s_p_dyn_calc : real;
begin

  p_dyn <= s_p_dyn_calc;

  calculation : process (clk)
  begin
    if (clk'event and clk = '1') then
      if (reset_n = '0') then
        s_p_dyn_calc <= real(0);
      elsif (en = '1') then
        s_p_dyn_calc <= vdd_squared * real(frequency) * capacitance * real(to_integer(activity));
      end if;
    end if;
  end process;

end beh;