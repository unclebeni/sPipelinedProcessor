-------------------------------------------------------------------------
-- Sidney Stowe
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); --Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end MIPS_processor;

architecture structural of MIPS_processor is

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
  signal s_Halt         : std_logic;  -- this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

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
		o_branch	: out std_logic; -- '1' for branch operations
		o_jump		: out std_logic;
		o_WriteRa	: out std_logic; -- '1' when using jal
		o_signed	: out std_logic; -- '1' when adding or subtracting a signed number
		o_bneop		: out std_logic; -- '1' when bne operation
		o_halt		: out std_logic; --'1'
		o_luiOp		: out std_logic;
    o_jrOp		: out std_logic;
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
    i_BranchPC : in std_logic_vector(31 downto 0);
    i_PCStall	: std_logic;
      i_PCRST	: in std_logic;
      i_Instr	: in std_logic_vector(31 downto 0);
      i_ExtendedImm	: in std_logic_vector(31 downto 0);
      o_PC		: out std_logic_vector(31 downto 0);
      o_PCp4		: out std_logic_vector(31 downto 0);
    o_BranchTaken	: out std_logic;
      i_HALT	: in std_logic;
      i_CLK	: in std_logic;
      i_Jump	: in std_logic;
      i_Branch	: in std_logic;
      i_BranchNotEqual	: in std_logic;
      i_ALUResult	: in std_logic);
  end component;

  component luiShifter is

	   port(
           i_data : in std_logic_vector(16-1 downto 0);
           o_out    : out std_logic_vector(32-1 downto 0));
 
  end component;

  component CompareEqual is
  	port(i_A	: in std_logic_vector(31 downto 0);
	     i_B	: in std_logic_vector(31 downto 0);
	     o_Eq	: out std_logic);
  end component;

  component IFID is
    port (i_Clk     : in std_logic;
          i_Rst     : in std_logic;
	        i_WE	: in std_logic;
          i_PCp4    : in std_logic_vector(31 downto 0);
          i_Inst    : in std_logic_vector(31 downto 0);
          o_PCp4    : out std_logic_vector(31 downto 0);
          o_Inst    : out std_logic_vector(31 downto 0));
end component;

component IDEX is
  port (i_Clk     : in std_logic;
  i_Rst     : in std_logic;
i_WE	: in std_logic;
i_Halt    : in std_logic;
o_Halt    : out std_logic;
i_PCp4	: in std_logic_vector(31 downto 0);
o_PCp4	: out std_logic_vector(31 downto 0);
i_Instr25t21	: in std_logic_vector(4 downto 0);
o_Instr25t21	: out std_logic_vector(4 downto 0);
i_Instr15t0	: in std_logic_vector(15 downto 0);
o_Instr15t0	: out std_logic_vector(15 downto 0);
i_Instr20t16	: in std_logic_vector(4 downto 0);
o_Instr20t16	: out std_logic_vector(4 downto 0);
i_Rd	: in std_logic_vector(4 downto 0);
o_Rd	: out std_logic_vector(4 downto 0);
i_Rt	: in std_logic_vector(4 downto 0);
o_Rt	: out std_logic_vector(4 downto 0);
i_shamt	: in std_logic_vector(4 downto 0);
o_shamt	: out std_logic_vector(4 downto 0);
i_RD1	: in std_logic_vector(31 downto 0);
o_RD1	: out std_logic_vector(31 downto 0);
i_RD2	: in std_logic_vector(31 downto 0);
o_RD2	: out std_logic_vector(31 downto 0);
i_Imm	: in std_logic_vector(31 downto 0);
o_Imm	: out std_logic_vector(31 downto 0);
i_Branch	: in std_logic;
o_Branch	: out std_logic;
i_Jump	: in std_logic;
o_Jump	: out std_logic;
i_ALUSrc	: in std_logic;
o_ALUSrc	: out std_logic;
i_RegDst	: in std_logic;
o_RegDst	: out std_logic;
i_MemToReg	: in std_logic;
o_MemToReg	: out std_logic;
i_RegWrite	: in std_logic;
o_RegWrite	: out std_logic;
i_MemWrite	: in std_logic;
o_MemWrite	: out std_logic;
i_WriteRa	: in std_logic;
o_WriteRa	: out std_logic;
i_LuiOp	: in std_logic;
o_LuiOp	: out std_logic;
i_ALUOp	: in std_logic_vector(3 downto 0);
o_ALUOp	: out std_logic_vector(3 downto 0));
end component;

