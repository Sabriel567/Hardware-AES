`timescale 1ps/1ps
module(input clk, input [31:0]line0, input [31:0]line1, input [31:0]line2, input [31:0]line3, output [31:0]outline0, output [31:0]outline1, output [31:0]outline2, output [31:0]outline3, input ready, input decrypt) begin

	initial begin
		//Rijndael Matrix
		rijmatrix[0][31:24] = 2;
		rijmatrix[0][23:16] = 3;
		rijmatrix[0][15:8] = 1;
		rijmatrix[0][7:0] = 1;
		rijmatrix[1][31:24] = 1;
		rijmatrix[1][23:16] = 2;
		rijmatrix[1][15:8] = 3;
		rijmatrix[1][7:0] = 1;	
		rijmatrix[2][31:24] = 1;
		rijmatrix[2][23:16] = 1;
		rijmatrix[2][15:8] = 2;
		rijmatrix[2][7:0] = 3;	
		rijmatrix[3][31:24] = 3;
		rijmatrix[3][23:16] = 1;
		rijmatrix[3][15:8] = 1;
		rijmatrix[3][7:0] = 2;

		//Inverse Rijndael Matrix
		invmatrix[0][31:24] = 14;
		invmatrix[0][23:16] = 11;
		invmatrix[0][15:8] = 13;
		invmatrix[0][7:0] = 9;
		invmatrix[1][31:24] = 9;
		invmatrix[1][23:16] = 14;
		invmatrix[1][15:8] = 13;
		invmatrix[1][7:0] = 13;	
		invmatrix[2][31:24] = 13;
		invmatrix[2][23:16] = 9;
		invmatrix[2][15:8] = 14;
		invmatrix[2][7:0] = 11;	
		invmatrix[3][31:24] = 11;
		invmatrix[3][23:16] = 13;
		invmatrix[3][15:8] = 9;
		invmatrix[3][7:0] = 14;
	end

	reg[31:0]rijmatrix[3:0];
	reg[31:0]invmatrix[3:0];
	

	//Trying to figure out if there is a way to streamline mixCols.
	//As of right now values are hardcoded in, but this pains me.
	/*function [7:0]multiply;
		input [31:0]row;
		input [31:0]column;
	
	endfunction*/
	
//	always @(posedge clk) begin
	
//		if(!decrypt) begin	//encrypt
			//0th column
			assign outline0[31:24] = ((line0[31:24] * rijmatrix[0][31:24]) + (line1[31:24] * rijmatrix[0][23:16]) + (line2[31:24] * rijmatrix[0][15:8]) + (line3[31:24] * rijmatrix[0][7:0]));
			assign outline1[31:24] = ((line0[31:24] * rijmatrix[1][31:24]) + (line1[31:24] * rijmatrix[1][23:16]) + (line2[31:24] * rijmatrix[1][15:8]) + (line3[31:24] * rijmatrix[1][7:0]));
			assign outline2[31:24] = ((line0[31:24] * rijmatrix[2][31:24]) + (line1[31:24] * rijmatrix[2][23:16]) + (line2[31:24] * rijmatrix[2][15:8]) + (line3[31:24] * rijmatrix[2][7:0]));
			assign outline3[31:24] = ((line0[31:24] * rijmatrix[3][31:24]) + (line1[31:24] * rijmatrix[3][23:16]) + (line2[31:24] * rijmatrix[3][15:8]) + (line3[31:24] * rijmatrix[3][7:0]));

			//1st column
			assign outline0[23:16] = ((line0[23:16] * rijmatrix[0][31:24]) + (line1[23:16] * rijmatrix[0][23:16]) + (line2[23:16] * rijmatrix[0][15:8]) + (line3[23:16] * rijmatrix[0][7:0]));
			assign outline1[23:16] = ((line0[23:16] * rijmatrix[1][31:24]) + (line1[23:16] * rijmatrix[1][23:16]) + (line2[23:16] * rijmatrix[1][15:8]) + (line3[23:16] * rijmatrix[1][7:0]));
			assign outline2[23:16] = ((line0[23:16] * rijmatrix[2][31:24]) + (line1[23:16] * rijmatrix[2][23:16]) + (line2[23:16] * rijmatrix[2][15:8]) + (line3[23:16] * rijmatrix[2][7:0]));
			assign outline3[23:16] = ((line0[23:16] * rijmatrix[3][31:24]) + (line1[23:16] * rijmatrix[3][23:16]) + (line2[23:16] * rijmatrix[3][15:8]) + (line3[23:16] * rijmatrix[3][7:0]));
	
			//2nd column
			assign outline0[15:8] = (([15:8] * rijmatrix[0][31:24]) + ([15:8] * rijmatrix[0][23:16]) + ([15:8] * rijmatrix[0][15:8]) + ([15:8] * rijmatrix[0][7:0]));
			assign outline1[15:8] = (([15:8] * rijmatrix[1][31:24]) + ([15:8] * rijmatrix[1][23:16]) + ([15:8] * rijmatrix[1][15:8]) + ([15:8] * rijmatrix[1][7:0]));
			assign outline2[15:8] = (([15:8] * rijmatrix[2][31:24]) + ([15:8] * rijmatrix[2][23:16]) + ([15:8] * rijmatrix[2][15:8]) + ([15:8] * rijmatrix[2][7:0]));
			assign outline3[15:8] = (([15:8] * rijmatrix[3][31:24]) + ([15:8] * rijmatrix[3][23:16]) + ([15:8] * rijmatrix[3][15:8]) + ([15:8] * rijmatrix[3][7:0]));

			//3rd column
			assign outline0[7:0] = ((line0[7:0] * rijmatrix[0][31:24]) + (line1[7:0] * rijmatrix[0][23:16]) + (line2[7:0] * rijmatrix[0][15:8]) + (line3[7:0] * rijmatrix[0][7:0]));
			assign outline1[7:0] = ((line0[7:0] * rijmatrix[1][31:24]) + (line1[7:0] * rijmatrix[1][23:16]) + (line2[7:0] * rijmatrix[1][15:8]) + (line3[7:0] * rijmatrix[1][7:0]));
			assign outline2[7:0] = ((line0[7:0] * rijmatrix[2][31:24]) + (line1[7:0] * rijmatrix[2][23:16]) + (line2[7:0] * rijmatrix[2][15:8]) + (line3[7:0] * rijmatrix[2][7:0]));
			assign outline3[7:0] = ((line0[7:0] * rijmatrix[3][31:24]) + (line1[7:0] * rijmatrix[3][23:16]) + (line2[7:0] * rijmatrix[3][15:8]) + (line3[7:0] * rijmatrix[3][7:0]));
/*		end
		else begin //decrypt
			//0th column
			outline0[31:24] <= ((line0[31:24] * invmatrix[0][31:24]) + (line1[31:24] * invmatrix[0][23:16]) + (line2[31:24] * invmatrix[0][15:8]) + (line3[31:24] * invmatrix[0][7:0]));
			outline1[31:24] <= ((line0[31:24] * invmatrix[1][31:24]) + (line1[31:24] * invmatrix[1][23:16]) + (line2[31:24] * invmatrix[1][15:8]) + (line3[31:24] * invmatrix[1][7:0]));
			outline2[31:24] <= ((line0[31:24] * invmatrix[2][31:24]) + (line1[31:24] * invmatrix[2][23:16]) + (line2[31:24] * invmatrix[2][15:8]) + (line3[31:24] * invmatrix[2][7:0]));
			outline3[31:24] <= ((line0[31:24] * invmatrix[3][31:24]) + (line1[31:24] * invmatrix[3][23:16]) + (line2[31:24] * invmatrix[3][15:8]) + (line3[31:24] * invmatrix[3][7:0]));

			//1st column
			outline0[23:16] <= ((line0[23:16] * invmatrix[0][31:24]) + (line1[23:16] * invmatrix[0][23:16]) + (line2[23:16] * invmatrix[0][15:8]) + (line3[23:16] * invmatrix[0][7:0]));
			outline1[23:16] <= ((line0[23:16] * invmatrix[1][31:24]) + (line1[23:16] * invmatrix[1][23:16]) + (line2[23:16] * invmatrix[1][15:8]) + (line3[23:16] * invmatrix[1][7:0]));
			outline2[23:16] <= ((line0[23:16] * invmatrix[2][31:24]) + (line1[23:16] * invmatrix[2][23:16]) + (line2[23:16] * invmatrix[2][15:8]) + (line3[23:16] * invmatrix[2][7:0]));
			outline3[23:16] <= ((line0[23:16] * invmatrix[3][31:24]) + (line1[23:16] * invmatrix[3][23:16]) + (line2[23:16] * invmatrix[3][15:8]) + (line3[23:16] * invmatrix[3][7:0]));
	
			//2nd column
			outline0[15:8] <= ((line0[15:8] * invmatrix[0][31:24]) + (line1[15:8] * invmatrix[0][23:16]) + (line2[15:8] * invmatrix[0][15:8]) + (line3[15:8] * invmatrix[0][7:0]));
			outline1[15:8] <= ((line0[15:8] * invmatrix[1][31:24]) + (line1[15:8] * invmatrix[1][23:16]) + (line2[15:8] * invmatrix[1][15:8]) + (line3[15:8] * invmatrix[1][7:0]));
			outline2[15:8] <= ((line0[15:8] * invmatrix[2][31:24]) + (line1[15:8] * invmatrix[2][23:16]) + (line2[15:8] * invmatrix[2][15:8]) + (line3[15:8] * invmatrix[2][7:0]));
			outline3[15:8] <= ((line0[15:8] * invmatrix[3][31:24]) + (line1[15:8] * invmatrix[3][23:16]) + (line2[15:8] * invmatrix[3][15:8]) + (line3[15:8] * invmatrix[3][7:0]));

			//3rd column
			outline0[7:0] <= ((line0[7:0] * invmatrix[0][31:24]) + (line1[7:0] * invmatrix[0][23:16]) + (line2[7:0] * invmatrix[0][15:8]) + (line3[7:0] * invmatrix[0][7:0]));
			outline1[7:0] <= ((line0[7:0] * invmatrix[1][31:24]) + (line1[7:0] * invmatrix[1][23:16]) + (line2[7:0] * invmatrix[1][15:8]) + (line3[7:0] * invmatrix[1][7:0]));
			outline2[7:0] <= ((line0[7:0] * invmatrix[2][31:24]) + (line1[7:0] * invmatrix[2][23:16]) + (line2[7:0] * invmatrix[2][15:8]) + (line3[7:0] * invmatrix[2][7:0]));
			outline3[7:0] <= ((line0[7:0] * invmatrix[3][31:24]) + (line1[7:0] * invmatrix[3][23:16]) + (line2[7:0] * invmatrix[3][15:8]) + (line3[7:0] * invmatrix[3][7:0]));
		end

	end*/
endmodule
