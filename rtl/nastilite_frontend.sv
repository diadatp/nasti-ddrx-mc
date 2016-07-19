/**
* This module is responsible for managing NASTILite communications for the
* configuration registers. It is not capable of handling outstanding
* transactions. The module waits till write address and data are both
* available.
*/

`include "timescale.svh"

module nastilite_frontend #(
    C_NASTI_ADDR_WIDTH = 5 , // decides width of register addressing. +3 for 64 bit, +2 for 32 bit
    C_NASTI_DATA_WIDTH = 64  // width of data, must be either 32 or 64
) (
    // NASTILite interface
    input            s_nastilite_clk    ,
    input            s_nastilite_aresetn,
    nasti_if.slave   s_nastilite        ,
    // configuration register outputs
    config_if.master m_cfg
);

    localparam int I_ADDR_OFFSET = (C_NASTI_DATA_WIDTH/32) + 1;

    logic [C_NASTI_ADDR_WIDTH-(C_NASTI_DATA_WIDTH/32):0][C_NASTI_DATA_WIDTH-1:0] cfg_reg;

    logic [C_NASTI_ADDR_WIDTH-1:0] aw_addr;
    logic [C_NASTI_ADDR_WIDTH-1:0] ar_addr;

    // write address and data handshake
    // awvalid and rvalid assertion is used to latch the address after which
    // ready is asserted in the next clock cycle.
    always_ff @(posedge s_nastilite_clk) begin : proc_aw_w_handshake
        if(~s_nastilite_aresetn) begin
            s_nastilite.aw_ready <= 1'b0;
            s_nastilite.w_ready  <= 1'b0;
            aw_addr              <= 0;
        end else begin
            if(~s_nastilite.aw_ready && ~s_nastilite.w_ready && s_nastilite.aw_valid && s_nastilite.w_valid) begin
                s_nastilite.aw_ready <= 1'b1;
                s_nastilite.w_ready  <= 1'b1;
                aw_addr              <= s_nastilite.aw_addr;
            end else begin
                s_nastilite.aw_ready <= 1'b0;
                s_nastilite.w_ready  <= 1'b0;
                aw_addr              <= aw_addr;
            end
        end
    end

    // implement write transactions. This happens during the clock cycle that
    // ready is asserted
    always_ff @(posedge s_nastilite_clk) begin : proc_w_data
        if(~s_nastilite_aresetn) begin
            cfg_reg <= 0;
        end else begin
            // if all signals are asserted, accept the data into the registers. else keep them.
            if(s_nastilite.aw_ready && s_nastilite.w_ready && s_nastilite.aw_valid && s_nastilite.w_valid) begin
                for (int i = 0; i < (C_NASTI_DATA_WIDTH/8)-1; i++) begin
                    if(1'b1 == s_nastilite.w_strb[i]) begin
                        cfg_reg[aw_addr[C_NASTI_ADDR_WIDTH-1:I_ADDR_OFFSET]][(i*8)+:8] <= s_nastilite.w_data[(i*8)+:8];
                    end
                end
            end else begin
                cfg_reg <= cfg_reg;
            end
        end
    end

    // write response handshake
    always_ff @(posedge s_nastilite_clk) begin : proc_b_handshake
        if(~s_nastilite_aresetn) begin
            s_nastilite.b_valid <= 1'b0;
            s_nastilite.b_resp  <= 2'b00; // default response of OKAY. No error handling.
        end else begin
            s_nastilite.b_resp  <= 2'b00; // default response of OKAY. No error handling.
            if(~s_nastilite.b_valid && s_nastilite.aw_ready && s_nastilite.w_ready && s_nastilite.aw_valid && s_nastilite.w_valid) begin
                s_nastilite.b_valid <= 1'b1;
            end else begin
                // wait till bready is asserted before deasserting bvalid
                if(s_nastilite.b_valid && s_nastilite.b_ready) begin
                    s_nastilite.b_valid <= 1'b0;
                end
            end

        end
    end

    // read address handshake
    always_ff @(posedge s_nastilite_clk) begin : proc_ar_handshake
        if(~s_nastilite_aresetn) begin
            s_nastilite.ar_ready <= 1'b0;
            ar_addr              <= 0;
        end else begin
            if(~s_nastilite.ar_ready && s_nastilite.ar_valid) begin
                s_nastilite.ar_ready <= 1'b1;
                ar_addr              <= s_nastilite.ar_addr;
            end else begin
                s_nastilite.ar_ready <= 1'b0;
                ar_addr              <= 0;
            end
        end
    end

    // read response handshake
    always_ff @(posedge s_nastilite_clk) begin : proc_r_handshake
        if(~s_nastilite_aresetn) begin
            s_nastilite.r_valid <= 1'b0;
            s_nastilite.r_resp  <= 2'b00; // OKAY resp.
            s_nastilite.r_data  <= 0;
        end else begin
            s_nastilite.r_resp <= 2'b00; // OKAY resp.
            if(~s_nastilite.r_valid && s_nastilite.ar_valid && s_nastilite.ar_ready) begin
                s_nastilite.r_valid <= 1'b1;
                s_nastilite.r_data  <= cfg_reg[aw_addr[C_NASTI_ADDR_WIDTH-1:I_ADDR_OFFSET]];
            end else begin
                // wait till rready is asserted before deasserting bvalid
                if(s_nastilite.r_valid && s_nastilite.r_ready) begin
                    s_nastilite.r_valid <= 1'b0;
                    s_nastilite.r_data  <= 0;
                end
            end
        end
    end

    always_comb begin : proc_mapping
        m_cfg.msr0         = 13'b0_1001_0010_0000;
        m_cfg.msr1         = 13'b1_0000_0100_1100;
        m_cfg.msr2         = 13'b0_0000_0000_1000;
        m_cfg.msr3         = 13'b0_0000_0000_0000;
        m_cfg.tAL          = cfg_reg[0][0 +: 4];
        m_cfg.tBURST       = cfg_reg[0][1 +: 4];
        m_cfg.tCCD         = cfg_reg[0][2 +: 4];
        m_cfg.tCL          = cfg_reg[0][3 +: 4];
        m_cfg.tCMD         = cfg_reg[0][4 +: 4];
        m_cfg.tCWD         = cfg_reg[0][5 +: 4];
        m_cfg.tCWL         = cfg_reg[0][6 +: 4];
        m_cfg.tFAW         = cfg_reg[0][7 +: 4];
        m_cfg.tMOD         = '1;
        m_cfg.tMRD         = '0;
        m_cfg.tOST         = '1;
        m_cfg.tphy_rdcslat = '1;
        m_cfg.tphy_rdlat   = '1;
        m_cfg.tRAS         = '1;
        m_cfg.tRC          = '1;
        m_cfg.tRCD         = '1;
        m_cfg.trdata_en    = '1;
        m_cfg.tRFC         = '1;
        m_cfg.tRP          = '1;
        m_cfg.tRRD         = '1;
        m_cfg.tRTP         = '1;
        m_cfg.tRTRS        = '1;
        m_cfg.tWR          = '1;
        m_cfg.tWTR         = '1;
        m_cfg.tZQinit      = '1;
        m_cfg.tXPR         = '1;
    end

endmodule //nastilite_frontend
