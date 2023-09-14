LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY program_counter IS
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        inc     : IN STD_LOGIC;
        loadH   : IN STD_LOGIC;
        loadL   : IN STD_LOGIC;
        dataIn  : IN STD_LOGIC_VECTOR (size-1 downto 0);
        PCL_OUT : out STD_LOGIC_VECTOR (size-1 downto 0);
        PCH_OUT : out STD_LOGIC_VECTOR (size-1 downto 0)
    );
END ENTITY program_counter;

ARCHITECTURE behavioral OF program_counter IS
    SIGNAL pointer : STD_LOGIC_VECTOR (2*size-1 downto 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            pointer <= (OTHERS => '0');
        ELSIF (clk = '1' AND clk'EVENT) THEN
            IF (inc = '1') THEN
                pointer <= pointer + '1';
            ELSIF (loadL = '1') THEN
                pointer (size-1 DOWNTO 0) <= dataIn;
            ELSIF (loadH = '1') THEN
                pointer (2*size-1 DOWNTO size) <= dataIn;
            END IF;
        END IF;
    END PROCESS ;
    PCL_OUT <= pointer (size-1 DOWNTO 0);
    PCH_OUT <= pointer (2*size-1 DOWNTO size);
END ARCHITECTURE behavioral;