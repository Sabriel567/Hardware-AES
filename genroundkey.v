module genroundkey(input clk, input encode, input cipherready, input [31:0]ck0,  input [31:0]ck1, input [31:0]ck2, input [31:0]ck3,
               output [31:0]out0, output [31:0]out1, output [31:0]out2, output [31:0]out3, output keyready, output keygening);
  reg [127:0]sbox[15:0];
  reg [127:0]sibox[15:0];
  reg [7:0]rcon = 1;
  reg [8:0]rounds = 40;

  initial begin
    sbox[0][7:0] <= 8'h63;sbox[0][15:8] <= 8'h7c;sbox[0][23:16] <= 8'h77;sbox[0][31:24] <= 8'h7b;sbox[0][39:32] <= 8'hf2;sbox[0][47:40] <= 8'h6b;sbox[0][55:48] <= 8'h6f;sbox[0][63:56] <= 8'hc5;sbox[0][71:64] <= 8'h30;sbox[0][79:72] <= 8'h01;sbox[0][87:80] <= 8'h67;sbox[0][95:88] <= 8'h2b;sbox[0][103:96] <= 8'hfe;sbox[0][111:104] <= 8'hd7;sbox[0][119:112] <= 8'hab;sbox[0][127:120] <= 8'h76;
    sbox[1][7:0] <= 8'hca;sbox[1][15:8] <= 8'h82;sbox[1][23:16] <= 8'hc9;sbox[1][31:24] <= 8'h7d;sbox[1][39:32] <= 8'hfa;sbox[1][47:40] <= 8'h59;sbox[1][55:48] <= 8'h47;sbox[1][63:56] <= 8'hf0;sbox[1][71:64] <= 8'had;sbox[1][79:72] <= 8'hd4;sbox[1][87:80] <= 8'ha2;sbox[1][95:88] <= 8'haf;sbox[1][103:96] <= 8'h9c;sbox[1][111:104] <= 8'ha4;sbox[1][119:112] <= 8'h72;sbox[1][127:120] <= 8'hc0;
    sbox[2][7:0] <= 8'hb7;sbox[2][15:8] <= 8'hfd;sbox[2][23:16] <= 8'h93;sbox[2][31:24] <= 8'h26;sbox[2][39:32] <= 8'h36;sbox[2][47:40] <= 8'h3f;sbox[2][55:48] <= 8'hf7;sbox[2][63:56] <= 8'hcc;sbox[2][71:64] <= 8'h34;sbox[2][79:72] <= 8'ha5;sbox[2][87:80] <= 8'he5;sbox[2][95:88] <= 8'hf1;sbox[2][103:96] <= 8'h71;sbox[2][111:104] <= 8'hd8;sbox[2][119:112] <= 8'h31;sbox[2][127:120] <= 8'h15;
    sbox[3][7:0] <= 8'h04;sbox[3][15:8] <= 8'hc7;sbox[3][23:16] <= 8'h23;sbox[3][31:24] <= 8'hc3;sbox[3][39:32] <= 8'h18;sbox[3][47:40] <= 8'h96;sbox[3][55:48] <= 8'h05;sbox[3][63:56] <= 8'h9a;sbox[3][71:64] <= 8'h07;sbox[3][79:72] <= 8'h12;sbox[3][87:80] <= 8'h80;sbox[3][95:88] <= 8'he2;sbox[3][103:96] <= 8'heb;sbox[3][111:104] <= 8'h27;sbox[3][119:112] <= 8'hb2;sbox[3][127:120] <= 8'h75;
    sbox[4][7:0] <= 8'h09;sbox[4][15:8] <= 8'h83;sbox[4][23:16] <= 8'h2c;sbox[4][31:24] <= 8'h1a;sbox[4][39:32] <= 8'h1b;sbox[4][47:40] <= 8'h6e;sbox[4][55:48] <= 8'h5a;sbox[4][63:56] <= 8'ha0;sbox[4][71:64] <= 8'h52;sbox[4][79:72] <= 8'h3b;sbox[4][87:80] <= 8'hd6;sbox[4][95:88] <= 8'hb3;sbox[4][103:96] <= 8'h29;sbox[4][111:104] <= 8'he3;sbox[4][119:112] <= 8'h2f;sbox[4][127:120] <= 8'h84;
    sbox[5][7:0] <= 8'h53;sbox[5][15:8] <= 8'hd1;sbox[5][23:16] <= 8'h00;sbox[5][31:24] <= 8'hed;sbox[5][39:32] <= 8'h20;sbox[5][47:40] <= 8'hfc;sbox[5][55:48] <= 8'hb1;sbox[5][63:56] <= 8'h5b;sbox[5][71:64] <= 8'h6a;sbox[5][79:72] <= 8'hcb;sbox[5][87:80] <= 8'hbe;sbox[5][95:88] <= 8'h39;sbox[5][103:96] <= 8'h4a;sbox[5][111:104] <= 8'h4c;sbox[5][119:112] <= 8'h58;sbox[5][127:120] <= 8'hcf;
    sbox[6][7:0] <= 8'hd0;sbox[6][15:8] <= 8'hef;sbox[6][23:16] <= 8'haa;sbox[6][31:24] <= 8'hfb;sbox[6][39:32] <= 8'h43;sbox[6][47:40] <= 8'h4d;sbox[6][55:48] <= 8'h33;sbox[6][63:56] <= 8'h85;sbox[6][71:64] <= 8'h45;sbox[6][79:72] <= 8'hf9;sbox[6][87:80] <= 8'h02;sbox[6][95:88] <= 8'h7f;sbox[6][103:96] <= 8'h50;sbox[6][111:104] <= 8'h3c;sbox[6][119:112] <= 8'h9f;sbox[6][127:120] <= 8'ha8;
    sbox[7][7:0] <= 8'h51;sbox[7][15:8] <= 8'ha3;sbox[7][23:16] <= 8'h40;sbox[7][31:24] <= 8'h8f;sbox[7][39:32] <= 8'h92;sbox[7][47:40] <= 8'h9d;sbox[7][55:48] <= 8'h38;sbox[7][63:56] <= 8'hf5;sbox[7][71:64] <= 8'hbc;sbox[7][79:72] <= 8'hb6;sbox[7][87:80] <= 8'hda;sbox[7][95:88] <= 8'h21;sbox[7][103:96] <= 8'h10;sbox[7][111:104] <= 8'hff;sbox[7][119:112] <= 8'hf3;sbox[7][127:120] <= 8'hd2;
    sbox[8][7:0] <= 8'hcd;sbox[8][15:8] <= 8'h0c;sbox[8][23:16] <= 8'h13;sbox[8][31:24] <= 8'hec;sbox[8][39:32] <= 8'h5f;sbox[8][47:40] <= 8'h97;sbox[8][55:48] <= 8'h44;sbox[8][63:56] <= 8'h17;sbox[8][71:64] <= 8'hc4;sbox[8][79:72] <= 8'ha7;sbox[8][87:80] <= 8'h7e;sbox[8][95:88] <= 8'h3d;sbox[8][103:96] <= 8'h64;sbox[8][111:104] <= 8'h5d;sbox[8][119:112] <= 8'h19;sbox[8][127:120] <= 8'h73;
    sbox[9][7:0] <= 8'h60;sbox[9][15:8] <= 8'h81;sbox[9][23:16] <= 8'h4f;sbox[9][31:24] <= 8'hdc;sbox[9][39:32] <= 8'h22;sbox[9][47:40] <= 8'h2a;sbox[9][55:48] <= 8'h90;sbox[9][63:56] <= 8'h88;sbox[9][71:64] <= 8'h46;sbox[9][79:72] <= 8'hee;sbox[9][87:80] <= 8'hb8;sbox[9][95:88] <= 8'h14;sbox[9][103:96] <= 8'hde;sbox[9][111:104] <= 8'h5e;sbox[9][119:112] <= 8'h0b;sbox[9][127:120] <= 8'hdb;
    sbox[10][7:0] <= 8'he0;sbox[10][15:8] <= 8'h32;sbox[10][23:16] <= 8'h3a;sbox[10][31:24] <= 8'h0a;sbox[10][39:32] <= 8'h49;sbox[10][47:40] <= 8'h06;sbox[10][55:48] <= 8'h24;sbox[10][63:56] <= 8'h5c;sbox[10][71:64] <= 8'hc2;sbox[10][79:72] <= 8'hd3;sbox[10][87:80] <= 8'hac;sbox[10][95:88] <= 8'h62;sbox[10][103:96] <= 8'h91;sbox[10][111:104] <= 8'h95;sbox[10][119:112] <= 8'he4;sbox[10][127:120] <= 8'h79;
    sbox[11][7:0] <= 8'he7;sbox[11][15:8] <= 8'hc8;sbox[11][23:16] <= 8'h37;sbox[11][31:24] <= 8'h6d;sbox[11][39:32] <= 8'h8d;sbox[11][47:40] <= 8'hd5;sbox[11][55:48] <= 8'h4e;sbox[11][63:56] <= 8'ha9;sbox[11][71:64] <= 8'h6c;sbox[11][79:72] <= 8'h56;sbox[11][87:80] <= 8'hf4;sbox[11][95:88] <= 8'hea;sbox[11][103:96] <= 8'h65;sbox[11][111:104] <= 8'h7a;sbox[11][119:112] <= 8'hae;sbox[11][127:120] <= 8'h08;
    sbox[12][7:0] <= 8'hba;sbox[12][15:8] <= 8'h78;sbox[12][23:16] <= 8'h25;sbox[12][31:24] <= 8'h2e;sbox[12][39:32] <= 8'h1c;sbox[12][47:40] <= 8'ha6;sbox[12][55:48] <= 8'hb4;sbox[12][63:56] <= 8'hc6;sbox[12][71:64] <= 8'he8;sbox[12][79:72] <= 8'hdd;sbox[12][87:80] <= 8'h74;sbox[12][95:88] <= 8'h1f;sbox[12][103:96] <= 8'h4b;sbox[12][111:104] <= 8'hbd;sbox[12][119:112] <= 8'h8b;sbox[12][127:120] <= 8'h8a;
    sbox[13][7:0] <= 8'h70;sbox[13][15:8] <= 8'h3e;sbox[13][23:16] <= 8'hb5;sbox[13][31:24] <= 8'h66;sbox[13][39:32] <= 8'h48;sbox[13][47:40] <= 8'h03;sbox[13][55:48] <= 8'hf6;sbox[13][63:56] <= 8'h0e;sbox[13][71:64] <= 8'h61;sbox[13][79:72] <= 8'h35;sbox[13][87:80] <= 8'h57;sbox[13][95:88] <= 8'hb9;sbox[13][103:96] <= 8'h86;sbox[13][111:104] <= 8'hc1;sbox[13][119:112] <= 8'h1d;sbox[13][127:120] <= 8'h9e;
    sbox[14][7:0] <= 8'he1;sbox[14][15:8] <= 8'hf8;sbox[14][23:16] <= 8'h98;sbox[14][31:24] <= 8'h11;sbox[14][39:32] <= 8'h69;sbox[14][47:40] <= 8'hd9;sbox[14][55:48] <= 8'h8e;sbox[14][63:56] <= 8'h94;sbox[14][71:64] <= 8'h9b;sbox[14][79:72] <= 8'h1e;sbox[14][87:80] <= 8'h87;sbox[14][95:88] <= 8'he9;sbox[14][103:96] <= 8'hce;sbox[14][111:104] <= 8'h55;sbox[14][119:112] <= 8'h28;sbox[14][127:120] <= 8'hdf;
    sbox[15][7:0] <= 8'h8c;sbox[15][15:8] <= 8'ha1;sbox[15][23:16] <= 8'h89;sbox[15][31:24] <= 8'h0d;sbox[15][39:32] <= 8'hbf;sbox[15][47:40] <= 8'he6;sbox[15][55:48] <= 8'h42;sbox[15][63:56] <= 8'h68;sbox[15][71:64] <= 8'h41;sbox[15][79:72] <= 8'h99;sbox[15][87:80] <= 8'h2d;sbox[15][95:88] <= 8'h0f;sbox[15][103:96] <= 8'hb0;sbox[15][111:104] <= 8'h54;sbox[15][119:112] <= 8'hbb;sbox[15][127:120] <= 8'h16;
    sibox[0][7:0] <= 8'h52;sibox[0][15:8] <= 8'h09;sibox[0][23:16] <= 8'h6a;sibox[0][31:24] <= 8'hd5;sibox[0][39:32] <= 8'h30;sibox[0][47:40] <= 8'h36;sibox[0][55:48] <= 8'ha5;sibox[0][63:56] <= 8'h38;sibox[0][71:64] <= 8'hbf;sibox[0][79:72] <= 8'h40;sibox[0][87:80] <= 8'ha3;sibox[0][95:88] <= 8'h9e;sibox[0][103:96] <= 8'h81;sibox[0][111:104] <= 8'hf3;sibox[0][119:112] <= 8'hd7;sibox[0][127:120] <= 8'hfb;
    sibox[1][7:0] <= 8'h7c;sibox[1][15:8] <= 8'he3;sibox[1][23:16] <= 8'h39;sibox[1][31:24] <= 8'h82;sibox[1][39:32] <= 8'h9b;sibox[1][47:40] <= 8'h2f;sibox[1][55:48] <= 8'hff;sibox[1][63:56] <= 8'h87;sibox[1][71:64] <= 8'h34;sibox[1][79:72] <= 8'h8e;sibox[1][87:80] <= 8'h43;sibox[1][95:88] <= 8'h44;sibox[1][103:96] <= 8'hc4;sibox[1][111:104] <= 8'hde;sibox[1][119:112] <= 8'he9;sibox[1][127:120] <= 8'hcb;
    sibox[2][7:0] <= 8'h54;sibox[2][15:8] <= 8'h7b;sibox[2][23:16] <= 8'h94;sibox[2][31:24] <= 8'h32;sibox[2][39:32] <= 8'ha6;sibox[2][47:40] <= 8'hc2;sibox[2][55:48] <= 8'h23;sibox[2][63:56] <= 8'h3d;sibox[2][71:64] <= 8'hee;sibox[2][79:72] <= 8'h4c;sibox[2][87:80] <= 8'h95;sibox[2][95:88] <= 8'h0b;sibox[2][103:96] <= 8'h42;sibox[2][111:104] <= 8'hfa;sibox[2][119:112] <= 8'hc3;sibox[2][127:120] <= 8'h4e;
    sibox[3][7:0] <= 8'h08;sibox[3][15:8] <= 8'h2e;sibox[3][23:16] <= 8'ha1;sibox[3][31:24] <= 8'h66;sibox[3][39:32] <= 8'h28;sibox[3][47:40] <= 8'hd9;sibox[3][55:48] <= 8'h24;sibox[3][63:56] <= 8'hb2;sibox[3][71:64] <= 8'h76;sibox[3][79:72] <= 8'h5b;sibox[3][87:80] <= 8'ha2;sibox[3][95:88] <= 8'h49;sibox[3][103:96] <= 8'h6d;sibox[3][111:104] <= 8'h8b;sibox[3][119:112] <= 8'hd1;sibox[3][127:120] <= 8'h25;
    sibox[4][7:0] <= 8'h72;sibox[4][15:8] <= 8'hf8;sibox[4][23:16] <= 8'hf6;sibox[4][31:24] <= 8'h64;sibox[4][39:32] <= 8'h86;sibox[4][47:40] <= 8'h68;sibox[4][55:48] <= 8'h98;sibox[4][63:56] <= 8'h16;sibox[4][71:64] <= 8'hd4;sibox[4][79:72] <= 8'ha4;sibox[4][87:80] <= 8'h5c;sibox[4][95:88] <= 8'hcc;sibox[4][103:96] <= 8'h5d;sibox[4][111:104] <= 8'h65;sibox[4][119:112] <= 8'hb6;sibox[4][127:120] <= 8'h92;
    sibox[5][7:0] <= 8'h6c;sibox[5][15:8] <= 8'h70;sibox[5][23:16] <= 8'h48;sibox[5][31:24] <= 8'h50;sibox[5][39:32] <= 8'hfd;sibox[5][47:40] <= 8'hed;sibox[5][55:48] <= 8'hb9;sibox[5][63:56] <= 8'hda;sibox[5][71:64] <= 8'h5e;sibox[5][79:72] <= 8'h15;sibox[5][87:80] <= 8'h46;sibox[5][95:88] <= 8'h57;sibox[5][103:96] <= 8'ha7;sibox[5][111:104] <= 8'h8d;sibox[5][119:112] <= 8'h9d;sibox[5][127:120] <= 8'h84;
    sibox[6][7:0] <= 8'h90;sibox[6][15:8] <= 8'hd8;sibox[6][23:16] <= 8'hab;sibox[6][31:24] <= 8'h00;sibox[6][39:32] <= 8'h8c;sibox[6][47:40] <= 8'hbc;sibox[6][55:48] <= 8'hd3;sibox[6][63:56] <= 8'h0a;sibox[6][71:64] <= 8'hf7;sibox[6][79:72] <= 8'he4;sibox[6][87:80] <= 8'h58;sibox[6][95:88] <= 8'h05;sibox[6][103:96] <= 8'hb8;sibox[6][111:104] <= 8'hb3;sibox[6][119:112] <= 8'h45;sibox[6][127:120] <= 8'h06;
    sibox[7][7:0] <= 8'hd0;sibox[7][15:8] <= 8'h2c;sibox[7][23:16] <= 8'h1e;sibox[7][31:24] <= 8'h8f;sibox[7][39:32] <= 8'hca;sibox[7][47:40] <= 8'h3f;sibox[7][55:48] <= 8'h0f;sibox[7][63:56] <= 8'h02;sibox[7][71:64] <= 8'hc1;sibox[7][79:72] <= 8'haf;sibox[7][87:80] <= 8'hbd;sibox[7][95:88] <= 8'h03;sibox[7][103:96] <= 8'h01;sibox[7][111:104] <= 8'h13;sibox[7][119:112] <= 8'h8a;sibox[7][127:120] <= 8'h6b;
    sibox[8][7:0] <= 8'h3a;sibox[8][15:8] <= 8'h91;sibox[8][23:16] <= 8'h11;sibox[8][31:24] <= 8'h41;sibox[8][39:32] <= 8'h4f;sibox[8][47:40] <= 8'h67;sibox[8][55:48] <= 8'hdc;sibox[8][63:56] <= 8'hea;sibox[8][71:64] <= 8'h97;sibox[8][79:72] <= 8'hf2;sibox[8][87:80] <= 8'hcf;sibox[8][95:88] <= 8'hce;sibox[8][103:96] <= 8'hf0;sibox[8][111:104] <= 8'hb4;sibox[8][119:112] <= 8'he6;sibox[8][127:120] <= 8'h73;
    sibox[9][7:0] <= 8'h96;sibox[9][15:8] <= 8'hac;sibox[9][23:16] <= 8'h74;sibox[9][31:24] <= 8'h22;sibox[9][39:32] <= 8'he7;sibox[9][47:40] <= 8'had;sibox[9][55:48] <= 8'h35;sibox[9][63:56] <= 8'h85;sibox[9][71:64] <= 8'he2;sibox[9][79:72] <= 8'hf9;sibox[9][87:80] <= 8'h37;sibox[9][95:88] <= 8'he8;sibox[9][103:96] <= 8'h1c;sibox[9][111:104] <= 8'h75;sibox[9][119:112] <= 8'hdf;sibox[9][127:120] <= 8'h6e;
    sibox[10][7:0] <= 8'h47;sibox[10][15:8] <= 8'hf1;sibox[10][23:16] <= 8'h1a;sibox[10][31:24] <= 8'h71;sibox[10][39:32] <= 8'h1d;sibox[10][47:40] <= 8'h29;sibox[10][55:48] <= 8'hc5;sibox[10][63:56] <= 8'h89;sibox[10][71:64] <= 8'h6f;sibox[10][79:72] <= 8'hb7;sibox[10][87:80] <= 8'h62;sibox[10][95:88] <= 8'h0e;sibox[10][103:96] <= 8'haa;sibox[10][111:104] <= 8'h18;sibox[10][119:112] <= 8'hbe;sibox[10][127:120] <= 8'h1b;
    sibox[11][7:0] <= 8'hfc;sibox[11][15:8] <= 8'h56;sibox[11][23:16] <= 8'h3e;sibox[11][31:24] <= 8'h4b;sibox[11][39:32] <= 8'hc6;sibox[11][47:40] <= 8'hd2;sibox[11][55:48] <= 8'h79;sibox[11][63:56] <= 8'h20;sibox[11][71:64] <= 8'h9a;sibox[11][79:72] <= 8'hdb;sibox[11][87:80] <= 8'hc0;sibox[11][95:88] <= 8'hfe;sibox[11][103:96] <= 8'h78;sibox[11][111:104] <= 8'hcd;sibox[11][119:112] <= 8'h5a;sibox[11][127:120] <= 8'hf4;
    sibox[12][7:0] <= 8'h1f;sibox[12][15:8] <= 8'hdd;sibox[12][23:16] <= 8'ha8;sibox[12][31:24] <= 8'h33;sibox[12][39:32] <= 8'h88;sibox[12][47:40] <= 8'h07;sibox[12][55:48] <= 8'hc7;sibox[12][63:56] <= 8'h31;sibox[12][71:64] <= 8'hb1;sibox[12][79:72] <= 8'h12;sibox[12][87:80] <= 8'h10;sibox[12][95:88] <= 8'h59;sibox[12][103:96] <= 8'h27;sibox[12][111:104] <= 8'h80;sibox[12][119:112] <= 8'hec;sibox[12][127:120] <= 8'h5f;
    sibox[13][7:0] <= 8'h60;sibox[13][15:8] <= 8'h51;sibox[13][23:16] <= 8'h7f;sibox[13][31:24] <= 8'ha9;sibox[13][39:32] <= 8'h19;sibox[13][47:40] <= 8'hb5;sibox[13][55:48] <= 8'h4a;sibox[13][63:56] <= 8'h0d;sibox[13][71:64] <= 8'h2d;sibox[13][79:72] <= 8'he5;sibox[13][87:80] <= 8'h7a;sibox[13][95:88] <= 8'h9f;sibox[13][103:96] <= 8'h93;sibox[13][111:104] <= 8'hc9;sibox[13][119:112] <= 8'h9c;sibox[13][127:120] <= 8'hef;
    sibox[14][7:0] <= 8'ha0;sibox[14][15:8] <= 8'he0;sibox[14][23:16] <= 8'h3b;sibox[14][31:24] <= 8'h4d;sibox[14][39:32] <= 8'hae;sibox[14][47:40] <= 8'h2a;sibox[14][55:48] <= 8'hf5;sibox[14][63:56] <= 8'hb0;sibox[14][71:64] <= 8'hc8;sibox[14][79:72] <= 8'heb;sibox[14][87:80] <= 8'hbb;sibox[14][95:88] <= 8'h3c;sibox[14][103:96] <= 8'h83;sibox[14][111:104] <= 8'h53;sibox[14][119:112] <= 8'h99;sibox[14][127:120] <= 8'h61;
    sibox[15][7:0] <= 8'h17;sibox[15][15:8] <= 8'h2b;sibox[15][23:16] <= 8'h04;sibox[15][31:24] <= 8'h7e;sibox[15][39:32] <= 8'hba;sibox[15][47:40] <= 8'h77;sibox[15][55:48] <= 8'hd6;sibox[15][63:56] <= 8'h26;sibox[15][71:64] <= 8'he1;sibox[15][79:72] <= 8'h69;sibox[15][87:80] <= 8'h14;sibox[15][95:88] <= 8'h63;sibox[15][103:96] <= 8'h55;sibox[15][111:104] <= 8'h21;sibox[15][119:112] <= 8'h0c;sibox[15][127:120] <= 8'h7d;

  end

  function [7:0]subbyte;
    input encode;
    input [7:0]in;
    subbyte = encode ? sbox[in[7:4]][((in[3:0]+1)*8)-1 -: 8] : sibox[in[7:4]][((in[3:0]+1)*8)-1 -: 8] ;
  endfunction

  function [5:0]top_bound;
    input [3:0]round;
    top_bound = ((4-(round%4))*8)-1;
  endfunction

  assign keyready = (round > 0 && (round + 1) % 4 == 0) ? 1 : 0;
  assign keygening = run_key || cipherready;

  assign out0[31:8] = prev_mat[0][31:8];
  assign out1[31:8] = prev_mat[1][31:8];
  assign out2[31:8] = prev_mat[2][31:8];
  assign out3[31:8] = prev_mat[3][31:8];

  assign out0[7:0] = prev_mat[0][top_bound(round) -: 8] ^ prev_mat[0][top_bound(round-1) -: 8];  
  assign out1[7:0] = prev_mat[1][top_bound(round) -: 8] ^ prev_mat[1][top_bound(round-1) -: 8];  
  assign out2[7:0] = prev_mat[2][top_bound(round) -: 8] ^ prev_mat[2][top_bound(round-1) -: 8];  
  assign out3[7:0] = prev_mat[3][top_bound(round) -: 8] ^ prev_mat[3][top_bound(round-1) -: 8];  

  reg [8:0]round = 0;
  reg run_key = 0;

  reg [31:0]prev_mat[3:0];

  always @(posedge clk) begin
    if(cipherready) begin
      prev_mat[0] <= ck0;
      prev_mat[1] <= ck1;
      prev_mat[2] <= ck2;
      prev_mat[3] <= ck3;
      round <= 0;
      run_key <= 1;
      $display("Expansion set\n");
    end
    if(run_key) begin
      if(round % 4  == 0) begin
        prev_mat[0][31:24] <= rcon ^ subbyte(encode, prev_mat[1][7:0]) ^ prev_mat[0][31:24];
        prev_mat[1][31:24] <= 0 ^ subbyte(encode, prev_mat[2][7:0]) ^ prev_mat[1][31:24];
        prev_mat[2][31:24] <= 0 ^ subbyte(encode, prev_mat[3][7:0]) ^ prev_mat[2][31:24];
        prev_mat[3][31:24] <= 0 ^ subbyte(encode, prev_mat[0][7:0]) ^ prev_mat[3][31:24];
        rcon <= (rcon << 1) ^ (12'h11b  & -(rcon >> 7));
//        $display("OUT: \n%x\n%x\n%x\n%x\n%d", prev_mat[0], prev_mat[1], prev_mat[2], prev_mat[3]);
      end else begin
        prev_mat[0][top_bound(round) -: 8] <= prev_mat[0][top_bound(round) -: 8] ^ prev_mat[0][top_bound(round-1) -: 8];
        prev_mat[1][top_bound(round) -: 8] <= prev_mat[1][top_bound(round) -: 8] ^ prev_mat[1][top_bound(round-1) -: 8];
        prev_mat[2][top_bound(round) -: 8] <= prev_mat[2][top_bound(round) -: 8] ^ prev_mat[2][top_bound(round-1) -: 8];
        prev_mat[3][top_bound(round) -: 8] <= prev_mat[3][top_bound(round) -: 8] ^ prev_mat[3][top_bound(round-1) -: 8];
      end
      if(round <= rounds) begin
        round <= round + 1;
      end else begin
        round <= 0;
        run_key <= 0;
        $display("END GENERATION\n");
      end
    end

  end


endmodule
