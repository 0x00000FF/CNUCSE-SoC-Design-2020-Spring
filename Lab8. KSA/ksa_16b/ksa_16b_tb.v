`timescale 1ns/100ps

module ksa_16b_tb;
    reg [15:0] a, b;
    reg cin;
    
    wire cout;
    wire [15:0] sum;
    
    reg  [15:0] check;
    integer     i, j;
    integer     num_correct, num_wrong;
    
    ksa_16b_top ksa(.cout(cout), .sum(sum), .a(a), .b(b), .cin(cin));
    
    initial begin
        num_correct = 0; num_wrong = 0;
        
        $display("initialized check parameters to 0");
        // test for 16bit max (65535)
        for (i = 0; i < 65536; i = i + 1) begin
            a = i;
            for (j = 0; j < 65536; j = j + 1) begin
                b = j;
                cin = 1'b0;
                
                check = a + b + cin;
                #10;
                if ({cout, sum} == check)
                    num_correct = num_correct + 1;
                else
                    num_wrong   = num_wrong + 1;
            end
        end
        
        $display("test done, num_correct=%d, num_wrong=%d", num_correct, num_wrong);
    end

endmodule