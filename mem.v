/*Memory with 1 read, and 1 write port */

`timescale 1ps/1ps

module mem(input clk, 

	//read port
	input ren, output [31:0]row0, output [31:0]row1, output [31:0]row2, output [31:0]row3,
	
	//write port
	input wen, input [31:0]row0, input [31:0]row1, input [31:0]row2, input [31:0]row3);


	initial begin
		$readmemh("input.txt", mem);
		pc = 0
	end

	reg [15:0]pc;
	reg [31:0]mem[1023:0];

	assign row0 = mem[pc];
	assign row1 = mem[pc+1];
	assign row2 = mem[pc+2];
	assign row3 = mem[pc+3];

	always @(posedge clk) begin
		if(wen) begin
			$writememh("output.txt", row0);
			$writememh("output.txt", row1);
			$writememh("output.txt", row2);
			$writememh("output.txt", row3);
		end
		if(ren) begin
			pc <= pc + 4;
		end
	end



end module
