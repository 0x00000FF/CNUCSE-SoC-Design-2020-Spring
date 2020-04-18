`timescale 1ns/100ps

module tb_decoder_2to4;

	wire [3:0] out_st, out_df, out_bh;
	reg  [1:0] in;
	
	decoder_top decoder_test(.out_st(out_st), .out_df(out_df), .out_bh(out_bh), .in(in));
	
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