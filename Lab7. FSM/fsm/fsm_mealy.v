module fsm_mealy (Y, X, clock);
    input clock;
    input X;
    output Y;
    
    reg       state_master;
    reg [1:0] state_slave;
    reg       Y;
    
    always @(posedge clock) begin
        $display("[ML] current state(sm, ss) = %b, %b | input = %b", state_master, state_slave, X);
        if (state_master == X && state_slave == 2'b10) begin
            $display("[ML] >> Reached input = 1");
            Y = 1;
        end
        else begin 
            if (state_master == X) 
                state_slave = state_slave + 1;
            else begin 
                $display("[ML] state mistmatch, update to %b", X);
                state_master = X;
                state_slave  = 0;
            end
            
            Y = 0; 
        end
    end

endmodule