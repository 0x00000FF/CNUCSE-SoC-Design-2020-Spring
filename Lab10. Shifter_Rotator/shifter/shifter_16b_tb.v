`timescale 1ns/100ps

module shifter_16b_tb;
    reg  [15:0] x, check;
    reg  [3:0]  sel;
    reg         dir;
    
    wire  [15:0] y;
    
    integer    i, j;
    integer    check_correct, check_wrong;
    
    shifter_16b_top  sh(.out(y), .x(x), .shift(sel), .dir(dir));
    
    initial begin
        x = 1;
        sel = 0; dir = 0;
        
        check_correct = 0; check_wrong = 0;
    
       // 16bit min to max
        for (x = 0; x <= 16'hffff; x = x + 1) begin
            check = 1;
            dir = 0;
            
            for (j = 0; j < 16; j = j+1) begin
                sel   = j;
                check = x << j;
                 
                #10
                if (y == check) check_correct = check_correct + 1;
                else begin
                    $display("TEST CASE MISMATCH: [%b << %d] %b (EXPECTED %b)", x, sel, y, check);
                    check_wrong   = check_wrong + 1;
                end
            end
            
            $display("CASE:   (x = %b), SHL 0 to 15 COMPLETE", x);
            
            dir = 1;
            for (j = 0; j < 16; j = j+1) begin
                sel   = j;
                check = x >> j;
                 
                #10
                if (y == check) check_correct = check_correct + 1;
                else begin
                    $display("TEST CASE MISMATCH: [%b >> %d] %b (EXPECTED %b)", x, sel, y, check);
                    check_wrong   = check_wrong + 1;
                end
            end
            $display("CASE:   (x = %b), SHR 0 to 15 COMPLETE\n", x);
            
            $display("CORRECT: %d, WRONG: %d SO FAR\n==========================================", 
                         check_correct, check_wrong);
        end
    end
endmodule