component EXMEM is
  port (i_Clk     : in std_logic;
  i_Rst     : in std_logic;
  i_WE	: in std_logic;
  i_PCp4	: in std_logic_vector(31 downto 0);
  o_PCp4	: out std_logic_vector(31 downto 0);
  i_Halt    : in std_logic;
         o_Halt    : out std_logic;
  i_MemWrite    : in std_logic;
         o_MemWrite    : out std_logic;
  i_WriteRa    : in std_logic;
         o_WriteRa    : out std_logic;
  i_MemToReg    : in std_logic;
         o_MemToReg    : out std_logic;
  i_RegWrite    : in std_logic;
         o_RegWrite    : out std_logic;
  i_ALUOut	: in std_logic_vector(31 downto 0);
  o_ALUOut	: out std_logic_vector(31 downto 0);
  i_RD2	: in std_logic_vector(31 downto 0);
  o_RD2	: out std_logic_vector(31 downto 0);
  i_RegDstMux	: in std_logic_vector(4 downto 0);
  o_RegDstMux	: out std_logic_vector(4 downto 0);
  i_LuiOp	: in std_logic;
  o_LuiOp	: out std_logic;
  i_LuiShift	: in std_logic_vector(31 downto 0);
  o_LuiShift	: out std_logic_vector(31 downto 0));
end component;

component MEMWB is
  port (i_Clk     : in std_logic;
  i_Rst     : in std_logic;
  i_WE	: in std_logic;
  i_Halt    : in std_logic;
          o_Halt    : out std_logic;
  i_PCp4	: in std_logic_vector(31 downto 0);
  o_PCp4	: out std_logic_vector(31 downto 0);
  i_WriteRa    : in std_logic;
          o_WriteRa    : out std_logic;
  i_MemToReg    : in std_logic;
          o_MemToReg    : out std_logic;
  i_RegWrite    : in std_logic;
          o_RegWrite    : out std_logic;
  i_LuiOp    : in std_logic;
          o_LuiOp    : out std_logic;
  i_RegDstMux	: in std_logic_vector(4 downto 0);
  o_RegDstMux	: out std_logic_vector(4 downto 0);
  i_DMemOut	: in std_logic_vector(31 downto 0);
  o_DMemOut	: out std_logic_vector(31 downto 0);
  i_ALUOut	: in std_logic_vector(31 downto 0);
  o_ALUOut	: out std_logic_vector(31 downto 0);
  i_LuiShift	: in std_logic_vector(31 downto 0);
  o_LuiShift	: out std_logic_vector(31 downto 0));
