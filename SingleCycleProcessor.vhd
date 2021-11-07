-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------


-- MIPSFetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a MIPS processor.
--
-- NOTES:
-- 11/4/21 by Sid::Created
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
       oALUOut         : out std_logic_vector(N-1 downto 0)); --Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end SingleCycleProcessor;

architecture structural of SingleCycleProcessor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- this signal indicates an overflow exception would have been initiated

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
    port(i_opCode  	: in std_logic_vector(5 downto 0);
	  i_functCode : in std_logic_vector(5 downto 0);
		o_RegDest 	: out std_logic; -- '1' when using R format instruction
		o_ALUSrc	: out std_logic; -- '1' for immediate value operations
		o_MemtoReg	: out std_logic; -- '1' for load word
		o_RegWrite	: out std_logic; -- '1' for storing to register
		o_MemRead	: out std_logic; -- '1' for reading memory
		o_MemWrite	: out std_logic; -- '1' for store word in memory
		o_branch	: out std_logic; -- '1' for branch and jump operations
		o_WriteRa	: out std_logic; -- '1' when using jal
		o_signed	: out std_logic; -- '1' when adding or subtracting a signed number
		o_bneop		: out std_logic; -- '1' when bne operation
		o_halt		: out std_logic; --'1'
		o_ALUop	: out std_logic_vector(3 downto 0)); -- ALU op code
  end component;

  component ALU is
port(
	i_Adata		: in std_logic_vector(32-1 downto 0);
	i_Bdata		: in std_logic_vector(32-1 downto 0);
	i_ALUShiftDir	: in std_logic;
	i_ALUShiftArithmetic	: in std_logic;
	i_ALUAddSub		: in std_logic;
	i_ALUMuxCtrl	: in std_logic_vector(3-1 downto 0);
	i_shamt		:	in std_logic_vector(5-1 downto 0);
	i_signed	:	in std_logic;
	o_equal			: out std_logic;
	o_carryout	:	out std_logic;
	o_overflow	:	out std_logic;
	o_result	: out std_logic_vector(32-1 downto 0));
  end component;

  component ALUControl is
    port(i_ALUop  				: in std_logic_vector(3 downto 0);
         o_ALUShiftDir 			: out std_logic;
         o_ALUShiftArithmetic	: out std_logic;
         o_ALUAddSub				: out std_logic;
         o_ALUMuxCtrl			: out std_logic_vector(2 downto 0);
         o_signed				: out std_logic);
  end component;

  component MIPSRegFile is
    port(i_WE	: in std_logic;
    i_CLK	: in std_logic;
    i_RST	: in std_logic;
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
	 i_HALT	: in std_logic;
         i_CLK	: in std_logic;
         i_Jump	: in std_logic;
         i_Branch	: in std_logic;
	 i_BranchNotEqual	: in std_logic;
         i_ALUResult	: in std_logic);
  end component;

  signal s_032  : std_logic_vector(31 downto 0);
  signal s_31 : std_logic_vector(4 downto 0);

  --Control Signals
  signal s_RegDst, s_WriteRa, s_RegWrite, s_Jump, s_Branch, s_MemToReg, s_MemWrite, s_ALUSrc, s_SignZero, s_bneOp, s_MemRead  : std_logic;
  signal s_ALUOp  : std_logic_vector(3 downto 0);

  --ALUControl Signals
  signal s_ALUShiftDir, s_ALUShiftArithmetic, s_ALUAddSub, s_signed : std_logic;
  signal s_ALUMuxCtrl : std_logic_vector(2 downto 0);

  --MUX output
  signal s_WriteRaDataMUX, s_DMEMMUXOut, s_ALUSRCMux : std_logic_vector(31 downto 0);
  signal s_RegDstMUX, s_WriteRaRegMUX : std_logic_vector(4 downto 0);

  --Module output
  signal s_RegFileRD1, s_RegFileRD2, s_ALUOut, s_ImmExtended, s_PCp8, s_PC : std_logic_vector(31 downto 0);
  signal s_ALUSecondOut, s_overflow, s_carryout : std_logic;

  --Instruction segments
  signal s_instr25t21, s_instr20t16, s_instr15t11, s_instr10t6  : std_logic_vector(4 downto 0);
  signal s_instr31t26, s_instr5t0 : std_logic_vector(5 downto 0);
  signal s_instr15t0  : std_logic_vector(15 downto 0);
  signal s_instr25t0  : std_logic_vector(25 downto 0);

  signal s_RegFileReset	: std_logic;

