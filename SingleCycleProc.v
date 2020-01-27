module singlecycle(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    //assign mux = control ? : 1 , 0

    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
    wire [4:0] rd;            // The destination register
    wire [4:0] rm;            // Operand 1
    wire [4:0] rn;            // Operand 2
    wire [10:0] opcode;

    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
    wire [1:0] signop;

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B
    wire [63:0] writedata_reg;
    

    // ALU connections
    wire [63:0] aluin2;
    wire [63:0] aluout;
    wire zero;

    // Sign Extender connections
    wire [63:0] extimm;

    // PC update logic
    always @(negedge CLK)
    begin
        if (resetl)
            currentpc <= nextpc;
        else
            currentpc <= startpc;
    end

    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
    assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];

    InstructionMemory imem(
        .Data(instruction),
        .Address(currentpc)
    );

    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode)
    );
    
    assign aluin2 = alusrc ? extimm : regoutB;
    
        
    /*Mux21 alumux(
        .out(aluin2),
        .in1(extimm),
        .in0(regoutB),
        .sel(alusrc)
    );*/
    
    assign writedata_reg = mem2reg ? dmemout : aluout;
        
    /*Mux21 writedatamux(
        .out(writedata_reg),
        .in1(dmemout),
        .in0(aluout),
        .sel(mem2reg)
    );*/
    
    ALU ALU(
        .BusW(aluout),
        .BusA(regoutA),
        .BusB(aluin2),
        .ALUCtrl(aluctrl),
        .Zero(zero)
    );
    
    NextPCLogic nextpclogic(
        .NextPC(nextpc),
        .CurrentPC(currentpc),
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch)
    );
    
    SignExtender signext(
        .instruction(instruction[25:0]),
        .control(signop),
        .extended(extimm)
    );
    
    DataMemory datamem(
        .ReadData(dmemout),
        .Address(aluout),
        .WriteData(regoutB),
        .MemoryRead(memread),
        .MemoryWrite(memwrite),
        .Clock(CLK)
    );

    RegisterFile regfile(
        .BusA(regoutA),
        .BusB(regoutB),
        .BusW(writedata_reg),
        .RA(rm),
        .RB(rn),
        .RW(rd),
        .RegWr(regwrite),
        .Clk(CLK)
    );
    

    /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */



endmodule

