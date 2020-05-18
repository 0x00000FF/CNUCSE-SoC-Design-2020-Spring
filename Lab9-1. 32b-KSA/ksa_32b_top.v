// P, G Term Generator
// Generates for each bit in parallel
module pg_gen(p, g, a, b);
    input  [31:0] a, b;
    output [31:0] p, g;
    
    assign p = a ^ b;
    assign g = a & b;
endmodule

// Black Cell
// for carry-look-ahead tree
module black_cell(pout, gout, p, g, p_1, g_1);
    input     p, g, p_1, g_1;
    output    pout, gout;
    
    assign pout = p & p_1;
    assign gout = g | (p & g_1);
endmodule

// Carry generator
// Generates carry output
module carry_gen(cout, p, g, cin);
    input  p, g, cin;
    output cout;
    
    assign cout = g | p & cin;
endmodule

module ksa_32b_top(cout, sum, a, b, cin);
    input  [31:0] a, b;
    input  cin;
    
    output [31:0] sum;
    output cout;

    // p, g terms
    wire    [31:0] p_terms, g_terms;
    wire    [31:0] sum, c_outs;
    
    // create wire for each CLA tree stage
    wire    [31:0]  p_st_1, g_st_1;
    wire    [30:0]  p_st_2, g_st_2;
    wire    [28:0]  p_st_3, g_st_3;
    wire    [24:0]  p_st_4, g_st_4;
    wire    [16:0]  p_st_5, g_st_5;
	 wire            p_st_6, g_st_6;
    
    // P,G Generation
    pg_gen     _pg_gen(.p(p_terms), .g(g_terms), .a(a), .b(b));
    
    // CLA tree stage 1 (32 cells)
    black_cell _black_cell1_0  (.pout(p_st_1[0]),  .gout(g_st_1[0]),  .p(p_terms[0]),  .g(g_terms[0]),  .p_1(1'b0),        .g_1(cin) );
    black_cell _black_cell1_1  (.pout(p_st_1[1]),  .gout(g_st_1[1]),  .p(p_terms[1]),  .g(g_terms[1]),  .p_1(p_terms[0]),  .g_1(g_terms[0]) );
    black_cell _black_cell1_2  (.pout(p_st_1[2]),  .gout(g_st_1[2]),  .p(p_terms[2]),  .g(g_terms[2]),  .p_1(p_terms[1]),  .g_1(g_terms[1]) );
    black_cell _black_cell1_3  (.pout(p_st_1[3]),  .gout(g_st_1[3]),  .p(p_terms[3]),  .g(g_terms[3]),  .p_1(p_terms[2]),  .g_1(g_terms[2]) );
    black_cell _black_cell1_4  (.pout(p_st_1[4]),  .gout(g_st_1[4]),  .p(p_terms[4]),  .g(g_terms[4]),  .p_1(p_terms[3]),  .g_1(g_terms[3]) );
    black_cell _black_cell1_5  (.pout(p_st_1[5]),  .gout(g_st_1[5]),  .p(p_terms[5]),  .g(g_terms[5]),  .p_1(p_terms[4]),  .g_1(g_terms[4]) );
    black_cell _black_cell1_6  (.pout(p_st_1[6]),  .gout(g_st_1[6]),  .p(p_terms[6]),  .g(g_terms[6]),  .p_1(p_terms[5]),  .g_1(g_terms[5]) );
    black_cell _black_cell1_7  (.pout(p_st_1[7]),  .gout(g_st_1[7]),  .p(p_terms[7]),  .g(g_terms[7]),  .p_1(p_terms[6]),  .g_1(g_terms[6]) );
    black_cell _black_cell1_8  (.pout(p_st_1[8]),  .gout(g_st_1[8]),  .p(p_terms[8]),  .g(g_terms[8]),  .p_1(p_terms[7]),  .g_1(g_terms[7]) );
    black_cell _black_cell1_9  (.pout(p_st_1[9]),  .gout(g_st_1[9]),  .p(p_terms[9]),  .g(g_terms[9]),  .p_1(p_terms[8]),  .g_1(g_terms[8]) );
    black_cell _black_cell1_a  (.pout(p_st_1[10]), .gout(g_st_1[10]), .p(p_terms[10]), .g(g_terms[10]), .p_1(p_terms[9]),  .g_1(g_terms[9]) );
    black_cell _black_cell1_b  (.pout(p_st_1[11]), .gout(g_st_1[11]), .p(p_terms[11]), .g(g_terms[11]), .p_1(p_terms[10]), .g_1(g_terms[10]) );
    black_cell _black_cell1_c  (.pout(p_st_1[12]), .gout(g_st_1[12]), .p(p_terms[12]), .g(g_terms[12]), .p_1(p_terms[11]), .g_1(g_terms[11]) );
    black_cell _black_cell1_d  (.pout(p_st_1[13]), .gout(g_st_1[13]), .p(p_terms[13]), .g(g_terms[13]), .p_1(p_terms[12]), .g_1(g_terms[12]) );
    black_cell _black_cell1_e  (.pout(p_st_1[14]), .gout(g_st_1[14]), .p(p_terms[14]), .g(g_terms[14]), .p_1(p_terms[13]), .g_1(g_terms[13]) );
    black_cell _black_cell1_f  (.pout(p_st_1[15]), .gout(g_st_1[15]), .p(p_terms[15]), .g(g_terms[15]), .p_1(p_terms[14]), .g_1(g_terms[14]) );
	 black_cell _black_cell1_10 (.pout(p_st_1[16]), .gout(g_st_1[16]), .p(p_terms[16]), .g(g_terms[16]), .p_1(p_terms[15]), .g_1(g_terms[15]) );
    black_cell _black_cell1_11 (.pout(p_st_1[17]), .gout(g_st_1[17]), .p(p_terms[17]), .g(g_terms[17]), .p_1(p_terms[16]), .g_1(g_terms[16]) );
    black_cell _black_cell1_12 (.pout(p_st_1[18]), .gout(g_st_1[18]), .p(p_terms[18]), .g(g_terms[18]), .p_1(p_terms[17]), .g_1(g_terms[17]) );
    black_cell _black_cell1_13 (.pout(p_st_1[19]), .gout(g_st_1[19]), .p(p_terms[19]), .g(g_terms[19]), .p_1(p_terms[18]), .g_1(g_terms[18]) );
    black_cell _black_cell1_14 (.pout(p_st_1[20]), .gout(g_st_1[20]), .p(p_terms[20]), .g(g_terms[20]), .p_1(p_terms[19]), .g_1(g_terms[19]) );
    black_cell _black_cell1_15 (.pout(p_st_1[21]), .gout(g_st_1[21]), .p(p_terms[21]), .g(g_terms[21]), .p_1(p_terms[20]), .g_1(g_terms[20]) );
    black_cell _black_cell1_16 (.pout(p_st_1[22]), .gout(g_st_1[22]), .p(p_terms[22]), .g(g_terms[22]), .p_1(p_terms[21]), .g_1(g_terms[21]) );
    black_cell _black_cell1_17 (.pout(p_st_1[23]), .gout(g_st_1[23]), .p(p_terms[23]), .g(g_terms[23]), .p_1(p_terms[22]), .g_1(g_terms[22]) );
    black_cell _black_cell1_18 (.pout(p_st_1[24]), .gout(g_st_1[24]), .p(p_terms[24]), .g(g_terms[24]), .p_1(p_terms[23]), .g_1(g_terms[23]) );
    black_cell _black_cell1_19 (.pout(p_st_1[25]), .gout(g_st_1[25]), .p(p_terms[25]), .g(g_terms[25]), .p_1(p_terms[24]), .g_1(g_terms[24]) );
    black_cell _black_cell1_1a (.pout(p_st_1[26]), .gout(g_st_1[26]), .p(p_terms[26]), .g(g_terms[26]), .p_1(p_terms[25]), .g_1(g_terms[25]) );
    black_cell _black_cell1_1b (.pout(p_st_1[27]), .gout(g_st_1[27]), .p(p_terms[27]), .g(g_terms[27]), .p_1(p_terms[26]), .g_1(g_terms[26]) );
    black_cell _black_cell1_1c (.pout(p_st_1[28]), .gout(g_st_1[28]), .p(p_terms[28]), .g(g_terms[28]), .p_1(p_terms[27]), .g_1(g_terms[27]) );
    black_cell _black_cell1_1d (.pout(p_st_1[29]), .gout(g_st_1[29]), .p(p_terms[29]), .g(g_terms[29]), .p_1(p_terms[28]), .g_1(g_terms[28]) );
    black_cell _black_cell1_1e (.pout(p_st_1[30]), .gout(g_st_1[30]), .p(p_terms[30]), .g(g_terms[30]), .p_1(p_terms[29]), .g_1(g_terms[29]) );
    black_cell _black_cell1_1f (.pout(p_st_1[31]), .gout(g_st_1[31]), .p(p_terms[31]), .g(g_terms[31]), .p_1(p_terms[30]), .g_1(g_terms[30]) );
    
    // CLA tree stage 2 (31 cells)
    black_cell _black_cell2_0  (.pout(p_st_2[0]),   .gout(g_st_2[0]),   .p(p_st_1[1]),   .g(g_st_1[1]),   .p_1(1'b0),         .g_1(cin) );
    black_cell _black_cell2_1  (.pout(p_st_2[1]),   .gout(g_st_2[1]),   .p(p_st_1[2]),   .g(g_st_1[2]),   .p_1(p_st_1[0]),    .g_1(g_st_1[0]) );
    black_cell _black_cell2_2  (.pout(p_st_2[2]),   .gout(g_st_2[2]),   .p(p_st_1[3]),   .g(g_st_1[3]),   .p_1(p_st_1[1]),    .g_1(g_st_1[1]) );
    black_cell _black_cell2_3  (.pout(p_st_2[3]),   .gout(g_st_2[3]),   .p(p_st_1[4]),   .g(g_st_1[4]),   .p_1(p_st_1[2]),    .g_1(g_st_1[2]) );
    black_cell _black_cell2_4  (.pout(p_st_2[4]),   .gout(g_st_2[4]),   .p(p_st_1[5]),   .g(g_st_1[5]),   .p_1(p_st_1[3]),    .g_1(g_st_1[3]) );
    black_cell _black_cell2_5  (.pout(p_st_2[5]),   .gout(g_st_2[5]),   .p(p_st_1[6]),   .g(g_st_1[6]),   .p_1(p_st_1[4]),    .g_1(g_st_1[4]) );
    black_cell _black_cell2_6  (.pout(p_st_2[6]),   .gout(g_st_2[6]),   .p(p_st_1[7]),   .g(g_st_1[7]),   .p_1(p_st_1[5]),    .g_1(g_st_1[5]) );
    black_cell _black_cell2_7  (.pout(p_st_2[7]),   .gout(g_st_2[7]),   .p(p_st_1[8]),   .g(g_st_1[8]),   .p_1(p_st_1[6]),    .g_1(g_st_1[6]) );
    black_cell _black_cell2_8  (.pout(p_st_2[8]),   .gout(g_st_2[8]),   .p(p_st_1[9]),   .g(g_st_1[9]),   .p_1(p_st_1[7]),    .g_1(g_st_1[7]) );
    black_cell _black_cell2_9  (.pout(p_st_2[9]),   .gout(g_st_2[9]),   .p(p_st_1[10]),  .g(g_st_1[10]),  .p_1(p_st_1[8]),    .g_1(g_st_1[8]) );
    black_cell _black_cell2_a  (.pout(p_st_2[10]),  .gout(g_st_2[10]),  .p(p_st_1[11]),  .g(g_st_1[11]),  .p_1(p_st_1[9]),    .g_1(g_st_1[9]) );
    black_cell _black_cell2_b  (.pout(p_st_2[11]),  .gout(g_st_2[11]),  .p(p_st_1[12]),  .g(g_st_1[12]),  .p_1(p_st_1[10]),   .g_1(g_st_1[10]) );
    black_cell _black_cell2_c  (.pout(p_st_2[12]),  .gout(g_st_2[12]),  .p(p_st_1[13]),  .g(g_st_1[13]),  .p_1(p_st_1[11]),   .g_1(g_st_1[11]) );
    black_cell _black_cell2_d  (.pout(p_st_2[13]),  .gout(g_st_2[13]),  .p(p_st_1[14]),  .g(g_st_1[14]),  .p_1(p_st_1[12]),   .g_1(g_st_1[12]) );
    black_cell _black_cell2_e  (.pout(p_st_2[14]),  .gout(g_st_2[14]),  .p(p_st_1[15]),  .g(g_st_1[15]),  .p_1(p_st_1[13]),   .g_1(g_st_1[13]) );
    black_cell _black_cell2_f  (.pout(p_st_2[15]),  .gout(g_st_2[15]),  .p(p_st_1[16]),  .g(g_st_1[16]),  .p_1(p_st_1[14]),   .g_1(p_st_1[14]) );
    black_cell _black_cell2_10 (.pout(p_st_2[16]),  .gout(g_st_2[16]),  .p(p_st_1[17]),  .g(g_st_1[17]),  .p_1(p_st_1[15]),   .g_1(g_st_1[15]) );
    black_cell _black_cell2_11 (.pout(p_st_2[17]),  .gout(g_st_2[17]),  .p(p_st_1[18]),  .g(g_st_1[18]),  .p_1(p_st_1[16]),   .g_1(g_st_1[16]) );
    black_cell _black_cell2_12 (.pout(p_st_2[18]),  .gout(g_st_2[18]),  .p(p_st_1[19]),  .g(g_st_1[19]),  .p_1(p_st_1[17]),   .g_1(g_st_1[17]) );
    black_cell _black_cell2_13 (.pout(p_st_2[19]),  .gout(g_st_2[19]),  .p(p_st_1[20]),  .g(g_st_1[20]),  .p_1(p_st_1[18]),   .g_1(g_st_1[18]) );
    black_cell _black_cell2_14 (.pout(p_st_2[20]),  .gout(g_st_2[20]),  .p(p_st_1[21]),  .g(g_st_1[21]),  .p_1(p_st_1[19]),   .g_1(g_st_1[19]) );
    black_cell _black_cell2_15 (.pout(p_st_2[21]),  .gout(g_st_2[21]),  .p(p_st_1[22]),  .g(g_st_1[22]),  .p_1(p_st_1[20]),   .g_1(g_st_1[20]) );
    black_cell _black_cell2_16 (.pout(p_st_2[22]),  .gout(g_st_2[22]),  .p(p_st_1[23]),  .g(g_st_1[23]),  .p_1(p_st_1[21]),   .g_1(g_st_1[21]) );
    black_cell _black_cell2_17 (.pout(p_st_2[23]),  .gout(g_st_2[23]),  .p(p_st_1[24]),  .g(g_st_1[24]),  .p_1(p_st_1[22]),   .g_1(g_st_1[22]) );
    black_cell _black_cell2_18 (.pout(p_st_2[24]),  .gout(g_st_2[24]),  .p(p_st_1[25]),  .g(g_st_1[25]),  .p_1(p_st_1[23]),   .g_1(g_st_1[23]) );
    black_cell _black_cell2_19 (.pout(p_st_2[25]),  .gout(g_st_2[25]),  .p(p_st_1[26]),  .g(g_st_1[26]),  .p_1(p_st_1[24]),   .g_1(g_st_1[24]) );
    black_cell _black_cell2_1a (.pout(p_st_2[26]),  .gout(g_st_2[26]),  .p(p_st_1[27]),  .g(g_st_1[27]),  .p_1(p_st_1[25]),   .g_1(g_st_1[25]) );
    black_cell _black_cell2_1b (.pout(p_st_2[27]),  .gout(g_st_2[27]),  .p(p_st_1[28]),  .g(g_st_1[28]),  .p_1(p_st_1[26]),   .g_1(g_st_1[26]) );
    black_cell _black_cell2_1c (.pout(p_st_2[28]),  .gout(g_st_2[28]),  .p(p_st_1[29]),  .g(g_st_1[29]),  .p_1(p_st_1[27]),   .g_1(g_st_1[27]) );
    black_cell _black_cell2_1d (.pout(p_st_2[29]),  .gout(g_st_2[29]),  .p(p_st_1[30]),  .g(g_st_1[30]),  .p_1(p_st_1[28]),   .g_1(g_st_1[28]) );
	 black_cell _black_cell2_1e (.pout(p_st_2[30]),  .gout(g_st_2[30]),  .p(p_st_1[31]),  .g(g_st_1[31]),  .p_1(p_st_1[29]),   .g_1(g_st_1[29]) );

    
    // CLA tree stage 3 (29 cells)
    black_cell _black_cell3_0  (.pout(p_st_3[0]),   .gout(g_st_3[0]),   .p(p_st_2[2]),   .g(g_st_2[2]),   .p_1(1'b0),         .g_1(cin) );
    black_cell _black_cell3_1  (.pout(p_st_3[1]),   .gout(g_st_3[1]),   .p(p_st_2[3]),   .g(g_st_2[3]),   .p_1(p_st_1[0]),    .g_1(g_st_1[0]) );
    black_cell _black_cell3_2  (.pout(p_st_3[2]),   .gout(g_st_3[2]),   .p(p_st_2[4]),   .g(g_st_2[4]),   .p_1(p_st_2[0]),    .g_1(g_st_2[0]) );
    black_cell _black_cell3_3  (.pout(p_st_3[3]),   .gout(g_st_3[3]),   .p(p_st_2[5]),   .g(g_st_2[5]),   .p_1(p_st_2[1]),    .g_1(g_st_2[1]) );
    black_cell _black_cell3_4  (.pout(p_st_3[4]),   .gout(g_st_3[4]),   .p(p_st_2[6]),   .g(g_st_2[6]),   .p_1(p_st_2[2]),    .g_1(g_st_2[2]) );
    black_cell _black_cell3_5  (.pout(p_st_3[5]),   .gout(g_st_3[5]),   .p(p_st_2[7]),   .g(g_st_2[7]),   .p_1(p_st_2[3]),    .g_1(g_st_2[3]) );
    black_cell _black_cell3_6  (.pout(p_st_3[6]),   .gout(g_st_3[6]),   .p(p_st_2[8]),   .g(g_st_2[8]),   .p_1(p_st_2[4]),    .g_1(g_st_2[4]) );
    black_cell _black_cell3_7  (.pout(p_st_3[7]),   .gout(g_st_3[7]),   .p(p_st_2[9]),   .g(g_st_2[9]),   .p_1(p_st_2[5]),    .g_1(g_st_2[5]) );
    black_cell _black_cell3_8  (.pout(p_st_3[8]),   .gout(g_st_3[8]),   .p(p_st_2[10]),  .g(g_st_2[10]),  .p_1(p_st_2[6]),    .g_1(g_st_2[6]) );
    black_cell _black_cell3_9  (.pout(p_st_3[9]),   .gout(g_st_3[9]),   .p(p_st_2[11]),  .g(g_st_2[11]),  .p_1(p_st_2[7]),    .g_1(g_st_2[7]) );
    black_cell _black_cell3_a  (.pout(p_st_3[10]),  .gout(g_st_3[10]),  .p(p_st_2[12]),  .g(g_st_2[12]),  .p_1(p_st_2[8]),    .g_1(g_st_2[8]) );
    black_cell _black_cell3_b  (.pout(p_st_3[11]),  .gout(g_st_3[11]),  .p(p_st_2[13]),  .g(g_st_2[13]),  .p_1(p_st_2[9]),    .g_1(g_st_2[9]) );
    black_cell _black_cell3_c  (.pout(p_st_3[12]),  .gout(g_st_3[12]),  .p(p_st_2[14]),  .g(g_st_2[14]),  .p_1(p_st_2[10]),   .g_1(g_st_2[10]) );
    black_cell _black_cell3_d  (.pout(p_st_3[13]),  .gout(g_st_3[13]),  .p(p_st_2[14]),  .g(g_st_2[14]),  .p_1(p_st_2[12]),   .g_1(g_st_2[12]) );
    black_cell _black_cell3_e  (.pout(p_st_3[14]),  .gout(g_st_3[14]),  .p(p_st_2[15]),  .g(g_st_2[15]),  .p_1(p_st_2[13]),   .g_1(g_st_2[13]) );
    black_cell _black_cell3_f  (.pout(p_st_3[15]),  .gout(g_st_3[15]),  .p(p_st_2[16]),  .g(g_st_2[16]),  .p_1(p_st_2[14]),   .g_1(p_st_2[14]) );
    black_cell _black_cell3_10 (.pout(p_st_3[16]),  .gout(g_st_3[16]),  .p(p_st_2[17]),  .g(g_st_2[17]),  .p_1(p_st_2[15]),   .g_1(g_st_2[15]) );
    black_cell _black_cell3_11 (.pout(p_st_3[17]),  .gout(g_st_3[17]),  .p(p_st_2[18]),  .g(g_st_2[18]),  .p_1(p_st_2[16]),   .g_1(g_st_2[16]) );
    black_cell _black_cell3_12 (.pout(p_st_3[18]),  .gout(g_st_3[18]),  .p(p_st_2[19]),  .g(g_st_2[19]),  .p_1(p_st_2[17]),   .g_1(g_st_2[17]) );
    black_cell _black_cell3_13 (.pout(p_st_3[19]),  .gout(g_st_3[19]),  .p(p_st_2[20]),  .g(g_st_2[20]),  .p_1(p_st_2[18]),   .g_1(g_st_2[18]) );
    black_cell _black_cell3_14 (.pout(p_st_3[20]),  .gout(g_st_3[20]),  .p(p_st_2[21]),  .g(g_st_2[21]),  .p_1(p_st_2[19]),   .g_1(g_st_2[19]) );
    black_cell _black_cell3_15 (.pout(p_st_3[21]),  .gout(g_st_3[21]),  .p(p_st_2[22]),  .g(g_st_2[22]),  .p_1(p_st_2[20]),   .g_1(g_st_2[20]) );
    black_cell _black_cell3_16 (.pout(p_st_3[22]),  .gout(g_st_3[22]),  .p(p_st_2[23]),  .g(g_st_2[23]),  .p_1(p_st_2[21]),   .g_1(g_st_2[21]) );
    black_cell _black_cell3_17 (.pout(p_st_3[23]),  .gout(g_st_3[23]),  .p(p_st_2[24]),  .g(g_st_2[24]),  .p_1(p_st_2[22]),   .g_1(g_st_2[22]) );
    black_cell _black_cell3_18 (.pout(p_st_3[24]),  .gout(g_st_3[24]),  .p(p_st_2[25]),  .g(g_st_2[25]),  .p_1(p_st_2[23]),   .g_1(g_st_2[23]) );
    black_cell _black_cell3_19 (.pout(p_st_3[25]),  .gout(g_st_3[25]),  .p(p_st_2[26]),  .g(g_st_2[26]),  .p_1(p_st_2[24]),   .g_1(g_st_2[24]) );
    black_cell _black_cell3_1a (.pout(p_st_3[26]),  .gout(g_st_3[26]),  .p(p_st_2[27]),  .g(g_st_2[27]),  .p_1(p_st_2[25]),   .g_1(g_st_2[25]) );
    black_cell _black_cell3_1b (.pout(p_st_3[27]),  .gout(g_st_3[27]),  .p(p_st_2[28]),  .g(g_st_2[28]),  .p_1(p_st_2[26]),   .g_1(g_st_2[26]) );
    black_cell _black_cell3_1c (.pout(p_st_3[28]),  .gout(g_st_3[28]),  .p(p_st_2[29]),  .g(g_st_2[29]),  .p_1(p_st_2[27]),   .g_1(g_st_2[27]) );
	 
    // CLA tree stage 4 (25 cells)
    black_cell _black_cell4_0  (.pout(p_st_4[0]),   .gout(g_st_4[0]),   .p(p_st_3[4]),   .g(g_st_3[4]),   .p_1(1'b0),       .g_1(cin) );
    black_cell _black_cell4_1  (.pout(p_st_4[1]),   .gout(g_st_4[1]),   .p(p_st_3[5]),   .g(g_st_3[5]),   .p_1(p_st_1[0]),  .g_1(g_st_1[0]) );
    black_cell _black_cell4_2  (.pout(p_st_4[2]),   .gout(g_st_4[2]),   .p(p_st_3[6]),   .g(g_st_3[6]),   .p_1(p_st_2[0]),  .g_1(g_st_2[0]) );
    black_cell _black_cell4_3  (.pout(p_st_4[3]),   .gout(g_st_4[3]),   .p(p_st_3[7]),   .g(g_st_3[7]),   .p_1(p_st_2[1]),  .g_1(g_st_2[1]) );
    black_cell _black_cell4_4  (.pout(p_st_4[4]),   .gout(g_st_4[4]),   .p(p_st_3[8]),   .g(g_st_3[8]),   .p_1(p_st_3[0]),  .g_1(g_st_3[0]) );
    black_cell _black_cell4_5  (.pout(p_st_4[5]),   .gout(g_st_4[5]),   .p(p_st_3[9]),   .g(g_st_3[9]),   .p_1(p_st_3[1]),  .g_1(g_st_3[1]) );
    black_cell _black_cell4_6  (.pout(p_st_4[6]),   .gout(g_st_4[6]),   .p(p_st_3[10]),  .g(g_st_3[10]),  .p_1(p_st_3[2]),  .g_1(g_st_3[2]) );
    black_cell _black_cell4_7  (.pout(p_st_4[7]),   .gout(g_st_4[7]),   .p(p_st_3[11]),  .g(g_st_3[11]),  .p_1(p_st_3[3]),  .g_1(g_st_3[3]) );
    black_cell _black_cell4_8  (.pout(p_st_4[8]),   .gout(g_st_4[8]),   .p(p_st_3[12]),  .g(g_st_3[12]),  .p_1(p_st_3[4]),  .g_1(g_st_3[4]) );
    black_cell _black_cell4_9  (.pout(p_st_4[9]),   .gout(g_st_4[9]),   .p(p_st_3[13]),  .g(g_st_3[11]),  .p_1(p_st_3[5]),  .g_1(g_st_3[5]) );
    black_cell _black_cell4_a  (.pout(p_st_4[10]),  .gout(g_st_4[10]),  .p(p_st_3[14]),  .g(g_st_3[12]),  .p_1(p_st_3[6]),  .g_1(g_st_3[6]) );
    black_cell _black_cell4_b  (.pout(p_st_4[11]),  .gout(g_st_4[11]),  .p(p_st_3[15]),  .g(g_st_3[13]),  .p_1(p_st_3[7]),  .g_1(g_st_3[7]) );
    black_cell _black_cell4_c  (.pout(p_st_4[12]),  .gout(g_st_4[12]),  .p(p_st_3[16]),  .g(g_st_3[14]),  .p_1(p_st_3[8]),  .g_1(g_st_3[8]) );
    black_cell _black_cell4_d  (.pout(p_st_4[13]),  .gout(g_st_4[13]),  .p(p_st_3[17]),  .g(g_st_3[14]),  .p_1(p_st_3[9]),  .g_1(g_st_3[9]) );
    black_cell _black_cell4_e  (.pout(p_st_4[14]),  .gout(g_st_4[14]),  .p(p_st_3[18]),  .g(g_st_3[15]),  .p_1(p_st_3[10]), .g_1(g_st_3[10]) );
    black_cell _black_cell4_f  (.pout(p_st_4[15]),  .gout(g_st_4[15]),  .p(p_st_3[19]),  .g(g_st_3[16]),  .p_1(p_st_3[11]), .g_1(p_st_3[11]) );
    black_cell _black_cell4_10 (.pout(p_st_4[16]),  .gout(g_st_4[16]),  .p(p_st_3[20]),  .g(g_st_3[17]),  .p_1(p_st_3[12]), .g_1(g_st_3[12]) );
    black_cell _black_cell4_11 (.pout(p_st_4[17]),  .gout(g_st_4[17]),  .p(p_st_3[21]),  .g(g_st_3[18]),  .p_1(p_st_3[13]), .g_1(g_st_3[13]) );
    black_cell _black_cell4_12 (.pout(p_st_4[18]),  .gout(g_st_4[18]),  .p(p_st_3[22]),  .g(g_st_3[19]),  .p_1(p_st_3[14]), .g_1(g_st_3[14]) );
    black_cell _black_cell4_13 (.pout(p_st_4[19]),  .gout(g_st_4[19]),  .p(p_st_3[23]),  .g(g_st_3[20]),  .p_1(p_st_3[15]), .g_1(g_st_3[15]) );
    black_cell _black_cell4_14 (.pout(p_st_4[20]),  .gout(g_st_4[20]),  .p(p_st_3[24]),  .g(g_st_3[21]),  .p_1(p_st_3[16]), .g_1(g_st_3[16]) );
    black_cell _black_cell4_15 (.pout(p_st_4[21]),  .gout(g_st_4[21]),  .p(p_st_3[25]),  .g(g_st_3[22]),  .p_1(p_st_3[17]), .g_1(g_st_3[17]) );
    black_cell _black_cell4_16 (.pout(p_st_4[22]),  .gout(g_st_4[22]),  .p(p_st_3[26]),  .g(g_st_3[23]),  .p_1(p_st_3[18]), .g_1(g_st_3[18]) );
    black_cell _black_cell4_17 (.pout(p_st_4[23]),  .gout(g_st_4[23]),  .p(p_st_3[27]),  .g(g_st_3[24]),  .p_1(p_st_3[19]), .g_1(g_st_3[19]) );
    black_cell _black_cell4_18 (.pout(p_st_4[24]),  .gout(g_st_4[24]),  .p(p_st_3[28]),  .g(g_st_3[25]),  .p_1(p_st_3[20]), .g_1(g_st_3[20]) );
    
    // CLA tree stage 5 (17 cells)
    black_cell _black_cell5_0  (.pout(p_st_5[0]),   .gout(g_st_5[0]),   .p(p_st_4[8]),   .g(g_st_4[8]),   .p_1(1'b0),       .g_1(cin) );
    black_cell _black_cell5_1  (.pout(p_st_5[1]),   .gout(g_st_5[1]),   .p(p_st_4[9]),   .g(g_st_4[9]),   .p_1(p_st_1[0]),  .g_1(g_st_1[0]) );
    black_cell _black_cell5_2  (.pout(p_st_5[2]),   .gout(g_st_5[2]),   .p(p_st_4[10]),  .g(g_st_4[10]),  .p_1(p_st_2[0]),  .g_1(g_st_2[0]) );
    black_cell _black_cell5_3  (.pout(p_st_5[3]),   .gout(g_st_5[3]),   .p(p_st_4[11]),  .g(g_st_4[11]),  .p_1(p_st_2[1]),  .g_1(g_st_2[1]) );
    black_cell _black_cell5_4  (.pout(p_st_5[4]),   .gout(g_st_5[4]),   .p(p_st_4[12]),  .g(g_st_4[12]),  .p_1(p_st_3[0]),  .g_1(g_st_3[0]) );
    black_cell _black_cell5_5  (.pout(p_st_5[5]),   .gout(g_st_5[5]),   .p(p_st_4[13]),  .g(g_st_4[13]),  .p_1(p_st_3[1]),  .g_1(g_st_3[1]) );
    black_cell _black_cell5_6  (.pout(p_st_5[6]),   .gout(g_st_5[6]),   .p(p_st_4[14]),  .g(g_st_4[14]),  .p_1(p_st_3[2]),  .g_1(g_st_3[2]) );
    black_cell _black_cell5_7  (.pout(p_st_5[7]),   .gout(g_st_5[7]),   .p(p_st_4[15]),  .g(g_st_4[15]),  .p_1(p_st_3[3]),  .g_1(g_st_3[3]) );
    black_cell _black_cell5_8  (.pout(p_st_5[8]),   .gout(g_st_5[8]),   .p(p_st_4[16]),  .g(g_st_4[16]),  .p_1(p_st_3[4]),  .g_1(g_st_3[4]) );
    black_cell _black_cell5_9  (.pout(p_st_5[9]),   .gout(g_st_5[9]),   .p(p_st_4[17]),  .g(g_st_4[17]),  .p_1(p_st_4[0]),  .g_1(g_st_4[0]) );
    black_cell _black_cell5_a  (.pout(p_st_5[10]),  .gout(g_st_5[10]),  .p(p_st_4[18]),  .g(g_st_4[18]),  .p_1(p_st_4[1]),  .g_1(g_st_4[1]) );
    black_cell _black_cell5_b  (.pout(p_st_5[11]),  .gout(g_st_5[11]),  .p(p_st_4[19]),  .g(g_st_4[19]),  .p_1(p_st_4[2]),  .g_1(g_st_4[2]) );
    black_cell _black_cell5_c  (.pout(p_st_5[12]),  .gout(g_st_5[12]),  .p(p_st_4[20]),  .g(g_st_4[20]),  .p_1(p_st_4[3]),  .g_1(g_st_4[3]) );
    black_cell _black_cell5_d  (.pout(p_st_5[13]),  .gout(g_st_5[13]),  .p(p_st_4[21]),  .g(g_st_4[21]),  .p_1(p_st_4[4]),  .g_1(g_st_4[4]) );
    black_cell _black_cell5_e  (.pout(p_st_5[14]),  .gout(g_st_5[14]),  .p(p_st_4[22]),  .g(g_st_4[22]),  .p_1(p_st_4[5]),  .g_1(g_st_4[5]) );
    black_cell _black_cell5_f  (.pout(p_st_5[15]),  .gout(g_st_5[15]),  .p(p_st_4[23]),  .g(g_st_4[23]),  .p_1(p_st_4[6]),  .g_1(p_st_4[6]) );
    black_cell _black_cell5_10 (.pout(p_st_5[16]),  .gout(g_st_5[16]),  .p(p_st_4[24]),  .g(g_st_4[24]),  .p_1(p_st_4[7]),  .g_1(g_st_4[7]) );
    
	 
	 // CLA Tree stage final
    black_cell _black_cell6    (.pout(p_st_6),      .gout(g_st_6),      .p(p_st_5[16]),  .g(g_st_5[16]),  .p_1(1'b0),       .g_1(cin) );
	 
    // CLA Tree done
    // Carry Generation
	 assign c_outs[0] = cin;
	 
    carry_gen _carry_gen0 (.cout(c_outs[1]),  .p(p_st_1[0]), .g(g_st_1[0]),  .cin(c_outs[0]));
    carry_gen _carry_gen1 (.cout(c_outs[2]),  .p(p_st_2[0]), .g(g_st_2[0]),  .cin(c_outs[1]));
    carry_gen _carry_gen2 (.cout(c_outs[3]),  .p(p_st_2[1]), .g(g_st_2[1]),  .cin(c_outs[2]));
    carry_gen _carry_gen3 (.cout(c_outs[4]),  .p(p_st_3[0]), .g(g_st_3[0]),  .cin(c_outs[3]));
    carry_gen _carry_gen4 (.cout(c_outs[5]),  .p(p_st_3[1]), .g(g_st_3[1]),  .cin(c_outs[4]));
    carry_gen _carry_gen5 (.cout(c_outs[6]),  .p(p_st_3[2]), .g(g_st_3[2]),  .cin(c_outs[5]));
    carry_gen _carry_gen6 (.cout(c_outs[7]),  .p(p_st_3[3]), .g(g_st_3[3]),  .cin(c_outs[6]));
    carry_gen _carry_gen7 (.cout(c_outs[8]),  .p(p_st_4[0]), .g(g_st_4[0]),  .cin(c_outs[7]));
    carry_gen _carry_gen8 (.cout(c_outs[9]),  .p(p_st_4[1]), .g(g_st_4[1]),  .cin(c_outs[8]));
    carry_gen _carry_gen9 (.cout(c_outs[10]), .p(p_st_4[2]), .g(g_st_4[2]),  .cin(c_outs[9]));
    carry_gen _carry_gena (.cout(c_outs[11]), .p(p_st_4[3]), .g(g_st_4[3]),  .cin(c_outs[10]));
    carry_gen _carry_genb (.cout(c_outs[12]), .p(p_st_4[4]), .g(g_st_4[4]),  .cin(c_outs[11]));
    carry_gen _carry_genc (.cout(c_outs[13]), .p(p_st_4[5]), .g(g_st_4[5]),  .cin(c_outs[12]));
    carry_gen _carry_gend (.cout(c_outs[14]), .p(p_st_4[6]), .g(g_st_4[6]),  .cin(c_outs[13]));
    carry_gen _carry_gene (.cout(c_outs[15]), .p(p_st_4[7]), .g(g_st_4[7]),  .cin(c_outs[14]));
    carry_gen _carry_genf (.cout(cout),       .p(p_st_5),    .g(g_st_5),     .cin(c_outs[15]));
    
    assign sum = p_terms ^ c_outs;
endmodule