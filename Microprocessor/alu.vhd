LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL ;
use IEEE.numeric_std.all;

ENTITY alu IS
    GENERIC (
        size : INTEGER := 8
    );
    PORT (
        dataInA  : IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        dataInB  : IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        op       : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin      : IN STD_LOGIC;
        inVisCin : IN STD_LOGIC;
        CY       : OUT STD_LOGIC;
        ACY      : OUT STD_LOGIC;
        SGN      : OUT STD_LOGIC;
        PARITY   : OUT STD_LOGIC;
        ZERO     : OUT STD_LOGIC;
        dataOut  : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0)
    );
END ENTITY alu;



ARCHITECTURE behavioral OF alu IS
    SIGNAL dataOut_temp : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL SUM          : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL COUT         : STD_LOGIC_VECTOR(size DOWNTO 0);
    SIGNAL cin_temp     : STD_LOGIC;
    SIGNAL dataInA_temp : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL dataInB_temp : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
BEGIN

    COUT(0) <= cin_temp;
    ADDER: FOR i IN 0 TO size-1 GENERATE
        SUM(i) <= dataInA_temp(i) XOR dataInB_temp(i) XOR cout(i);
        COUT(i+1) <= (dataInA_temp(i) AND dataInB_temp(i)) OR (dataInA_temp(i) AND COUT(i)) OR (dataInB_temp(i) AND COUT(i));
    END GENERATE;

    PROCESS (dataInA, dataInB, cin, op, SUM, COUT)
    BEGIN
        CASE op IS
            WHEN "0000" => ----------------------------- ADD: A + B
                dataInA_temp <= dataInA;
                dataInB_temp <= dataInB;
                cin_temp <= '0';
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT (size);
            WHEN "0001" => ----------------------------- ADDC: A + B + cin
                dataInA_temp <= dataInA;
                dataInB_temp <= dataInB;
                cin_temp <= cin;
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT(size);
            WHEN "0010" => ----------------------------- SUB: A - B
                dataInA_temp <= dataInA;
                dataInB_temp <= NOT(dataInB);
                cin_temp <= '1';
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT(size);
            WHEN "0011" => ----------------------------- SBB: A - B - cin
                dataInA_temp <= dataInA;
                dataInB_temp <= NOT(dataInB);
                cin_temp <= NOT(cin);
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT(size);
            WHEN "0100" => ----------------------------- INC: B + 1
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= dataInB;
                cin_temp <= '1';
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT(size);
            WHEN "0101" => ----------------------------- DEC: B - 1
                dataInA_temp <= dataInB;
                dataInB_temp <= "11111110";
                cin_temp <= '1';
                dataOut_temp <= SUM;
                ACY  <= COUT(size/2);
                CY   <= COUT(size);
            WHEN "0110" => ----------------------------- AND: A and B
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= dataInA AND dataInB;
                ACY  <= '0';
                CY   <= '0';
            WHEN "0111" => ----------------------------- OR:‌ A or B
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= dataInA OR dataInB;
                ACY  <= '0';
                CY   <= '0';
            WHEN "1000" => ----------------------------- XOR:‌ A xor B
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= dataInA XOR dataInB;
                ACY  <= '0';
                CY   <= '0';
            WHEN "1001" => ----------------------------- RLC: A(size-2 DOWNTO 0) & A(size)
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= dataInA(size-2 DOWNTO 0) & dataInA(size-1);
                ACY  <= '0';
                CY   <= dataInA(size-1);
            WHEN "1010" => ----------------------------- RRC: A(0) & A(size-1 DOWNTO 1)
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= dataInA(0) & dataInA(size-1 DOWNTO 1);
                ACY  <= '0';
                CY   <= dataInA(0);
            WHEN "1011" => ----------------------------- NOT A
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= NOT(dataInA);
                ACY  <= '0';
                CY   <= '0';
            WHEN "1100" => ----------------------------- NOT CY
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= (OTHERS => '0');
                ACY  <= '0';
                CY   <= NOT(cin);
            WHEN "1101" => ----------------------------- SET CY
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= (OTHERS => '0');
                ACY  <= '0';
                CY   <= '1';
            WHEN "1110" => ----------------------------- INX
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= dataInB;
                cin_temp <= inVisCin;
                dataOut_temp <= SUM;
                ACY  <= '0';
                CY   <= '0';
            WHEN "1111" => ----------------------------- DCX
                dataInA_temp <= dataInB;
                dataInB_temp <= "11111111";
                cin_temp <= inVisCin;
                dataOut_temp <= SUM;
                ACY  <= '0';
                CY   <= '0';
            WHEN OTHERS =>
                dataInA_temp <= (OTHERS => '0');
                dataInB_temp <= (OTHERS => '0');
                cin_temp <= '0';
                dataOut_temp <= (OTHERS => '0');
                ACY  <= '0';
                CY   <= '0';
        END CASE;
    END PROCESS;

    dataOut <= dataOut_temp;
    PARITY <= dataOut_temp(0) XOR dataOut_temp(1) XOR dataOut_temp(2) XOR dataOut_temp(3) XOR dataOut_temp(4) XOR dataOut_temp(5) XOR dataOut_temp(6) XOR dataOut_temp(7);
    ZERO <= NOT(dataOut_temp(0) OR dataOut_temp(1) OR dataOut_temp(2) OR dataOut_temp(3) OR dataOut_temp(4) OR dataOut_temp(5) OR dataOut_temp(6) OR dataOut_temp(7));
    SGN <= dataOut_temp(size-1);

END ARCHITECTURE behavioral;