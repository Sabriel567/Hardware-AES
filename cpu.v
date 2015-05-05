`timescale 1ps/1ps
module main();

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(1,main);
//        in[0][31:24] <= 8'h19;in[0][23:16] <= 8'ha0;in[0][15:8] <= 8'h9a;in[0][7:0] <= 8'he9;
//        in[1][31:24] <= 8'h3d;in[1][23:16] <= 8'hf4;in[1][15:8] <= 8'hc6;in[1][7:0] <= 8'hf8;
//        in[2][31:24] <= 8'he3;in[2][23:16] <= 8'he2;in[2][15:8] <= 8'h8d;in[2][7:0] <= 8'h48;
//        in[3][31:24] <= 8'hbe;in[3][23:16] <= 8'h2b;in[3][15:8] <= 8'h2a;in[3][7:0] <= 8'h08;
          
        in[0][31:24] <= 8'h2b;in[0][23:16] <= 8'h28;in[0][15:8] <= 8'hab;in[0][7:0] <= 8'h09;
        in[1][31:24] <= 8'h7e;in[1][23:16] <= 8'hae;in[1][15:8] <= 8'hf7;in[1][7:0] <= 8'hcf;
        in[2][31:24] <= 8'h15;in[2][23:16] <= 8'hd2;in[2][15:8] <= 8'h15;in[2][7:0] <= 8'h4f;
        in[3][31:24] <= 8'h16;in[3][23:16] <= 8'ha6;in[3][15:8] <= 8'h88;in[3][7:0] <= 8'h3c;
    end

    // clock
    wire clk;
    clock c0(clk);

    reg [7:0]counter = 0;
    reg cipher_ready = 1;
    reg cipher_running = 0;
    wire keyready;
    wire keygening;

    wire [31:0]out[3:0];
    reg [31:0]in[3:0];
    genroundkey g0(clk, 1, cipher_ready, in[0], in[1], in[2], in[3], out[0], out[1], out[2], out[3], keyready, keygening);
    
    always @(posedge clk) begin
      if(keygening) begin
        cipher_ready <= 0;
      end else $finish;
      if(keyready) begin
        $display("OUT: \n%x\n%x\n%x\n%x\nCOUNTER: %d", out[0], out[1], out[2], out[3], counter);
      end
      if(keygening || cipher_ready) counter <= counter + 1;
    end

endmodule

/* clock */
module clock(output clk);
    reg theClock = 1;

    assign clk = theClock;
    
    always begin
        #5;
        theClock = !theClock;
    end
endmodule



