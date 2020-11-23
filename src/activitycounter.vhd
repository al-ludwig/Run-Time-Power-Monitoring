--------------------------------------------------------------------------------
-- filename: activitycounter.vhd
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

ENTITY activitycounter is
  GENERIC(
    output_width:   NATURAL
  );
  PORT(
    clk:    IN std_logic;
    reset_n:  IN std_logic;           --low active
    inp: IN std_logic;
    result: OUT unsigned (output_width-1 downto 0)
  );
END activitycounter;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

ARCHITECTURE activitycounter_beh OF activitycounter IS

  signal s_cnt: unsigned(output_width-1 downto 0);
  signal s_inp: std_logic;
  constant result_max: unsigned := to_unsigned(2**(output_width-1)-1, output_width);

BEGIN

  result <= s_cnt;

  counting: process(clk, reset_n)
  begin
    if(clk'event and clk='1') then
      if(reset_n = '0') then
        s_cnt <= (others => '0');

      elsif(reset_n = '1') then
        if(s_cnt >= 0 and s_cnt <= result_max) then
          if((inp xor s_inp)='1') then
          	s_cnt <= s_cnt + 1;
          end if;
        end if;
      end if;
      s_inp <= inp;
    end if;
  END process;


END activitycounter_beh;