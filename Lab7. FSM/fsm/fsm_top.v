module fsm_top(Y1, Y2, X, clock);

    input  X, clock;
    output Y1, Y2;
    
    
    fsm_moore fsm0(.Y(Y1), .X(X), .clock(clock));
    fsm_mealy fsm1(.Y(Y2), .X(X), .clock(clock));
endmodule