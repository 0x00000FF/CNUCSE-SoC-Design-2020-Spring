module st_decoder_2to4(out, in);
	output [3:0] out;
	input  [1:0] in;
	
	wire   [1:0] in_inv;
	
	not    not0(in_inv[0], in[0]);
	not    not1(in_inv[1], in[1]);
	
	and    and0(out[0], in_inv[1], in_inv[0]);
	and    and1(out[1], in_inv[1], in[0]);
	and    and2(out[2], in[1]    , in_inv[0]);
	and    and3(out[3], in[1]    , in[0]);
endmodule