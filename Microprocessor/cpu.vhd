LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cpu IS
    GENERIC (
        size : INTEGER := 8
    );
    PORT (
        -- CLK GEN
        clk                : IN STD_LOGIC;
        X1                 : IN STD_LOGIC;
        X2                 : IN STD_LOGIC;
        READY              : IN STD_LOGIC;
        CLK_OUT            : OUT STD_LOGIC;
        -- RESET
        RESETn_IN          : IN STD_LOGIC;
        RESETOUT           : OUT STD_LOGIC;
        -- Control
        RDn                : OUT STD_LOGIC;
        WRn                : OUT STD_LOGIC;
        ALE                : OUT STD_LOGIC;
        -- Status
        S0                 : OUT STD_LOGIC;
        S1                 : OUT STD_LOGIC;
        IO_Mn              : OUT STD_LOGIC;
        -- DMA
        HOLD               : IN STD_LOGIC;
        HOLDA              : OUT STD_LOGIC;
        -- Address/Data
        Address_Data_Bus   : INOUT STD_LOGIC_VECTOR(size-1 downto 0);
        Address_Bus        : OUT STD_LOGIC_VECTOR(size-1 downto 0);
        -- Serial I/O Control
        SID                : IN STD_LOGIC;
        SOD                : OUT STD_LOGIC;
        -- Interrupt Control
        INTR               : IN STD_LOGIC;
        RST5_5             : IN STD_LOGIC;
        RST6_5             : IN STD_LOGIC;
        RST7_5             : IN STD_LOGIC;
        TRAP               : IN STD_LOGIC;
        INTAn              : OUT STD_LOGIC
      );
END cpu;

ARCHITECTURE behavioral OF cpu IS
    SIGNAL loadA              : STD_LOGIC;
    SIGNAL loadT              : STD_LOGIC;
    SIGNAL loadCYflag         : STD_LOGIC;
    SIGNAL loadPflag          : STD_LOGIC;
    SIGNAL loadACYflag        : STD_LOGIC;
    SIGNAL loadZflag          : STD_LOGIC;
    SIGNAL loadSflag          : STD_LOGIC;
    SIGNAL loadI              : STD_LOGIC;
    SIGNAL loadW              : STD_LOGIC;
    SIGNAL loadZ              : STD_LOGIC;
    SIGNAL loadB              : STD_LOGIC;
    SIGNAL loadC              : STD_LOGIC;
    SIGNAL loadD              : STD_LOGIC;
    SIGNAL loadE              : STD_LOGIC;
    SIGNAL loadH              : STD_LOGIC;
    SIGNAL loadL              : STD_LOGIC;
    SIGNAL loadSP_L           : STD_LOGIC;
    SIGNAL loadSP_H           : STD_LOGIC;
    SIGNAL loadPC_L           : STD_LOGIC;
    SIGNAL loadPC_H           : STD_LOGIC;
    SIGNAL incPC              : STD_LOGIC;
    SIGNAL incSP              : STD_LOGIC;
    SIGNAL decSP              : STD_LOGIC;
    SIGNAL incAdd             : STD_LOGIC;
    SIGNAL xChange            : STD_LOGIC;
    SIGNAL AccInEn            : STD_LOGIC;
    SIGNAL FlagsInEn          : STD_LOGIC;
    SIGNAL aluInEn            : STD_LOGIC;
    SIGNAL regArrInEn         : STD_LOGIC;
    SIGNAL AddHInEn           : STD_LOGIC;
    SIGNAL AddLInEn           : STD_LOGIC;
    SIGNAL AddDtIsel          : STD_LOGIC;
    SIGNAL AddDtOsel          : STD_LOGIC;
    SIGNAL CYout              : STD_LOGIC;
    SIGNAL ACYout             : STD_LOGIC;
    SIGNAL Pout               : STD_LOGIC;
    SIGNAL Zout               : STD_LOGIC;
    SIGNAL Sout               : STD_LOGIC;
    SIGNAL AddDtInOutSel      : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL opSel              : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL selArrData         : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL selArrAdd          : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL inst               : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
