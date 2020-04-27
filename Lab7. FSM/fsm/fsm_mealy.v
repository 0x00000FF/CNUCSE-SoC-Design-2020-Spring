module fsm_mealy (Y, X, clock);
    input clock;
    input X;
    output Y;
    
    reg       state_master;
    reg [1:0] state_slave;
    reg       Y;
    
    always @(posedge clock) begin
        // begin state & output logic
        $display("[ML] current state(sm, ss) = %b, %b | input = %b", state_master, state_slave, X);
        if (state_master == X && state_slave == 2'b10) begin // when state and input accepted
            $display("[ML] >> Reached input = 1");
            Y = 1; // set output 1
        end
        else begin  // otherwise set output 0
            if (state_master == X)  // update slave state 
                state_slave = state_slave + 1;
            else begin  // reset state
                $display("[ML] state mistmatch, update to %b", X);
                state_master = X;
                state_slave  = 0;
            end
            
            Y = 0; 
        end
    end

endmodule