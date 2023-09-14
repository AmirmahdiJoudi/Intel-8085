LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY normalRegister is
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        pLoad   : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        load    : IN STD_LOGIC;
        init    : IN STD_LOGIC;
        dOut    : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY normalRegister;

ARCHITECTURE behavioral OF normalRegister IS
BEGIN
    PROCESS (clk, rst)
        VARIABLE dOut_t : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
    BEGIN
        IF (rst = '1') THEN
            dOut_t := "00000000";--(OTHERS => '0');
        ELSIF (clk = '1' AND clk'EVENT) THEN
            IF (init = '1') THEN
                dOut_t := (OTHERS => '0');
            ELSIF (load = '1') THEN
                dOut_t := pLoad;
            END IF;
        END IF;
        dOut <= dOut_t;
    END PROCESS;

END ARCHITECTURE behavioral;