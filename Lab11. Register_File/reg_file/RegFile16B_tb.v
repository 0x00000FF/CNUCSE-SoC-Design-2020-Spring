`timescale 1ns/100ps

`define WRITE(addr, data)           \
        #10                         \
        writeEnable = 1;            \
        writeAddr   = addr;         \
        writeData   = data;         \
        #10                         \
        writeEnable = 0;            \
        writeCount = writeCount + 1; 


`define READ(addrA, addrB, expA, expB)                                                        \ 
        #10                                                                                   \
        readAddrA = addrA;                                                                    \
        readAddrB = addrB;                                                                    \
        #10                                                                                   \
        if (readDataA == expA) readAMatchCount <= readAMatchCount + 1;                         \
        else readAMismatchCount <= readAMismatchCount + 1;                                     \
        if (readDataB == expB) readBMatchCount <= readBMatchCount + 1;                         \
        else readBMismatchCount <= readBMismatchCount + 1;           
           

           

module RegFile16B_tb;
    reg           CLK, nRST, writeEnable;
    reg  [3:0]    readAddrA, readAddrB, writeAddr;
    reg  [15:0]   writeData;
    
    wire [15:0]   readDataA, readDataB;

    
    integer     i, j,
                writeCount, readAMatchCount, readAMismatchCount,
                readBMatchCount, readBMismatchCount;
    

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

        writeCount = 0; readAMatchCount = 0; readAMismatchCount = 0;
        readBMatchCount = 0; readBMismatchCount = 0;
        
        #5;
        nRST = 0; // reset system
        #5;
        nRST = 1;
        
        #5

        // reset test
        $display(">>> [TEST] RESET");
        for (i = 0; i < 16; i = i + 1) begin
            `READ(i, i, 16'b0000000000000000, 16'b0000000000000000);
        end

        // write test
        $display(">>> [TEST] WRITE AND READ FOR EACH REGISTER");
        for (i = 0; i < 16; i = i + 1) begin
            $display(">>>>>>>>> Proceeding to %d/16", i + 1);
            for (j = 0; j <= 16'hffff; j = j + 1) begin 
                `WRITE(i, j);
                `READ(i, i, j, j);
            end 
        end

        $display("=== TEST RESULT =====================");
        $display("Total Write | %d", writeCount);
        $display("=====================================");
        $display("Match ReadA | %d", readAMatchCount);
        $display("Wrong ReadA | %d", readAMismatchCount);
        $display("=====================================");
        $display("Match ReadB | %d", readBMatchCount);
        $display("Wrong ReadB | %d", readBMismatchCount);
        $display("=====================================");
        
        #999999999999;
    end
endmodule