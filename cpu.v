`timescale 1ps/1ps
module main();
    reg [31:0]ck[3:0];
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(1,main);
        $dumpvars(1,g0);
        $dumpvars(1,sb1);
        $dumpvars(1,mc1);
        $dumpvars(1,ar1);
        $dumpvars(1,ar0);
//        $dumpvars(1, main.mc1_data[0]);
//        $dumpvars(1, main.mc1_data[1]);
//        $dumpvars(1, main.mc1_data[2]);
//        $dumpvars(1, main.mc1_data[3]);
//        $dumpvars(1, main.sb1_data[0]);
//        $dumpvars(1, main.sb1_data[1]);
//        $dumpvars(1, main.sb1_data[2]);
//        $dumpvars(1, main.sb1_data[3]);
//        $dumpvars(1, main.sr1_data[0]);
//        $dumpvars(1, main.sr1_data[1]);
//        $dumpvars(1, main.sr1_data[2]);
//        $dumpvars(1, main.sr1_data[3]);
//        $dumpvars(1, main.ar1_data[0]);
//        $dumpvars(1, main.ar1_data[1]);
//        $dumpvars(1, main.ar1_data[2]);
//        $dumpvars(1, main.ar1_data[3]);
//        $dumpvars(1, main.ar0_data[0]);
//        $dumpvars(1, main.ar0_data[1]);
//        $dumpvars(1, main.ar0_data[2]);
//        $dumpvars(1, main.ar0_data[3]);
//        $dumpvars(1, main.ar0_out[0]);
//        $dumpvars(1, main.ar0_out[1]);
//        $dumpvars(1, main.ar0_out[2]);
//        $dumpvars(1, main.ar0_out[3]);
//        ar0_data[0][31:24] <= 8'h32;ar0_data[0][23:16] <= 8'h88;ar0_data[0][15:8] <= 8'h31;ar0_data[0][7:0] <= 8'he0;
//        ar0_data[1][31:24] <= 8'h43;ar0_data[1][23:16] <= 8'h5a;ar0_data[1][15:8] <= 8'h31;ar0_data[1][7:0] <= 8'h37;
//        ar0_data[2][31:24] <= 8'hf6;ar0_data[2][23:16] <= 8'h30;ar0_data[2][15:8] <= 8'h98;ar0_data[2][7:0] <= 8'h07;
//        ar0_data[3][31:24] <= 8'ha8;ar0_data[3][23:16] <= 8'h8d;ar0_data[3][15:8] <= 8'ha2;ar0_data[3][7:0] <= 8'h34;
          
        ck[0][31:24] <= 8'h2b;ck[0][23:16] <= 8'h28;ck[0][15:8] <= 8'hab;ck[0][7:0] <= 8'h09;
        ck[1][31:24] <= 8'h7e;ck[1][23:16] <= 8'hae;ck[1][15:8] <= 8'hf7;ck[1][7:0] <= 8'hcf;
        ck[2][31:24] <= 8'h15;ck[2][23:16] <= 8'hd2;ck[2][15:8] <= 8'h15;ck[2][7:0] <= 8'h4f;
        ck[3][31:24] <= 8'h16;ck[3][23:16] <= 8'ha6;ck[3][15:8] <= 8'h88;ck[3][7:0] <= 8'h3c;
    end

    // clock
    wire clk;
    clock c0(clk);
    wire queue_empty;
    wire pipe_empty = (!ar0_valid && !sb1_valid && !sr1_valid && !mc1_valid && !ar1_valid && !sb2_valid && !sr2_valid && !ar2_valid) ? 1 : 0;
    mem m0(clk, queue_empty,ar0_valid, ar0_data[0], ar0_data[1], ar0_data[2], ar0_data[3],ar2_valid,ar2_out[0],ar2_out[1],ar2_out[2],ar2_out[3]);

    wire [31:0]ar0_data[3:0];
    reg [4:0]ar0_round = 0;
    reg ar0_ready = 0;
    wire ar0_valid = (!ar1_valid || pipe_empty)  && !queue_empty ;
    wire [31:0]ar0_out[3:0];
    addroundkey ar0(clk, encode, ck[0], ck[1], ck[2], ck[3], 
                     ar0_data[0], ar0_data[1],ar0_data[2], ar0_data[3],
                     ar0_out[0], ar0_out[1], ar0_out[2], ar0_out[3]);

    reg [31:0]sr1_data[3:0];
    reg [4:0]sr1_round = 0;
    reg sr1_valid = 0;
    wire [31:0]sr1_out[3:0];
    shiftrows sr1(clk, sr1_data[0], sr1_data[1],sr1_data[2], sr1_data[3],
                     sr1_out[0], sr1_out[1], sr1_out[2], sr1_out[3],1,0);


    reg [31:0]sb1_data[3:0];
    reg [4:0]sb1_round = 0;
    reg sb1_valid = 0;
    wire [31:0]sb1_out[3:0];
    subbytes sb1(clk, encode, sb1_data[0], sb1_data[1],sb1_data[2], sb1_data[3],
                     sb1_out[0], sb1_out[1], sb1_out[2], sb1_out[3]);

    reg [31:0]mc1_data[3:0];
    reg [4:0]mc1_round = 0;
    reg mc1_valid = 0;
    wire [31:0]mc1_out[3:0];
    mixedColumns mc1(clk, mc1_data[0], mc1_data[1],mc1_data[2], mc1_data[3],
                     mc1_out[0], mc1_out[1], mc1_out[2], mc1_out[3]);

    reg [31:0]ar1_data[3:0];
    reg [4:0]ar1_round = 0;
    reg [4:0]ar1_prev_round = 1;
    reg ar1_valid = 0;
    wire [31:0]ar1_out[3:0];
    addroundkey ar1(clk, encode, 
                     (ar1_prev_round == ar1_round ? rk[0] : rko[0]), 
                     (ar1_prev_round == ar1_round ? rk[1] : rko[1]), 
                     (ar1_prev_round == ar1_round ? rk[2] : rko[2]), 
                     (ar1_prev_round == ar1_round ? rk[3] : rko[3]), 
                     ar1_data[0], ar1_data[1],ar1_data[2], ar1_data[3],
                     ar1_out[0], ar1_out[1], ar1_out[2], ar1_out[3]);

    reg [31:0]sb2_data[3:0];
    reg [4:0]sb2_round = 0;
    reg sb2_valid = 0;
    wire [31:0]sb2_out[3:0];
    subbytes sb2(clk, encode, sb2_data[0], sb2_data[1],sb2_data[2], sb2_data[3],
                     sb2_out[0], sb2_out[1], sb2_out[2], sb2_out[3]);

    reg [31:0]sr2_data[3:0];
    reg [4:0]sr2_round = 0;
    reg sr2_valid = 0;
    wire [31:0]sr2_out[3:0];
    shiftrows sr2(clk, sr2_data[0], sr2_data[1],sr2_data[2], sr2_data[3],
                     sr2_out[0], sr2_out[1], sr2_out[2], sr2_out[3],1,0);

    reg [31:0]ar2_data[3:0];
    reg [4:0]ar2_round = 0;
    reg ar2_valid = 0;
    wire [31:0]ar2_out[3:0];
    addroundkey ar2(clk, encode, (keyready && keygening ? rko[0] : rk2[0]), 
                     (keyready && keygening ? rko[1] : rk2[1]), 
                     (keyready && keygening ? rko[2] : rk2[2]), 
                     (keyready && keygening ? rko[3] : rk2[3]), 
                     ar2_data[0], ar2_data[1],ar2_data[2], ar2_data[3],
                     ar2_out[0], ar2_out[1], ar2_out[2], ar2_out[3]);
    reg [31:0]s_data[3:0];
    reg s_valid = 0;


    reg [7:0]counter = 0;
    reg encode = 1;
    reg cipher_ready = 1;
    reg cipher_running = 0;
    wire keyready;
    wire keygening;
    wire [31:0]rko[3:0];
    reg [31:0]rk[3:0];
    reg [31:0]rk2[3:0];
    reg stall = 1;

    genroundkey g0(clk, 1, (ar0_valid && !keygening), ck[0], ck[1], ck[2], ck[3], rko[0], rko[1], rko[2], rko[3], keyready, keygening);
    
    always @(posedge clk) begin
        counter <= counter + 1;
        //SOMETHING FOR AR0

        //Subbytes from AR0
        if(ar0_valid) begin
          sb1_valid <= 1;
          sb1_data[0] <= ar0_out[0];
          sb1_data[1] <= ar0_out[1];
          sb1_data[2]<= ar0_out[2];
          sb1_data[3]<= ar0_out[3];
        //  $display("ar0_out: \n%x\n%x\n%x\n%x\n",ar0_out[0],ar0_out[1],ar0_out[2],ar0_out[3]);
          sb1_round <= 0;
        end else if(ar1_valid && ar1_round < 9) begin
          sb1_valid <= 1;
          sb1_data[0] <= ar1_out[0];
          sb1_data[1] <= ar1_out[1];
          sb1_data[2]<= ar1_out[2];
          sb1_data[3]<= ar1_out[3];
          sb1_round <= ar1_round + 1;
          ar1_prev_round <= ar1_round;
          //$display("ar1_out: \n%x\n%x\n%x\n%x\nrk0: \n%x\n%x\n%x\n%x\n",ar1_out[0],ar1_out[1],ar1_out[2],ar1_out[3],rko[0],rko[1],rko[2],rko[3]);
          if(keyready) begin
          //  $display("ar1_out: \n%x\n%x\n%x\n%x\nrk0: \n%x\n%x\n%x\n%x\n",ar1_out[0],ar1_out[1],ar1_out[2],ar1_out[3],rko[0],rko[1],rko[2],rko[3]);
          end
          else begin
           // $display("Round Key not ready");
           // $display("ar1_out: \n%x\n%x\n%x\n%x\n",ar1_out[0],ar1_out[1],ar1_out[2],ar1_out[3]);
          //  $display("ar1_data \n%x\n%x\n%x\n%x\n",ar1_data[0],ar1_data[1],ar1_data[2],ar1_data[3]);
          //  $finish;
          end
          if(ar1_prev_round != ar1_round && keyready) begin
            rk[0] <= rko[0];
            rk[1] <= rko[1];
            rk[2] <= rko[2];
            rk[3] <= rko[3];
          end
        end else begin
          sb1_valid <= 0;
        end

        //Shift Rows from subbytes1
        if(sb1_valid) begin
          sr1_valid <= 1;
          sr1_data[0] <= sb1_out[0];
          sr1_data[1] <= sb1_out[1];
          sr1_data[2] <= sb1_out[2];
          sr1_data[3] <= sb1_out[3];
          sr1_round <= sb1_round;
          //$display("sb1_data Results: \n%x\n%x\n%x\n%x\n",sb1_data[0],sb1_data[1],sb1_data[2],sb1_data[3]);
          //$display("sb1_out Results: \n%x\n%x\n%x\n%x\n",sb1_out[0],sb1_out[1],sb1_out[2],sb1_out[3]);
        end else begin
          sr1_valid <= 0;
        end

        //MixColumns from shift rows 1
        if(sr1_valid) begin
          mc1_valid <= 1;
          mc1_data[0] <= sr1_out[0];
          mc1_data[1] <= sr1_out[1];
          mc1_data[2] <= sr1_out[2];
          mc1_data[3] <= sr1_out[3];
          mc1_round <= sr1_round;
          //$display("sb1_out Results: \n%x\n%x\n%x\n%x\n",sb1_out[0],sb1_out[1],sb1_out[2],sb1_out[3]);
          //$display("sr1_out Results: \n%x\n%x\n%x\n%x\n",sr1_out[0],sr1_out[1],sr1_out[2],sr1_out[3]);
        end else begin
          mc1_valid <= 0;
        end

        //Add round 1 from 
        if(mc1_valid) begin
          ar1_valid <= 1;
          ar1_data[0] <= mc1_out[0];
          ar1_data[1] <= mc1_out[1];
          ar1_data[2] <= mc1_out[2];
          ar1_data[3] <= mc1_out[3];
          ar1_round <= mc1_round;
         // $display("mc1_out Results: \n%x\n%x\n%x\n%x\n",mc1_out[0],mc1_out[1],mc1_out[2],mc1_out[3]);
        end else begin
          ar1_valid <= 0;
        end

        //LEAVING ROUNDS THE ROUNDS
        if(ar1_valid && ar1_round == 8) begin
          sb2_valid <= 1;
          sb2_data[0] <= ar1_out[0];
          sb2_data[1] <= ar1_out[1];
          sb2_data[2] <= ar1_out[2];
          sb2_data[3] <= ar1_out[3];
         // $display("ar1_out Results: \n%x\n%x\n%x\n%x\n",ar1_out[0],ar1_out[1],ar1_out[2],ar1_out[3]);
        end else begin
          sb2_valid <= 0;
        end
        
        if(sb2_valid) begin
          sr2_valid <= 1;
          sr2_data[0] <= sb2_out[0];
          sr2_data[1] <= sb2_out[1];
          sr2_data[2] <= sb2_out[2];
          sr2_data[3] <= sb2_out[3];
          //$display("sb2_out Results: \n%x\n%x\n%x\n%x\n",sb2_out[0],sb2_out[1],sb2_out[2],sb2_out[3]);
        end else begin
          sr2_valid <= 0;
        end

        if(sr2_valid) begin
          s_valid <= 1;
          s_data[0] <= sr2_out[0];
          s_data[1] <= sr2_out[1];
          s_data[2] <= sr2_out[2];
          s_data[3] <= sr2_out[3];
         //$display("sr2_out Results: \n%x\n%x\n%x\n%x\n",sr2_out[0],sr2_out[1],sr2_out[2],sr2_out[3]);
        end else begin
          s_valid <= 0;
        end
        
        if(s_valid) begin
          ar2_valid <= 1;
          ar2_data[0] <= s_data[0];
          ar2_data[1] <= s_data[1];
          ar2_data[2] <= s_data[2];
          ar2_data[3] <= s_data[3];
         //$display("s_out Results: \n%x\n%x\n%x\n%x\n",s_data[0],s_data[1],s_data[2],s_data[3]);
        end else begin
          ar2_valid <= 0;
        end
        //Write ar2 output to file it's encrypted

        if(ar2_valid) begin
            if(keyready) begin
              rk2[0] <= rko[0];
              rk2[1] <= rko[1];
              rk2[2] <= rko[2];
              rk2[3] <= rko[3];
            end
          
          $display("%x\n%x\n%x\n%x\n",ar2_out[0],ar2_out[1],ar2_out[2],ar2_out[3]);
        end

        if(queue_empty && pipe_empty) begin
          $finish;
        end

    end

endmodule

/* clock */
module clock(output clk);
    reg theClock = 1;

    assign clk = theClock;
    
    always begin
        #1;
        theClock = !theClock;
    end
endmodule



