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
    output pout, gout;
    
    assign pout = g | (p & g_1);
    assign gout = p & p_1;
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

    // p, g terms (includes pin, cin)
    wire    [16:0] p_terms, g_terms;
    wire    [15:0] sum, c_outs;
    
    assign p_terms[0] = 0;
    assign g_terms[0] = cin;
    
    // create wire for each CLA tree stage
    wire   [15:0] pg_tree_p_st_1, pg_tree_g_st_1;
    wire   [14:0] pg_tree_p_st_2, pg_tree_g_st_2;
    wire   [12:0] pg_tree_p_st_3, pg_tree_g_st_3;
    wire   [8:0]  pg_tree_p_st_4, pg_tree_g_st_4;
    wire          pg_tree_p_st_5, pg_tree_g_st_5;
    
    // generate p,g for each bits
    // for iterator index 
    genvar idx;
    
    generate
        for ( idx = 1; idx < 17; idx = idx + 1 ) begin : pg_generator_bits
            pg_gen _pg_gen(.p(p_terms[idx]), .g(g_terms[idx]), .a(a[idx - 1]), .b(b[idx - 1]));
        end
    endgenerate
    
    // CLA tree stage 1 (16 cells)
    generate
        for ( idx = 1; idx < 17; idx = idx + 1 ) begin : cla_tree_stage_1
            black_cell _black_cell1(.pout(pg_tree_p_st_1[idx-1]), .gout(pg_tree_g_st_1[idx-1]),
                             .p(p_terms[idx]),             .g(g_terms[idx]), 
                             .p_1(p_terms[idx-1]),         .g_1(g_terms[idx-1]));
        end
    endgenerate
    
    // CLA tree stage 2 (15 cells)
    generate
        for ( idx = 0; idx < 15; idx = idx + 1 ) begin : cla_tree_stage_2
            if ( idx == 2 ) begin // if first cell of the stage
                black_cell _black_cell2(.pout(pg_tree_p_st_2[idx]),  .gout(pg_tree_g_st_2[idx]),
                                 .p(pg_tree_p_st_1[idx + 1]), .g(pg_tree_g_st_1[idx + 1]),
                                 .p_1(p_terms[idx-2]),        .g_1(g_terms[idx-2]));   
            end
            else begin
                black_cell _black_cell2(.pout(pg_tree_p_st_2[idx]),  .gout(pg_tree_g_st_2[idx]),
                                 .p(pg_tree_p_st_1[idx + 1]), .g(pg_tree_g_st_1[idx + 1]),
                                 .p_1(pg_tree_p_st_1[idx]),   .g_1(pg_tree_g_st_1[idx]));
            end
        end
    endgenerate
    
    // CLA tree stage 3 (13 cells)
    generate
        for ( idx = 0; idx < 13; idx = idx + 1 ) begin : cla_tree_stage_3
            if ( idx == 4 ) begin // if first cell of the stage
                black_cell _black_cell2(.pout(pg_tree_p_st_3[idx]),  .gout(pg_tree_g_st_3[idx]),
                                 .p(pg_tree_p_st_2[idx + 2]), .g(pg_tree_g_st_2[idx + 2]),
                                 .p_1(p_terms[idx-4]),        .g_1(g_terms[idx-4]));   
            end
            else begin
                black_cell _black_cell2(.pout(pg_tree_p_st_3[idx]),  .gout(pg_tree_g_st_3[idx]),
                                 .p(pg_tree_p_st_2[idx + 2]), .g(pg_tree_g_st_2[idx + 2]),
                                 .p_1(pg_tree_p_st_2[idx]),   .g_1(pg_tree_g_st_2[idx]));
            end
        end
    endgenerate
    
    // CLA tree stage 4 (9 cells)
    generate
        for ( idx = 0; idx < 9; idx = idx + 1 ) begin : cla_tree_stage_4
            if ( idx == 8 ) begin // if first cell of the stage
                black_cell _black_cell4(.pout(pg_tree_p_st_4[idx]),  .gout(pg_tree_g_st_4[idx]),
                                 .p(pg_tree_p_st_3[idx + 4]), .g(pg_tree_g_st_3[idx + 4]),
                                 .p_1(p_terms[idx-8]),        .g_1(g_terms[idx-8])); // get p_1, g_1 from pin, gin
            end
            else begin
                black_cell _black_cell4(.pout(pg_tree_p_st_4[idx]),  .gout(pg_tree_g_st_4[idx]),
                                 .p(pg_tree_p_st_3[idx + 4]), .g(pg_tree_g_st_3[idx + 4]),
                                 .p_1(pg_tree_p_st_3[idx]),   .g_1(pg_tree_g_st_3[idx])); // get p_1, g_1 from n-4 th cell of prev_stage
            end
        end
    endgenerate
    
    // CLA tree stage final (1 cell)
    black_cell _black_cell5(.pout(pg_tree_p_st_5),     .gout(pg_tree_g_st_5),
                            .p(pg_tree_p_st_4[8]),     .g(pg_tree_g_st_4[8]),
                            .p_1(p_terms[0]),          .g_1(g_terms[0]));
    
    // CLA Tree done
    // Carry Generation (g_terms[0] is cin)
    carry_gen _carry_gen0 (.cout(c_outs[0]),  .p(p_terms[1]),        .g(g_terms[1]),        .cin(g_terms[0]));
    carry_gen _carry_gen1 (.cout(c_outs[1]),  .p(pg_tree_p_st_1[0]), .g(pg_tree_g_st_1[0]), .cin(c_outs[0]));
    carry_gen _carry_gen2 (.cout(c_outs[2]),  .p(pg_tree_p_st_2[0]), .g(pg_tree_g_st_2[0]), .cin(c_outs[1]));
    carry_gen _carry_gen3 (.cout(c_outs[3]),  .p(pg_tree_p_st_2[1]), .g(pg_tree_g_st_2[1]), .cin(c_outs[2]));
    carry_gen _carry_gen4 (.cout(c_outs[4]),  .p(pg_tree_p_st_3[0]), .g(pg_tree_g_st_3[0]), .cin(c_outs[3]));
    carry_gen _carry_gen5 (.cout(c_outs[5]),  .p(pg_tree_p_st_3[1]), .g(pg_tree_g_st_3[1]), .cin(c_outs[4]));
    carry_gen _carry_gen6 (.cout(c_outs[6]),  .p(pg_tree_p_st_3[2]), .g(pg_tree_g_st_3[2]), .cin(c_outs[5]));
    carry_gen _carry_gen7 (.cout(c_outs[7]),  .p(pg_tree_p_st_3[3]), .g(pg_tree_g_st_3[3]), .cin(c_outs[6]));
    carry_gen _carry_gen8 (.cout(c_outs[8]),  .p(pg_tree_p_st_4[0]), .g(pg_tree_g_st_4[0]), .cin(c_outs[7]));
    carry_gen _carry_gen9 (.cout(c_outs[9]),  .p(pg_tree_p_st_4[1]), .g(pg_tree_g_st_4[1]), .cin(c_outs[8]));
    carry_gen _carry_gen10(.cout(c_outs[10]), .p(pg_tree_p_st_4[2]), .g(pg_tree_g_st_4[2]), .cin(c_outs[9]));
    carry_gen _carry_gen11(.cout(c_outs[11]), .p(pg_tree_p_st_4[3]), .g(pg_tree_g_st_4[3]), .cin(c_outs[10]));
    carry_gen _carry_gen12(.cout(c_outs[12]), .p(pg_tree_p_st_4[4]), .g(pg_tree_g_st_4[4]), .cin(c_outs[11]));
    carry_gen _carry_gen13(.cout(c_outs[13]), .p(pg_tree_p_st_4[5]), .g(pg_tree_g_st_4[5]), .cin(c_outs[12]));
    carry_gen _carry_gen14(.cout(c_outs[14]), .p(pg_tree_p_st_4[6]), .g(pg_tree_g_st_4[6]), .cin(c_outs[13]));
    carry_gen _carry_gen15(.cout(c_outs[15]), .p(pg_tree_p_st_4[7]), .g(pg_tree_g_st_4[7]), .cin(c_outs[14]));
    carry_gen _carry_gen16(.cout(cout),       .p(pg_tree_p_st_5),    .g(pg_tree_g_st_5),    .cin(c_outs[15]));
    
    // Sum generation
    generate
        for ( idx = 1; idx < 17; idx = idx + 1 ) begin : sum_generation
            assign sum[idx-1] = p_terms[idx] ^ c_outs[idx-1];
        end
    endgenerate
endmodule