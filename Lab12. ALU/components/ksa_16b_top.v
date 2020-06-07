// P, G Term Generator
// Generates for each bit in parallel
module pg_gen(p, g, a, b);
    input  [15:0] a, b;
    output [15:0] p, g;
    
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

module ksa_16b_top(cout, sum, a, b, cin);
    input  [15:0] a, b;
    input  cin;
    
    output [15:0] sum;
    output cout;

    // p, g terms
    wire    [15:0] p_terms, g_terms;
    wire    [15:0] sum, c_outs;
    
    // create wire for each CLA tree stage
    wire    [15:0] p_st_1, g_st_1;
    wire    [14:0] p_st_2, g_st_2;
    wire    [12:0] p_st_3, g_st_3;
    wire    [8:0]  p_st_4, g_st_4;
    wire           p_st_5, g_st_5;
    
    // P,G Generation
    pg_gen     _pg_gen(.p(p_terms), .g(g_terms), .a(a), .b(b));
    
    // CLA tree stage 1 (16 cells)
    black_cell _black_cell1_0(.pout(p_st_1[0]),  .gout(g_st_1[0]),  .p(p_terms[0]),  .g(g_terms[0]),  .p_1(1'b0),        .g_1(cin) );
    black_cell _black_cell1_1(.pout(p_st_1[1]),  .gout(g_st_1[1]),  .p(p_terms[1]),  .g(g_terms[1]),  .p_1(p_terms[0]),  .g_1(g_terms[0]) );
    black_cell _black_cell1_2(.pout(p_st_1[2]),  .gout(g_st_1[2]),  .p(p_terms[2]),  .g(g_terms[2]),  .p_1(p_terms[1]),  .g_1(g_terms[1]) );
    black_cell _black_cell1_3(.pout(p_st_1[3]),  .gout(g_st_1[3]),  .p(p_terms[3]),  .g(g_terms[3]),  .p_1(p_terms[2]),  .g_1(g_terms[2]) );
    black_cell _black_cell1_4(.pout(p_st_1[4]),  .gout(g_st_1[4]),  .p(p_terms[4]),  .g(g_terms[4]),  .p_1(p_terms[3]),  .g_1(g_terms[3]) );
    black_cell _black_cell1_5(.pout(p_st_1[5]),  .gout(g_st_1[5]),  .p(p_terms[5]),  .g(g_terms[5]),  .p_1(p_terms[4]),  .g_1(g_terms[4]) );
    black_cell _black_cell1_6(.pout(p_st_1[6]),  .gout(g_st_1[6]),  .p(p_terms[6]),  .g(g_terms[6]),  .p_1(p_terms[5]),  .g_1(g_terms[5]) );
    black_cell _black_cell1_7(.pout(p_st_1[7]),  .gout(g_st_1[7]),  .p(p_terms[7]),  .g(g_terms[7]),  .p_1(p_terms[6]),  .g_1(g_terms[6]) );
    black_cell _black_cell1_8(.pout(p_st_1[8]),  .gout(g_st_1[8]),  .p(p_terms[8]),  .g(g_terms[8]),  .p_1(p_terms[7]),  .g_1(g_terms[7]) );
    black_cell _black_cell1_9(.pout(p_st_1[9]),  .gout(g_st_1[9]),  .p(p_terms[9]),  .g(g_terms[9]),  .p_1(p_terms[8]),  .g_1(g_terms[8]) );
    black_cell _black_cell1_a(.pout(p_st_1[10]), .gout(g_st_1[10]), .p(p_terms[10]), .g(g_terms[10]), .p_1(p_terms[9]),  .g_1(g_terms[9]) );
    black_cell _black_cell1_b(.pout(p_st_1[11]), .gout(g_st_1[11]), .p(p_terms[11]), .g(g_terms[11]), .p_1(p_terms[10]), .g_1(g_terms[10]) );
    black_cell _black_cell1_c(.pout(p_st_1[12]), .gout(g_st_1[12]), .p(p_terms[12]), .g(g_terms[12]), .p_1(p_terms[11]), .g_1(g_terms[11]) );
    black_cell _black_cell1_d(.pout(p_st_1[13]), .gout(g_st_1[13]), .p(p_terms[13]), .g(g_terms[13]), .p_1(p_terms[12]), .g_1(g_terms[12]) );
    black_cell _black_cell1_e(.pout(p_st_1[14]), .gout(g_st_1[14]), .p(p_terms[14]), .g(g_terms[14]), .p_1(p_terms[13]), .g_1(g_terms[13]) );
    black_cell _black_cell1_f(.pout(p_st_1[15]), .gout(g_st_1[15]), .p(p_terms[15]), .g(g_terms[15]), .p_1(p_terms[14]), .g_1(g_terms[14]) );
    
    // CLA tree stage 2 (15 cells)
    black_cell _black_cell2_0(.pout(p_st_2[0]),   .gout(g_st_2[0]),   .p(p_st_1[1]),   .g(g_st_1[1]),   .p_1(1'b0),         .g_1(cin) );
    black_cell _black_cell2_1(.pout(p_st_2[1]),   .gout(g_st_2[1]),   .p(p_st_1[2]),   .g(g_st_1[2]),   .p_1(p_st_1[0]),    .g_1(g_st_1[0]) );
    black_cell _black_cell2_2(.pout(p_st_2[2]),   .gout(g_st_2[2]),   .p(p_st_1[3]),   .g(g_st_1[3]),   .p_1(p_st_1[1]),    .g_1(g_st_1[1]) );
    black_cell _black_cell2_3(.pout(p_st_2[3]),   .gout(g_st_2[3]),   .p(p_st_1[4]),   .g(g_st_1[4]),   .p_1(p_st_1[2]),    .g_1(g_st_1[2]) );
    black_cell _black_cell2_4(.pout(p_st_2[4]),   .gout(g_st_2[4]),   .p(p_st_1[5]),   .g(g_st_1[5]),   .p_1(p_st_1[3]),    .g_1(g_st_1[3]) );
    black_cell _black_cell2_5(.pout(p_st_2[5]),   .gout(g_st_2[5]),   .p(p_st_1[6]),   .g(g_st_1[6]),   .p_1(p_st_1[4]),    .g_1(g_st_1[4]) );
    black_cell _black_cell2_6(.pout(p_st_2[6]),   .gout(g_st_2[6]),   .p(p_st_1[7]),   .g(g_st_1[7]),   .p_1(p_st_1[5]),    .g_1(g_st_1[5]) );
    black_cell _black_cell2_7(.pout(p_st_2[7]),   .gout(g_st_2[7]),   .p(p_st_1[8]),   .g(g_st_1[8]),   .p_1(p_st_1[6]),    .g_1(g_st_1[6]) );
    black_cell _black_cell2_8(.pout(p_st_2[8]),   .gout(g_st_2[8]),   .p(p_st_1[9]),   .g(g_st_1[9]),   .p_1(p_st_1[7]),    .g_1(g_st_1[7]) );
    black_cell _black_cell2_9(.pout(p_st_2[9]),   .gout(g_st_2[9]),   .p(p_st_1[10]),  .g(g_st_1[10]),  .p_1(p_st_1[8]),    .g_1(g_st_1[8]) );
    black_cell _black_cell2_a(.pout(p_st_2[10]),  .gout(g_st_2[10]),  .p(p_st_1[11]),  .g(g_st_1[11]),  .p_1(p_st_1[9]),    .g_1(g_st_1[9]) );
    black_cell _black_cell2_b(.pout(p_st_2[11]),  .gout(g_st_2[11]),  .p(p_st_1[12]),  .g(g_st_1[12]),  .p_1(p_st_1[10]),   .g_1(g_st_1[10]) );
    black_cell _black_cell2_c(.pout(p_st_2[12]),  .gout(g_st_2[12]),  .p(p_st_1[13]),  .g(g_st_1[13]),  .p_1(p_st_1[11]),   .g_1(g_st_1[11]) );
    black_cell _black_cell2_d(.pout(p_st_2[13]),  .gout(g_st_2[13]),  .p(p_st_1[14]),  .g(g_st_1[14]),  .p_1(p_st_1[12]),   .g_1(g_st_1[12]) );
    black_cell _black_cell2_e(.pout(p_st_2[14]),  .gout(g_st_2[14]),  .p(p_st_1[15]),  .g(g_st_1[15]),  .p_1(p_st_1[13]),   .g_1(g_st_1[13]) );
    
    // CLA tree stage 3 (13 cells)
    black_cell _black_cell3_0(.pout(p_st_3[0]),   .gout(g_st_3[0]),   .p(p_st_2[2]),   .g(g_st_2[2]),   .p_1(1'b0),         .g_1(cin) );
    black_cell _black_cell3_1(.pout(p_st_3[1]),   .gout(g_st_3[1]),   .p(p_st_2[3]),   .g(g_st_2[3]),   .p_1(p_st_1[0]),    .g_1(g_st_1[0]) );
    black_cell _black_cell3_2(.pout(p_st_3[2]),   .gout(g_st_3[2]),   .p(p_st_2[4]),   .g(g_st_2[4]),   .p_1(p_st_2[0]),    .g_1(g_st_2[0]) );
    black_cell _black_cell3_3(.pout(p_st_3[3]),   .gout(g_st_3[3]),   .p(p_st_2[5]),   .g(g_st_2[5]),   .p_1(p_st_2[1]),    .g_1(g_st_2[1]) );
    black_cell _black_cell3_4(.pout(p_st_3[4]),   .gout(g_st_3[4]),   .p(p_st_2[6]),   .g(g_st_2[6]),   .p_1(p_st_2[2]),    .g_1(g_st_2[2]) );
    black_cell _black_cell3_5(.pout(p_st_3[5]),   .gout(g_st_3[5]),   .p(p_st_2[7]),   .g(g_st_2[7]),   .p_1(p_st_2[3]),    .g_1(g_st_2[3]) );
    black_cell _black_cell3_6(.pout(p_st_3[6]),   .gout(g_st_3[6]),   .p(p_st_2[8]),   .g(g_st_2[8]),   .p_1(p_st_2[4]),    .g_1(g_st_2[4]) );
    black_cell _black_cell3_7(.pout(p_st_3[7]),   .gout(g_st_3[7]),   .p(p_st_2[9]),   .g(g_st_2[9]),   .p_1(p_st_2[5]),    .g_1(g_st_2[5]) );
    black_cell _black_cell3_8(.pout(p_st_3[8]),   .gout(g_st_3[8]),   .p(p_st_2[10]),  .g(g_st_2[10]),  .p_1(p_st_2[6]),    .g_1(g_st_2[6]) );
    black_cell _black_cell3_9(.pout(p_st_3[9]),   .gout(g_st_3[9]),   .p(p_st_2[11]),  .g(g_st_2[11]),  .p_1(p_st_2[7]),    .g_1(g_st_2[7]) );
    black_cell _black_cell3_a(.pout(p_st_3[10]),  .gout(g_st_3[10]),  .p(p_st_2[12]),  .g(g_st_2[12]),  .p_1(p_st_2[8]),    .g_1(g_st_2[8]) );
    black_cell _black_cell3_b(.pout(p_st_3[11]),  .gout(g_st_3[11]),  .p(p_st_2[13]),  .g(g_st_2[13]),  .p_1(p_st_2[9]),    .g_1(g_st_2[9]) );
    black_cell _black_cell3_c(.pout(p_st_3[12]),  .gout(g_st_3[12]),  .p(p_st_2[14]),  .g(g_st_2[14]),  .p_1(p_st_2[10]),   .g_1(g_st_2[10]) );
    
    // CLA tree stage 4 (9 cells)
    black_cell _black_cell4_0(.pout(p_st_4[0]),   .gout(g_st_4[0]),   .p(p_st_3[4]),    .g(g_st_3[4]),    .p_1(1'b0),       .g_1(cin) );
    black_cell _black_cell4_1(.pout(p_st_4[1]),   .gout(g_st_4[1]),   .p(p_st_3[5]),    .g(g_st_3[5]),    .p_1(p_st_1[0]),  .g_1(g_st_1[0]) );
    black_cell _black_cell4_2(.pout(p_st_4[2]),   .gout(g_st_4[2]),   .p(p_st_3[6]),    .g(g_st_3[6]),    .p_1(p_st_2[0]),  .g_1(g_st_2[0]) );
    black_cell _black_cell4_3(.pout(p_st_4[3]),   .gout(g_st_4[3]),   .p(p_st_3[7]),    .g(g_st_3[7]),    .p_1(p_st_2[1]),  .g_1(g_st_2[1]) );
    black_cell _black_cell4_4(.pout(p_st_4[4]),   .gout(g_st_4[4]),   .p(p_st_3[8]),    .g(g_st_3[8]),    .p_1(p_st_3[0]),  .g_1(g_st_3[0]) );
    black_cell _black_cell4_5(.pout(p_st_4[5]),   .gout(g_st_4[5]),   .p(p_st_3[9]),    .g(g_st_3[9]),    .p_1(p_st_3[1]),  .g_1(g_st_3[1]) );
    black_cell _black_cell4_6(.pout(p_st_4[6]),   .gout(g_st_4[6]),   .p(p_st_3[10]),   .g(g_st_3[10]),   .p_1(p_st_3[2]),  .g_1(g_st_3[2]) );
    black_cell _black_cell4_7(.pout(p_st_4[7]),   .gout(g_st_4[7]),   .p(p_st_3[11]),   .g(g_st_3[11]),   .p_1(p_st_3[3]),  .g_1(g_st_3[3]) );
    black_cell _black_cell4_8(.pout(p_st_4[8]),   .gout(g_st_4[8]),   .p(p_st_3[12]),   .g(g_st_3[12]),   .p_1(p_st_3[4]),  .g_1(g_st_3[4]) );
    
    // CLA tree stage final (1 cell)
    black_cell _black_cell5(.pout(p_st_5),        .gout(g_st_5),      .p(p_st_4[8]),    .g(g_st_4[8]),    .p_1(1'b0),       .g_1(cin));
    
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