-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects 
-- VHDL project: VHDL code for a single-port RAM 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- A 128x8 single-port RAM in VHDL
entity Single_port_RAM_VHDL is
port(
 RAM_ADDR: in std_logic_vector(7 downto 0); -- Address to write/read RAM
 RAM_DATA_IN: in std_logic_vector(15 downto 0); -- Data to write into RAM
 RAM_WR: in std_logic; -- Write enable 
 RAM_CLOCK: in std_logic; -- clock input for RAM
 RAM_DATA_OUT: out std_logic_vector(15 downto 0); -- Data output of RAM
 RAM_RESTN: in std_logic -- low active reset
);
end Single_port_RAM_VHDL;

architecture Behavioral of Single_port_RAM_VHDL is
    -- define the new type for the 256x16 RAM 
    type RAM_ARRAY is array (0 to 255 ) of std_logic_vector (15 downto 0);
    -- initial values in the RAM
    signal RAM: RAM_ARRAY; 

    begin

    process(RAM_CLOCK)
    begin
        if(rising_edge(RAM_CLOCK)) then
            if(RAM_RESTN = '0') then
                RAM <= (others => x"1234");
            elsif(RAM_WR='1') then -- when write enable = 1, 
                -- write input data into RAM at the provided address
                RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN;
                -- The index of the RAM array type needs to be integer so
                -- converts RAM_ADDR from std_logic_vector -> Unsigned -> Interger using numeric_std library
            elsif(RAM_WR='0') then -- when write enable = 0
                -- read from RAM at the provided address
                RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
            end if;
        end if;
    end process;
end Behavioral;