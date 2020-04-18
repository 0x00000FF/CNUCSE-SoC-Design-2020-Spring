module mux_top(out_df, out_st, out_bh, in0, in1, in2, in3, sel);

output out_df, out_st, out_bh;
input  in0, in1, in2, in3;
input [1:0] sel;

df_4to1_mux mux0(.out(out_df), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel));
st_4to1_mux mux1(.out(out_st), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel));
bh_4to1_mux mux2(.out(out_bh), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel));

endmodule