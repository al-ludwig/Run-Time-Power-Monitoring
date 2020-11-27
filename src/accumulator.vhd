library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

constant DATA_WIDTH         : integer   := 8;
constant RESULT_WIDTH       : integer   := 8;

type DATA_TYPE          is  std_logic_vector(DATA_WIDTH-1 downto 0);
type RESULT_TYPE        is  std_logic_vector(RESULT_WIDTH-1 downto 0);
type DATA_ARRAY_TYPE    is  array(integer range <>) of DATA_TYPE;

entity accumulator is
    generic (
        INPUT_NUM   : integer := 1
        DATA_WIDTH  : integer := 8
    );
	port (
        summands    : in    DATA_ARRAY_TYPE(INPUT_NUM-1 downto 0);
        result      : out   RESULT_TYPE
	);
end accumulator;

architecture syn of accumulator is
    signal data_sig     : DATA_TYPE;
    signal result_sig   : RESULT_TYPE;

begin

    output : process(data_sig)
        variable sum : integer range -(2**(DATA_WIDTH-1)) to (2**(DATA_WIDTH-1)-1) := 0;
    begin
        for j in 0 to INPUT_NUM-1 loop
            sum := sum + to_integer(signed(data(j)));
        end loop;
        result_sig <= std_logic_vector(to_signed(sum, DATA_WIDTH));
    end process;

end architecture syn;