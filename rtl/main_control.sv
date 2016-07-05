/**
*
*/

module main_control (
    input           core_clk      ,
    input           core_arstn    ,
    input           r_empty       ,
    output          ddr_init_start,
    input           ddr_init_done ,
    config_if.slave s_cfg         ,
    dfi_if.master   m_dfi
);

    enum logic[5:0] {RESET, INIT_DFI, INIT_DDR, ZQCAL, IDLE, XXXX = 'x} state, next;

    logic ddr_init_start;

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_state
        if(~core_arstn) begin
            state <= RESET;
        end else begin
            state <= next;
        end
    end

    always_comb begin : proc_next
        next = XXXX; // for debug
        unique case (state)
            RESET :
                next = INIT_DFI;
            INIT_DFI :
                if(1'b1 == m_dfi.dfi_init_complete) begin
                    next = INIT_DDR;
                end
                else begin
                    next = INIT_DFI;
                end
            INIT_DDR :
                if(1'b1 == ddr_init_done) begin
                    next = IDLE;
                end
                else begin
                    next = INIT_DDR;
                end
            IDLE : next = IDLE;
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            init_dfi();
        end else begin
            unique case (next)
                INIT_DFI : begin
                    m_dfi.dfi_init_start <= 1'b1;
                end
                INIT_DDR : begin
                    ddr_init_start <= 1'b1;
                end
            endcase
        end
    end

    // JESD79-3F pg. 33
    // CS' RAS' CAS' WE'
    localparam CMD_MRS   = 4'b0000; // Mode Register Set
    localparam CMD_REF   = 4'b0001; // Refresh
    localparam CMD_SRE   = 4'b0001; // Self Refresh Entry
    localparam CMD_SRX   = 4'b0000; // Self Refresh Exit
    localparam CMD_PRE   = 4'b0010; // Single Bank Precharge
    localparam CMD_PREA  = 4'b0011; // Precharge all Banks
    localparam CMD_ACT   = 4'b0000; // Bank Activate
    localparam CMD_WR    = 4'b0100; // Write (Fixed BL8 or BC4)
    localparam CMD_WRS4  = 4'b0100; // Write (BC4, on the Fly)
    localparam CMD_WRS8  = 4'b0100; // Write (BL8, on the Fly)
    localparam CMD_WRA   = 4'b0100; // Write with Auto Precharge (Fixed BL8 or BC4)
    localparam CMD_WRAS4 = 4'b0100; // Write with Auto Precharge (BC4, on the Fly)
    localparam CMD_WRAS8 = 4'b0100; // Write with Auto Precharge (BL8, on the Fly)
    localparam CMD_RD    = 4'b0101; // Read (Fixed BL8 or BC4)
    localparam CMD_RDS4  = 4'b0101; // Read (BC4, on the Fly)
    localparam CMD_RDS8  = 4'b0101; // Read (BL8, on the Fly)
    localparam CMD_RDA   = 4'b0101; // Read with Auto Precharge (Fixed BL8 or BC4)
    localparam CMD_RDAS4 = 4'b0101; // Read with Auto Precharge (BC4, on the Fly)
    localparam CMD_RDAS8 = 4'b0101; // Read with Auto Precharge (BL8, on the Fly)
    localparam CMD_NOP   = 4'b0111; // No Operation
    localparam CMD_DES   = 4'b1000; // Device Deselected
    localparam CMD_PDE   = 4'b0000; // Power Down Entry
    localparam CMD_PDX   = 4'b0000; // Power Down Exit
    localparam CMD_ZQCL  = 4'b0000; // ZQ Calibration Long
    localparam CMD_ZQCS  = 4'b0000; // ZQ Calibration Short


    task init_dfi();
        m_dfi.dfi_address           <= '0;
        m_dfi.dfi_bank              <= '0;
        m_dfi.dfi_ras_n             <= '1;
        m_dfi.dfi_cas_n             <= '1;
        m_dfi.dfi_we_n              <= '1;
        m_dfi.dfi_cs_n              <= '1;
        m_dfi.dfi_cke               <= '0;
        m_dfi.dfi_odt               <= '0;
        m_dfi.dfi_reset_n           <= '1;
        m_dfi.dfi_wrdata_en         <= '0;
        m_dfi.dfi_wrdata            <= '0;
        m_dfi.dfi_wrdata_cs_n       <= '1;
        m_dfi.dfi_wrdata_mask       <= '0;
        m_dfi.dfi_rddata_en         <= '0;
        m_dfi.dfi_rddata_cs_n       <= '1;
        m_dfi.dfi_ctrlupd_req       <= '0;
        m_dfi.dfi_phyupd_ack        <= '0;
        m_dfi.dfi_data_byte_disable <= '0; // don't disable any byte lanes
        m_dfi.dfi_dram_clk_disable  <= '0;
        m_dfi.dfi_freq_ratio        <= 2'b00; // 1:1 matched frequency
        m_dfi.dfi_init_start        <= '0;
        m_dfi.dfi_parity_in         <= '0;
        m_dfi.dfi_rdlvl_en          <= '0;
        m_dfi.dfi_rdlvl_gate_en     <= '0;
        m_dfi.dfi_wrlvl_en          <= '0;
        m_dfi.dfi_wrlvl_strobe      <= '0;
        m_dfi.dfi_lvl_periodic      <= '0;
        m_dfi.dfi_phylvl_ack_cs_n   <= '1;
        m_dfi.dfi_lp_ctrl_req       <= '0;
        m_dfi.dfi_lp_data_req       <= '0;
        m_dfi.dfi_lp_wakeup         <= '0;
        ddr_init_start <= '0;
    endtask : init_dfi

endmodule // main_control
