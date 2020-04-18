/*
 *  Behavioral Style Verilog Code
 *  2-to-4 Decoder
 *  out: 4bit, in: 2bit
 */

module bh_decoder_2to4(out, in);
    output [3:0] out;
    input  [1:0] in;
    
    reg    [3:0] out;

    // When input(in) changes
    always @ (in) begin
        // out is assigned with case statements
        case (in)
            2'b00: out = 4'b0001;
            2'b01: out = 4'b0010;
            2'b10: out = 4'b0100;
            2'b11: out = 4'b1000;
            
            //don't care for unexpected input
            default: out = 4'bxxxx; 
        endcase
    end
endmodule