LIBRARY ieee;
USE ieee.math_real.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
--=============================================================================
ENTITY btn_puls IS
	PORT(RESET_n : IN  std_logic;
		 CLK     : IN  std_logic;
		 btn     : IN  std_logic;
		 PULS    : OUT std_logic);
END btn_puls;
--=============================================================================

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ARCHITECTURE rtl OF btn_puls IS
	--===========================================================================
	type statetype is (ST_IDLE, ST_PULSE, ST_WAIT);
	signal state             : statetype := ST_IDLE;
	signal signal_level_last : std_logic := '0';
--===========================================================================
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BEGIN
	--===========================================================================
	label_puls : PROCESS(CLK, RESET_n)
	BEGIN
		IF (RESET_n = '0') THEN
			state <= ST_IDLE;
			PULS  <= '0';
		ELSIF (CLK'EVENT and CLK = '1') THEN
			IF (state = ST_IDLE) then
				PULS <= '0';
				if (btn /= signal_level_last) then
					state             <= ST_PULSE;
					signal_level_last <= btn;
				else
					State <= ST_IDLE;
				end if;
			ELSIF (state = ST_PULSE) then
				PULS  <= '1';
				state <= ST_IDLE;
			END IF;
		END IF;
	END PROCESS;
--===========================================================================
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
END rtl;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@