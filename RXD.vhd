library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY RXD IS
PORT(
CLK: IN std_logic;
BUSY: OUT std_logic;
DATA: OUT std_logic_vector(7 downto 0);
RX_IN: IN std_logic
);
END RXD;


ARCHITECTURE MAIN OF RXD IS

SIGNAL DATA_IN: std_logic_vector(9 downto 0);
SIGNAL PRSC: INTEGER RANGE 0 to 5207:=0;
SIGNAL INDEX: INTEGER RANGE 0 to 9:=0;
SIGNAL FLG: std_logic;

BEGIN
PROCESS(CLK)
BEGIN
	IF(CLK'EVENT AND CLK='1')THEN
		IF(FLG='0' AND RX_IN='0')THEN
			INDEX<=0;
			PRSC<=0;
			FLG<='1';
			BUSY<='1';
		ELSE
			FLG<='0';
			BUSY<='0';
		END IF;
		IF(FLG='1')THEN
		DATA_IN(INDEX)<=RX_IN;
			IF(PRSC<5207)THEN
				PRSC<= PRSC+1;
			ELSE
				PRSC<=0;
			END IF;
			IF(PRSC=2600)THEN
				IF(INDEX<9)THEN
					INDEX<=INDEX+1;
				ELSE
					IF(DATA_IN(0)='0' AND DATA_IN(9)='1')THEN
						DATA<=DATA_IN(8 downto 1);
					ELSE
						DATA<=(OTHERS=>'0');
					END IF;
					FLG<='0';
					BUSY<='0';
				END IF;
			END IF;
		END IF;
	END IF;
END PROCESS;
END MAIN;
