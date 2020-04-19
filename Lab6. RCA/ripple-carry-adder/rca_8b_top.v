/*
 *   8bit RCA Top Module
 *   201704150 Kangjun Heo
 *
 *   Input:  [7:0] x, y
 *           carry_in 
 *
 *   Output: [7:0] sum
 *           carry_out
 */

module rca_8b_top(sum, carry_out, x, y, carry_in);
    output [7:0] sum;
    output carry_out;
    
    input  [7:0] x, y;
    input  carry_in;
    
    wire   [7:0] out;
    wire   [6:0] carry;
    
    // pass input and carries for each full adders
    full_adder_1b  adder0(.s(sum[0]), .cout(carry[0]),
                          .x(x[0]), .y(y[0]), .cin(carry_in));
                          
    full_adder_1b  adder1(.s(sum[1]), .cout(carry[1]),
                          .x(x[1]), .y(y[1]), .cin(carry[0]));
                          
    full_adder_1b  adder2(.s(sum[2]), .cout(carry[2]),
                          .x(x[2]), .y(y[2]), .cin(carry[1]));
                          
    full_adder_1b  adder3(.s(sum[3]), .cout(carry[3]),
                          .x(x[3]), .y(y[3]), .cin(carry[2]));

    full_adder_1b  adder4(.s(sum[4]), .cout(carry[4]),
                          .x(x[4]), .y(y[4]), .cin(carry[3]));
                         
    full_adder_1b  adder5(.s(sum[5]), .cout(carry[5]),
                          .x(x[5]), .y(y[5]), .cin(carry[4]));
                          
    full_adder_1b  adder6(.s(sum[6]), .cout(carry[6]),
                          .x(x[6]), .y(y[6]), .cin(carry[5]));

    full_adder_1b  adder7(.s(sum[7]), .cout(carry_out),
                          .x(x[7]), .y(y[7]), .cin(carry[6]));
                          
endmodule