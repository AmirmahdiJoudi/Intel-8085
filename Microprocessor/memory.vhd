LIBRARY IEEE;
LIBRARY STD;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
USE IEEE.std_logic_textio.ALL;
USE STD.textio.ALL;

ENTITY memory IS
    GENERIC
    (
        dataWidth       : INTEGER := 8;
        addressWidth    : INTEGER := 16;
        blockSize       : integer := 2 ** 16
    );
    PORT
    (
        clk             : IN    STD_LOGIC;
        readmem         : IN    STD_LOGIC;
        writemem        : IN    STD_LOGIC;
        addressBus      : IN    STD_LOGIC_VECTOR (addressWidth - 1 DOWNTO 0);
        dataBus         : INOUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0)
    );
END memory;

ARCHITECTURE behavioral OF memory IS
    TYPE mem_type IS ARRAY (0 TO blockSize - 1) OF STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR (addressWidth - 1 DOWNTO 0);
---------------------------------------------------------------------------- MemLoad Procedure
    PROCEDURE MemLoad (buffermem : OUT mem_type) IS
        VARIABLE memline   : LINE;
        VARIABLE offset    : INTEGER := 0;
        VARIABLE err_check : FILE_OPEN_STATUS;
        VARIABLE hexcode_v : STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0);
        FILE fle           : TEXT;
    BEGIN
        buffermem := (OTHERS => (OTHERS => '0'));
        FILE_OPEN (err_check, fle, ("../Memory/program.hex"), READ_MODE);
        IF err_check = OPEN_OK THEN
            WHILE NOT ENDFILE (fle) LOOP
                READLINE (fle, memline);
                HREAD (memline, hexcode_v);
                buffermem (offset) := hexcode_v;
                offset             := offset + 1;
            END LOOP;
            FILE_CLOSE (fle);
        END IF;
    END MemLoad;
---------------------------------------------------------------------------- updateFILE Procedure
    PROCEDURE updateFILE (buffermem : IN mem_type) IS
        VARIABLE memline   : LINE;
        VARIABLE err_check : FILE_OPEN_STATUS;
        FILE fle           : TEXT;
    BEGIN
        FILE_OPEN (err_check, fle, ("../Memory/programRes.hex"), WRITE_MODE);
        IF err_check = OPEN_OK THEN
            FOR i IN 0 TO blockSize - 1 LOOP
                HWRITE (memline, buffermem (i));
                WRITELINE (fle, memline);
            END LOOP;
            FILE_CLOSE (fle);
        END IF;
    END updateFILE;
BEGIN
---------------------------------------------------------------------------- main
    ADD : PROCESS(addressBus)
    BEGIN
        IF (writemem /= '0') THEN
            address <= addressBus;
        END IF;
    END PROCESS;

    RW : PROCESS
        VARIABLE buffermem         : mem_type := (OTHERS => (OTHERS => '0'));
        VARIABLE addressBusInteger : INTEGER;
        VARIABLE memLoadedNum      : INTEGER := 1;
        VARIABLE blockID           : INTEGER;
        VARIABLE init              : BOOLEAN := true;
    BEGIN
        IF (init = true) THEN
            MemLoad (buffermem);
            memLoadedNum := 1;
            init         := false;
            dataBus <= (OTHERS => 'Z');
        END IF;
        WAIT FOR 0 ns;
        addressBusInteger := to_integer(unsigned(address));
        IF (readmem = '0') THEN
            WAIT FOR 20 ns;
            dataBus <= buffermem (addressBusInteger);
            WAIT FOR 20 ns;
            dataBus <= (OTHERS => 'Z');
        ELSIF (writemem = '0') THEN
            WAIT FOR 5 ns;
            buffermem (addressBusInteger) := dataBus;
            UpdateFILE (buffermem);
        END IF;
        WAIT ON writemem, readmem;
    END PROCESS;
END behavioral;

