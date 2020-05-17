`define P2A 'd1
`define P1A 'd2
`define ZRO 'd3
`define M1A 'd4
`define M2A 'd5
`

/*
 * Booth Encoder
 *
 * pb: partial(3bits) multiplier
 * y:  encoding result
 */
module booth_encoder(y, s, pb);
	input  [2:0] pb;
	output [2:0] y;
	output       s;
	
	reg    [2:0] y;

	always @(pb) begin
		casex (pb)
			3'b100        : begin y = M2A;  s = 1'b1; end   
			3'b110, 3'b101: begin y = M1A;  s = 1'b1; end
			3'b000, 3'b111: begin y = ZRO;  s = 1'b0; end
			3'b010, 3'b001: begin y = P1A;  s = 1'b0; end
			3'b011        : begin y = P2A;  s = 1'b0; end
			
			default       : begin y = 3'bx; s = 1'bx; end
		endcase
	end
endmodule


/*
 * Partial Product MUX
 *
 * ma: multiplicand
 * be: booth-encoded multiplier
 * pp: partial product
 */

module booth_pp_mux(pp, ma, be);
   input  [15:0] ma;
	input  [2:0]  be;
	
	output [16:0] pp;
	
	reg    [16:0] pp;
	
	always @(ma or be) begin
	    casex (be)
           M2A    : pp = ~{ma    , 1'b0};
           MA     : pp = ~{ma[15], ma};
           ZRO    : pp = 17'b0;
           PA     : pp =  {ma[15], ma};
           P2A    : pp =  {ma    , 1'b0};
			  
           default: pp = 17'bx;
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
	
	wire   [2 :0]  be [7:0];   // encoded multipliers
	wire   [17:0]  pp [7:0];   // partial products
	wire   [17:0] 
	
	// encoding multiplier
	booth_encoder  booth_encoder0(.y(be[0]), .pb({mb[1:0], 1'b0}));
	booth_encoder  booth_encoder1(.y(be[1]), .pb(mb[3:1]));
	booth_encoder  booth_encoder2(.y(be[2]), .pb(mb[5:3]));
	booth_encoder  booth_encoder3(.y(be[3]), .pb(mb[7:5]));
	booth_encoder  booth_encoder4(.y(be[4]), .pb(mb[9:7]));
	booth_encoder  booth_encoder5(.y(be[5]), .pb(mb[11:9]));
	booth_encoder  booth_encoder6(.y(be[6]), .pb(mb[13:11]));
	booth_encoder  booth_encoder7(.y(be[7]), .pb(mb[15:13]));
	
	// generate partial product through mux
	booth_pp_mux   booth_pp_mux0 (.pp(pp[0]), .ma(ma), .be(be[0]));
	booth_pp_mux   booth_pp_mux1 (.pp(pp[1]), .ma(ma), .be(be[1]));
	booth_pp_mux   booth_pp_mux2 (.pp(pp[2]), .ma(ma), .be(be[2]));
	// -------------------- CSA 0_1
	booth_pp_mux   booth_pp_mux3 (.pp(pp[3]), .ma(ma), .be(be[3]));
	booth_pp_mux   booth_pp_mux4 (.pp(pp[4]), .ma(ma), .be(be[4]));
	booth_pp_mux   booth_pp_mux5 (.pp(pp[5]), .ma(ma), .be(be[5]));
	// -------------------- CSA_0_2
	booth_pp_mux   booth_pp_mux6 (.pp(pp[6]), .ma(ma), .be(be[6]));
	booth_pp_mux   booth_pp_mux7 (.pp(pp[7]), .ma(ma), .be(be[7]));
	// -------------------- CSA_0_3
	
	// carry save adder tree
	// stage1
	
	
	// final stage adder
	
endmodule