end component;

  signal s_032  : std_logic_vector(31 downto 0);
  signal s_31 : std_logic_vector(4 downto 0);

  --Control Signals
  signal s_RegDst, s_WriteRa, s_RegWrite, s_Jump, s_Branch, s_MemToReg, s_MemWrite, s_ALUSrc, s_SignZero, s_bneOp, s_MemRead, s_luiOp, s_jrOp  : std_logic;
  signal s_ALUOp  : std_logic_vector(3 downto 0);

  --ALUControl Signals
  signal s_ALUShiftDir, s_ALUShiftArithmetic, s_ALUAddSub, s_signed : std_logic;
  signal s_ALUMuxCtrl : std_logic_vector(2 downto 0);

  --MUX output
  signal s_DMEMMUXOut, s_ALUSRCMux, s_luiMux : std_logic_vector(31 downto 0);
  signal s_RegDstMUX : std_logic_vector(4 downto 0);
  signal s_jumpAddrMux  : std_logic_vector(31 downto 0);

  --Module output
  signal s_RegFileRD1, s_RegFileRD2, s_ALUOut, s_ImmExtended, s_PCp4, s_luiShifted : std_logic_vector(31 downto 0);
  signal s_ALUSecondOut, s_overflow, s_carryout : std_logic;

  --Instruction segments
  signal s_instr25t21, s_instr20t16, s_instr15t11, s_instr10t6  : std_logic_vector(4 downto 0);
  signal s_instr31t26, s_instr5t0 : std_logic_vector(5 downto 0);
  signal s_instr15t0  : std_logic_vector(15 downto 0);
  signal s_instr25t0  : std_logic_vector(25 downto 0);

  --Misc
  signal s_Reset, s_AreEqual	: std_logic;
  signal s_instr25t0shift : std_logic_vector(31 downto 0);

  --Pipeline register output
  signal ps_PCp41, ps_PCp42, ps_PCp43, ps_PCp44, ps_Inst : std_logic_vector(31 downto 0);
  signal p1Halt, p2Halt, p3Halt, s_BT : std_logic;
  signal ps_RegDst, ps_WriteRa1, ps_RegWrite1, ps_RegWrite2, ps_WriteRa2, ps_WriteRa3, ps_MemToReg1, ps_MemToReg2, ps_MemToReg3, ps_MemWrite1, ps_ALUSrc, ps_luiOp1, ps_luiOp2, ps_luiOp3, ps_Branch, ps_jump  : std_logic;
  signal ps_instr25t21, ps_instr20t16, ps_shamt, ps_RegDstMux1, ps_RegDstMux2, ps_Rd, ps_Rt : std_logic_vector(4 downto 0);
  signal ps_RD1, ps_RD2, ps_Imm, ps_ALUOut1, ps_ALUOut2, ps_ALUSrcout, ps_LuiShift1, ps_LuiShift2, ps_DMemData, ps_DMemOut : std_logic_vector(31 downto 0);
  signal ps_ALUOp  : std_logic_vector(3 downto 0);
  signal ps_LuiImm  : std_logic_vector(15 downto 0);

