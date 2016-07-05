/**
* This module is the initialization controller.
*/

`include "defines.svh"
`include "functions.svh"

module init_control (
    input           core_clk      ,
    input           core_arstn    ,
    input           ddr_init_start,
    output          ddr_init_done ,
    config_if.slave s_cfg         ,
    dfi_if.master   init_dfi
);

    enum logic[5:0] {RESET, IDLE, WAIT_200US, WAIT_500US, DONE, XXXX = 'x} state, next;

    logic [15:0] counter       ;
    logic [15:0] count_top     ;
    logic [15:0] counter_next  ;
    logic [15:0] count_top_next;
    logic        ddr_init_done ;

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_state
        if(~core_arstn) begin
            state     <= RESET;
            counter   <= '0;
        end else begin
            state     <= next;
            counter   <= counter_next;
        end
    end

    always_comb begin : proc_next
        next = XXXX;
        unique case (state)
            RESET :
                begin
                    next         = IDLE;
                    counter_next = '0;
                end
            IDLE :
                if(1'b1 == ddr_init_start) begin
                    next         = WAIT_200US;
                    counter_next = '0;
                end else begin
                    next         = IDLE;
                    counter_next = '0;
                end
            WAIT_200US :
                if(ns_to_clk(200*1000) == counter) begin
                    next         = WAIT_500US;
                    counter_next = '0;
                end else begin
                    next         = WAIT_200US;
                    counter_next = counter + 1;
                end
            WAIT_500US :
                if(ns_to_clk(500*1000) == counter) begin
                    next         = WAIT_500US;
                    counter_next = '0;
                end else begin
                    next         = WAIT_500US;
                    counter_next = counter + 1;
                end
            DONE : begin
                next = DONE;
                counter_next = '0;
            end
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            init_dfi.dfi_reset_n <= 1'b0;
            ddr_init_done        <= 1'b0;
        end else begin
            unique case (next)
                WAIT_200US : begin
                    init_dfi.dfi_reset_n <= 1'b0;
                    init_dfi.dfi_cke     <= 1'b0;
                end
                WAIT_500US : begin
                    init_dfi.dfi_reset_n <= 1'b1;
                end
                DONE : begin
                    ddr_init_done <= 1'b1;
                end
            endcase
        end
    end

endmodule // init_control
