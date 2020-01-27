`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
/*
    Buses A, B, and W are 64 bits wide.
	
    When RegWr is set to 1, then the data on Bus W is stored in the register specified by Rw, on the negative (falling) clock edge.
    Register 31 must always read zero. 
	
    Data from registers (as specified by Ra and Rb) is sent on Bus A and Bus B respectively, after a delay of 2 tics. 
    Writes to the register file must have a delay of 3 tics. 
*/


	output [63:0] BusA, BusB;
	input [63:0] BusW;
	input RegWr, Clk;
	input [4:0] RA, RB, RW;
	
	reg [63:0] registers [31:0];
	
	initial begin
		//BusA = 64'b0;
		//BusB = 64'b0;
		registers[31] = 64'b0;
	end
	
	always @(negedge Clk) begin
		if(RegWr == 1 && RW != 5'd31) begin
			registers[RW] <= #3 BusW;
		end
	end
		
	assign #2 BusA = registers[RA];
	assign #2 BusB = registers[RB];
	
	
	/*always @ (*) begin
		BusA = #2 registers[RA];
	end
	
	always @ (*) begin
		BusB = #2 registers[RB];
	end*/
endmodule