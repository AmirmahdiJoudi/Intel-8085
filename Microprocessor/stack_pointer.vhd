LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY stack_pointer IS
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        inc     : IN STD_LOGIC;
        dec     : IN STD_LOGIC;
        loadH   : IN STD_LOGIC;
        loadL   : IN STD_LOGIC;
        dataIn  : IN STD_LOGIC_VECTOR (size-1 downto 0);
        SPL_OUT : out STD_LOGIC_VECTOR (size-1 downto 0);
        SPH_OUT : out STD_LOGIC_VECTOR (size-1 downto 0)
    );
END ENTITY stack_pointer;

ARCHITECTURE behavioral OF stack_pointer IS
    SIGNAL pointer : STD_LOGIC_VECTOR (2*size-1 downto 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            pointer <= (OTHERS => '0');
        ELSIF (clk = '1' AND clk'EVENT) THEN
            IF (inc = '1') THEN
                pointer <= pointer + 1;
            ELSIF (dec = '1') THEN
                pointer <= pointer - 1;
            ELSIF (loadL = '1') THEN
                pointer (size-1 DOWNTO 0) <= dataIn;
            ELSIF (loadH = '1') THEN
                pointer (2*size-1 DOWNTO size) <= dataIn;
            END IF;
        END IF;
    END PROCESS ;
    SPL_OUT <= pointer (size-1 DOWNTO 0);
    SPH_OUT <= pointer (2*size-1 DOWNTO size);
END ARCHITECTURE behavioral;