library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY UART IS
Port(
CLK_0: IN std_logic;
TRIGGER: IN std_logic_vector(3 downto 0);
DATA_SOURCE: IN std_logic_vector(7 downto 0);
UART_TX: OUT std_logic;
UART_RX: IN std_logic;
LED_PIO: OUT std_logic_vector(7 downto 0)
);
END UART;

ARCHITECTURE MAIN OF UART IS

SIGNAL TX_BUSY: STD_LOGIC:='0';
SIGNAL RX_BUSY: STD_LOGIC:='0';
SIGNAL TX_START: STD_LOGIC:='0';
SIGNAL TX_DATA: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL RX_DATA: STD_LOGIC_VECTOR(7 downto 0);
--------------------------------
COMPONENT TXD
PORT(
CLK: IN std_logic;
START: IN std_logic;
BUSY: OUT std_logic;
DATA: IN std_logic_vector(7 downto 0);
TX_OUT: OUT std_logic
);

END COMPONENT;
--------------------------------
COMPONENT RXD
PORT(
CLK: IN std_logic;
BUSY: OUT std_logic;
DATA: OUT std_logic_vector(7 downto 0);
RX_IN: IN std_logic
);
END COMPONENT;
--------------------------------
BEGIN
C1: TXD port map(CLK_0,TX_START,TX_BUSY,TX_DATA,UART_TX);
C2: RXD port map(CLK_0,RX_BUSY,RX_DATA,UART_RX);

PROCESS(RX_BUSY)
BEGIN
	IF(RX_BUSY'EVENT AND RX_BUSY='0')THEN
		LED_PIO<=RX_DATA;
	END IF;
END PROCESS;

PROCESS(CLK_0)
BEGIN
	IF(CLK_0'EVENT AND CLK_0='1')THEN
		IF(TRIGGER(0)='0' AND TX_BUSY='0')THEN
			TX_START<='1';
			TX_DATA<=DATA_SOURCE(7 downto 0);
		ELSE
			TX_START<='0';
		END IF;
	END IF;
END PROCESS;
END MAIN;