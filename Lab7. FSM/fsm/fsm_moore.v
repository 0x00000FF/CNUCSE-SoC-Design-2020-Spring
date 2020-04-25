module fsm_moore (Y, X, clock);
    input clock;
    input X;
    output Y;
    
    reg       state_master;
    reg [1:0] state_slave;
    reg       Y;

    always @(posedge clock) begin
        // next state logic
        if (state_master == X) begin
            $display("[MR] master state matches sm=%b, ss=%b, x=%b", state_master, state_slave, X);
            if (state_slave != 2'b11) begin // when state less than 2'b11
                state_slave = state_slave + 1;
                $display("[MR] >> slave state updated ss=%b", state_slave);
            end
        end
        else begin
            $display("[MR] state mismatch, update to %b, reset ss to 0", X);
            
            state_master = X;
            state_slave  = 0;
        end
        
        // output logic
        case (state_slave)
            2'b00, 2'b01, 2'b10:   Y = 0;
            2'b11:                 Y = 1;
            default:               Y = 1'bx;
        endcase
    end
endmodule
