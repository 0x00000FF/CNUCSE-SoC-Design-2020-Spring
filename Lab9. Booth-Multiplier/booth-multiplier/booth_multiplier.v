/*
 * Booth Encoder
 *
 * pb: partial(3bits) multiplier
 * y:  encoding result
 */
module booth_encoder(y, pb);
	input  [2:0] pb;
	output [2:0] y;

	always begin
		case (pb)
			3'b100        : y = 3'b110;
			3'b110, 3'b101: y = 3'b111;
			3'b000, 3'b111: y = 3'b000;
			3'b010, 3'b001: y = 3'b001;
			3'b011        : y = 3'b010;
			
			default: y = 3'bxxx;
		endcase
	end
endmodule

/*
 * Partial Product Generator
 * ma: multiplicand
 * be: booth-encoded multiplier
 * pp: partial product
 */
module booth_ppg(pp, ma, be);
	input 
endmodule



/*
 * 16bx16x Modified Radix-4 Booth Multiplier
 *
 * ma:   16bit multiplicand
 * mb:   16bit multiplier
 * ov:   overflow bit
 * mout: result
 */
module booth_multiplier(ov, mout, ma, mb);
	input  [15:0]  ma, mb;
	
	output [30:0]  mout;
	output         ov;
	
	// encode
endmodule