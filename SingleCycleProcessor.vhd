-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- MIPSFetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the fetch logic of a MIPS processor.
--
-- NOTES:
-- 9/23/21 by Sid::Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SingleCycleProcessor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); 
-- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end SingleCycleProcessor;

architecture structural of SingleCycleProcessor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  signal s_032  : std_logic_vector(31 downto 0);
  signal s_31 : std_logic_vector(4 downto 0);

  signal s_RegDst, s_WriteRa, s_RegWrite, s_Jump, s_Branch, s_MemToReg, s_MemWrite, s_ALUSrc, s_ALUOp, s_Sign/Zero  : std_logic;

  signal s_RegDstMUX, s_WriteRaRegMUX, s_WriteRaDataMUX : std_logic_vector(31 downto 0);

  signal s_instr25t21, s_instr20t16, s_instr15t11  : std_logic_vector(4 downto 0);
  signal s_instr31t26, s_instr5t0 : std_logic_vector(5 downto 0);
  signal s_instr15t0  : std_logic_vector(15 downto 0);

  signal s_DataMemOut, s_PCp8 ; std_logic_vector(31 downto 0);

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;
  
  component control is

  end component;

  component ALU is

  end component;

  component ALUControl is

  end component;

  component MIPSRegFile is
    port(i_WE	: in std_logic;
    i_CLK	: in std_logic;
    i_WS	: in std_logic_vector(4 downto 0);
    i_RS	: in std_logic_vector(4 downto 0);
    i_R2S	: in std_logic_vector(4 downto 0);
    i_wD	: in std_logic_vector(31 downto 0);
    o_R1F	: out std_logic_vector(31 downto 0);
    o_R2F	: out std_logic_vector(31 downto 0));
  end component;

  component Extend16t32 is
  	port(i_D	: in std_logic_vector(15 downto 0);
	       i_SignZero	: in std_logic;
	       o_D	: out std_logic_vector(31 downto 0));
  end component;

  component mux2t1_N is
    generic(N : integer);
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component MIPSFetch is
    port(i_PC	: in std_logic_vector(31 downto 0);
         i_Instr25t0	: in std_logic_vector(25 downto 0);
         i_ExtendedImm	: in std_logic_vector(31 downto 0);
         o_PC		: out std_logic_vector(31 downto 0);
         o_PCp8		: out std_logic_vector(31 downto 0);
         i_CLK	: in std_logic;
         i_Jump	: in std_logic;
         i_Branch	: in std_logic;
        i_ALUResult	: in std_logic);
  end component;

  architecture structural of SingleCycleProcessor is

    s_032 <= x"00000000";
    s_31 <= "11111";

    IMEM: mem port map(clk => iCLK, addr => s_NextInstAddr, data => s_032, we => '0', q => s_Inst);
    
    s_instr31t26(5) <= s_Inst(31);
    s_instr31t26(4) <= s_Inst(30);
    s_instr31t26(3) <= s_Inst(29);
    s_instr31t26(2) <= s_Inst(28);
    s_instr31t26(1) <= s_Inst(27);
    s_instr31t26(0) <= s_Inst(26);

    s_instr5t0(5) <= s_Inst(5);
    s_instr5t0(4) <= s_Inst(4);
    s_instr5t0(3) <= s_Inst(3);
    s_instr5t0(2) <= s_Inst(2);
    s_instr5t0(1) <= s_Inst(1);
    s_instr5t0(0) <= s_Inst(0);

    s_instr25t21(4) <= s_Inst(25);
    s_instr25t21(3) <= s_Inst(24);
    s_instr25t21(2) <= s_Inst(23);
    s_instr25t21(1) <= s_Inst(22));
    s_instr25t21(0) <= s_Inst(21);

    s_instr20t16(4) <= s_Inst(20);
    s_instr20t16(3) <= s_Inst(19);
    s_instr20t16(2) <= s_Inst(18);
    s_instr20t16(1) <= s_Inst(17);
    s_instr20t16(0) <= s_Inst(16);

    s_instr15t11(4) <= s_Inst(15);
    s_instr15t11(3) <= s_Inst(14);
    s_instr15t11(2) <= s_Inst(13);
    s_instr15t11(1) <= s_Inst(12);
    s_instr15t11(0) <= s_Inst(11);

    s_instr15t0(15) <= s_Inst(15);
    s_instr15t0(14) <= s_Inst(14);
    s_instr15t0(13) <= s_Inst(13);
    s_instr15t0(12) <= s_Inst(12);
    s_instr15t0(11) <= s_Inst(11);
    s_instr15t0(10) <= s_Inst(10);
    s_instr15t0(9) <= s_Inst(9);
    s_instr15t0(8) <= s_Inst(8);
    s_instr15t0(7) <= s_Inst(7);
    s_instr15t0(6) <= s_Inst(6);
    s_instr15t0(5) <= s_Inst(5);
    s_instr15t0(4) <= s_Inst(4);
    s_instr15t0(3) <= s_Inst(3);
    s_instr15t0(2) <= s_Inst(2);
    s_instr15t0(1) <= s_Inst(1);
    s_instr15t0(0) <= s_Inst(0);

    --TODO
    CONTROLUNIT: control port map();

    REGDSTMUX: Mux2t1_N generic map(N => 5); port map(i_S => s_RegDst, i_D0 => s_instr20t16, i_D1 => s_instr15t11, o_O => s_RegDstMUX);

    WRITERAREGMUX: Mux2t1_N generic map(N => 5); port map(i_S => s_WriteRa, i_D0 => s_RegDstMUX, i_D1 => s_31, o_O => s_WriteRaRegMUX);

    WRITERADATAMUX: Mux2t1_N generic map(N => 32); port map(i_S => s_WriteRa, i_D0 => s_DataMemOut, i_D1 => s_PCp8, o_O => s_WriteRaDataMUX);

    REGFILE: MIPSRegFile port map(i_WE => s_RegWrite, i_CLK => iCLK, i_WS => s_WriteRaRegMUX, i_RS => s_instr25t21, i_R2S => s_instr20t16, i_wD => sWriteRaDataMUX);

    

    FETCHLOGIC: MipsFetch port map(i_PC => )
  
  begin

    

  end structural;