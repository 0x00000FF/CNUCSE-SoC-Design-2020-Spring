/*
 * Booth Encoder
 *
 * pb: partial(3bits) multiplier
 * y:  encoding result
 */
module booth_encoder(y, pb);
	input  [2:0] pb;
	output [2:0] y;

	always @* begin
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
 * Partial Product MUX
 * ma: multiplicand
 * be: booth-encoded multiplier
 * pp: partial product
 */

module booth_pp_mux(pp, ma, be);
   input  [15:0] ma;
	input  [2:0]  be;
	output [16:0] pp;
	
	always @* begin
	    case (be)
           3'b110: pp = ~{ma    , 1'b0};
           3'b111: pp = ~{ma[15], ma};
           3'b000: pp = 17'b0;
           3'b001: pp =  {ma[15], ma};
           3'b010: pp =  {ma    , 1'b0};
			  
           default: pp = 17'bxxxxxxxxxxxxxxxxx;
		 endcase
	end
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
	
	// encoding multiplier
	
endmodule