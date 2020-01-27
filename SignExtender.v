`timescale 1ns / 1ps

module SignExtender(input [25:0] instruction, input [1:0] control, output reg [63:0] extended);
	always @(instruction, control) begin
		if(control == 2'b00) //B
			extended = {{36{instruction[25]}}, instruction[25:0], 2'b0};
		else if(control == 2'b01) //CB
			extended = {{43{instruction[23]}}, instruction[23:5], 2'b0};
		else if(control == 2'b10) //I-type
			extended = {{52'b0}, instruction[21:10]};
		else if(control == 2'b11)//D-type
			extended = {{55{instruction[19]}}, instruction[20:12]};
	end
	
endmodule
