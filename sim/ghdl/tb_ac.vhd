--------------------------------------------------------------------------------
-- filename: tb_ac.vhd
--
-- assumption: f_clk = 50MHz
-- assumption: num_inputs = 4
-- read out 'result' with 1MHz, so result_max is 200 (=> 8bit)
--------------------------------------------------------------------------------

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
--USE work.ac_package.all;
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
entity tb_ac is
  end tb_ac;
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
architecture behaviour of tb_ac is

  component activitycounter
    generic(
      num_input: NATURAL := 4;
      output_width:   NATURAL := 8
    );
    port(
      clk:    IN std_logic;
      reset_n:  IN std_logic;           --low active
      inputs: IN std_logic_vector (num_input-1 downto 0);
      result: OUT signed (output_width-1 downto 0)
    );
  end component;

  signal s_clk:   std_logic := '0';
  signal s_reset_n: std_logic := '1';
  signal s_inputs:  std_logic_vector(4-1 downto 0);
  signal s_result:  signed(8-1 downto 0);

  begin

    uut:  activitycounter 
      generic map(
        num_input => 4,
        output_width => 8)
      port map(
        clk => s_clk,
        reset_n => s_reset_n,
        inputs => s_inputs,
        result => s_result);

    s_clk <= not s_clk after 10 ns; -- 50MHz

    -- periodic reset after 1us
    resetting: process
    begin
      s_reset_n <= '0';
      wait for 20 ns;
      s_reset_n <= '1';
      wait for 980 ns;
    end process;

    -- "random" inputs
    stim: process
    begin
      --wait for 10 ns;
      s_inputs <= "0001";
      wait for 20 ns;
      s_inputs <= "0101";
      wait for 20 ns;
      s_inputs <= "1111";
      wait for 20 ns;
      s_inputs <= "0000";
      wait for 20 ns;
      s_inputs <= "1011";
      wait for 20 ns;
      s_inputs <= "1010";
      wait for 20 ns;
    end process;

end behaviour;
