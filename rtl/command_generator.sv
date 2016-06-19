/**
 *
 */

module command_generator (
    input         core_clk  ,
    input         core_arstn,
    input         r_empty   ,
    dfi_if.master m_dfi
);

    enum logic[5:0] {RESET, INIT, IDLE, XXXXX = 'x} state, next;

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_state
        if(~core_arstn) begin
            state <= RESET;
        end else begin
            state <= next;
        end
    end

    always_comb begin : proc_next
        next = XXXXX;
        unique case (state)
            RESET : next = INIT;
            INIT  : if(1'b1 == m_dfi.dfi_init_complete) next = IDLE;
            else next = INIT;
            IDLE  : next = IDLE;
        endcase
    end

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_output
        if(~core_arstn) begin
            m_dfi.dfi_init_start        <= 1'b0;
            m_dfi.dfi_data_byte_disable <= '0;    // don't disable any byte lanes
            m_dfi.dfi_freq_ratio        <= 2'b00; // 1:1 matched frequency
        end else begin
            unique case (next)
                INIT : begin
                    m_dfi.dfi_init_start <= 1'b1;
                end
            endcase
        end
    end

    // enum {POWER, reset, init, zqcal, idle, active, prech} sdram_state;

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

endmodule // command_generator
