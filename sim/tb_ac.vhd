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
      output_width:   NATURAL := 8
    );
    port(
      clk:    IN std_logic;
      reset_n:  IN std_logic;           --low active
      inp: IN std_logic;
      result: OUT unsigned (output_width-1 downto 0)
    );
  end component;

  signal s_clk:   std_logic := '0';
  signal s_reset_n: std_logic := '1';
  signal s_inp:  std_logic;
  signal s_result:  unsigned(8-1 downto 0);

  begin

    uut:  activitycounter 
      generic map(
        output_width => 8)
      port map(
        clk => s_clk,
        reset_n => s_reset_n,
        inp => s_inp,
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
      s_inp <= '0';
      wait for 20 ns;
      s_inp <= '1';
      wait for 20 ns;
      s_inp <= '0';
      wait for 20 ns;
      s_inp <= '0';
      wait for 20 ns;
      s_inp <= '1';
      wait for 20 ns;
      s_inp <= '0';
      wait for 20 ns;
    end process;

end behaviour;
