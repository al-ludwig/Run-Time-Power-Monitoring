library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

entity scaler is
    generic (
        INPUT_WIDTH         : integer   := 8;
        RESULT_WIDTH        : integer   := 2*INPUT_WIDTH;
        FACTOR_RANGE_MIN    : integer   := -(2**(INPUT_WIDTH-1));
        FACTOR_RANGE_MAX    : integer   := (2**(INPUT_WIDTH-1))-1
    );
    port (
        reset   :   in  std_logic;
        clk     :   in  std_logic;
        data    :   in  std_logic_vector(INPUT_WIDTH-1 downto 0);
        factor  :   in  integer range FACTOR_RANGE_MIN to FACTOR_RANGE_MAX;
        result  :   out std_logic_vector(RESULT_WIDTH-1 downto 0)
    );
end entity scaler_accumulator;

architecture syn of scaler is

    signal mult_result  : std_logic_vector(RESULT_WIDTH-1 downto 0);

begin
    data_sig    <= data;
    factor_sig  <= std_logic_vector(to_signed(factor, DATA_WIDTH));
    result      <= mult_result;

    mult_inst : mult
        generic map (
            DATA_WIDTH      => DATA_WIDTH,
            RESULT_WIDTH    => RESULT_WIDTH
        )
        port map (
            reset   =>  reset,
            clk     =>  clk,
            dataa   =>  input,
            datab   =>  factors_sig,
            result  =>  mult_result
        );
end architecture syn;