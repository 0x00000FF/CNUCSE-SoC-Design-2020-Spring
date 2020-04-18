/*
 *  Structural Style Verilog Code
 *  4-to-1 Multiplexer
 *  4 x 1bit input, 2-bits selection, out: 1bit
 */


module st_4to1_mux(out, in0, in1, in2, in3, sel);

    input in0, in1, in2, in3;
    input [1:0] sel;

    output out;

    // wire for inversed signal for selection lines
    wire [1:0] sel_inv;
    // wire for output signals
    wire and00, and01, and10, and11;

    // inverse selection signals
    not inv0(sel_inv[0], sel[0]);
    not inv1(sel_inv[1], sel[1]);

    // get candidate output signals with AND gates
    and and0(and00, in0, sel_inv[1], sel_inv[0]);
    and and1(and01, in1, sel_inv[1], sel[0]);
    and and2(and10, in2, sel[1]    , sel_inv[0]);
    and and3(and11, in3, sel[1]    , sel[0]);

    // extract actual output signal from candidates with OR gate
    or  or0(out, and00, and01, and10, and11);

endmodule