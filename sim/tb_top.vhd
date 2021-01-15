library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity tb_top is
end tb_top;

architecture tb_top_beh of tb_top is

    component top 
        port(
            clk:            in std_logic;
            en:             in std_logic;
            reset_n:        in std_logic;
            RAM_ADDR:       in std_logic_vector(7 downto 0);
            RAM_DATA_IN:    in std_logic_vector(15 downto 0);
            RAM_WR:         in std_logic;
            RAM_DATA_OUT:   out std_logic_vector(15 downto 0);
            p_dyn:          out real;
            activity:       out unsigned(7 downto 0)
    );
    end component;

    signal s_clk:               std_logic := '0';
    signal s_en:                std_logic := '0';
    signal s_reset_n:           std_logic := '1';
    signal s_RAM_ADDR:          std_logic_vector(7 downto 0);
    signal s_RAM_DATA_IN:       std_logic_vector(15 downto 0);
    signal s_RAM_WR:            std_logic;
    signal s_RAM_DATA_OUT:      std_logic_vector(15 downto 0);
    signal s_p_dyn:             real := 0.0;
    signal s_activity:          unsigned(7 downto 0);

    begin

        uut: entity work.top(top_behav) port map(
            clk => s_clk,
            en => s_en,
            reset_n => s_reset_n,
            RAM_ADDR => s_RAM_ADDR,
            RAM_DATA_IN => s_RAM_DATA_IN,
            RAM_WR => s_RAM_WR,
            RAM_DATA_OUT => s_RAM_DATA_OUT,
            p_dyn => s_p_dyn,
            activity => s_activity
        );

        s_clk <= not s_clk after 10 ns;

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

        p_WR: process
        begin
            wait for 20 ns;
            --write block
            s_RAM_ADDR <= x"01";
            s_RAM_WR <= '1';
            s_RAM_DATA_IN <= x"FAC1";
            wait for 40 ns;
            s_RAM_ADDR <= x"05";
            s_RAM_WR <= '1';
            s_RAM_DATA_IN <= x"DDE1";
            wait for 40 ns;
            s_RAM_ADDR <= x"F1";
            s_RAM_WR <= '1';
            s_RAM_DATA_IN <= x"00F2";
            wait for 40 ns;

            --read block
            s_RAM_ADDR <= x"01";
            s_RAM_WR <= '0';
            wait for 40 ns;
            s_RAM_ADDR <= x"03";
            s_RAM_WR <= '0';
            wait for 40 ns;
            s_RAM_ADDR <= x"F1";
            s_RAM_WR <= '0';
            wait for 40 ns;
            s_RAM_ADDR <= x"05";
            s_RAM_WR <= '0';
            wait for 40 ns;
        end process;

end tb_top_beh;