BEGIN

    CLK_OUT <= clk;
    RESETOUT <= RESETn_IN;
    HOLDA <= '0';
    SOD <= '0';
    INTAn <= '1';

----------------------------------------------------- datapath
    datapath : ENTITY WORK.datapath (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk              => clk,
            RESETn_IN        => RESETn_IN,
            Address_Data_Bus => Address_Data_Bus,
            Address_Bus      => Address_Bus,
            loadA            => loadA,
            loadT            => loadT,
            loadCYflag       => loadCYflag,
            loadPflag        => loadPflag,
            loadACYflag      => loadACYflag,
            loadZflag        => loadZflag,
            loadSflag        => loadSflag,
            loadI            => loadI,
            loadW            => loadW,
            loadZ            => loadZ,
            loadB            => loadB,
            loadC            => loadC,
            loadD            => loadD,
            loadE            => loadE,
            loadH            => loadH,
            loadL            => loadL,
            loadSP_L         => loadSP_L,
            loadSP_H         => loadSP_H,
            loadPC_L         => loadPC_L,
            loadPC_H         => loadPC_H,
            incPC            => incPC,
            incSP            => incSP,
            decSP            => decSP,
            incAdd           => incAdd,
            xChange          => xChange,
            AccInEn          => AccInEn,
            FlagsInEn        => FlagsInEn,
            aluInEn          => aluInEn,
            regArrInEn       => regArrInEn,
            AddHInEn         => AddHInEn,
            AddLInEn         => AddLInEn,
            AddDtIsel        => AddDtIsel,
            AddDtOsel        => AddDtOsel,
            AddDtInOutSel    => AddDtInOutSel,
            opSel            => opSel,
            selArrData       => selArrData,
            selArrAdd        => selArrAdd,
            CYout            => CYout,
            ACYout           => ACYout,
            Pout             => Pout,
            Zout             => Zout,
            Sout             => Sout,
            inst             => inst
        );
----------------------------------------------------- controller
    controller : ENTITY WORK.controller (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk              => clk,
            RESETn_IN        => RESETn_IN,
            RDn              => RDn,
            WRn              => WRn,
            ALE              => ALE,
            S0               => S0,
            S1               => S1,
            IO_Mn            => IO_Mn,
            inst             => inst,
            CYout            => CYout,
            ACYout           => ACYout,
            Pout             => Pout,
            Zout             => Zout,
            Sout             => Sout,
            loadA            => loadA,
            loadT            => loadT,
            loadCYflag       => loadCYflag,
            loadPflag        => loadPflag,
            loadACYflag      => loadACYflag,
            loadZflag        => loadZflag,
            loadSflag        => loadSflag,
            loadI            => loadI,
            loadW            => loadW,
            loadZ            => loadZ,
            loadB            => loadB,
            loadC            => loadC,
            loadD            => loadD,
            loadE            => loadE,
            loadH            => loadH,
            loadL            => loadL,
            loadSP_L         => loadSP_L,
            loadSP_H         => loadSP_H,
            loadPC_L         => loadPC_L,
            loadPC_H         => loadPC_H,
            incPC            => incPC,
            incSP            => incSP,
            decSP            => decSP,
            incAdd           => incAdd,
            xChange          => xChange,
            AccInEn          => AccInEn,
            FlagsInEn        => FlagsInEn,
            aluInEn          => aluInEn,
            regArrInEn       => regArrInEn,
            AddHInEn         => AddHInEn,
            AddLInEn         => AddLInEn,
            AddDtIsel        => AddDtIsel,
            AddDtOsel        => AddDtOsel,
            AddDtInOutSel    => AddDtInOutSel,
            opSel            => opSel,
            selArrData       => selArrData,
            selArrAdd        => selArrAdd
        );
END ARCHITECTURE behavioral;