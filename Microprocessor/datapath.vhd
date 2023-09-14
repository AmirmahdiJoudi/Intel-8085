LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY datapath IS
    GENERIC (
        size : INTEGER := 8
    );
    PORT (
        -- CLK GEN
        clk                : IN STD_LOGIC;
        -- RESET
        RESETn_IN          : IN STD_LOGIC;
        -- Address/Data
        Address_Data_Bus   : INOUT STD_LOGIC_VECTOR(size-1 downto 0);
        Address_Bus        : OUT STD_LOGIC_VECTOR(size-1 downto 0);
        -- Control Signals
        loadA              : IN STD_LOGIC;
        loadT              : IN STD_LOGIC;
        loadCYflag         : IN STD_LOGIC;
        loadPflag          : IN STD_LOGIC;
        loadACYflag        : IN STD_LOGIC;
        loadZflag          : IN STD_LOGIC;
        loadSflag          : IN STD_LOGIC;
        loadI              : IN STD_LOGIC;
        loadW              : IN STD_LOGIC;
        loadZ              : IN STD_LOGIC;
        loadB              : IN STD_LOGIC;
        loadC              : IN STD_LOGIC;
        loadD              : IN STD_LOGIC;
        loadE              : IN STD_LOGIC;
        loadH              : IN STD_LOGIC;
        loadL              : IN STD_LOGIC;
        loadSP_L           : IN STD_LOGIC;
        loadSP_H           : IN STD_LOGIC;
        loadPC_L           : IN STD_LOGIC;
        loadPC_H           : IN STD_LOGIC;
        incPC              : IN STD_LOGIC;
        incSP              : IN STD_LOGIC;
        decSP              : IN STD_LOGIC;
        incAdd             : IN STD_LOGIC;
        xChange            : IN STD_LOGIC;
        AccInEn            : IN STD_LOGIC;
        FlagsInEn          : IN STD_LOGIC;
        aluInEn            : IN STD_LOGIC;
        regArrInEn         : IN STD_LOGIC;
        AddHInEn           : IN STD_LOGIC;
        AddLInEn           : IN STD_LOGIC;
        AddDtIsel          : IN STD_LOGIC;
        AddDtOsel          : IN STD_LOGIC;
        AddDtInOutSel      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        opSel              : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        selArrData         : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        selArrAdd          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CYout              : OUT STD_LOGIC;
        ACYout             : OUT STD_LOGIC;
        Pout               : OUT STD_LOGIC;
        Zout               : OUT STD_LOGIC;
        Sout               : OUT STD_LOGIC;
        inst               : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0)
      );
END datapath;

ARCHITECTURE behavioral OF datapath IS
    SIGNAL clkn           : STD_LOGIC;
    SIGNAL rst            : STD_LOGIC;
    SIGNAL inVisCin       : STD_LOGIC;
    SIGNAL CY             : STD_LOGIC;
    SIGNAL ACY            : STD_LOGIC;
    SIGNAL S              : STD_LOGIC;
    SIGNAL P              : STD_LOGIC;
    SIGNAL Z              : STD_LOGIC;
    SIGNAL ALUenBus       : STD_LOGIC;
    SIGNAL RegArrenBus    : STD_LOGIC;
    SIGNAL ACCinBus       : STD_LOGIC;
    SIGNAL AddDtIselBus   : STD_LOGIC;
    SIGNAL internalBus    : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Aout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Tout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL flagsVector    : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL Fout           : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL ALUout         : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL ArrDataOut     : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL ArrAddOutH     : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL ArrAddOutL     : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL AddLDataIn     : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    SIGNAL AddLDataOut    : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
BEGIN

    clkn <= NOT(clk);
    rst  <= NOT(RESETn_IN);
--------------------------------------------------- Register Accumulator
    regAcc : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => internalBus,
            load    => loadA,
            init    => '0',
            dOut    => Aout
        );
--------------------------------------------------- Register Accumulator Output tri-state
    ACCinBus <= clk WHEN((aluInEn AND AccInEn) = '1') ELSE AccInEn;
    triAcc : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => Aout,
            control  => ACCinBus,
            dOut     => internalBus
        );
--------------------------------------------------- Register Temporary
    regTmp : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clkn,
            rst     => rst,
            pLoad   => internalBus,
            load    => loadT,
            init    => '0',
            dOut    => Tout
        );
