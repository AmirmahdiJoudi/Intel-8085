LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FFregister is
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        pLoad   : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        load0   : IN STD_LOGIC;
        load1   : IN STD_LOGIC;
        load2   : IN STD_LOGIC;
        load3   : IN STD_LOGIC;
        load4   : IN STD_LOGIC;
        load5   : IN STD_LOGIC;
        load6   : IN STD_LOGIC;
        load7   : IN STD_LOGIC;
        init    : IN STD_LOGIC;
        dOut    : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY FFregister;

ARCHITECTURE behavioral OF FFregister IS
BEGIN
    PROCESS (clk, rst)
        VARIABLE dOut_t : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
    BEGIN
        IF (rst = '1') THEN
            dOut_t := (OTHERS => '0');
        ELSIF (clk = '1' AND clk'EVENT) THEN
            IF (init = '1') THEN
                dOut_t := (OTHERS => '0');
            ELSE
                IF (load0 = '1') THEN
                    dOut_t(0) := pLoad(0);
                END IF;
                IF (load1 = '1') THEN
                    dOut_t(1) := pLoad(1);
                END IF;
                IF (load2 = '1') THEN
                    dOut_t(2) := pLoad(2);
                END IF;
                IF (load3 = '1') THEN
                    dOut_t(3) := pLoad(3);
                END IF;
                IF (load4 = '1') THEN
                    dOut_t(4) := pLoad(4);
                END IF;
                IF (load5 = '1') THEN
                    dOut_t(5) := pLoad(5);
                END IF;
                IF (load6 = '1') THEN
                    dOut_t(6) := pLoad(6);
                END IF;
                IF (load7 = '1') THEN
                    dOut_t(7) := pLoad(7);
                END IF;
            END IF;
        END IF;
        dOut <= dOut_t;
    END PROCESS;

END ARCHITECTURE behavioral;