/**
* This module is the initialization controller.
*/

`include "timescale.svh"
`include "defines.svh"
`include "defines.svh"
`include "enums.svh"
`include "functions.svh"
`include "structs.svh"

module init_control (
    input           core_clk      ,
    input           core_arstn    ,
    input           ddr_init_start,
    output logic    ddr_init_done ,
    config_if.slave s_cfg         ,
    dfi_if.master   init_dfi
);

    enum logic[5:0] {RESET, IDLE, WAIT_200US, WAIT_500US, WAIT_XPR, ISSUE_MR2, WAIT_MR2, ISSUE_MR3, WAIT_MR3, ISSUE_MR1, WAIT_MR1, ISSUE_MR0, WAIT_MR0, ISSUE_ZQCL, WAIT_ZQCL, RL_START, RL_WAIT, RL_DONE, WL_START, WL_WAIT, WL_DONE, DONE, XXXX = 'x} state, next;

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
            RESET : begin
                next         = IDLE;
                counter_next = '0;
            end
            IDLE : if(1'b1 == ddr_init_start) begin
                next         = WAIT_200US;
                counter_next = 1'b1;
            end else begin
                next         = IDLE;
                counter_next = '0;
            end
            WAIT_200US : if(ns_to_clk(200) == counter) begin
                next         = WAIT_500US;
                counter_next = 1'b1;
            end else begin
                next         = WAIT_200US;
                counter_next = counter + 1;
            end
            WAIT_500US : if(ns_to_clk(500) == counter) begin
                next         = WAIT_XPR;
                counter_next = 1'b1;
            end else begin
                next         = WAIT_500US;
                counter_next = counter + 1;
            end
            WAIT_XPR : if(s_cfg.tXPR == counter) begin
                next         = ISSUE_MR2;
                counter_next = '0;
            end else begin
                next         = WAIT_XPR;
                counter_next = counter + 1;
            end
            ISSUE_MR2 : if(1'b1 == s_cfg.tMRD) begin
                next         = WAIT_MR2;
                counter_next = 1'b1;
            end else begin
                next         = ISSUE_MR3;
                counter_next = '0;
            end
            WAIT_MR2 : if(s_cfg.tMRD == counter) begin
                next         = ISSUE_MR3;
                counter_next = '0;
            end else begin
                next         = WAIT_MR2;
                counter_next = counter + 1;
            end
            ISSUE_MR3 : if(1'b1 == s_cfg.tMRD) begin
                next         = WAIT_MR3;
                counter_next = 1'b1;
            end else begin
                next         = ISSUE_MR1;
                counter_next = '0;
            end
            WAIT_MR3 : if(s_cfg.tMRD == counter) begin
                next         = ISSUE_MR1;
                counter_next = '0;
            end else begin
                next         = WAIT_MR3;
                counter_next = counter + 1;
            end
            ISSUE_MR1 : if(1'b1 == s_cfg.tMRD) begin
                next         = WAIT_MR1;
                counter_next = 1'b1;
            end else begin
                next         = ISSUE_MR0;
                counter_next = '0;
            end
            WAIT_MR1 : if(s_cfg.tMRD == counter) begin
                next         = ISSUE_MR0;
                counter_next = '0;
            end else begin
                next         = WAIT_MR1;
                counter_next = counter + 1;
            end
            ISSUE_MR0 : if(1'b1 == s_cfg.tMRD) begin
                next         = WAIT_MR0;
                counter_next = 1'b1;
            end else begin
                next         = ISSUE_ZQCL;
                counter_next = '0;
            end
            WAIT_MR0 : if(s_cfg.tMOD == counter) begin
                next         = ISSUE_ZQCL;
                counter_next = '0;
            end else begin
                next         = WAIT_MR0;
                counter_next = counter + 1;
            end
            ISSUE_ZQCL : begin
                next         = WAIT_ZQCL;
                counter_next = 1'b1;
            end
            WAIT_ZQCL : if(s_cfg.tZQinit == counter) begin
                next         = WL_START;
                counter_next = '0;
            end else begin
                next         = WAIT_ZQCL;
                counter_next = counter + 1;
            end
            WL_START : begin
                next         = WL_WAIT;
                counter_next = 1'b1;
            end
            WL_WAIT : if(1'b1 == init_dfi.dfi_wrlvl_resp) begin
                next         = RL_START;
                counter_next = '0;
            end else begin
                next         = WL_WAIT;
                counter_next = counter + 1;
            end
            RL_START : begin
                next         = RL_WAIT;
                counter_next = 1'b1;
            end
            RL_WAIT : if(1'b1 == init_dfi.dfi_rdlvl_resp) begin
                next         = DONE;
                counter_next = '0;
            end else begin
                next         = RL_WAIT;
                counter_next = counter + 1;
            end
            DONE : begin
                next         = DONE;
                counter_next = '0;
            end
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            ddr_init_done                 <= '0;
            init_dfi.dfi_address[15:0]    <= '0;
            init_dfi.dfi_bank             <= '0;
            init_dfi.dfi_ras_n[0]         <= '1;
            init_dfi.dfi_cas_n[0]         <= '1;
            init_dfi.dfi_we_n[0]          <= '1;
            init_dfi.dfi_cs_n[1:0]        <= '1;
            init_dfi.dfi_cke              <= '0;
            init_dfi.dfi_odt              <= '0;
            init_dfi.dfi_reset_n[0]       <= '0;
            init_dfi.dfi_dram_clk_disable <= '0;
        end else begin
            ddr_init_done                 <= '0;
            init_dfi.dfi_address          <= '0;
            init_dfi.dfi_bank             <= '0;
            init_dfi.dfi_cke              <= '1;
            init_dfi.dfi_odt              <= '0;
            init_dfi.dfi_reset_n[0]       <= '1;
            init_dfi.dfi_dram_clk_disable <= '0;
            init_dfi.cmd(0, `CMD_NOP);
            init_dfi.cmd(1, `CMD_NOP);
            init_dfi.cmd(2, `CMD_NOP);
            init_dfi.cmd(3, `CMD_NOP);
            unique case (next)
                IDLE : begin
                    init_dfi.dfi_reset_n <= '0;
                    init_dfi.dfi_cke     <= '0;
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WAIT_200US : begin
                    init_dfi.dfi_reset_n <= '0;
                    init_dfi.dfi_cke     <= '0;
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WAIT_500US : begin
                    init_dfi.dfi_cke     <= '0;
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WAIT_XPR : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                ISSUE_MR2 : begin
                    init_dfi.cmd(0, `CMD_MRS);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(2, s_cfg.msr2);
                end
                WAIT_MR2 : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(2, s_cfg.msr2);
                end
                ISSUE_MR3 : begin
                    init_dfi.cmd(0, `CMD_MRS);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(3, s_cfg.msr3);
                end
                WAIT_MR3 : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(3, s_cfg.msr3);
                end
                ISSUE_MR1 : begin
                    init_dfi.cmd(0, `CMD_MRS);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(1, s_cfg.msr1);
                end
                WAIT_MR1 : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(1, s_cfg.msr1);
                end
                ISSUE_MR0 : begin
                    init_dfi.cmd(0, `CMD_MRS);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(0, s_cfg.msr0);
                end
                WAIT_MR0 : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                    init_dfi.mrs(0, s_cfg.msr0);
                end
                ISSUE_ZQCL : begin
                    init_dfi.cmd(0, `CMD_ZQCL);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WAIT_ZQCL : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WL_START : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                WL_WAIT : begin
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
                RL_START : begin

                end
                RL_WAIT : begin

                end
                DONE : begin
                    ddr_init_done <= 1'b1;
                    init_dfi.cmd(0, `CMD_NOP);
                    init_dfi.cmd(1, `CMD_NOP);
                    init_dfi.cmd(2, `CMD_NOP);
                    init_dfi.cmd(3, `CMD_NOP);
                end
            endcase
        end
    end

endmodule // init_control