--------------------------------------------------- Register Flags
    regFlgs : ENTITY WORK.FFregister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk      => clk,
            rst      => rst,
            pLoad    => flagsVector,
            load0    => loadCYflag,
            load1    => '0',
            load2    => loadPflag,
            load3    => '0',
            load4    => loadACYflag,
            load5    => '0',
            load6    => loadZflag,
            load7    => loadSflag,
            init     => '0',
            dOut     => Fout
        );
        CYout  <= Fout(0);
        ACYout <= Fout(4);
        Pout   <= Fout(2);
        Zout   <= Fout(6);
        Sout   <= Fout(7);
--------------------------------------------------- Register Flags Output tri-state
    triFlags : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => Fout,
            control  => FlagsInEn,
            dOut     => internalBus
        );
--------------------------------------------------- ALU
    ALU : ENTITY WORK.alu (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dataInA     => Aout,
            dataInB     => Tout,
            op          => opSel,
            cin         => Fout(0),
            inVisCin    => inVisCin,
            CY          => CY,
            ACY         => ACY,
            SGN         => S,
            PARITY      => P,
            ZERO        => Z,
            dataOut     => ALUout

        );
    flagsVector <= S & Z & '0' & ACY & '0' & P & '0' & CY;
    PROCESS (clk)
    BEGIN
        IF (clk = '1' AND clk'EVENT) THEN
            inVisCin <= CY;
        END IF;
    END PROCESS;
--------------------------------------------------- ALU Output tri-state
    ALUenBus <= clkn WHEN ((aluInEn AND regArrInEn) = '1' OR (aluInEn AND AccInEn) = '1' OR (aluInEn AND AddDtIsel) = '1') ELSE aluInEn;
    triALU : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => ALUout,
            control  => ALUenBus,
            dOut     => internalBus
        );
--------------------------------------------------- Register Instruction
    regInst : ENTITY WORK.normalRegister (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk     => clk,
            rst     => rst,
            pLoad   => internalBus,
            load    => loadI,
            init    => '0',
            dOut    => inst
        );
--------------------------------------------------- Register Array
    regArr : ENTITY WORK.register_array (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            clk          => clk,
            rst          => rst,
            loadW        => loadW,
            loadZ        => loadZ,
            loadB        => loadB,
            loadC        => loadC,
            loadD        => loadD,
            loadE        => loadE,
            loadH        => loadH,
            loadL        => loadL,
            loadSP_H     => loadSP_H,
            loadSP_L     => loadSP_L,
            loadPC_H     => loadPC_H,
            loadPC_L     => loadPC_L,
            incPC        => incPC,
            incSP        => incSP,
            decSP        => decSP,
            incAdd       => incAdd,
            xChange      => xChange,
            selDataOut   => selArrData,
            selAddresOut => selArrAdd,
            dataIn       => internalBus,
            dataOut      => ArrDataOut,
            addressOutH  => ArrAddOutH,
            addressOutL  => ArrAddOutL
        );
--------------------------------------------------- Register Array Output Data tri-state
    RegArrenBus <= clk WHEN ((aluInEn AND regArrInEn) = '1') ELSE regArrInEn;
    arrALU : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => ArrDataOut,
            control  => RegArrenBus,
            dOut     => internalBus
        );
--------------------------------------------------- Buffer Address High
    bufferAddH : ENTITY WORK.bufferBlock (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => ArrAddOutH,
            en       => AddHInEn,
            init     => '0',
            dOut     => Address_Bus
        );
--------------------------------------------------- Buffer Address Low
    AddLDataIn <= ArrAddOutL       WHEN (AddDtInOutSel = "00") ELSE
                  internalBus      WHEN (AddDtInOutSel = "01") ELSE
                  Address_Data_Bus WHEN (AddDtInOutSel = "10") ELSE
                  (OTHERS => 'Z');
    bufferAddL : ENTITY WORK.bufferBlock (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => AddLDataIn,
            en       => AddLInEn,
            init     => '0',
            dOut     => AddLDataOut
        );
--------------------------------------------------- Address/Data tri-state
    triAddData : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => AddLDataOut,
            control  => AddDtOsel,
            dOut     => Address_Data_Bus
        );
--------------------------------------------------- Data In tri-state
    AddDtIselBus <= clk WHEN ((aluInEn AND AddDtIsel) = '1') ELSE AddDtIsel;
    triDataIn : ENTITY WORK.tri_state (behavioral)
        GENERIC MAP (
            size => 8
        )
        PORT MAP (
            dIn      => AddLDataOut,
            control  => AddDtIselBus,
            dOut     => internalBus
        );
END ARCHITECTURE behavioral;