`timescale 1ns/100ps

module fsm_tb;
    
    reg  X, clock;
    wire Y1, Y2;
    
    fsm_top fsm0(.Y1(Y1), .Y2(Y2), .X(X), .clock(clock));
    
    initial begin
        X = 1'bx; clock = 0;
    end
    
    // clock interval: 5ns
    always @ (*) begin
        #5 clock <= ~clock;
    end
    
    always @ (posedge clock) begin
        X = 0; // 01 -> 11
        
        #10
        X = 1;
        
        #10    // 01 -> 02 -> 10
        X = 0;
        
        #20
        X = 1;
        
        #10
        X = 0;  // 01 -> 02 -> 03 -> 10
        
        #30
        X = 1;
        
        #10    // 01 -> 02 -> 03 -> 04(should be output 1) -> 10
        X = 0;
        
        #40
        X = 1;                    // 150ns
        
        // flip the testcase; Reset
        #10
        X = 0;
        
        #10
        X = 1;
        
        #10
        X = 0;
        
        #10    
        X = 1;
        
        #20
        X = 0;
        
        #10
        X = 1; 
        
        #30
        X = 0;
        
        #10    
        X = 1;
        
        #40
        X = 0;                  // 300ns
        
        
        // will output persists?
        #50
        X = 1;
        
        #50
        X = 0;
        #50;    // test done, total 450ns
    end
endmodule