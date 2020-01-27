`timescale 1ns / 1ps

module NextPCLogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
	input [63:0] CurrentPC, SignExtImm64;
	input Branch, ALUZero, Uncondbranch;
	output reg [63:0] NextPC;
	
	always @(Branch, ALUZero, Uncondbranch, CurrentPC, SignExtImm64) begin
		#1;
		if(Uncondbranch == 1'b1 || (Branch == 1'b1 && ALUZero == 1'b1)) //this is the mux, if unconditional branch is true or branch is true and ALU zero is true, add the sign extended value to current PC
			NextPC = #2 CurrentPC + (SignExtImm64);
		else //if not, add 4 to the Current PC
			NextPC = #1 CurrentPC + 64'b0000000000000000000000000000000000000000000000000000000000000100;
	end
endmodule