// 2-to-1 MUX
// for shifting control
module mux_21(out, x, y, sel0);
    output out;
    input  x, y, sel0;

    reg out;

    always @(x or y or sel0) begin
        if      (sel0 == 0) out = x;
        else if (sel0 == 1) out = y;
        else                out = 1'bx;
    end        
endmodule

// 3-to-1 MUX
// for shifting parameters
module mux_31(out, x, y, z, sel0, sel1);
    output out;
    
    // input x, y, z
    // sel0 for x | (y, z) -- shift on/off
    // sel1 for y , z      -- shifting direction
    input  x, y, z, sel0, sel1;
     
    reg    out;
     
    always @(x or y or z or sel0 or sel1) begin
        if (sel1 == 0) begin
           if      (sel0 == 0) out = x;
           else if (sel0 == 1) out = y;
           else                out = 1'bx;
        end
        else if (sel1 == 1) begin
            if      (sel0 == 0) out = x;
            else if (sel0 == 1) out = z;
            else                out = 1'bx;
        end
        else out = 1'bx;
    end
endmodule

// 16bit left/right shifter
// out:    output
// x:      input
// shift:  amount of shift
// as:     arith/logic shift switch
// dir:    direction 0=left otherwise right
// rotate: enable/disable rotate
module shifter_16b_top(out, x, shift, as, dir, rotate);
    output [15:0] out;
    
    input  [15:0] x;
    input  [3:0]  shift;
    input  as, dir, rotate;
    
    // wires for each shift/rotate selection
    wire   [1:0]  s1_m;
    wire   [3:0]  s2_m;
    wire   [7:0]  s3_m;

    // wires for each mux31 stage
    wire   [15:0] s1, s2, s3, out;
    
    // begin generation
    genvar idx;
    
    // MUX Stage 1
    mux_21 m21_1asr (.out(s1_m[0]), .x(1'b0), .y(x[15]), .sel0(rotate));
    mux_31 m31_1a   (.out(s1[0]),   .x(x[0]), .y(s1_m[0]), .z(x[1]), .sel0(shift[0]), .sel1(dir));
    
    generate
       for (idx = 1; idx < 15; idx = idx + 1) begin : mux_s1
             mux_31 _m31(.out(s1[idx]), .x(x[idx]), .y(x[idx-1]), .z(x[idx+1]), .sel0(shift[0]), .sel1(dir)); 
         end
    endgenerate
    
    mux_21 m21_1bsr (.out(s1_m[1]), .x(as) , .y(x[0]),  .sel0(rotate));
    mux_31 m31_1b   (.out(s1[15]) , .x(x[15]), .y(x[14]), .z(s1_m[1]), .sel0(shift[0]), .sel1(dir));
    
    // MUX Stage 2
    mux_21 m21_2asr(.out(s2_m[0]), .x(1'b0), .y(s1[14]), .sel0(rotate));
    mux_31 m31_2a  (.out(s2[0]), .x(s1[0]), .y(1'b0), .z(s1[2]), .sel0(shift[1]), .sel1(dir));
    
    mux_31 m31_2b(.out(s2[1]), .x(s1[1]), .y(1'b0), .z(s1[3]), .sel0(shift[1]), .sel1(dir));
    
    generate
       for (idx = 2; idx < 14; idx = idx + 1) begin : mux_s2
             mux_31 _m31(.out(s2[idx]), .x(s1[idx]), .y(s1[idx-2]), .z(s1[idx+2]), .sel0(shift[1]), .sel1(dir)); 
         end
    endgenerate
    
    mux_31 m31_2c(.out(s2[14]), .x(s1[14]), .y(s1[12]), .z(1'b1), .sel0(shift[1]), .sel1(dir));
    mux_31 m31_2d(.out(s2[15]), .x(s1[15]), .y(s1[13]), .z(1'b1), .sel0(shift[1]), .sel1(dir));
    
    // MUX Stage 3
    mux_31 m31_3a(.out(s3[0]), .x(s2[0]), .y(1'b0), .z(s2[4]), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3b(.out(s3[1]), .x(s2[1]), .y(1'b0), .z(s2[5]), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3c(.out(s3[2]), .x(s2[2]), .y(1'b0), .z(s2[6]), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3d(.out(s3[3]), .x(s2[3]), .y(1'b0), .z(s2[7]), .sel0(shift[2]), .sel1(dir));
    
    generate
       for (idx = 4; idx < 12; idx = idx + 1) begin : mux_s3
             mux_31 _m31(.out(s3[idx]), .x(s2[idx]), .y(s2[idx-4]), .z(s2[idx+4]), .sel0(shift[2]), .sel1(dir)); 
         end
    endgenerate
    
    mux_31 m31_3e(.out(s3[12]), .x(s2[12]), .y(s2[8]),  .z(1'b1), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3f(.out(s3[13]), .x(s2[13]), .y(s2[9]),  .z(1'b1), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3g(.out(s3[14]), .x(s2[14]), .y(s2[10]), .z(1'b1), .sel0(shift[2]), .sel1(dir));
    mux_31 m31_3h(.out(s3[15]), .x(s2[15]), .y(s2[11]), .z(1'b1), .sel0(shift[2]), .sel1(dir));
    
    // MUX Stage 4
    mux_31 m31_4a(.out(out[0]),  .x(s3[0]),  .y(1'b0),  .z(s3[8]),  .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4b(.out(out[1]),  .x(s3[1]),  .y(1'b0),  .z(s3[9]),  .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4c(.out(out[2]),  .x(s3[2]),  .y(1'b0),  .z(s3[10]), .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4d(.out(out[3]),  .x(s3[3]),  .y(1'b0),  .z(s3[11]), .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4e(.out(out[4]),  .x(s3[4]),  .y(1'b0),  .z(s3[12]), .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4f(.out(out[5]),  .x(s3[5]),  .y(1'b0),  .z(s3[13]), .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4g(.out(out[6]),  .x(s3[6]),  .y(1'b0),  .z(s3[14]), .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4h(.out(out[7]),  .x(s3[7]),  .y(1'b0),  .z(s3[15]), .sel0(shift[3]), .sel1(dir));
    
    mux_31 m31_4i(.out(out[8]),  .x(s3[8]),  .y(s3[0]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4j(.out(out[9]),  .x(s3[9]),  .y(s3[1]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4k(.out(out[10]), .x(s3[10]), .y(s3[2]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4l(.out(out[11]), .x(s3[11]), .y(s3[3]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4m(.out(out[12]), .x(s3[12]), .y(s3[4]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4n(.out(out[13]), .x(s3[13]), .y(s3[5]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4o(.out(out[14]), .x(s3[14]), .y(s3[6]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    mux_31 m31_4p(.out(out[15]), .x(s3[15]), .y(s3[7]), .z(1'b1),   .sel0(shift[3]), .sel1(dir));
    
endmodule