--------------------------------------------------------------------------------
-- filename: activitycounter.vhd
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
--USE work.ac_package.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

ENTITY activitycounter is
  GENERIC(
    num_input: NATURAL;
    output_width:   NATURAL
  );
  PORT(
    clk:    IN std_logic;
    reset_n:  IN std_logic;           --low active
    inputs: IN std_logic_vector (num_input-1 downto 0);
    result: OUT signed (output_width-1 downto 0)
  );
END activitycounter;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

ARCHITECTURE activitycounter_beh OF activitycounter IS

  signal s_cnt: signed(output_width-1 downto 0);
  signal s_inputs: std_logic_vector (num_input-1 downto 0);
  constant result_max: signed := to_signed(2**(output_width-1)-1, output_width);

BEGIN

  result <= s_cnt;

  counting: process(clk, reset_n)
    VARIABLE count_ones: NATURAL;
    VARIABLE tmp_xor: std_logic_vector(num_input-1 downto 0);
  begin
    if(clk'event and clk='1') then
      if(reset_n = '0') then
        s_cnt <= to_signed(0,output_width);
        count_ones := 0;
        tmp_xor := (others => '0');

      elsif(reset_n = '1') then
        if(s_cnt >= 0 and s_cnt <= result_max) then
          -- for i in 0 to (num_input-1) loop
          --   if(inputs(i) xor s_inputs(i)) then
          --     count_ones := count_ones + 1;
          --   end if;
          -- end loop;

          tmp_xor := inputs xor s_inputs;
          
          count_ones := 0;
          for i in 0 to (num_input-1) loop
            if(tmp_xor(i) = '1') then
              count_ones := count_ones + 1;
            end if;
          end loop;

          s_cnt <= s_cnt + to_signed(count_ones, output_width);
        --else
        --  exception?
        end if;
      end if;
      s_inputs <= inputs;
    end if;
  END process;


END activitycounter_beh;