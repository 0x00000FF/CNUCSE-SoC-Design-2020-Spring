/*
 *  Testbench
 *  2-to-4 Decoder
 *  out: 4bit, in: 2bit
 */

 // delay unit 1ns, precision 100ps
`timescale 1ns/100ps

module tb_decoder_2to4;
	// prepare 3 outputs for the top module
	wire [3:0] out_st, out_df, out_bh;
	reg  [1:0] in;
	
	// gets output from top module for each desciprion type
	decoder_top decoder_test(.out_st(out_st), .out_df(out_df), .out_bh(out_bh), .in(in));
	
	// update input for each 10 nanoseconds
	initial begin
		in = 2'bxx;
		
		#10
		in = 2'b00;
		
		#10
		in = 2'b01;
		
		#10
		in = 2'b10;
		
		#10
		in = 2'b11;
		
		#10;
	end

endmodule