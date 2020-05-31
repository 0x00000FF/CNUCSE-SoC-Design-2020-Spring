module Decoder16B_4to16(out, in);
    input   [3:0]  in;
    output  [15:0] out;
    
    reg     [15:0] out;
    
    always @(in) begin
        case (in)
            4'b0000: out = 16'b0000000000000001;
            4'b0001: out = 16'b0000000000000010;
            4'b0010: out = 16'b0000000000000100;
            4'b0011: out = 16'b0000000000001000;
            
            4'b0100: out = 16'b0000000000010000;
            4'b0101: out = 16'b0000000000100000;
            4'b0110: out = 16'b0000000001000000;
            4'b0111: out = 16'b0000000010000000;
            
            4'b1000: out = 16'b0000000100000000;
            4'b1001: out = 16'b0000001000000000;
            4'b1010: out = 16'b0000010000000000;
            4'b1011: out = 16'b0000100000000000;
            
            4'b1100: out = 16'b0001000000000000;
            4'b1101: out = 16'b0010000000000000;
            4'b1110: out = 16'b0100000000000000;
            4'b1111: out = 16'b1000000000000000;
            
            default: out = 16'bx;
        endcase
    end
endmodule

module Mux16B_16to1(out, in0, in1, in2, in3,
                         in4, in5, in6, in7,
                         in8, in9, inA, inB,
                         inC, inD, inE, inF, sel);

    input   [15:0] in0, in1, in2, in3,
                   in4, in5, in6, in7,
                   in8, in9, inA, inB,
                   inC, inD, inE, inF;
    input   [3 :0] sel;
    
    output  [15:0] out;
    
    reg     [15:0] out;
    
    always @(in0 or in1 or in2 or in3 or in4 or in5 or in6 or in7 or in8 or in9 or inA or inB or inC or inD or inE or inF or sel) begin
        case (sel)
            4'b0000: out = in0;
            4'b0001: out = in1;
            4'b0010: out = in2;
            4'b0011: out = in3;
            
            4'b0100: out = in4;
            4'b0101: out = in5;
            4'b0110: out = in6;
            4'b0111: out = in7;
            
            4'b1000: out = in8;
            4'b1001: out = in9;
            4'b1010: out = inA;
            4'b1011: out = inB;
            
            4'b1100: out = inC;
            4'b1101: out = inD;
            4'b1110: out = inE;
            4'b1111: out = inF;
            
            default: out = 16'bx;
        endcase
    end
endmodule

module D_FF(Q, CLK, nRST, D, EN);
    input  CLK, nRST, D, EN;
    output Q;
    
    reg    Q;
    
    always @(posedge CLK or negedge nRST) begin
        if      (nRST == 0) Q <= 0;
        else if (EN == 1)   Q <= D;
    end
endmodule

module Register16B(Q, CLK, nRST, D, EN);
    input         CLK, nRST, EN;
    input  [15:0] D;
    output [15:0] Q;
    
    genvar regGen;
    
    generate
        for (regGen = 0; regGen < 16; regGen = regGen + 1) begin : registerFFGen
            D_FF ff(.Q(Q[regGen]), .CLK(CLK), .nRST(nRST), .D(D[regGen]), .EN(EN));
        end    
    endgenerate
    
endmodule

module RegFile16B(readDataA, readDataB, readAddrA, readAddrB, CLK, nRST, writeEnable, writeAddr, writeData);
    input          CLK, nRST, writeEnable;
    input  [3:0]   readAddrA, readAddrB, writeAddr;
    input  [15:0]  writeData;
    
    output [15:0]  readDataA, readDataB;
     
    wire   [15:0]  ffDec, ffDecEnable, ffData [15:0], readDataA, readDataB;
    
    Decoder16B_4to16 writeDecoder(.out(ffDec), .in(writeAddr));
    
    
    and         passEnable0 (ffDecEnable[0],  ffDec[0],  writeEnable);
    and         passEnable1 (ffDecEnable[1],  ffDec[1],  writeEnable);
    and         passEnable2 (ffDecEnable[2],  ffDec[2],  writeEnable);
    and         passEnable3 (ffDecEnable[3],  ffDec[3],  writeEnable);
     
    and         passEnable4 (ffDecEnable[4],  ffDec[4],  writeEnable);
    and         passEnable5 (ffDecEnable[5],  ffDec[5],  writeEnable);
    and         passEnable6 (ffDecEnable[6],  ffDec[6],  writeEnable);
    and         passEnable7 (ffDecEnable[7],  ffDec[7],  writeEnable);
     
    and         passEnable8 (ffDecEnable[8],  ffDec[8],  writeEnable);
    and         passEnable9 (ffDecEnable[9],  ffDec[9],  writeEnable);
    and         passEnablea (ffDecEnable[10], ffDec[10], writeEnable);
    and         passEnableb (ffDecEnable[11], ffDec[11], writeEnable);
     
    and         passEnablec (ffDecEnable[12], ffDec[12], writeEnable);
    and         passEnabled (ffDecEnable[13], ffDec[13], writeEnable);
    and         passEnablee (ffDecEnable[14], ffDec[14], writeEnable);
    and         passEnablef (ffDecEnable[15], ffDec[15], writeEnable);
     
    Register16B register0   (.Q(ffData[0]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[0]));
    Register16B register1   (.Q(ffData[1]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[1]));
    Register16B register2   (.Q(ffData[2]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[2]));
    Register16B register3   (.Q(ffData[3]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[3]));
                                                                                                   
    Register16B register4   (.Q(ffData[4]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[4]));
    Register16B register5   (.Q(ffData[5]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[5]));
    Register16B register6   (.Q(ffData[6]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[6]));
    Register16B register7   (.Q(ffData[7]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[7]));
                                                                                                   
    Register16B register8   (.Q(ffData[8]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[8]));
    Register16B register9   (.Q(ffData[9]),  .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[9]));
    Register16B registera   (.Q(ffData[10]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[10]));
    Register16B registerb   (.Q(ffData[11]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[11]));
                                                                                                   
    Register16B registerc   (.Q(ffData[12]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[12]));
    Register16B registerd   (.Q(ffData[13]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[13]));
    Register16B registere   (.Q(ffData[14]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[14]));
    Register16B registerf   (.Q(ffData[15]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[15]));  
    
    Mux16B_16to1 regReadA(.out(readDataA), 
                          .in0(ffData[0]),  .in1(ffData[1]),  .in2(ffData[2]),  .in3(ffData[3]), 
                          .in4(ffData[4]),  .in5(ffData[5]),  .in6(ffData[6]),  .in7(ffData[7]), 
                          .in8(ffData[8]),  .in9(ffData[9]),  .inA(ffData[10]), .inB(ffData[11]), 
                          .inC(ffData[12]), .inD(ffData[13]), .inE(ffData[14]), .inF(ffData[15]), .sel(readAddrA));
                          
    Mux16B_16to1 regReadB(.out(readDataB), 
                          .in0(ffData[0]),  .in1(ffData[1]),  .in2(ffData[2]),  .in3(ffData[3]), 
                          .in4(ffData[4]),  .in5(ffData[5]),  .in6(ffData[6]),  .in7(ffData[7]), 
                          .in8(ffData[8]),  .in9(ffData[9]),  .inA(ffData[10]), .inB(ffData[11]), 
                          .inC(ffData[12]), .inD(ffData[13]), .inE(ffData[14]), .inF(ffData[15]), .sel(readAddrB));
endmodule