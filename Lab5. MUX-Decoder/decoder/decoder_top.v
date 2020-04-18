module decoder_top(out_st, out_df, out_bh, in);

	output [3:0] out_st, out_df, out_bh;
	input  [1:0] in;
	
	st_decoder_2to4 decoder0(.out(out_st), .in(in));
	df_decoder_2to4 decoder1(.out(out_df), .in(in));
	bh_decoder_2to4 decoder2(.out(out_bh), .in(in));
endmodule