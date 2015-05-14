/*Memory with 1 read, and 1 write port */

`timescale 1ps/1ps

module mem(input clk, output empty,

	//read port
	input ren, output [31:0]row0, output [31:0]row1, output [31:0]row2, output [31:0]row3,
	
	//write port
	input wen, input [31:0]w_row0, input [31:0]w_row1, input [31:0]w_row2, input [31:0]w_row3);


	initial begin
		$readmemh("input.txt", mem);
		pc = 0;
	end

	reg [15:0]pc;
	reg [31:0]mem[1023:0];

	assign empty = (mem[pc] == 32'h0000 && mem[pc + 1] == 32'h0000 && mem[pc + 2] == 32'h0000 && mem[pc + 3] == 32'h0000 ) ? 1 : 0;
	assign row0 = mem[pc];
	assign row1 = mem[pc+1];
	assign row2 = mem[pc+2];
	assign row3 = mem[pc+3];

	always @(posedge clk) begin
		if(wen) begin
		//	$writememh("output.txt", w_row0);
		//	$writememh("output.txt", w_row1);
		//	$writememh("output.txt", w_row2);
		//	$writememh("output.txt", w_row3);
		end
		else if(ren) begin
			pc <= pc + 4;
		end
	end



endmodule
