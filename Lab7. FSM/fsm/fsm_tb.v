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
        X = 0;
        
        #30
        X = 1;
        
        #40
        X = 0;
        
        #70
        X = 1;
        
        #100
        X = 0;
        
        #40;
    end
endmodule