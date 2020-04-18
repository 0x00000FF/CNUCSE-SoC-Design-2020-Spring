`timescale 1ns/100ps

module tb_4to1_mux;

  reg  in0, in1, in2, in3;
  reg [1:0] sel;
  
  wire out_df, out_st, out_bh;

  mux_top mux_top0(.out_df(out_df), .out_st(out_st), .out_bh(out_bh), 
              .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel));

  initial begin 
    in0 = 1'bx; in1 = 1'bx; in2 = 1'bx; in3 = 1'bx; sel = 2'bx;
  
    #10
    in0 = 0; in1 = 1; in2 = 0; in3 = 1; sel = 2'b00;
    
    #10
    sel = 2'b01;
    
    #10
    sel = 2'b10;
    
    #10
    sel = 2'b11;
    
    #10;
  end
              
endmodule