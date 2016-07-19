/**
 *
 */

`include "timescale.svh"

module cali_control (
    input           core_clk   ,
    input           core_arstn ,
    input           cali_start,
    output          cali_done ,
    config_if.slave s_cfg      ,
    dfi_if.master   cali_dfi
);
  
    enum logic[5:0] {RESET, IDLE, DONE, XXXX = 'x} state, next;

    logic [15:0] counter     ;
    logic [15:0] counter_next;

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
                if(1'b1 == cali_start) begin
                    next         = INIT;
                    counter_next = counter + 1;
                end else begin
                    next         = IDLE;
                    counter_next = '0;
                end
            INIT :
                if(counter == count_top) begin
                    next         = DONE;
                    counter_next = '0;
                end else begin
                    next         = INIT;
                    counter_next = counter + 1;
                end
            WL_START :
                begin
                    next         = WL_WAIT;
                    counter_next = '0;
                end
            WL_WAIT :
                if(1'b1 == init_dfi.dfi_wrlvl_resp) begin
                    next         = RL_START;
                    counter_next = '0;
                end else begin
                    next         = WL_WAIT;
                    counter_next = counter + 1;
                end
            RL_START :
                begin
                    next         = RL_WAIT;
                    counter_next = '0;
                end
            RL_WAIT :
                if(1'b1 == init_dfi.dfi_rdlvl_resp) begin
                    next         = RL_START;
                    counter_next = '0;
                end else begin
                    next         = RL_WAIT;
                    counter_next = counter + 1;
                end
            DONE :
                next = DONE;
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            cali_dfi.dfi_reset_n <= 1'b1;
            cali_done            <= 1'b0;
        end else begin
            unique case (next)
                INIT : begin
                    cali_dfi.dfi_reset_n <= 1'b0;
                end
                DONE : begin
                    cali_done <= 1'b1;
                end
            endcase
        end
    end

endmodule // cali_control