begin

  s_032 <= x"00000000";
  s_31 <= "11111";
  s_Reset <= iRST;

  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  --Instruction memory
  IMEM: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => 32) port map(clk => iCLK, addr => s_IMemAddr(11 downto 2), data => iInstExt, we => iInstLd, q => s_Inst);
    
  --IF/ID Register
  IFIDREG: IFID port map(i_Clk => iCLK, i_Rst => s_Reset, i_WE => '1', i_PCp4 => s_PCp4, i_Inst => s_Inst, o_PCp4 => ps_PCp41, o_Inst => ps_Inst);

  --Defining instruction segments
  s_instr31t26(5 downto 0) <= ps_Inst(31 downto 26);

  s_instr5t0(5 downto 0) <= ps_Inst(5 downto 0);

  s_instr25t21(4 downto 0) <= ps_Inst(25 downto 21);

  s_instr20t16(4 downto 0) <= ps_Inst(20 downto 16);

  s_instr15t11(4 downto 0) <= ps_Inst(15 downto 11);

  s_instr15t0(15 downto 0) <= ps_Inst(15 downto 0);

  s_instr10t6(4 downto 0) <= ps_Inst(10 downto 6);

  s_instr25t0(25 downto 0) <= ps_Inst(25 downto 0);

  --Control Unit
  CONTROLUNIT: control port map(i_opCode => s_instr31t26, i_functCode => s_instr5t0, o_RegDest => s_RegDst, o_ALUSrc => s_ALUSrc, o_MemtoReg => s_MemToReg, o_RegWrite => s_RegWrite, o_MemRead => s_MemRead, o_MemWrite => s_MemWrite, o_jump => s_jump, o_branch => s_Branch, o_WriteRa => s_WriteRa, o_signed => s_SignZero, o_bneOp => s_bneOp, o_halt => p1Halt, o_luiOp => s_luiOP, o_jrOp => s_jrOp, o_ALUop => s_ALUOp);

  --Register Destination Mux
  REGDSTMUX: Mux2t1_N generic map(N => 5) port map(i_S => ps_RegDst, i_D0 => ps_Rt, i_D1 => ps_Rd, o_O => s_RegDstMUX);

  --Write Ra Register Mux
  WRITERAREGMUX: Mux2t1_N generic map(N => 5) port map(i_S => ps_WriteRa3, i_D0 => ps_RegDstMUX2, i_D1 => s_31, o_O => s_RegWrAddr);

  --Write Ra Data Mux
  WRITERADATAMUX: Mux2t1_N generic map(N => 32) port map(i_S => ps_WriteRa3, i_D0 => s_luiMux, i_D1 => ps_PCp44, o_O => s_RegWrData);

  --Register File
  REGFILE: MIPSRegFile port map(i_WE => s_RegWr, i_CLK => iCLK, i_RST => s_Reset, i_WS => s_RegWrAddr, i_RS => s_instr25t21, i_R2S => s_instr20t16, i_wD => s_RegWrData, o_R1F => s_RegFileRD1, o_R2F => s_RegFileRD2);

  --Comparator for equivalence
  EQUALS: CompareEqual port map(i_A => s_RegFileRD1, i_B => s_RegFileRD2, o_Eq => s_AreEqual);

  s_instr25t0shift(31 downto 28) <= "0000";
  s_instr25t0shift(27 downto 2) <= s_instr25t0(25 downto 0);
  s_instr25t0shift(1 downto 0) <= "00";

  --Fetch Jump Address input Mux
  JUMPADDRMUX: Mux2t1_N generic map(N => 32) port map(i_S => s_jrOp, i_D0 => s_instr25t0shift, i_D1 => s_RegFileRD1, o_O => s_jumpAddrMux);

  --Fetch Logic module
  FETCHLOGIC: MipsFetch port map(i_PC => s_IMemAddr, i_BranchPC => ps_PCp41, i_PCRST => s_Reset, i_PCStall => '0', o_BranchTaken => s_BT, i_Instr => s_jumpAddrMux, i_ExtendedImm => s_ImmExtended, o_PC => s_NextInstAddr, o_PCp4 => s_PCp4, i_HALT => s_Halt, i_CLK => iCLK, i_Jump => s_Jump, i_Branch => s_Branch, i_BranchNotEqual => s_bneOp, i_ALUResult => s_AreEqual);

  --Immediate sign extension
  IMMEXTEND: Extend16t32 port map(i_D => s_instr15t0, i_SignZero => s_signZero, o_D => s_ImmExtended);

  --ID/EX Register
  IDEXREG: IDEX port map(i_CLK => iCLK, i_Rst => s_Reset, i_WE => '1', i_Halt => p1Halt, o_Halt => p2halt, i_PCp4 => ps_PCp41, o_PCp4 => ps_PCp42, i_Instr25t21 => s_instr25t21, o_Instr25t21 => ps_instr25t21, i_Instr15t0 => s_instr15t0, o_Instr15t0 => ps_LuiImm, i_Instr20t16 => s_instr20t16, o_Instr20t16 => ps_instr20t16, i_Rd => s_instr15t11, o_Rd => ps_Rd, i_Rt => s_instr20t16, o_Rt => ps_Rt, i_shamt => s_instr10t6, o_shamt => ps_shamt, i_RD1 => s_RegFileRD1, o_RD1 => ps_RD1, i_RD2 => s_RegFileRD2, o_RD2 => ps_RD2, i_Imm => s_ImmExtended, o_Imm => ps_Imm, i_Branch => s_Branch, o_Branch => ps_Branch, i_Jump => s_jump, o_Jump => ps_jump, i_ALUSrc => s_ALUSrc, o_ALUSrc => ps_ALUSrc, i_RegDst => s_RegDst, o_RegDst => ps_RegDst, i_MemToReg => s_MemtoReg, o_MemToReg => ps_MemToReg1, i_RegWrite => s_RegWrite, o_RegWrite => ps_RegWrite1, i_MemWrite => s_MemWrite, o_MemWrite => ps_MemWrite1, i_WriteRa => s_WriteRa, o_WriteRa => ps_WriteRa1, i_LuiOp => s_luiOp, o_LuiOp => ps_luiOp1, i_ALUOp => s_ALUOp, o_ALUOp => ps_ALUOp);
    
  --ALU Source Mux
  ALUSRCMUX: Mux2t1_N generic map(N => 32) port map(i_S => ps_ALUSrc, i_D0 => ps_RD2, i_D1 => ps_Imm, o_O => s_ALUSRCMux);

  --ALU Control
  MIPSALUCNTRL: ALUControl port map(i_ALUop => ps_ALUOp, o_ALUShiftDir => s_ALUShiftDir, o_ALUShiftArithmetic => s_ALUShiftArithmetic, o_ALUAddSub => s_ALUAddSub, o_ALUMuxCtrl => s_ALUMuxCtrl, o_signed => s_signed);

  --ALU
  MIPSALU: ALU port map(i_Adata => ps_RD1, i_Bdata => s_ALUSRCMux, i_ALUShiftDir => s_ALUShiftDir, i_ALUShiftArithmetic => s_ALUShiftArithmetic, i_ALUAddSub => s_ALUAddSub, i_ALUMuxCtrl => s_ALUMuxCtrl, i_shamt => ps_shamt, i_signed => s_signed, o_equal => s_ALUSecondOut, o_carryout => s_carryout, o_overflow => s_Ovfl, o_result => s_ALUOut);

  --Lui Shifter
  LUISHIFT: luiShifter port map(i_data => ps_LuiImm, o_out => s_luiShifted);
	
  --Assign ouput of Processor for synthesis
  oALUOut <= s_ALUOut;
  
  --EX/Mem Register
  EXMEMREG: EXMEM port map(i_Clk => iCLK, i_Rst => s_Reset, i_WE => '1', i_Halt => p2Halt, o_Halt => p3Halt, i_PCp4 => ps_PCp42, o_PCp4 => ps_PCp43, i_MemWrite => ps_MemWrite1, o_MemWrite => s_DMemWr, i_WriteRa => ps_WriteRa1, o_WriteRa => ps_WriteRa2, i_MemToReg => ps_MemToReg1, o_MemToReg => ps_MemToReg2, i_RegWrite => ps_RegWrite1, o_RegWrite => ps_RegWrite2, i_ALUOut => s_ALUOut, o_ALUOut => ps_ALUOut1, i_RD2 => ps_RD2, o_RD2 => ps_DMemData, i_RegDstMux => s_RegDstMUX, o_RegDstMux => ps_RegDstMux1, i_LuiOP => ps_luiOp1, o_LuiOp => ps_luiOp2, i_LuiShift => s_luiShifted, o_LuiShift => ps_LuiShift1);

  s_DMemAddr <= ps_ALUOut1;

  s_DMemData <= ps_DMemData;

  --Data memory
  DMem: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => 32) port map(clk => iCLK, addr => s_DMemAddr(11 downto 2), data => s_DMemData, we => s_DMemWr, q => s_DMemOut);

  --Mem/WB Register
  MEMWBREG: MEMWB port map(i_Clk => iCLK, i_Rst => s_Reset, i_WE => '1', i_Halt => p3Halt, o_Halt => s_Halt, i_PCp4 => ps_PCp43, o_PCp4 => ps_PCp44, i_WriteRa => ps_WriteRa2, o_WriteRa => ps_WriteRa3, i_MemToReg => ps_MemToReg2, o_MemToReg => ps_MemToReg3, i_RegWrite => ps_RegWrite2, o_RegWrite => s_RegWr, i_LuiOp => ps_luiOp2, o_LuiOp => ps_luiOp3, i_RegDstMux => ps_RegDstMux1, o_RegDstMux => ps_RegDstMux2, i_DMemOut => s_DMemOut, o_DMemOut => ps_DMemOut, i_ALUOut => ps_ALUOut1, o_ALUOut => ps_ALUOut2, i_LuiShift => ps_LuiShift1, o_LuiShift => ps_LuiShift2);

  --Mem to Reg Mux
  DMEMTREGMUX: Mux2t1_N generic map(N => 32) port map(i_S => ps_MemToReg3, i_D0 => ps_ALUOut2, i_D1 => ps_DMemOut, o_O => s_DMEMMUXOut);

  --Lui mux
  LUIMUX: Mux2t1_N generic map(N => 32) port map(i_S => ps_luiOp3, i_D0 => s_DMEMMUXOut, i_D1 => ps_LuiShift2, o_O => s_luiMux);

  end structural;
