LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY tri_state is
    GENERIC (
        size: INTEGER := 8
    );
    PORT (
        dIn      : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        control  : IN STD_LOGIC;
        dOut     : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY tri_state;

ARCHITECTURE behavioral OF tri_state IS
BEGIN

    dOut <= dIn WHEN (control = '1') ELSE (OTHERS => 'Z');

END ARCHITECTURE behavioral;