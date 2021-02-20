--==============================================================================
-- project: Run-Time-Power-Monitoring
--==============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.fxd_arith_pkg.all;
use work.rtpm_pkg.all;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

entity top is
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
end top;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

architecture struct of top is

    signal s_clk     : std_logic;
    signal s_en      : std_logic;
    signal s_reset_n : std_logic;
    signal s_inp     : std_logic;

    signal s_RAM_ADDR     : std_logic_vector(7 downto 0);
    signal s_RAM_DATA_IN  : std_logic_vector(15 downto 0);
    signal s_RAM_WR       : std_logic;
    signal s_RAM_DATA_OUT : std_logic_vector(15 downto 0);

    signal s_activity : activity_array_type;
    signal s_p_dyn    : res_fxd_type;

    signal s_ac_inp: std_logic_vector(activity_count-1 downto 0);

begin

    s_clk         <= clk;
    s_en          <= en;
    s_reset_n     <= reset_n;
    s_RAM_ADDR    <= RAM_ADDR;
    s_RAM_DATA_IN <= RAM_DATA_IN;
    s_RAM_WR      <= RAM_WR;
    RAM_DATA_OUT  <= s_RAM_DATA_OUT;
    p_dyn         <= s_p_dyn;

    s_ac_inp(0) <= s_RAM_WR;
    s_ac_inp(4 downto 1) <= s_RAM_DATA_IN(3 downto 0);
    s_ac_inp(8 downto 5) <= s_RAM_DATA_OUT(3 downto 0);
    ----------------------------------------------------------------------------
    dut_ram : sp_ram port map(
        RAM_ADDR     => s_RAM_ADDR,
        RAM_DATA_IN  => s_RAM_DATA_IN,
        RAM_WR       => s_RAM_WR,
        RAM_CLOCK    => s_clk,
        RAM_DATA_OUT => s_RAM_DATA_OUT,
        RAM_RESTN    => s_reset_n
    );
    ----------------------------------------------------------------------------
    dut_calc : calc generic map(
        multiplier => c_multiplier
    )
    port map(
        clk      => s_clk,
        en       => s_en,
        reset_n  => s_reset_n,
        activity => s_activity,
        p_dyn    => s_p_dyn
    );
    ----------------------------------------------------------------------------
    gen_ac: for i in 0 to activity_count - 1 generate
        dut_ac : ac port map(
            clk     => s_clk,
            reset_n => s_reset_n,
            inp     => s_ac_inp(i),
            result  => s_activity(i)
        );
    end generate;
    ----------------------------------------------------------------------------
end struct;