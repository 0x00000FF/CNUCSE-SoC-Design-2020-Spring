module fsm_moore (y, x, clock);
    input clock;
    input x;
    output y;
    
    reg       state_master;
    reg [1:0] state_slave;
    reg       y;
    
    initial begin
        state_master = 0;
        state_slave  = 0;
    end
    
    always @(posedge clock) begin
        if (state_master == x) 
            $display("x=%b sm=%b", x, state_master);
            if (state_slave < 2'b11) state_slave = state_slave + 1'b1;
        else begin
            state_master <= ~state_master;
            state_slave  <= 0;
        end

        case (state_slave)
            2'b00, 2'b01, 2'b10:   y = 0;
            2'b11:                 y = 1;
            default:               y = 1'bx;
        endcase

        $display("x=%b y=%b sm=%b ss=%b", x, y, state_master, state_slave);
    end
endmodule
