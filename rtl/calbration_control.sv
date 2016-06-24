/**
 * 
 */

module calbration_control (
    input           core_clk   ,
    input           core_arstn ,
    input           calib_start,
    output          calib_done ,
    config_if.slave s_cfg      ,
    dfi_if.master   calib_dfi
);

    
    enum logic[5:0] {RESET, IDLE, CALIB, DONE, XXXX = 'x} state, next;

    logic [15:0] counter       ;
    logic [15:0] count_top     ;
    logic [15:0] counter_next  ;
    logic [15:0] count_top_next;

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_state
        if(~core_arstn) begin
            state     <= RESET;
            counter   <= '0;
            count_top <= '0;
        end else begin
            state     <= next;
            counter   <= counter_next;
            count_top <= count_top_next;
        end
    end

    always_comb begin : proc_next
        next = XXXX;
        unique case (state)
            RESET :
                begin
                    next           = IDLE;
                    count_top_next = '0;
                    counter_next   = '0;
                end
            IDLE :
                if(1'b1 == calib_start) begin
                    next           = INIT;
                    count_top_next = ns_to_clk(1000);
                    counter_next   = counter + 1;
                end else begin
                    next           = IDLE;
                    count_top_next = '0;
                    counter_next   = '0;
                end
            INIT :
                if(counter == count_top) begin
                    next           = DONE;
                    count_top_next = '0;
                    counter_next   = '0;
                end else begin
                    next           = INIT;
                    count_top_next = count_top;
                    counter_next   = counter + 1;
                end
            DONE :
                next = DONE;
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            calib_dfi.dfi_reset_n <= 1'b1;
            calib_done            <= 1'b0;
        end else begin
            unique case (next)
                INIT : begin
                    calib_dfi.dfi_reset_n <= 1'b0;
                end
                DONE : begin
                    calib_done <= 1'b1;
                end
            endcase
        end
    end

endmodule // calbration_control
