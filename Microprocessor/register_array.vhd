LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY register_array IS
    GENERIC (
        size : integer := 8
    );
    PORT (
        clk           : IN STD_LOGIC;
        rst           : IN STD_LOGIC;
        loadW         : IN STD_LOGIC;
        loadZ         : IN STD_LOGIC;
        loadB         : IN STD_LOGIC;
        loadC         : IN STD_LOGIC;
        loadD         : IN STD_LOGIC;
        loadE         : IN STD_LOGIC;
        loadH         : IN STD_LOGIC;
        loadL         : IN STD_LOGIC;
        loadSP_H      : IN STD_LOGIC;
        loadSP_L      : IN STD_LOGIC;
        loadPC_H      : IN STD_LOGIC;
        loadPC_L      : IN STD_LOGIC;
        incPC         : IN STD_LOGIC;
        incSP         : IN STD_LOGIC;
        decSP         : IN STD_LOGIC;
        incAdd        : IN STD_LOGIC;
        xChange       : IN STD_LOGIC;
        selDataOut    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        selAddresOut  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        dataIn        : IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        dataOut       : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        addressOutH   : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0);
        addressOutL   : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0)
    );
END register_array;

ARCHITECTURE behavioral OF register_array IS
    SIGNAL Din              : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Ein              : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Hin              : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Lin              : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Wout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Zout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Bout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Cout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Dout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Eout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Hout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Lout             : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL SPHout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL SPLout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL PCHout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL PCLout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL addressOutH_tmp  : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL addressOutL_tmp  : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL addressOut_tmp   : STD_LOGIC_VECTOR(2*size-1 DOWNTO 0);
BEGIN
--------------------------------------------------- Register W
    regW : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => dataIn,
            load    => loadW,
            init    => '0',
            dOut    => Wout
        );
--------------------------------------------------- Register Z
    regZ : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => dataIn,
            load    => loadZ,
            init    => '0',
            dOut    => Zout
        );
--------------------------------------------------- Register B
    regB : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => dataIn,
            load    => loadB,
            init    => '0',
            dOut    => Bout
        );
--------------------------------------------------- Register C
    regC : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => dataIn,
            load    => loadC,
            init    => '0',
            dOut    => Cout
        );
--------------------------------------------------- Register D
    Din <= dataIn WHEN (xChange = '0') ELSE Hout;
    regD : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => Din,
            load    => loadD,
            init    => '0',
            dOut    => Dout
        );
--------------------------------------------------- Register E
    Ein <= dataIn WHEN (xChange = '0') ELSE Lout;
    regE : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => Ein,
            load    => loadE,
            init    => '0',
            dOut    => Eout
        );
--------------------------------------------------- Register H
    Hin <= dataIn WHEN (xChange = '0') ELSE Dout;
    regH : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => Hin,
            load    => loadH,
            init    => '0',
            dOut    => Hout
        );
--------------------------------------------------- Register L
    Lin <= dataIn WHEN (xChange = '0') ELSE Eout;
    regL : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => Lin,
            load    => loadL,
            init    => '0',
            dOut    => Lout
        );
--------------------------------------------------- Stack Pointer
    regSP : ENTITY WORK.stack_pointer (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            inc     => incSP,
            dec     => decSP,
            loadH   => loadSP_H,
            loadL   => loadSP_L,
            dataIn  => dataIn,
            SPL_OUT => SPLout,
            SPH_OUT => SPHout
        );
--------------------------------------------------- Program Counter
    regPC : ENTITY WORK.program_counter (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            inc     => incPC,
            loadH   => loadPC_H,
            loadL   => loadPC_L,
            dataIn  => dataIn,
            PCL_OUT => PCLout,
            PCH_OUT => PCHout
        );
--------------------------------------------------- DataOut Multiplexer
    dataOut <= Wout   WHEN selDataOut = "0000" ELSE
               Zout   WHEN selDataOut = "0001" ELSE
               Bout   WHEN selDataOut = "0010" ELSE
               Cout   WHEN selDataOut = "0011" ELSE
               Dout   WHEN selDataOut = "0100" ELSE
               Eout   WHEN selDataOut = "0101" ELSE
               Hout   WHEN selDataOut = "0110" ELSE
               Lout   WHEN selDataOut = "0111" ELSE
               SPLout WHEN selDataOut = "1000" ELSE
               SPHout WHEN selDataOut = "1001" ELSE
               PCLout WHEN selDataOut = "1010" ELSE
               PCHout WHEN selDataOut = "1011" ELSE
               (OTHERS => '0');
--------------------------------------------------- AddressH Multiplexer
    addressOutH_tmp <= Wout   WHEN selAddresOut = "000" ELSE
                       Bout   WHEN selAddresOut = "001" ELSE
                       Dout   WHEN selAddresOut = "010" ELSE
                       Hout   WHEN selAddresOut = "011" ELSE
                       SPHout WHEN selAddresOut = "100" ELSE
                       PCHout WHEN selAddresOut = "101" ELSE
                       (OTHERS => '0');
--------------------------------------------------- AddressL Multiplexer
    addressOutL_tmp <= Zout   WHEN selAddresOut = "000" ELSE
                       Cout   WHEN selAddresOut = "001" ELSE
                       Eout   WHEN selAddresOut = "010" ELSE
                       Lout   WHEN selAddresOut = "011" ELSE
                       SPLout WHEN selAddresOut = "100" ELSE
                       PCLout WHEN selAddresOut = "101" ELSE
                       (OTHERS => '0');
--------------------------------------------------- Address Incrementing
    addressOut_tmp <= (addressOutH_tmp & addressOutL_tmp) WHEN (incAdd = '0') ELSE ((addressOutH_tmp & addressOutL_tmp) + 1);
    addressOutH <= addressOut_tmp(2*size-1 DOWNTO size);
    addressOutL <= addressOut_tmp(size-1 DOWNTO 0);

END ARCHITECTURE behavioral;