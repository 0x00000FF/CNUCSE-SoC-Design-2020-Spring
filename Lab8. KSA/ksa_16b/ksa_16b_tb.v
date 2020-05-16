`timescale 1ns/100ps

module ksa_16b_tb;
    reg [15:0] a, b;
    reg cin;
    
    wire cout;
    wire [15:0] sum;
    
    integer     check, i, j;
    integer     num_correct, num_wrong;
    
    ksa_16b_top ksa(.cout(cout), .sum(sum), .a(a), .b(b), .cin(cin));
    
    initial begin
        num_correct = 0; num_wrong = 0;
        $display("=== test begin ===", num_correct, num_wrong);

        // test for 16bit max (65535)
        for (i = 25452; i < 65536; i = i + 1) begin
            a = i;
            for (j = 0; j < 65536; j = j + 1) begin
                b = j;
                cin = 1'b0;
                
                check = a + b + cin;
                #10;
                if ({cout, sum} == check) begin
                    $display("[%d, %d] test case passed: %b", a, b, {cout, sum});
                    num_correct = num_correct + 1;
                end
                else begin
                    $display("[%d, %d] test case failed: %b (expected %b)", a, b, {cout, sum}, check);
                    num_wrong   = num_wrong + 1;
                end
            end
        end
        
        $display("test done, num_correct=%d, num_wrong=%d", num_correct, num_wrong);
    end

endmodule