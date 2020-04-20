`timescale 1ns/100ps

module fsm_tb;
    
    reg  x, clock;
    wire y1, y2;
    
    fsm_top fsm0(.y1(y1), .y2(y2), .x(x), .clock(clock));
    
    initial begin
        x = 0; clock = 0;
    end
    
    // clock timing: 5ns
    always @ (*) begin
        #5 clock <= ~clock;
    end
    
    always @ (posedge clock) begin
        #30
        x = 1;
        
        #40
        x = 0;
        
        #70
        x = 1;
        
        #100
        x = 0;
        
        #40;
    end
endmodule