begin

  s_032 <= x"00000000";
  s_31 <= "11111";
  s_PC <= iInstAddr;
  s_RegFileReset <= iRST;

  --Instruction memory
  IMEM: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => 32) port map(clk => iCLK, addr => s_NextInstAddr, data => s_032, we => iInstLd, q => s_Inst);
    
  --Defining instruction segments
  s_instr31t26(5 downto 0) <= s_Inst(31 downto 26);

  s_instr5t0(5 downto 0) <= s_Inst(5 downto 0);

  s_instr25t21(4 downto 0) <= s_Inst(25 downto 21);

  s_instr20t16(4 downto 0) <= s_Inst(20 downto 16);

  s_instr15t11(4 downto 0) <= s_Inst(15 downto 11);

  s_instr15t0(15 downto 0) <= s_Inst(15 downto 0);

  s_instr10t6(4 downto 0) <= s_Inst(10 downto 6);

  s_instr25t0(25 downto 0) <= s_Inst(25 downto 0);

  --Control Unit
  CONTROLUNIT: control port map(i_opCode => s_instr31t26, i_functCode => s_instr5t0, o_RegDest => s_RegDst, o_ALUSrc => s_ALUSrc, o_MemtoReg => s_MemToReg, o_RegWrite => s_RegWr, o_MemRead => s_MemRead, o_MemWrite => s_DMemWr, o_branch => s_Branch, o_WriteRa => s_WriteRa, o_signed => s_SignZero, o_bneOp => s_bneOp, o_halt => s_Halt o_ALUop => s_ALUOp);

  --Register Destination Mux
  REGDSTMUX: Mux2t1_N generic map(N => 5) port map(i_S => s_RegDst, i_D0 => s_instr20t16, i_D1 => s_instr15t11, o_O => s_RegDstMUX);

  --Write Ra Register Mux
  WRITERAREGMUX: Mux2t1_N generic map(N => 5) port map(i_S => s_WriteRa, i_D0 => s_RegDstMUX, i_D1 => s_31, o_O => s_RegWrAddr);

  --Write Ra Data Mux
  WRITERADATAMUX: Mux2t1_N generic map(N => 32) port map(i_S => s_WriteRa, i_D0 => s_DMEMMUXOut, i_D1 => s_PCp8, o_O => s_RegWrData);

  --Register File
  REGFILE: MIPSRegFile port map(i_WE => s_RegWr, i_CLK => iCLK, i_RST => s_RegFileReset, i_WS => s_RegWrAddr, i_RS => s_instr25t21, i_R2S => s_instr20t16, i_wD => s_RegWrData, o_R1F => s_RegFileRD1, o_R2F => s_RegFileRD2);

  s_DMemData <= s_RegFileRD2;

  --Immediate sign extension
  IMMEXTEND: Extend16t32 port map(i_D => s_instr15t0, i_SignZero => s_signZero, o_D => s_ImmExtended);
    
  --ALU Source Mux
  ALUSRCMUX: Mux2t1_N generic map(N => 32) port map(i_S => s_ALUSrc, i_D0 => s_RegFileRD2, i_D1 => s_ImmExtended, o_O => s_ALUSRCMux);

  --ALU Control
  MIPSALUCNTRL: ALUControl port map(i_ALUop => s_ALUOp, o_ALUShiftDir => s_ALUShiftDir, o_ALUShiftArithmetic => s_ALUShiftArithmetic, o_ALUAddSub => s_ALUAddSub, o_ALUMuxCtrl => s_ALUMuxCtrl, o_signed => s_signed);

  --ALU
  MIPSALU: ALU port map(i_Adata => s_RegFileRD1, i_Bdata => s_ALUSRCMux, i_ALUShiftDir => s_ALUShiftDir, i_ALUShiftArithmetic => s_ALUShiftArithmetic, i_ALUAddSub => s_ALUAddSub, i_ALUMuxCtrl => s_ALUMuxCtrl, i_shamt => s_instr10t6, i_signed => s_signed, o_equal => s_ALUSecondOut, o_carryout => s_carryout, o_overflow => s_Ovfl, o_result => s_ALUOut);

  --Assign ouput of Processor for synthesis
  oALUOut <= s_ALUOut;

  --Fetch Logic module
  FETCHLOGIC: MipsFetch port map(i_PC => s_PC, i_Instr25t0 => s_instr25t0, i_ExtendedImm => s_ImmExtended, o_PC => s_NextInstAddr, o_PCp8 => s_PCp8, i_HALT => s_Halt, i_CLK => iCLK, i_Jump => s_Jump, i_Branch => s_Branch, i_BranchNotEqual => s_bneOp, i_ALUResult => s_ALUSecondOut);
    
  s_DMemAddr <= s_ALUOut;

  --Data memory
  DATAMEM: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => 32) port map(clk => iCLK, addr => s_DMemAddr, data => s_DMemData, we => s_DMemWr, q => s_DMemOut);

  --Mem to Reg Mux
  DMEMTREGMUX: Mux2t1_N generic map(N => 32) port map(i_S => s_WriteRa, i_D0 => s_DMemOut, i_D1 => s_PCp8, o_O => s_DMEMMUXOut);

  end structural;
