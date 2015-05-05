module addroundkey (input clk, input encode, input [31:0]rk0, input [31:0]rk1, input [31:0]rk2, input [31:0]rk3, 
                     input [31:0]data0, input [31:0]data1, input [31:0]data2, input [31:0]data3,
                     output [31:0]out0, output [31:0]out1, output [31:0]out2, output [31:0]out3);

  assign out0[31:24] = data0[31:24] ^ rk0[31:24];
  assign out1[31:24] = data1[31:24] ^ rk1[31:24];
  assign out2[31:24] = data2[31:24] ^ rk2[31:24];
  assign out3[31:24] = data3[31:24] ^ rk3[31:24];

  assign out0[23:16] = data0[23:16] ^ rk0[23:16];
  assign out1[23:16] = data1[23:16] ^ rk1[23:16];
  assign out2[23:16] = data2[23:16] ^ rk2[23:16];
  assign out3[23:16] = data3[23:16] ^ rk3[23:16];
  
  assign out0[15:8] = data0[15:8] ^ rk0[15:8];
  assign out1[15:8] = data1[15:8] ^ rk1[15:8];
  assign out2[15:8] = data2[15:8] ^ rk2[15:8];
  assign out3[15:8] = data3[15:8] ^ rk3[15:8];

  assign out0[7:0] = data0[7:0] ^ rk0[7:0];
  assign out1[7:0] = data1[7:0] ^ rk1[7:0];
  assign out2[7:0] = data2[7:0] ^ rk2[7:0];
  assign out3[7:0] = data3[7:0] ^ rk3[7:0];
  
endmodule
