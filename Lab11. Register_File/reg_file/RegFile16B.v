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
    
    genvar regGen;
    
    generate 
        for (regGen = 0; regGen < 16; regGen = regGen + 1) begin : registerGen
            and         passEnable(ffDecEnable[regGen], ffDec[regGen], writeEnable);
            Register16B register  (.Q(ffData[regGen]), .CLK(CLK), .nRST(nRST), .D(writeData), .EN(ffDecEnable[regGen]));
        end
    endgenerate
    
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