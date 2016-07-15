/**
 *
 */

`include "timescale.svh"

module main_control (
    input              core_clk      ,
    input              core_arstn    ,
    //
    input              r_empty       ,
    //
    output logic       ddr_init_start,
    input              ddr_init_done ,
    output logic       cali_start    ,
    input              cali_done     ,
    output logic       tran_start    ,
    input              tran_done     ,
    //
    config_if.slave    s_cfg         ,
    output logic [1:0] sel           ,
    dfi_if.master      main_dfi
);

    enum logic[5:0] {RESET, INIT_DFI, INIT_DDR, DO_CALI, IDLE, XXXX = 'x} state, next;

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_state
        if(~core_arstn) begin
            state <= RESET;
        end else begin
            state <= next;
        end
    end

    always_comb begin : proc_next
        next = XXXX;
        unique case (state)
            RESET :
                next = INIT_DFI;
            INIT_DFI :
                if(1'b1 == main_dfi.dfi_init_complete) begin
                    next = INIT_DDR;
                end else begin
                    next = INIT_DFI;
                end
            INIT_DDR :
                if(1'b1 == ddr_init_done) begin
                    next = IDLE;
                end else begin
                    next = INIT_DDR;
                end
            DO_CALI :
                if(1'b1 == cali_done) begin
                    next = IDLE;
                end else begin
                    next = INIT_DDR;
                end
            IDLE :
                if(1'b1 == main_dfi.dfi_rdlvl_req) begin
                    next = DO_CALI;
                end else if(1'b1 == main_dfi.dfi_wrlvl_req) begin
                    next = DO_CALI;
                end else begin
                    next = IDLE;
                end
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            main_dfi.dfi_data_byte_disable <= '0; // don't disable any byte lanes
            main_dfi.dfi_dram_clk_disable  <= '0;
            main_dfi.dfi_freq_ratio        <= 2'b11; // 1:4matched frequency
            main_dfi.dfi_init_start        <= '0;
            ddr_init_start                 <= '0;
            sel                            <= '0;
        end else begin
            unique case (next)
                INIT_DFI : begin
                    main_dfi.dfi_data_byte_disable <= '0; // don't disable any byte lanes
                    main_dfi.dfi_dram_clk_disable  <= '0;
                    main_dfi.dfi_freq_ratio        <= 2'b11; // 1:4matched frequency
                    main_dfi.dfi_init_start        <= 1;
                    ddr_init_start                 <= 0;
                    sel                            <= 2'b00;
                end
                INIT_DDR : begin
                    main_dfi.dfi_data_byte_disable <= '0; // don't disable any byte lanes
                    main_dfi.dfi_dram_clk_disable  <= '0;
                    main_dfi.dfi_freq_ratio        <= 2'b11; // 1:4matched frequency
                    main_dfi.dfi_init_start        <= 1;
                    ddr_init_start                 <= 1;
                    sel                            <= 2'b01;
                end
                IDLE : begin
                    main_dfi.dfi_data_byte_disable <= '0; // don't disable any byte lanes
                    main_dfi.dfi_dram_clk_disable  <= '0;
                    main_dfi.dfi_freq_ratio        <= 2'b11; // 1:4matched frequency
                    main_dfi.dfi_init_start        <= 1;
                    ddr_init_start                 <= 1;
                    sel                            <= 2'b11;
                end
            endcase
        end
    end

endmodule // main_control
