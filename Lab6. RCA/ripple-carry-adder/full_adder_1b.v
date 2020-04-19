/*
 *   1bit Full Adder Submodule for 8bit RCA
 *   201704150 Kangjun Heo
 */

module full_adder_1b(s, cout, x, y, cin);
    output s, cout;
    input  x, y, cin;
    
    wire   s, cout;
    
    // sum of x and y can be defined as x xor y xor cin
    assign s    = x ^ y ^ cin;

    // carry is calculated as (x and y) or ( (x xor y) and cin )
    assign cout = (x && y) || ( (x ^ y) && cin );
endmodule