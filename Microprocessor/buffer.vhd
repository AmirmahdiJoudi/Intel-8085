LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY bufferBlock is
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        dIn     : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        en      : IN STD_LOGIC;
        init    : IN STD_LOGIC;
        dOut    : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY bufferBlock;

ARCHITECTURE behavioral OF bufferBlock IS
BEGIN
    PROCESS (en, dIn  , init)
        VARIABLE dOut_t : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
    BEGIN
        IF (init = '1') THEN
            dOut_t := (OTHERS => '0');
        ELSIF (en = '1') THEN
            dOut_t := dIn;
        END IF;
        dOut <= dOut_t;
    END PROCESS;

END ARCHITECTURE behavioral;