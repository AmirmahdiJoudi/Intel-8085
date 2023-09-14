LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cpuTB IS
END cpuTB;

ARCHITECTURE behavioral OF cpuTB IS
    SIGNAL clk                : STD_LOGIC := '0';
    SIGNAL READY              : STD_LOGIC := '1';
    SIGNAL CLK_OUT            : STD_LOGIC;
    SIGNAL RESETn_IN          : STD_LOGIC := '1';
    SIGNAL RESETOUT           : STD_LOGIC;
    SIGNAL RDn                : STD_LOGIC;
    SIGNAL WRn                : STD_LOGIC;
    SIGNAL ALE                : STD_LOGIC;
    SIGNAL S0                 : STD_LOGIC;
    SIGNAL S1                 : STD_LOGIC;
    SIGNAL IO_Mn              : STD_LOGIC;
    SIGNAL HOLDA              : STD_LOGIC;
    SIGNAL SOD                : STD_LOGIC;
    SIGNAL INTAn              : STD_LOGIC;
    SIGNAL Address_Data_Bus   : STD_LOGIC_VECTOR(8-1 downto 0);
    SIGNAL Address_Bus        : STD_LOGIC_VECTOR(8-1 downto 0);
    SIGNAL memAddress         : STD_LOGIC_VECTOR(2*8-1 downto 0);
BEGIN

    clk <= NOT clk AFTER 10 ns;
    RESETn_IN <= '0', '1' AFTER 30 ns;

    DUT : ENTITY WORK.cpu (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk                => clk,
            X1                 => 'Z',
            X2                 => 'Z',
            READY              => READY,
            CLK_OUT            => CLK_OUT,
            RESETn_IN          => RESETn_IN,
            RESETOUT           => RESETOUT,
            RDn                => RDn,
            WRn                => WRn,
            ALE                => ALE,
            S0                 => S0,
            S1                 => S1,
            IO_Mn              => IO_Mn,
            HOLD               => 'Z',
            HOLDA              => HOLDA,
            Address_Data_Bus   => Address_Data_Bus,
            Address_Bus        => Address_Bus,
            SID                => 'Z',
            SOD                => SOD,
            INTR               => 'Z',
            RST5_5             => 'Z',
            RST6_5             => 'Z',
            RST7_5             => 'Z',
            TRAP               => 'Z',
            INTAn              => INTAn
        );

        memAddress <= Address_Bus & Address_Data_Bus;
        MUT : ENTITY WORK.memory (behavioral)
        GENERIC MAP (
            dataWidth    => 8,
            addressWidth => 16,
            blockSize    => 2 ** 16
        )
        PORT MAP (
            clk         => clk,
            readmem     => RDn,
            writemem    => WRn,
            addressBus  => memAddress,
            dataBus     => Address_Data_Bus
        );

    SIMULATION : PROCESS
    BEGIN
        WAIT UNTIL (RESETn_IN = '1');
        WAIT FOR 200 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE behavioral;