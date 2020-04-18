module df_4to1_mux(out, in0, in1, in2, in3, sel);
    output out;
    input  in0, in1, in2, in3;
	 input  [1:0] sel;
    
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 :
                 (sel == 2'b11) ? in3 : 1'bx;
endmodule