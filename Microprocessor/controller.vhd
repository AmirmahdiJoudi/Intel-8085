LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY controller IS
    GENERIC (
        size : INTEGER := 8
    );
    PORT (
        -- CLK GEN
        clk                : IN STD_LOGIC;
        -- RESET
        RESETn_IN          : IN STD_LOGIC;
        -- Control
        RDn                : OUT STD_LOGIC;
        WRn                : OUT STD_LOGIC;
        ALE                : OUT STD_LOGIC;
        -- Status
        S0                 : OUT STD_LOGIC;
        S1                 : OUT STD_LOGIC;
        IO_Mn              : OUT STD_LOGIC;
        -- Control Signals
        inst               : IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        CYout              : IN STD_LOGIC;
        ACYout             : IN STD_LOGIC;
        Pout               : IN STD_LOGIC;
        Zout               : IN STD_LOGIC;
        Sout               : IN STD_LOGIC;
        loadA              : OUT STD_LOGIC;
        loadT              : OUT STD_LOGIC;
        loadCYflag         : OUT STD_LOGIC;
        loadPflag          : OUT STD_LOGIC;
        loadACYflag        : OUT STD_LOGIC;
        loadZflag          : OUT STD_LOGIC;
        loadSflag          : OUT STD_LOGIC;
        loadI              : OUT STD_LOGIC;
        loadW              : OUT STD_LOGIC;
        loadZ              : OUT STD_LOGIC;
        loadB              : OUT STD_LOGIC;
        loadC              : OUT STD_LOGIC;
        loadD              : OUT STD_LOGIC;
        loadE              : OUT STD_LOGIC;
        loadH              : OUT STD_LOGIC;
        loadL              : OUT STD_LOGIC;
        loadSP_L           : OUT STD_LOGIC;
        loadSP_H           : OUT STD_LOGIC;
        loadPC_L           : OUT STD_LOGIC;
        loadPC_H           : OUT STD_LOGIC;
        incPC              : OUT STD_LOGIC;
        incSP              : OUT STD_LOGIC;
        decSP              : OUT STD_LOGIC;
        incAdd             : OUT STD_LOGIC;
        xChange            : OUT STD_LOGIC;
        AccInEn            : OUT STD_LOGIC;
        FlagsInEn          : OUT STD_LOGIC;
        aluInEn            : OUT STD_LOGIC;
        regArrInEn         : OUT STD_LOGIC;
        AddHInEn           : OUT STD_LOGIC;
        AddLInEn           : OUT STD_LOGIC;
        AddDtIsel          : OUT STD_LOGIC;
        AddDtOsel          : OUT STD_LOGIC;
        AddDtInOutSel      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        opSel              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        selArrData         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        selArrAdd          : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
      );
END controller;

ARCHITECTURE behavioral OF controller IS
    TYPE state IS (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17);
    SIGNAL pstate, nstate : state;
    SIGNAL rst            : STD_LOGIC;
