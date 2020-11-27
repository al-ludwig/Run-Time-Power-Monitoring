library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

constant DATA_WIDTH         : integer   := 8;
constant RESULT_WIDTH       : integer   := 16;
constant FACTOR_RANGE_MIN   : integer   := -(2**(DATA_WIDTH-1));
constant FACTOR_RANGE_MAX   : integer   := (2**(DATA_WIDTH-1))-1;

type DATA_TYPE          is  std_logic_vector(DATA_WIDTH-1 downto 0);
type FACTOR_TYPE        is  integer range FACTOR_RANGE_MIN to FACTOR_RANGE_MAX;
type RESULT_TYPE        is  std_logic_vector(RESULT_WIDTH-1 downto 0);
type DATA_ARRAY_TYPE    is  array(integer range <>) of DATA_TYPE;
type FACTOR_ARRAY_TYPE  is  array(integer range <>) of FACTOR_TYPE;
type SCALED_ARRAY_TYPE  is  array(integer range <>) of RESULT_TYPE;


entity scaler_accumulator is
    generic (
        INPUT_NUM   : integer   := 1
    );
    port (
        reset   :   in  std_logic;
        clk     :   in  std_logic;
        inputs  :   in  DATA_ARRAY_TYPE(INPUT_NUM-1 downto 0);
        factors :   in  FACTOR_ARRAY_TYPE(INPUT_NUM-1 downto 0);
        result  :   out RESULT_TYPE
    );
end entity scaler_accumulator;


architecture syn of scaler_accumulator is
    signal inputs_sig   : DATA_ARRAY_TYPE;
    signal factors_sig  : FACTOR_ARRAY_TYPE;
    signal result_sig   : RESULT_TYPE;
    
    signal result_next  : RESULT_TYPE;
    signal scaled       : SCALED_ARRAY_TYPE;

begin
    inputs_sig  <= inputs;
    factors_sig <= factors;
    result      <= result_sig;


    scaler_gen : for j in 0 to INPUT_NUM-1 generate
    begin
        scaler_inst : scaler
            generic map (
                DATA_WIDTH      => DATA_WIDTH,
                RESULT_WIDTH    => RESULT_WIDTH
            )
            port map (
                reset   =>  reset,
                clk     =>  clk,
                data    =>  inputs_sig(j),
                factor  =>  factors_sig(j),
                result  =>  scaled(j)
            );
    end generate;
    
    accumulator_inst : accumulator
        generic map (
            INPUT_NUM   => INPUT_NUM,
            DATA_WIDTH  => DATA_WIDTH
        )
        port map (
            summands    => scaled,
            result      => result_sig
        );
end architecture syn;