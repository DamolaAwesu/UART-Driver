library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY TXD IS
PORT(
CLK: IN std_logic;
START: IN std_logic;
BUSY: OUT std_logic;
DATA: IN std_logic_vector(7 downto 0);
TX_OUT: OUT std_logic
);
END TXD;


ARCHITECTURE MAIN OF TXD IS

SIGNAL DATA_OUT: std_logic_vector(9 downto 0);
SIGNAL PRSC: INTEGER RANGE 0 to 5207:=0;
SIGNAL INDEX: INTEGER RANGE 0 to 9;
SIGNAL FLG: std_logic;

BEGIN
PROCESS(CLK)
BEGIN
	IF(CLK'EVENT AND CLK='1') THEN
		IF(FLG='0' AND START='1')THEN
			FLG<='1';
			BUSY<='1';
			DATA_OUT(0)<='0';
			DATA_OUT(9)<='1';
			DATA_OUT(8 downto 1)<=DATA;
		ELSE
			FLG<='0';
			BUSY<='0';
		END IF;
		IF(FLG<='1')THEN
			IF(PRSC<5207)THEN
				PRSC <= PRSC+1;
			ELSE
				PRSC<=0;
			END IF;
			IF(PRSC=2600)THEN
				TX_OUT<=DATA_OUT(INDEX);
				IF(INDEX<9)THEN
					INDEX <= INDEX+1;
				ELSE
					INDEX<=0;
					BUSY<='0';
					FLG<='0';
				END IF;
			END IF;
		END IF;
	END IF;
END PROCESS;
END MAIN;
