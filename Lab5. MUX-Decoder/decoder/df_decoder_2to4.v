/*
 *  Dataflow Style Verilog Code
 *  2-to-4 Decoder
 *  out: 4bit, in: 2bit
 */

module df_decoder_2to4(out, in);
    output [3:0] out;
    input  [1:0] in;

    // out is assigned with nested tenary operators
    assign out = (in == 2'b00) ? 4'b0001 :
                 (in == 2'b01) ? 4'b0010 :
                 (in == 2'b10) ? 4'b0100 :
                 // don't care for unexpected input
                 (in == 2'b11) ? 4'b1000 : 4'bxxxx; 
endmodule