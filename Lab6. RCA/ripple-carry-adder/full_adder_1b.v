/*
 *   1bit Full Adder Submodule for 8bit RCA
 *   201704150 Kangjun Heo
 */

module full_adder_1b(s, cout, x, y, cin);
    output s, cout;
    input  x, y, cin;
    
    wire   s, cout;
    
    assign s    = x ^ y ^ cin;
    assign cout = (x && y) || ( (x ^ y) && cin );
endmodule