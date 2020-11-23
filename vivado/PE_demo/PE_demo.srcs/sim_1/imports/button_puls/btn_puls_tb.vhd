-------------------------------------------------------------------------------
--Project : 5AHELO ESY
--Author  : Thomas Kotrba
--Date    : 18.09.2013
--File    : ticktack_fsm.vhd
--Design  : Altera DE0-Nano Board
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;
--------------------------------------------------------------------------------
entity btn_puls_tb is
end btn_puls_tb;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
architecture tb of btn_puls_tb is
  component btn_puls
	PORT  ( RESET_n :  IN std_logic;
           CLK     :  IN std_logic;
		   btn   : IN std_logic;
           PULS  : OUT std_logic);
   END component;
  --============================================================================
  signal s_clk_50   : std_logic;
  signal s_reset_n  : std_logic;  
  signal s_btn		: std_LOGIC;
  signal s_puls     : std_logic;
  --&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  begin
    --==========================================================================
    P_ticktack:btn_puls 
		PORT map   ( RESET_n => s_reset_n,
				CLK     => s_clk_50,
				btn   => s_btn,
				PULS  => s_puls);
    --==========================================================================
    P_clk: process
    begin
      s_clk_50 <= '1';
      wait for 10 ns;
      s_clk_50 <= '0';
      wait for 10 ns;
    end process;
    
    p_reset: process
    begin
	 s_reset_n <= '0';
      wait for 100 ns;
	  s_reset_n <= '1';
	  wait for 1980 ns;
    end process;
	
	p_btn: process
    begin
	 s_btn <= '0';
      wait for 270 ns;
	  s_btn <= '1';
	  wait for 810 ns;
    end process;
  --&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
end tb;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
