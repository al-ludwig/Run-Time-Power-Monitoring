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

    signal s_activity_tmp : activity_type;-- := "01010101010101010101";
    signal s_activity_stat : activity_array_type; 
    
    signal s_clk_div2 : std_logic := '0';

begin

    s_clk         <= clk;
    s_en          <= en;
    s_reset_n     <= reset_n;
    s_RAM_ADDR    <= RAM_ADDR;
    s_RAM_DATA_IN <= RAM_DATA_IN;
    s_RAM_WR      <= RAM_WR;
    RAM_DATA_OUT  <= s_RAM_DATA_OUT;
    p_dyn         <= s_p_dyn;



    s_activity_tmp <= "0000" & unsigned(RAM_DATA_IN);
    s_activity_stat <= (s_activity_tmp,s_activity_tmp,s_activity_tmp,s_activity_tmp,s_activity_tmp);
    
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
            inp     => s_clk_div2,
            result  => s_activity(i)
        );
    end generate;
    ----------------------------------------------------------------------------
    --divide clock by 2 and connect it to the activity counter input
    p_clkdiv2: process(clk)
        variable counter_var : natural := 0;
    begin
        if(rising_edge(clk)) then
            if(counter_var = 99) then
                s_clk_div2 <= not s_clk_div2;
                counter_var := 0;
            else
                counter_var := counter_var + 1;
            end if;
        end if;
    end process;
    ----------------------------------------------------------------------------
end struct;