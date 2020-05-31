`timescale 1ns/100ps

module RegFile16B_tb;
    reg           CLK, nRST, writeEnable;
    reg  [3:0]    readAddrA, readAddrB, writeAddr;
    reg  [15:0]   writeData;
    
    wire [15:0]   readDataA, readDataB;
    

    RegFile16B regFile(.readDataA(readDataA), .readDataB(readDataB), 
                       .readAddrA(readAddrA), .readAddrB(readAddrB), 
                       .CLK(CLK), .nRST(nRST), .writeEnable(writeEnable), 
                       .writeAddr(writeAddr), .writeData(writeData));
    
    initial begin
        CLK = 1;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        nRST = 1; writeEnable = 0;
        readAddrA = 4'b0000; readAddrB = 4'b0000; writeAddr = 4'b0000;
        writeData = 0;
        
        #5;
        nRST = 0; // reset system
        #5;
        nRST = 1;
        
        #5
        writeEnable = 1;
        writeAddr   = 4'b0000;
        writeData   = 16'b0000000000001000;
        
        #10
        writeEnable = 0;
        readAddrA   = 4'b0000;
        readAddrB   = 4'b0001;
        
        #10
        readAddrA   = 4'b0001;
        readAddrB   = 4'b0000;
        
    end
endmodule