BEGIN
    rst  <= NOT(RESETn_IN);
    ------------------------------------------------------------ State Machine
    PROCESS (pstate, inst) BEGIN
        nstate <= T0;
        CASE pstate IS
            WHEN T0  =>
                nstate <= T1;
            WHEN T1  =>
                nstate <= T2;
            WHEN T2  =>
                nstate <= T3;
            WHEN T3  =>
                IF (inst(7 DOWNTO 6) = "01") THEN
                    IF (inst(5 DOWNTO 3) = "110" OR inst(2 DOWNTO 0) = "110") THEN
                        nstate <= T4;
                    ELSE
                        nstate <= T0;
                    END IF;
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "110") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    nstate <= T4;
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 5) = "000" AND inst(1 DOWNTO 0) = "10") THEN
                    nstate <= T4;
                ELSIF (inst = "11101011") THEN
                    nstate <= T0;
                ELSIF ((inst(7 DOWNTO 5) = "100" AND inst(2 DOWNTO 0) /= "110")) THEN
                    nstate <= T0;
                ELSIF  (inst(7 DOWNTO 6) = "00" AND inst(5 DOWNTO 3) /= "110" AND (inst(2 DOWNTO 0) = "100" OR inst(2 DOWNTO 0) = "101")) THEN
                    nstate <= T0;
                ELSIF ((inst(7 DOWNTO 5) = "100" OR inst(7 DOWNTO 5) = "110") AND inst(2 DOWNTO 0) = "110") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "011") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 5) = "101") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 4) = "0000" AND inst(2 DOWNTO 0) = "111") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 5) = "001" AND inst(2 DOWNTO 0) = "111") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 0) = "11111110") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    nstate <= T4;
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    nstate <= T4;
                END IF;
            WHEN T4  =>
                nstate <= T5;
            WHEN T5  =>
                IF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "011") THEN
                    nstate <= T0;
                ELSE
                    nstate <= T6;
                END IF;
            WHEN T6  =>
                IF (inst(7 DOWNTO 3) = "01110") THEN
                    nstate <= T0;
                ELSIF (inst = "00110110") THEN
                    nstate <= T7;
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    nstate <= T7;
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    nstate <= T7;
                ELSIF (inst(7 DOWNTO 5) = "000" AND inst(1 DOWNTO 0) = "10") THEN
                    nstate <= T0;
                ELSIF ((inst(7 DOWNTO 5) = "100" OR inst(7 DOWNTO 5) = "110") AND inst(2 DOWNTO 0) = "110") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    nstate <= T7;
                ELSIF (inst(7 DOWNTO 0) = "11111110") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    nstate <= T7;
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    nstate <= T7;
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    nstate <= T7;
                END IF;
            WHEN T7  =>
                nstate <= T8;
            WHEN T8  =>
                nstate <= T9;
            WHEN T9  =>
                IF (inst = "00110110") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    nstate <= T0;
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    nstate <= T10;
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    nstate <= T10;
                END IF;
            WHEN T10 =>
                nstate <= T11;
            WHEN T11 =>
                nstate <= T12;
            WHEN T12 =>
                IF (inst = "00111010" OR inst = "00110010") THEN
                    nstate <= T0;
                ELSIF (inst = "00101010" OR inst = "00100010") THEN
                    nstate <= T13;
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    nstate <= T13;
                END IF;
            WHEN T13 =>
                nstate <= T14;
            WHEN T14 =>
                nstate <= T15;
            WHEN T15 =>
                IF (inst = "00101010" OR inst = "00100010") THEN
                    nstate <= T0;
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    nstate <= T16;
                END IF;
            WHEN T16 =>
                nstate <= T17;
            WHEN T17 =>
                nstate <= T0;
            WHEN OTHERS =>
                nstate <= T0;
        END CASE;
    END PROCESS;

    PROCESS (pstate, inst) BEGIN
        RDn            <= '1';
        WRn            <= '1';
        ALE            <= '1';
        S0             <= '0';
        S1             <= '0';
        IO_Mn          <= '0';
        loadA          <= '0';
        loadT          <= '0';
        loadCYflag     <= '0';
        loadPflag      <= '0';
        loadACYflag    <= '0';
        loadZflag      <= '0';
        loadSflag      <= '0';
        loadI          <= '0';
        loadW          <= '0';
        loadZ          <= '0';
        loadB          <= '0';
        loadC          <= '0';
        loadD          <= '0';
        loadE          <= '0';
        loadH          <= '0';
        loadL          <= '0';
        loadSP_L       <= '0';
        loadSP_H       <= '0';
        loadPC_L       <= '0';
        loadPC_H       <= '0';
        incPC          <= '0';
        incSP          <= '0';
        decSP          <= '0';
        incAdd         <= '0';
        xChange        <= '0';
        AccInEn        <= '0';
        FlagsInEn      <= '0';
        aluInEn        <= '0';
        regArrInEn     <= '0';
        AddHInEn       <= '0';
        AddLInEn       <= '0';
        AddDtIsel      <= '0';
        AddDtOsel      <= '0';
        AddDtInOutSel  <= (OTHERS => '0');
        opSel          <= (OTHERS => '0');
        selArrData     <= (OTHERS => '0');
        selArrAdd      <= (OTHERS => '0');
        CASE pstate IS
            WHEN T0  =>
                ALE           <= '1';
                IO_Mn         <= '0';
                S0            <= '1';
                S1            <= '1';
                selArrAdd     <= "101"; -- select PC
                AddHInEn      <= '1';
                AddLInEn      <= '1';
                AddDtInOutSel <= "00";
                AddDtOsel     <= '1';
            WHEN T1  =>
                ALE           <= '0';
                RDn           <= '0';
                IO_Mn         <= '0';
                S0            <= '1';
                S1            <= '1';
                AddDtOsel     <= '1';
                incPC         <= '1';
            WHEN T2  =>
                ALE           <= '0';
                S0            <= '1';
                S1            <= '1';
                AddLInEn      <= '1';
                AddDtInOutSel <= "10";
                AddDtIsel     <= '1';
                loadI         <= '1';
            WHEN T3  =>
                ALE           <= '0';
                S0            <= '1';
                S1            <= '1';
                --------------------------------------------------------------------- MOV RR
                AddDtOsel     <= '1';
                IF (inst(7 DOWNTO 6) = "01") THEN
                    ALE               <= '0';
                    IO_Mn             <= '0';
                    S1                <= '1';
                    S1                <= '1';
                    CASE inst(5 DOWNTO 3) IS
                        WHEN "000" =>
                            loadB <= '1';
                        WHEN "001" =>
                            loadC <= '1';
                        WHEN "010" =>
                            loadD <= '1';
                        WHEN "011" =>
                            loadE <= '1';
                        WHEN "100" =>
                            loadH <= '1';
                        WHEN "101" =>
                            loadL <= '1';
                        WHEN "111" =>
                            loadA <= '1';
                        WHEN OTHERS =>
                    END CASE;
                    CASE inst(2 DOWNTO 0) IS
                        WHEN "000" =>
                            selArrData <= "0010";
                            regArrInEn <= '1';
                        WHEN "001" =>
                            selArrData <= "0011";
                            regArrInEn <= '1';
                        WHEN "010" =>
                            selArrData <= "0100";
                            regArrInEn <= '1';
                        WHEN "011" =>
                            selArrData <= "0101";
                            regArrInEn <= '1';
                        WHEN "100" =>
                            selArrData <= "0110";
                            regArrInEn <= '1';
                        WHEN "101" =>
                            selArrData <= "0111";
                            regArrInEn <= '1';
                        WHEN "111" =>
                            AccInEn <= '1';
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- MVI M
                ELSIF (inst = "00110110") THEN
                --------------------------------------------------------------------- MVI R
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "110") THEN
                --------------------------------------------------------------------- XCHG
                ELSIF (inst = "11101011") THEN
                    xChange <= '1';
                    loadD <= '1';
                    loadE <= '1';
                    loadH <= '1';
                    loadL <= '1';
                --------------------------------------------------------------------- ARITH R
                ELSIF ((inst(7 DOWNTO 5) = "100" AND inst(2 DOWNTO 0) /= "110") OR (inst(7 DOWNTO 6) = "00" AND (inst(2 DOWNTO 0) = "100" OR inst(2 DOWNTO 0) = "101"))) THEN
                    aluInEn      <= '1';
                    loadT        <= '1';
                    loadPflag    <= '1';
                    loadACYflag  <= '1';
                    loadZflag    <= '1';
                    loadSflag    <= '1';
                    IF (inst(7 DOWNTO 5) = "100") THEN
                        loadA        <= '1';
                        loadCYflag   <= '1';
                        CASE inst(2 DOWNTO 0) IS
                            WHEN "000" =>
                                selArrData <= "0010";
                                regArrInEn <= '1';
                            WHEN "001" =>
                                selArrData <= "0011";
                                regArrInEn <= '1';
                            WHEN "010" =>
                                selArrData <= "0100";
                                regArrInEn <= '1';
                            WHEN "011" =>
                                selArrData <= "0101";
                                regArrInEn <= '1';
                            WHEN "100" =>
                                selArrData <= "0110";
                                regArrInEn <= '1';
                            WHEN "101" =>
                                selArrData <= "0111";
                                regArrInEn <= '1';
                            WHEN "111" =>
                                AccInEn <= '1';
                            WHEN OTHERS =>
                        END CASE;
                        CASE inst(4 DOWNTO 3) IS
                            WHEN "00" => -- ADD: A + B
                                opSel <= "0000";
                            WHEN "01" => -- ADDC: A + B + cin
                                opSel <= "0001";
                            WHEN "10" => -- SUB: A - B
                                opSel <= "0010";
                            WHEN "11" => -- SBB: A - B - cin
                                opSel <= "0011";
                            WHEN OTHERS =>
                        END CASE;
                    ELSE
                        CASE inst(5 DOWNTO 3) IS
                            WHEN "000" =>
                                loadB <= '1';
                                selArrData <= "0010";
                                regArrInEn <= '1';
                            WHEN "001" =>
                                loadC <= '1';
                                selArrData <= "0011";
                                regArrInEn <= '1';
                            WHEN "010" =>
                                loadD <= '1';
                                selArrData <= "0100";
                                regArrInEn <= '1';
                            WHEN "011" =>
                                loadE <= '1';
                                selArrData <= "0101";
                                regArrInEn <= '1';
                            WHEN "100" =>
                                loadH <= '1';
                                selArrData <= "0110";
                                regArrInEn <= '1';
                            WHEN "101" =>
                                loadL <= '1';
                                selArrData <= "0111";
                                regArrInEn <= '1';
                            WHEN "111" =>
                                loadA <= '1';
                                AccInEn <= '1';
                            WHEN OTHERS =>
                        END CASE;
                        CASE inst(2 DOWNTO 0) IS
                            WHEN "100" => -- INC
                                opSel <= "0100";
                            WHEN "101" => -- DEC
                                opSel <= "0101";
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- ARITH M I
                ELSIF ((inst(7 DOWNTO 5) = "100" OR inst(7 DOWNTO 5) = "110") AND inst(2 DOWNTO 0) = "110") THEN
                --------------------------------------------------------------------- Logical R
                ELSIF (inst(7 DOWNTO 5) = "101") THEN
                    aluInEn      <= '1';
                    loadT        <= '1';
                    loadPflag    <= '1';
                    loadCYflag   <= '1';
                    loadACYflag  <= '1';
                    loadZflag    <= '1';
                    loadSflag    <= '1';
                    CASE inst(2 DOWNTO 0) IS
                        WHEN "000" =>
                            selArrData <= "0010";
                            regArrInEn <= '1';
                        WHEN "001" =>
                            selArrData <= "0011";
                            regArrInEn <= '1';
                        WHEN "010" =>
                            selArrData <= "0100";
                            regArrInEn <= '1';
                        WHEN "011" =>
                            selArrData <= "0101";
                            regArrInEn <= '1';
                        WHEN "100" =>
                            selArrData <= "0110";
                            regArrInEn <= '1';
                        WHEN "101" =>
                            selArrData <= "0111";
                            regArrInEn <= '1';
                        WHEN "111" =>
                            AccInEn <= '1';
                        WHEN OTHERS =>
                    END CASE;
                    CASE inst(4 DOWNTO 3) IS
                            WHEN "00" =>
                                opSel <= "0110";
                                loadA <= '1';
                            WHEN "01" =>
                                opSel <= "1000";
                                loadA <= '1';
                            WHEN "10" =>
                                opSel <= "0111";
                                loadA <= '1';
                            WHEN "11" =>
                                opSel <= "0010";
                                loadA <= '0';
                            WHEN OTHERS =>
                        END CASE;
                --------------------------------------------------------------------- Rotate
                ELSIF (inst(7 DOWNTO 4) = "0000" AND inst(2 DOWNTO 0) = "111") THEN
                    aluInEn      <= '1';
                    loadCYflag   <= '1';
                    loadA <= '1';
                    IF (inst(3) = '0') THEN
                        opSel <= "1001";
                    ELSE
                        opSel <= "1010";
                    END IF;
                --------------------------------------------------------------------- Specials
                ELSIF (inst(7 DOWNTO 5) = "001" AND inst(2 DOWNTO 0) = "111") THEN
                    aluInEn      <= '1';
                    CASE inst(4 DOWNTO 3) IS
                        WHEN "01" =>
                            loadA <= '1';
                            opSel <= "1011";
                        WHEN "10" =>
                            opSel <= "1101";
                            loadCYflag <= '1';
                        WHEN "11" =>
                            opSel <= "1100";
                            loadCYflag   <= '1';
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    IO_Mn <= '1';
                    ALE   <= '0';
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    IO_Mn <= '1';
                END IF;
            WHEN T4  =>
                ALE               <= '1';
                IO_Mn             <= '0';
                S0                <= '0';
                S1                <= '1';
                AddHInEn          <= '1';
                AddLInEn          <= '1';
                AddDtInOutSel     <= "00";
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- MOV MR RM
                IF (inst(7 DOWNTO 6) = "01") THEN
                    selArrAdd     <= "011"; -- select HL
                    IF (inst(5 DOWNTO 3) = "110") THEN
                        S0                <= '1';
                        S1                <= '0';
                    ELSE
                        S0                <= '0';
                        S1                <= '1';
                    END IF;
                --------------------------------------------------------------------- MVI R M
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "110") THEN
                    selArrAdd     <= "101"; -- select PC
                    ALE               <= '1';
                    IO_Mn             <= '0';
                    S0                <= '0';
                    S1                <= '1';
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        selArrAdd     <= "101"; -- select PC
                    ELSE
                        loadZ <= '1';
                        AccInEn <= '1';
                        S0        <= '1';
                        S1        <= '1';
                        ALE       <= '0';
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    selArrAdd         <= "101"; -- select PC
                    S0                <= '0';
                    S1                <= '1';
                --------------------------------------------------------------------- LDAX - STAX
                ELSIF (inst(7 DOWNTO 5) = "000" AND inst(1 DOWNTO 0) = "10") THEN
                    IF (inst(4 DOWNTO 2) = "010" OR inst(4 DOWNTO 2) = "000") THEN
                        IF (inst(4 DOWNTO 2) = "010") THEN
                            S0            <= '0';
                            S1            <= '1';
                        ELSE
                            S0            <= '1';
                            S1            <= '0';
                        END IF;
                        selArrAdd     <= "001"; -- select BC
                    ELSIF (inst(4 DOWNTO 2) = "110" OR inst(4 DOWNTO 2) = "100") THEN
                        IF (inst(4 DOWNTO 2) = "110") THEN
                            S0            <= '0';
                            S1            <= '1';
                        ELSE
                            S0            <= '1';
                            S1            <= '0';
                        END IF;
                        selArrAdd         <= "010"; -- select DE
                    END IF;
                --------------------------------------------------------------------- ARITH I
                ELSIF (inst(7 DOWNTO 5) = "110" AND inst(2 DOWNTO 0) = "110") THEN
                    selArrAdd     <= "101"; -- select PC
                --------------------------------------------------------------------- ARITH M
                ELSIF (inst(7 DOWNTO 5) = "100" AND inst(2 DOWNTO 0) = "110") THEN
                    selArrAdd     <= "011"; -- select HL
                --------------------------------------------------------------------- ARITH INX DCX
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "011") THEN
                    aluInEn      <= '1';
                    loadT        <= '1';
                    regArrInEn   <= '1';
                    S0           <= '1';
                    S1           <= '1';
                    CASE inst(5 DOWNTO 4) IS
                        WHEN "00" =>
                            selArrData <= "0011";
                            loadC      <= '1';
                        WHEN "01" =>
                            selArrData <= "0101";
                            loadE      <= '1';
                        WHEN "10" =>
                            selArrData <= "0111";
                            loadL      <= '1';
                        WHEN OTHERS =>
                    END CASE;
                    CASE inst(3) IS
                        WHEN '0' => -- INC
                            opSel <= "0100";
                        WHEN '1' => -- DEC
                            opSel <= "0101";
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    selArrAdd     <= "011"; -- select HL
                    S0           <= '0';
                    S1           <= '1';
                --------------------------------------------------------------------- Logical I
                ELSIF (inst(7 DOWNTO 0) = "11111110") THEN
                    selArrAdd     <= "101"; -- select PC
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    selArrAdd     <= "101"; -- select PC
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    selArrAdd     <= "100"; -- select SP
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    --selArrAdd     <= "101"; -- select PC
                    S0           <= '1';
                    S1           <= '1';
                    IO_Mn        <= '1';
                    ALE          <= '0';
                    AddHInEn     <= '0';
                    AddLInEn     <= '0';
                END IF;
            WHEN T5  =>
                ALE               <= '0';
                IO_Mn             <= '0';
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- MOV MR
                IF (inst(7 DOWNTO 3) = "01110") THEN
                    S0            <= '1';
                    S1            <= '0';
                    WRn           <= '0';
                    AddDtInOutSel <= "01";
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                    CASE inst(2 DOWNTO 0) IS
                        WHEN "000" =>
                            selArrData <= "0010";
                            regArrInEn    <= '1';
                        WHEN "001" =>
                            selArrData <= "0011";
                            regArrInEn    <= '1';
                        WHEN "010" =>
                            selArrData <= "0100";
                            regArrInEn    <= '1';
                        WHEN "011" =>
                            selArrData <= "0101";
                            regArrInEn    <= '1';
                        WHEN "100" =>
                            selArrData <= "0110";
                            regArrInEn    <= '1';
                        WHEN "101" =>
                            selArrData <= "0111";
                            regArrInEn    <= '1';
                        WHEN "111" =>
                            AccInEn <= '1';
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- MOV RM - MVI R - MVI M
                ELSIF ((inst(7 DOWNTO 6) = "01" OR inst(7 DOWNTO 6) = "00") AND inst(2 DOWNTO 0) = "110") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    ALE               <= '0';
                    IO_Mn             <= '0';
                    S0                <= '0';
                    S1                <= '1';
                    IF (inst(7 DOWNTO 6) = "00") THEN
                        incPC     <= '1';
                    END IF;
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        AddDtInOutSel <= "00";
                        S0            <= '0';
                        S1            <= '1';
                        RDn           <= '0';
                        incPC         <= '1';
                    ELSE
                        S0                <= '1';
                        S1                <= '1';
                        ALE               <= '0';
                        AddHInEn          <= '0';
                        AddLInEn          <= '0';
                        loadA             <= '1';
                        regArrInEn        <= '1';
                        selArrData        <= "0111";
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incPC         <= '1';
                --------------------------------------------------------------------- LDAX - STAX
                ELSIF (inst(7 DOWNTO 5) = "000" AND inst(1 DOWNTO 0) = "10") THEN
                    IF (inst(4 DOWNTO 2) = "010" OR inst(4 DOWNTO 2) = "110") THEN
                        AddDtInOutSel <= "00";
                        S0            <= '0';
                        S1            <= '1';
                        RDn           <= '0';
                    ELSIF (inst(4 DOWNTO 2) = "000" OR inst(4 DOWNTO 2) = "100") THEN
                        S0            <= '1';
                        S1            <= '0';
                        WRn           <= '0';
                        AddDtInOutSel <= "01";
                        AddDtOsel     <= '1';
                        AddLInEn      <= '1';
                        AccInEn       <= '1';
                    END IF;
                --------------------------------------------------------------------- ARITH M I
                ELSIF ((inst(7 DOWNTO 5) = "100" OR inst(7 DOWNTO 5) = "110") AND inst(2 DOWNTO 0) = "110") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    IF (inst(7 DOWNTO 6) = "11") THEN
                        incPC     <= '1';
                    END IF;
                --------------------------------------------------------------------- ARITH INX DCX
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "011") THEN
                    aluInEn      <= '1';
                    loadT        <= '1';
                    regArrInEn   <= '1';
                    S0           <= '1';
                    S1           <= '1';
                    CASE inst(5 DOWNTO 4) IS
                        WHEN "00" =>
                            selArrData <= "0010";
                            loadB      <= '1';
                        WHEN "01" =>
                            selArrData <= "0100";
                            loadD      <= '1';
                        WHEN "10" =>
                            selArrData <= "0110";
                            loadH      <= '1';
                        WHEN OTHERS =>
                    END CASE;
                    CASE inst(3) IS
                        WHEN '0' => -- INC
                            opSel <= "1110";
                        WHEN '1' => -- DEC
                            opSel <= "1111";
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                --------------------------------------------------------------------- Logical I
                ELSIF (inst(7 DOWNTO 0) = "11111110") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incPC     <= '1';
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incPC     <= '1';
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incSP     <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    --selArrAdd     <= "101"; -- select PC
                    S0           <= '1';
                    S1           <= '1';
                    IO_Mn        <= '1';
                END IF;
            WHEN T6  =>
                ALE               <= '0';
                S0                <= '1';
                S1                <= '1';
                --------------------------------------------------------------------- MOV MR
                IF (inst(7 DOWNTO 3) = "01110") THEN
                    AddDtInOutSel <= "01";
                    AddDtOsel     <= '1';
                    S0            <= '1';
                    S1            <= '0';
                    CASE inst(2 DOWNTO 0) IS
                        WHEN "000" =>
                            selArrData <= "0010";
                            regArrInEn    <= '1';
                        WHEN "001" =>
                            selArrData <= "0011";
                            regArrInEn    <= '1';
                        WHEN "010" =>
                            selArrData <= "0100";
                            regArrInEn    <= '1';
                        WHEN "011" =>
                            selArrData <= "0101";
                            regArrInEn    <= '1';
                        WHEN "100" =>
                            selArrData <= "0110";
                            regArrInEn    <= '1';
                        WHEN "101" =>
                            selArrData <= "0111";
                            regArrInEn    <= '1';
                        WHEN "111" =>
                            AccInEn <= '1';
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- MVI M
                ELSIF (inst = "00110110") THEN
                    S0            <= '0';
                    S1            <= '1';
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadZ         <= '1';
                --------------------------------------------------------------------- MOV RM - MVI R
                ELSIF ((inst(7 DOWNTO 6) = "01" OR inst(7 DOWNTO 6) = "00") AND inst(2 DOWNTO 0) = "110") THEN
                    ALE               <= '0';
                    IO_Mn             <= '0';
                    S0                <= '0';
                    S1                <= '1';
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    CASE inst(5 DOWNTO 3) IS
                        WHEN "000" =>
                            loadB <= '1';
                        WHEN "001" =>
                            loadC <= '1';
                        WHEN "010" =>
                            loadD <= '1';
                        WHEN "011" =>
                            loadE <= '1';
                        WHEN "100" =>
                            loadH <= '1';
                        WHEN "101" =>
                            loadL <= '1';
                        WHEN "111" =>
                            loadA <= '1';
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        S0            <= '0';
                        S1            <= '1';
                        AddDtInOutSel <= "10";
                        AddDtIsel     <= '1';
                        AddLInEn      <= '1';
                        CASE inst(5 DOWNTO 3) IS
                            WHEN "000" =>
                                loadC <= '1';
                            WHEN "010" =>
                                loadE <= '1';
                            WHEN "100" =>
                                loadL <= '1';
                            WHEN OTHERS =>
                        END CASE;
                    ELSE
                        S0            <= '1';
                        S1            <= '1';
                        ALE           <= '0';
                        loadT         <= '1';
                        opSel         <= "0000";
                        aluInEn       <= '1';
                        regArrInEn    <= '1';
                        loadCYflag    <= '1';
                        AddDtOsel     <= '1';
                        loadL         <= '1';
                        CASE inst(5 DOWNTO 4) IS
                            WHEN "00" =>
                                selArrData <= "0011";
                            WHEN "01" =>
                                selArrData <= "0101";
                            WHEN "10" =>
                                selArrData <= "0111";
                            WHEN "11" =>
                                selArrData <= "1000";
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadZ         <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- LDAX - STAX
                ELSIF (inst(7 DOWNTO 5) = "000" AND inst(1 DOWNTO 0) = "10") THEN
                    IF (inst(4 DOWNTO 2) = "010" OR inst(4 DOWNTO 2) = "110") THEN
                        AddDtInOutSel <= "10";
                        AddDtIsel     <= '1';
                        AddLInEn      <= '1';
                        loadA         <= '1';
                        S0            <= '0';
                        S1            <= '1';
                    ELSIF (inst(4 DOWNTO 2) = "000" OR inst(4 DOWNTO 2) = "100") THEN
                        AddDtInOutSel <= "01";
                        AddDtOsel     <= '1';
                        AccInEn       <= '1';
                        S0            <= '1';
                        S1            <= '0';
                    END IF;
                --------------------------------------------------------------------- ARITH M I
                ELSIF ((inst(7 DOWNTO 5) = "100" OR inst(7 DOWNTO 5) = "110") AND inst(2 DOWNTO 0) = "110") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadA         <= '1';
                    loadT         <= '1';
                    aluInEn       <= '1';
                    loadCYflag    <= '1';
                    loadPflag     <= '1';
                    loadACYflag   <= '1';
                    loadZflag     <= '1';
                    loadSflag     <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    CASE inst(4 DOWNTO 3) IS
                        WHEN "00" => -- ADD: A + B
                            opSel <= "0000";
                        WHEN "01" => -- ADDC: A + B + cin
                            opSel <= "0001";
                        WHEN "10" => -- SUB: A - B
                            opSel <= "0010";
                        WHEN "11" => -- SBB: A - B - cin
                            opSel <= "0011";
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadT         <= '1';
                    loadZ         <= '1';
                    aluInEn       <= '1';
                    loadPflag     <= '1';
                    loadACYflag   <= '1';
                    loadZflag     <= '1';
                    loadSflag     <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    CASE inst(0) IS
                        WHEN '0' => -- INC
                            opSel <= "0100";
                        WHEN '1' => -- DEC
                            opSel <= "0101";
                        WHEN OTHERS =>
                    END CASE;
                --------------------------------------------------------------------- Logical I
                ELSIF (inst(7 DOWNTO 0) = "11111110") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadT         <= '1';
                    aluInEn       <= '1';
                    loadCYflag    <= '1';
                    loadPflag     <= '1';
                    loadACYflag   <= '1';
                    loadZflag     <= '1';
                    loadSflag     <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    opSel         <= "0010";
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    IF (inst(5 DOWNTO 3) = "000" AND inst(0) = '1') THEN
                        loadZ         <= '1';
                    ELSIF(inst(0) = '0') THEN
                        CASE (inst(5 DOWNTO 3)) IS
                            WHEN "000" =>
                                IF (Zout = '0') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "001" =>
                                IF (Zout = '1') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "010" =>
                                IF (CYout = '0') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "011" =>
                                IF (CYout = '1') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "100" =>
                                IF (Pout = '0') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "101" =>
                                IF (Pout = '1') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "110" =>
                                IF (Sout = '0') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN "111" =>
                                IF (Sout = '1') THEN
                                    loadZ <= '1';
                                ELSE
                                    loadZ <= '0';
                                END IF;
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadPC_L      <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    selArrAdd         <= "101"; -- select PC
                    S0                <= '0';
                    S1                <= '1';
                    ALE               <= '1';
                    AddHInEn          <= '1';
                    AddLInEn          <= '1';
                    AddDtInOutSel     <= "00";
                    AddDtOsel         <= '1';
                END IF;
                ---------------------------------------------------------------------
            WHEN T7  =>
                IO_Mn             <= '0';
                S0                <= '1';
                S1                <= '1';
                AddHInEn          <= '1';
                AddLInEn          <= '1';
                AddDtInOutSel     <= "00";
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- MVI M
                IF (inst = "00110110") THEN
                    selArrAdd     <= "011"; -- select HL
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        selArrAdd     <= "101"; -- select PC
                        S0            <= '0';
                        S1            <= '1';
                    ELSE
                        S0                <= '1';
                        S1                <= '1';
                        ALE               <= '0';
                        AddHInEn          <= '0';
                        AddLInEn          <= '0';
                        loadA             <= '1';
                        regArrInEn        <= '1';
                        selArrData        <= "0110";
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    selArrAdd     <= "101"; -- select PC
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    selArrAdd     <= "011"; -- select HL
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    S0            <= '0';
                    S1            <= '1';
                    IF (inst(5 DOWNTO 3) = "000" AND inst(0) = '1') THEN
                        selArrAdd     <= "101"; -- select PC
                        regArrInEn    <= '1';
                        selArrData    <= "0001";
                        loadPC_L      <= '1';
                    ELSIF(inst(0) = '0') THEN
                        CASE (inst(5 DOWNTO 3)) IS
                            WHEN "000" =>
                                IF (Zout = '0') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "001" =>
                                IF (Zout = '1') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "010" =>
                                IF (CYout = '0') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "011" =>
                                IF (CYout = '1') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "100" =>
                                IF (Pout = '0') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "101" =>
                                IF (Pout = '1') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "110" =>
                                IF (Sout = '0') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN "111" =>
                                IF (Sout = '1') THEN
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '1';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '1';
                                ELSE
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    selArrData    <= "0001";
                                    loadPC_L      <= '0';
                                END IF;
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    selArrAdd     <= "100"; -- select SP
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    AddHInEn      <= '0';
                    AddLInEn      <= '0';
                    incPC         <= '1';
                END IF;
            WHEN T8  =>
                ALE               <= '0';
                IO_Mn             <= '0';
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- MVI M
                IF (inst = "00110110") THEN
                    WRn           <= '0';
                    S0            <= '1';
                    S1            <= '0';
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                    selArrData    <= "0001";
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        AddDtInOutSel <= "00";
                        S0            <= '0';
                        S1            <= '1';
                        RDn           <= '0';
                        incPC         <= '1';
                    ELSE
                        S0            <= '1';
                        S1            <= '1';
                        ALE           <= '0';
                        loadT         <= '1';
                        opSel         <= "0001";
                        aluInEn       <= '1';
                        regArrInEn    <= '1';
                        loadCYflag    <= '1';
                        loadH         <= '1';
                        CASE inst(5 DOWNTO 4) IS
                            WHEN "00" =>
                                selArrData <= "0010";
                            WHEN "01" =>
                                selArrData <= "0100";
                            WHEN "10" =>
                                selArrData <= "0110";
                            WHEN "11" =>
                                selArrData <= "0111";
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incPC         <= '1';
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    WRn           <= '0';
                    S0            <= '1';
                    S1            <= '0';
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                    selArrData    <= "0001";
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incSP         <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadZ         <= '1';
                    AddDtOsel     <= '0';
                    S0            <= '0';
                    S1            <= '1';
                END IF;
            WHEN T9  =>
                ALE               <= '0';
                S0                <= '1';
                S1                <= '1';
                --------------------------------------------------------------------- MVI M
                IF (inst = "00110110") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    AddDtOsel     <= '1';
                    selArrData    <= "0001";
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- LXI - DAD
                ELSIF (inst(7 DOWNTO 6) = "00" AND inst(2 DOWNTO 0) = "001") THEN
                    IF (inst(3) = '0') THEN
                        AddDtInOutSel <= "10";
                        AddDtIsel     <= '1';
                        AddLInEn      <= '1';
                        S0            <= '0';
                        S1            <= '1';
                        CASE inst(5 DOWNTO 3) IS
                            WHEN "000" =>
                                loadB <= '1';
                            WHEN "010" =>
                                loadD <= '1';
                            WHEN "100" =>
                                loadH <= '1';
                            WHEN OTHERS =>
                        END CASE;
                    ELSE
                        S0            <= '1';
                        S1            <= '1';
                        ALE           <= '0';
                        loadA         <= '1';
                        AddDtOsel     <= '1';
                        selArrData    <= "0001";
                        regArrInEn    <= '1';
                    END IF;
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                ELSIF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadW         <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- INR M - DCR M
                ELSIF (inst(7 DOWNTO 1) = "0011010") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    AddDtOsel     <= '1';
                    selArrData    <= "0001";
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- JUMP
                ELSIF (inst(7 DOWNTO 6) = "11" AND inst(2 DOWNTO 1) = "01") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    IF (inst(5 DOWNTO 3) = "000" AND inst(0) = '1') THEN
                        loadPC_H      <= '1';
                    ELSIF(inst(0) = '0') THEN
                        CASE (inst(5 DOWNTO 3)) IS
                            WHEN "000" =>
                                IF (Zout = '0') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "001" =>
                                IF (Zout = '1') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "010" =>
                                IF (CYout = '0') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "011" =>
                                IF (CYout = '1') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "100" =>
                                IF (Pout = '0') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "101" =>
                                IF (Pout = '1') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "110" =>
                                IF (Sout = '0') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN "111" =>
                                IF (Sout = '1') THEN
                                    selArrAdd     <= "101";
                                    loadPC_H      <= '1';
                                ELSE
                                    incPC         <= '1';
                                    selArrAdd     <= "101";
                                    regArrInEn    <= '0';
                                    loadPC_H      <= '0';
                                END IF;
                            WHEN OTHERS =>
                        END CASE;
                    END IF;
                --------------------------------------------------------------------- Return
                ELSIF (inst(7 DOWNTO 0) = "11001001") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadPC_H      <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    selArrAdd     <= "101"; -- select PC
                    ALE           <= '1';
                    S0            <= '0';
                    S1            <= '1';
                    AddDtInOutSel <= "00";
                    AddDtOsel     <= '1';
                    AddHInEn      <= '1';
                    AddLInEn      <= '1';
                --------------------------------------------------------------------- Call
                -- ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                --     AddDtInOutSel <= "10";
                --     AddDtIsel     <= '1';
                --     AddLInEn      <= '1';
                --     loadZ         <= '1';
                --     decSP         <= '1';
                END IF;
            WHEN T10 =>
                IO_Mn             <= '0';
                S0                <= '1';
                S1                <= '1';
                AddHInEn          <= '1';
                AddLInEn          <= '1';
                AddDtInOutSel     <= "00";
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- LDA - STA - LHLD - SHLD
                IF (inst = "00111010" OR inst = "00110010" OR inst = "00101010" OR inst = "00100010") THEN
                    selArrAdd     <= "000"; -- select WZ
                    IF (inst = "00111010") THEN
                        S0            <= '0';
                        S1            <= '1';
                    ELSIF (inst = "00110010") THEN
                        S0            <= '1';
                        S1            <= '0';
                    ELSIF (inst = "00101010") THEN
                        S0            <= '0';
                        S1            <= '1';
                    ELSE
                        S0            <= '1';
                        S1            <= '0';
                    END IF;
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                    incPC         <= '1';
                    AddDtOsel     <= '1';
                    AddHInEn      <= '0';
                    AddLInEn      <= '0';
                END IF;
            WHEN T11 =>
                ALE               <= '0';
                IO_Mn             <= '0';
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- LDA - LHLD
                IF (inst = "00111010" OR inst = "00101010") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                --------------------------------------------------------------------- STA - SHLD
                ELSIF (inst = "00110010" OR inst = "00100010") THEN
                    S0            <= '1';
                    S1            <= '0';
                    WRn           <= '0';
                    AddDtInOutSel <= "01";
                    IF (inst = "00110010") THEN
                        AccInEn       <= '1';
                    ELSIF (inst = "00100010") THEN
                        regArrInEn    <= '1';
                        selArrData    <= "0111";
                    END IF;
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadW         <= '1';
                    AddDtOsel     <= '0';
                    decSP         <= '1';
                    S0            <= '1';
                    S1            <= '0';
                END IF;
            WHEN T12 =>
                ALE               <= '0';
                S0                <= '1';
                S1                <= '1';
                --------------------------------------------------------------------- LDA
                IF (inst = "00111010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadA         <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- LHLD
                ELSIF (inst = "00101010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadL         <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- STA
                ELSIF (inst = "00110010") THEN
                    AddDtInOutSel <= "01";
                    AccInEn       <= '1';
                    AddDtOsel     <= '1';
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- SHLD
                ELSIF (inst = "00100010") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "0111";
                    AddDtOsel     <= '1';
                    S0            <= '1';
                    S1            <= '0';
                -- --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    selArrAdd         <= "100"; -- select SP
                    IO_Mn             <= '0';
                    S0                <= '1';
                    S1                <= '0';
                    ALE               <= '1';
                    AddHInEn          <= '1';
                    AddLInEn          <= '1';
                    AddDtInOutSel     <= "00";
                    AddDtOsel         <= '1';
                END IF;
            WHEN T13 =>
                IO_Mn             <= '0';
                S0                <= '1';
                S1                <= '1';
                AddHInEn          <= '1';
                AddLInEn          <= '1';
                AddDtInOutSel     <= "00";
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- LHLD - SHLD
                IF (inst = "00101010" OR inst = "00100010") THEN
                    selArrAdd     <= "000"; -- select WZ
                    incAdd            <= '1';
                    IF (inst = "00101010") THEN
                        S0                <= '0';
                        S1                <= '1';
                    ELSE
                        S0                <= '1';
                        S1                <= '0';
                    END IF;
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    S0            <= '1';
                    S1            <= '0';
                    WRn           <= '0';
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "1011";
                    AddDtOsel     <= '1';
                    AddHInEn      <= '0';
                    AddLInEn      <= '1';
                END IF;
            WHEN T14 =>
                ALE               <= '0';
                IO_Mn             <= '0';
                AddDtOsel         <= '1';
                --------------------------------------------------------------------- LHLD
                IF (inst = "00101010") THEN
                    AddDtInOutSel <= "00";
                    S0            <= '0';
                    S1            <= '1';
                    RDn           <= '0';
                --------------------------------------------------------------------- SHLD
                ELSIF (inst = "00100010") THEN
                    S0            <= '1';
                    S1            <= '0';
                    WRn           <= '0';
                    AddDtInOutSel <= "01";
                    IF (inst = "00110010") THEN
                        AccInEn       <= '1';
                    ELSIF (inst = "00100010") THEN
                        regArrInEn    <= '1';
                        selArrData    <= "0110";
                    END IF;
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "0000";
                    loadPC_H      <= '1';
                    decSP         <= '1';
                    S0            <= '1';
                    S1            <= '0';
                END IF;
            WHEN T15 =>
                ALE               <= '0';
                S0                <= '1';
                S1                <= '1';
                --------------------------------------------------------------------- LHLD
                IF (inst = "00101010") THEN
                    AddDtInOutSel <= "10";
                    AddDtIsel     <= '1';
                    AddLInEn      <= '1';
                    loadH         <= '1';
                    S0            <= '0';
                    S1            <= '1';
                --------------------------------------------------------------------- SHLD
                ELSIF (inst = "00100010") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "0110";
                    AddDtOsel     <= '1';
                    S0            <= '1';
                    S1            <= '0';
                --------------------------------------------------------------------- Call
                ELSIF (inst(7 DOWNTO 0) = "11001101") THEN
                    selArrAdd     <= "100"; -- select SP
                    S0            <= '1';
                    S1            <= '0';
                    AddHInEn      <= '1';
                    AddLInEn      <= '1';
                    AddDtInOutSel <= "00";
                    AddDtOsel     <= '1';
                    ALE           <= '1';
                END IF;
            WHEN T16 =>
                --------------------------------------------------------------------- Call
                IF (inst(7 DOWNTO 0) = "11001101") THEN
                    S0            <= '1';
                    S1            <= '0';
                    WRn           <= '0';
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "1010";
                    AddDtOsel     <= '1';
                    AddLInEn      <= '1';
                END IF;
            WHEN T17 =>
                --------------------------------------------------------------------- Call
                IF (inst(7 DOWNTO 0) = "11001101") THEN
                    AddDtInOutSel <= "01";
                    regArrInEn    <= '1';
                    selArrData    <= "0001";
                    AddDtOsel     <= '1';
                    S0            <= '1';
                    S1            <= '0';
                    loadPC_L      <= '1';
                END IF;
            WHEN OTHERS =>
                RDn            <= '1';
                WRn            <= '1';
                ALE            <= '1';
                S0             <= '0';
                S1             <= '0';
                IO_Mn          <= '0';
                loadA          <= '0';
                loadT          <= '0';
                loadCYflag     <= '0';
                loadPflag      <= '0';
                loadACYflag    <= '0';
                loadZflag      <= '0';
                loadSflag      <= '0';
                loadI          <= '0';
                loadW          <= '0';
                loadZ          <= '0';
                loadB          <= '0';
                loadC          <= '0';
                loadD          <= '0';
                loadE          <= '0';
                loadH          <= '0';
                loadL          <= '0';
                loadSP_L       <= '0';
                loadSP_H       <= '0';
                loadPC_L       <= '0';
                loadPC_H       <= '0';
                incPC          <= '0';
                incSP          <= '0';
                decSP          <= '0';
                incAdd         <= '0';
                xChange        <= '0';
                AccInEn        <= '0';
                FlagsInEn      <= '0';
                aluInEn        <= '0';
                regArrInEn     <= '0';
                AddHInEn       <= '0';
                AddLInEn       <= '0';
                AddDtIsel      <= '0';
                AddDtOsel      <= '0';
                AddDtInOutSel  <= (OTHERS => '0');
                opSel          <= (OTHERS => '0');
                selArrData     <= (OTHERS => '0');
                selArrAdd      <= (OTHERS => '0');
        END CASE;
    END PROCESS;

    sequential : PROCESS (clk, rst) BEGIN
        IF rst = '1' THEN
            pstate <= T0;
        ELSIF (clk = '1' AND clk'EVENT) THEN
            pstate <= nstate;
        END IF;
    END PROCESS sequential;

END ARCHITECTURE behavioral;