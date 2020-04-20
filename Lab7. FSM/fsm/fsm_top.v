module fsm_top(y1, y2, x, clock);

    input  x, clock;
    output y1, y2;
    
    
    fsm_moore fsm0(.y(y1), .x(x), .clock(clock));
    /* this line is for mealy machine */
endmodule