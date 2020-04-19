`timescale 1ns/100ps

module rca_8b_tb;

    reg  [7:0] x, y;
    reg  carry_in;
    
    wire [7:0] sum;
    wire carry_out;
   
    // create instance for the adder
    rca_8b_top rca( .sum(sum), .carry_out(carry_out),
                    .x(x), .y(y), .carry_in(carry_in));
   
    // update input for each 10 nanoseconds
    initial begin
        // initialize input x, y, carry_in
        x = 8'bxxxxxxxx; y = 8'bxxxxxxxx; carry_in = 1'bx;
        
        /* test case 1: 
         * X = 00000001, Y = 00000001, Carry_In = 0
         * After 10 nanosec Carry = 1
         * Expected S = 00000010 - 10ns -> S = 00000011, Carry_Out = 0
         */
        #10
        x = 8'b00000001; y = 8'b00000001; carry_in = 0;
        
        #10
        carry_in=1;
        
        /* test case 2: 
         * X = 00000011, Y = 00000001, Carry_In = 0
         * After 10 nanosec Carry = 1
         * Expected S = 00000100 - 10ns -> S = 00000101, Carry_Out = 0
         */
        #10
        x = 8'b00000011; y = 8'b00000001; carry_in = 0;
    
        #10
        carry_in=1;
        
        /* test case 3: 
         * X = 11111111, Y = 00000001, Carry_In = 0
         * After 10 nanosec Carry = 1
         * Expected S = 00000000, Carry_Out = 1 - 10ns -> S = 00000001, Carry_Out = 1
         */
        #10
        x = 8'b11111111; y = 8'b00000001; carry_in = 0;
    
        #10
        carry_in=1;
        
        /* test case 4: 
         * X = 11111110, Y = 00000001, Carry_In = 0
         * After 10 nanosec Carry = 1
         * Expected S = 11111111, Carry_Out=0 - 10ns -> S = 00000000, Carry_Out = 1
         */
        #10
        x = 8'b11111110; y = 8'b00000001; carry_in = 0;
    
        #10
        carry_in=1;
        
        /* test case 5: 
         * X = 10000000, Y = 10000000, Carry_In = 0
         * After 10 nanosec Y = 01000000
         * Expected S = 00000000, Carry_Out=1 - 10ns -> S = 11000000, Carry_Out = 0
         */
        #10
        x = 8'b10000000; y = 8'b10000000; carry_in = 0;
    
        #10
        y = 8'b01000000;
        
        /* test case 6:
         * update X to 01000000 from previous state
         * Expected S = 10000000, Carry_Out = 0
         */
        #10
        x = 8'b01000000;
        
        /* test case 7:
         * update X, Y to 00100000 from previous state
         * Expected S = 01000000, Carry_Out = 0
         */
        #10
        x = 8'b00100000; y = 8'b00100000; 

        /* test case 8:
         * update X, Y to 00010000 from previous state
         * Expected S = 00100000, Carry_Out = 0
         */
        #10
        x = 8'b00010000; y = 8'b00010000;   
       
        /* test case 9:
         * update X, Y to 00001000 from previous state
         * Expected S = 00010000, Carry_Out = 0
         */
        #10
        x = 8'b00001000; y = 8'b00001000;    
        
        /* test case 10:
         * update X, Y to 00000100 from previous state
         * Expected S = 0001000, Carry_Out = 0
         */
        #10
        x = 8'b00000100; y = 8'b00000100;    
        
        /* test case 11:
         * update X, Y to 00000010 from previous state
         * Expected S = 00000100, Carry_Out = 0
         */
        #10
        x = 8'b00000010; y = 8'b00000010;    
        
        #10;
    end
endmodule