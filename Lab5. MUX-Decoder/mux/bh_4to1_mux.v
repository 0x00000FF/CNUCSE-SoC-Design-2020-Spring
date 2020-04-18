/*
 *  Behavioral Style Verilog Code
 *  4-to-1 Multiplexer
 *  4 x 1bit input, 2-bits selection, out: 1bit
 */

module bh_4to1_mux(out, in0, in1, in2, in3, sel);
    output out;
    input  in0, in1, in2, in3;
    input  [1:0] sel;

    // register type 'out' should be declared for assignment
    reg    out;

    always @ (sel or in0 or in1 or in2 or in3) begin
         // out is assigned with case statements
         case (sel)
              2'b00: out = in0;
              2'b01: out = in1;
              2'b10: out = in2;
              2'b11: out = in3;
              
              // don't care for unexpected input
              default: out = 1'bx;
         endcase
    end
endmodule