`define 

module alu_16v(cc, result, valA, valB, op, sub, sr, lr, arlo);
    input [15:0]  valA, valB;
    input [2:0]   op;
    input         sub, sr, lr, arlo;

    output [3:0]  cc;
    output [15:0] result;

    wire [15:0] not_b, b_mux, 
                result_and, result_or, result_xor,
                result_sh,  result_not, result_addr,
                result_addr_co, result_sh_ov,
                result, N, Z, C, V;

    // process input B
    assign not_b = ~valB;
    assign b_mux = ( sub == 0 ) ? valB : ~valB;

    // result of op AND
    assign result_and = valA & b_mux;

    // result of op OR
    assign result_or  = valA | b_mux;

    // result of op XOR
    assign result_xor = valA ^ b_mux;

    // result of op NOT A
    assign result_not = ~valA;

    // result of op SHFT
    

    // result of op ADD (from 16bit KSA) 
    ksa_16b_top      adder(.cout(result_addr_co), .cout(result_addr), .a(valA), .b(b_mux), .cin(sub));

    // mux all result to make result

    // make NZCV
    assign N  = result[15];
    assign Z  = (result == 0) ? 1 : 0;
    assign C  = (/* if op is add */) ? result_addr_co : 0;
    assign V  = (/* if op is add */) ? (/* calculate result overflow */) : 
                (/* if op is sh  */) ? result_sh_ov : 0;

    // complete control flag output
    assign cc = { N, Z, C, V };
endmodule