library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top is
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
end top;


architecture top_behav of top is
    
    component activitycounter
    generic(
      output_width:   NATURAL
    );
    port(
      clk:    IN std_logic;
      reset_n:  IN std_logic;           --low active
      inp: IN std_logic;
      result: OUT unsigned (output_width-1 downto 0)
    );
    end component;


    component Single_port_RAM_VHDL
    port(
        RAM_ADDR: in std_logic_vector(7 downto 0); -- Address to write/read RAM
        RAM_DATA_IN: in std_logic_vector(15 downto 0); -- Data to write into RAM
        RAM_WR: in std_logic; -- Write enable 
        RAM_CLOCK: in std_logic; -- clock input for RAM
        RAM_DATA_OUT: out std_logic_vector(15 downto 0); -- Data output of RAM
        RAM_RESTN: in std_logic -- low active reset
    );
    end component;


    component calc
    generic(
        vdd_squared : REAL;
        frequency   : natural;
        capacitance : REAL;
        input_width : natural
    );
    port(
        clk      : in std_logic;
        en       : in std_logic;
        reset_n  : in std_logic;
        activity : in unsigned (input_width - 1 downto 0);
        p_dyn    : out real
    );
    end component;

    constant AC_data_width: natural := 8;

    signal s_clk:       std_logic;
    signal s_en:        std_logic;
    signal s_reset_n:   std_logic;
    signal s_inp:       std_logic;

    signal s_RAM_ADDR:      std_logic_vector(7 downto 0);
    signal s_RAM_DATA_IN:   std_logic_vector(15 downto 0);
    signal s_RAM_WR:        std_logic;
    signal s_RAM_DATA_OUT:  std_logic_vector(15 downto 0);

    signal s_activity:  unsigned(AC_data_width-1 downto 0);
    signal s_p_dyn:     real;

    begin

        s_clk <= clk;
        s_en <= en;
        s_reset_n <= reset_n;
        s_RAM_ADDR <= RAM_ADDR;
        s_RAM_DATA_IN <= RAM_DATA_IN;
        s_RAM_WR <= RAM_WR;
        RAM_DATA_OUT <= s_RAM_DATA_OUT;
        p_dyn <= s_p_dyn;
        activity <= s_activity;


        RAM: Single_port_RAM_VHDL port map(
            RAM_ADDR => s_RAM_ADDR,
            RAM_DATA_IN => s_RAM_DATA_IN,
            RAM_WR => s_RAM_WR,
            RAM_CLOCK => s_clk,
            RAM_DATA_OUT => s_RAM_DATA_OUT,
            RAM_RESTN => s_reset_n
        );

        calculatepower : calc generic map(
                vdd_squared => 1.21,
                frequency   => 50e+6,
                capacitance => 8.0e-12,
                input_width => AC_data_width)
            port map(
                clk      => s_clk,
                en       => s_en,
                reset_n  => s_reset_n,
                activity => s_activity,
                p_dyn    => s_p_dyn
        );
        
        AC_WR: activitycounter generic map(
                output_width => AC_data_width)
            port map(
                clk => s_clk,
                reset_n => s_reset_n,
                inp => s_RAM_WR,
                result => s_activity
        );
            
end top_behav;