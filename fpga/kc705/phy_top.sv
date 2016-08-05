/**
 * tctrl_delay = 7
 * tphy_rdlat = 8
 * tphy_wrdata = 0
 */

`include "timescale.svh"

module phy_top (
    // DDR PHY Interface
    input         dfi_clk    ,
    input         dfi_clk_90 ,
    input         dfi_clkdiv2,
    input         dfi_clkdiv4,
    input         dfi_arstn  ,
    dfi_if.slave  s_dfi      ,
    // DDR3 Interface
    inout  [63:0] ddr_dq     ,
    inout  [ 7:0] ddr_dqs_n  ,
    inout  [ 7:0] ddr_dqs_p  ,
    output [15:0] ddr_addr   ,
    output [ 2:0] ddr_ba     ,
    output        ddr_ras_n  ,
    output        ddr_cas_n  ,
    output        ddr_we_n   ,
    output        ddr_reset_n,
    output [ 1:0] ddr_ck_p   ,
    output [ 1:0] ddr_ck_n   ,
    output [ 1:0] ddr_cke    ,
    output [ 1:0] ddr_cs_n   ,
    output [ 7:0] ddr_dm     ,
    output [ 1:0] ddr_odt    ,
    input         clk_300mhz
);


    logic ck_oddr_ce;
    assign ck_oddr_ce = ~s_dfi.dfi_dram_clk_disable[0];

    logic ck_oddr_rst;
    logic io_fifo_rst;

    logic cmd_fifo_rden;
    logic cmd_fifo_wren;

    logic phy_oser_rst;
    logic phy_oser_oce;

    logic phy_iser_rst;

    logic [63:0][4:0] dq_odly_cntin ;
    logic [63:0][4:0] dq_odly_cntout;
    logic [63:0] dq_odly_ce ;
    logic [63:0] dq_odly_inc;
    logic [63:0] dq_odly_ld ;
    logic        dq_odly_rst;

    logic [63:0][4:0] dq_idly_cntin ;
    logic [63:0][4:0] dq_idly_cntout;
    logic [63:0] dq_idly_ce ;
    logic [63:0] dq_idly_inc;
    logic [63:0] dq_idly_ld ;
    logic        dq_idly_rst;

    logic dq_iobuf_dci;
    logic dq_iobuf_id ;
    logic dq_iobuf_t  ;

    logic dqs_oddr_rst;

    logic [7:0] dqs_iobuf_tm ;
    logic [7:0] dqs_iobuf_ts ;
    logic [7:0] dqs_iobuf_dci;
    logic [7:0] dqs_iobuf_id ;
    logic [7:0] dqs_iobuf_t  ;

    logic [7:0][4:0] dqs_idly_cntout_p;
    logic [7:0][4:0] dqs_idly_cntout_n;

    logic [7:0][4:0] dqs_idly_cntin;
    logic [7:0] dqs_idly_ce ;
    logic [7:0] dqs_idly_ld ;
    logic [7:0] dqs_idly_inc;
    logic       dqs_idly_rst;

    logic [7:0][4:0] dqs_odly_cntout;
    logic [7:0][4:0] dqs_odly_cntin;
    logic [7:0] dqs_odly_ce ;
    logic [7:0] dqs_odly_ld ;
    logic [7:0] dqs_odly_inc;
    logic       dqs_odly_rst;

    enum logic[5:0] {RESET, PHY_INIT, IDLE, RL_START, RL_WAIT, RL_DONE, WL_START, WL_WAIT, WL_DONE, XXXX = 'x} state, next;

    logic [15:0] counter     ;
    logic [15:0] counter_next;

    always_ff @(posedge dfi_clkdiv4 or negedge dfi_arstn) begin : proc_main_fsm_state
        if(~dfi_arstn) begin
            state   <= RESET;
            counter <= '0;
        end else begin
            state   <= next;
            counter <= counter_next;
        end
    end

    always_comb begin : proc_main_fsm_next
        next = XXXX;
        unique case (state)
            RESET : if(1'b1 == s_dfi.dfi_init_start) begin
                next         = PHY_INIT;
                counter_next = '0;
            end else begin
                next         = RESET;
                counter_next = '0;
            end
            PHY_INIT : if(10 == counter) begin
                next         = IDLE;
                counter_next = '0;
            end else begin
                next         = PHY_INIT;
                counter_next = counter + 1;
            end
            IDLE : if(1'b1 == s_dfi.dfi_rdlvl_en) begin
                next         = RL_START;
                counter_next = counter + 1;
            end else if(1'b1 == s_dfi.dfi_wrlvl_en) begin
                next         = WL_START;
                counter_next = counter + 1;
            end else begin
                next         = IDLE;
                counter_next = '0;
            end
            RL_START : if(400 == counter) begin
                next         = RL_WAIT;
                counter_next = '0;
            end else begin
                next         = RL_START;
                counter_next = counter + 1;
            end
            RL_WAIT : if(400 == counter) begin
                next         = RL_WAIT;
                counter_next = '0;
            end else begin
                next         = RL_START;
                counter_next = counter + 1;
            end
            RL_DONE : begin
                next = IDLE;
            end
            WL_START : if(400 == counter) begin
                next         = WL_WAIT;
                counter_next = '0;
            end else begin
                next         = WL_START;
                counter_next = counter + 1;
            end
            WL_WAIT : if(400 == counter) begin
                next         = WL_WAIT;
                counter_next = '0;
            end else begin
                next         = WL_START;
                counter_next = counter + 1;
            end
            WL_DONE : begin
                next = IDLE;
            end
        endcase
    end

    always_ff @(posedge dfi_clkdiv4 or negedge dfi_arstn) begin : proc_main_fsm_output
        if(~dfi_arstn) begin
            ck_oddr_rst                   <= '1;
            dq_odly_ce                    <= '1;
            dq_idly_ce                    <= '1;
            dq_odly_rst                   <= '1;
            dq_idly_rst                   <= '1;
            phy_iser_rst                   <= '1;
            dq_iobuf_t                    <= '1;
            dq_idly_cntin                 <= '0;
            dq_odly_cntin                 <= '0;
            dqs_idly_cntin                <= '0;
            dqs_odly_cntin                <= '0;
            dqs_iobuf_tm                  <= '1;
            dqs_iobuf_ts                  <= '1;
            dqs_iobuf_dci                 <= '1;
            dqs_iobuf_id                  <= '1;
            dqs_iobuf_t                   <= '1;
            io_fifo_rst                   <= '1;
            phy_oser_rst                  <= '1;
            phy_oser_oce                  <= '0;
            //
            cmd_fifo_rden <= '0;
            //
            s_dfi.dfi_rddata_valid        <= '0;
            s_dfi.dfi_ctrlupd_ack         <= '0;
            s_dfi.dfi_phyupd_req          <= '0;
            s_dfi.dfi_phyupd_type         <= '0;
            s_dfi.dfi_init_complete       <= '0;
            s_dfi.dfi_alert_n             <= '0;
            s_dfi.dfi_rdlvl_req           <= '0;
            s_dfi.dfi_phy_rdlvl_cs_n      <= '0;
            s_dfi.dfi_rdlvl_resp          <= '0;
            s_dfi.dfi_rdlvl_gate_req      <= '0;
            s_dfi.dfi_phy_rdlvl_gate_cs_n <= '0;
            s_dfi.dfi_wrlvl_req           <= '0;
            s_dfi.dfi_phy_wrlvl_cs_n      <= '0;
            s_dfi.dfi_wrlvl_resp          <= '0;
            s_dfi.dfi_phylvl_req_cs_n     <= '0;
            s_dfi.dfi_lp_ack              <= '0;
            s_dfi.dfi_error               <= '0;
            s_dfi.dfi_error_info          <= '0;
        end else begin
            unique case (next)
                PHY_INIT : begin
                    ck_oddr_rst   <= '0;
                    dq_odly_rst   <= 1'b0;
                    dq_idly_rst   <= 1'b0;
                    phy_iser_rst   <= 1'b0;
                    //
                    io_fifo_rst   <= 1'b0;
                    phy_oser_rst  <= '0;
                    cmd_fifo_rden <= 1'b1;
                    cmd_fifo_wren <= 1'b1;
                end
                IDLE : begin
                    ck_oddr_rst             <= '0;
                    s_dfi.dfi_init_complete <= '1;
                    phy_oser_oce            <= '1;
                end
            endcase
        end
    end

    generate
        for (genvar ddr_ck_i = 0; ddr_ck_i < 2; ddr_ck_i++) begin : gen_ck

            logic ddr_ck;

            ODDR #(
                .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
                .INIT        (1'b0           ), // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE      ("SYNC"         )  // Set/Reset type: "SYNC" or "ASYNC"
            ) ODDR_inst (
                .Q (ddr_ck     ), // 1-bit DDR output
                .C (dfi_clk    ), // 1-bit clock input
                .CE(ck_oddr_ce ), // 1-bit clock enable input
                .D1(1'b0       ), // 1-bit data input (positive edge)
                .D2(1'b1       ), // 1-bit data input (negative edge)
                .R (ck_oddr_rst), // 1-bit reset
                .S (1'b0       )  // 1-bit set
            );

            OBUFDS #(
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUFDS_inst (
                .O (ddr_ck_p[ddr_ck_i]), // Diff_p output (connect directly to top-level port)
                .OB(ddr_ck_n[ddr_ck_i]), // Diff_n output (connect directly to top-level port)
                .I (ddr_ck            )  // Buffer input
            );

        end
    endgenerate

    logic [15:0][3:0] addr_oser_d;
    logic [2:0][3:0] ba_oser_d;
    logic [3:0] ras_oser_d  ;
    logic [3:0] cas_oser_d  ;
    logic [3:0] we_oser_d   ;
    logic [3:0] reset_oser_d;
    logic [1:0][3:0] cke_oser_d;
    logic [1:0][3:0] cs_n_oser_d;
    logic [7:0][3:0] dm_oser_d ;
    logic [1:0][3:0] odt_oser_d;

    logic [39:0][3:0] cmd_fifo_q;
    logic [39:0][3:0] cmd_fifo_d;

    always_comb begin : proc_cmd_fifo
        addr_oser_d       = cmd_fifo_q[15:0];
        ba_oser_d         = cmd_fifo_q[18:16];
        ras_oser_d        = cmd_fifo_q[19];
        cas_oser_d        = cmd_fifo_q[20];
        we_oser_d         = cmd_fifo_q[21];
        reset_oser_d      = cmd_fifo_q[22];
        cke_oser_d        = cmd_fifo_q[24:23];
        cs_n_oser_d       = cmd_fifo_q[26:25];
        dm_oser_d         = cmd_fifo_q[34:27];
        odt_oser_d        = cmd_fifo_q[36:35];
        cmd_fifo_d[15:0]  = s_dfi.dfi_address;
        cmd_fifo_d[18:16] = s_dfi.dfi_bank;
        cmd_fifo_d[19]    = s_dfi.dfi_ras_n[0];
        cmd_fifo_d[20]    = s_dfi.dfi_cas_n[0];
        cmd_fifo_d[21]    = s_dfi.dfi_we_n[0];
        cmd_fifo_d[22]    = s_dfi.dfi_reset_n[0] | s_dfi.dfi_reset_n[1];
        cmd_fifo_d[24:23] = s_dfi.dfi_cke;
        cmd_fifo_d[26:25] = s_dfi.dfi_cs_n;
        cmd_fifo_d[34:27] = s_dfi.dfi_wrdata_mask;
        cmd_fifo_d[36:35] = s_dfi.dfi_odt;
    end

    logic [3:0] cmd_fifo_aemtry;
    logic [3:0] cmd_fifo_afull ;
    logic [3:0] cmd_fifo_empty ;
    logic [3:0] cmd_fifo_full  ;

    logic [39:0][7:0] cmd_mapped;

    generate

        for (genvar i = 0; i < 40; i++) begin
            assign cmd_mapped[i] = {{2{cmd_fifo_d[i][3]}},{2{cmd_fifo_d[i][2]}},{2{cmd_fifo_d[i][1]}},{2{cmd_fifo_d[i][0]}}};
        end

        for (genvar cmd_i = 0; cmd_i < 4; cmd_i++) begin : gen_cmd_fifo

            OUT_FIFO #(
                .ALMOST_EMPTY_VALUE(1                 ), // Almost empty offset (1-2)
                .ALMOST_FULL_VALUE (1                 ), // Almost full offset (1-2)
                .ARRAY_MODE        ("ARRAY_MODE_8_X_4"), // ARRAY_MODE_8_X_4, ARRAY_MODE_4_X_4
                .OUTPUT_DISABLE    ("FALSE"           ), // Disable output (FALSE, TRUE)
                .SYNCHRONOUS_MODE  ("FALSE"           )  // Must always be set to false.
            ) cmd_OUT_FIFO_inst (
                // FIFO Status Flags: 1-bit (each) output: Flags and other FIFO status outputs
                .ALMOSTEMPTY(cmd_fifo_aemtry[cmd_i]    ), // 1-bit output: Almost empty flag
                .ALMOSTFULL (cmd_fifo_afull[cmd_i]     ), // 1-bit output: Almost full flag
                .EMPTY      (cmd_fifo_empty[cmd_i]     ), // 1-bit output: Empty flag
                .FULL       (cmd_fifo_full[cmd_i]      ), // 1-bit output: Full flag
                // Q0-Q9: 4-bit (each) output: FIFO Outputs
                .Q0         (cmd_fifo_q[cmd_i * 10 + 0]), // 4-bit output: Channel 0 output bus
                .Q1         (cmd_fifo_q[cmd_i * 10 + 1]), // 4-bit output: Channel 1 output bus
                .Q2         (cmd_fifo_q[cmd_i * 10 + 2]), // 4-bit output: Channel 2 output bus
                .Q3         (cmd_fifo_q[cmd_i * 10 + 3]), // 4-bit output: Channel 3 output bus
                .Q4         (cmd_fifo_q[cmd_i * 10 + 4]), // 4-bit output: Channel 4 output bus
                .Q5         (cmd_fifo_q[cmd_i * 10 + 5]), // 8-bit output: Channel 5 output bus
                .Q6         (cmd_fifo_q[cmd_i * 10 + 6]), // 8-bit output: Channel 6 output bus
                .Q7         (cmd_fifo_q[cmd_i * 10 + 7]), // 4-bit output: Channel 7 output bus
                .Q8         (cmd_fifo_q[cmd_i * 10 + 8]), // 4-bit output: Channel 8 output bus
                .Q9         (cmd_fifo_q[cmd_i * 10 + 9]), // 4-bit output: Channel 9 output bus
                // D0-D9: 8-bit (each) input: FIFO inputs
                .D0         (cmd_mapped[cmd_i * 10 + 0]), // 8-bit input: Channel 0 input bus
                .D1         (cmd_mapped[cmd_i * 10 + 1]), // 8-bit input: Channel 1 input bus
                .D2         (cmd_mapped[cmd_i * 10 + 2]), // 8-bit input: Channel 2 input bus
                .D3         (cmd_mapped[cmd_i * 10 + 3]), // 8-bit input: Channel 3 input bus
                .D4         (cmd_mapped[cmd_i * 10 + 4]), // 8-bit input: Channel 4 input bus
                .D5         (cmd_mapped[cmd_i * 10 + 5]), // 8-bit input: Channel 5 input bus
                .D6         (cmd_mapped[cmd_i * 10 + 6]), // 8-bit input: Channel 6 input bus
                .D7         (cmd_mapped[cmd_i * 10 + 7]), // 8-bit input: Channel 7 input bus
                .D8         (cmd_mapped[cmd_i * 10 + 8]), // 8-bit input: Channel 8 input bus
                .D9         (cmd_mapped[cmd_i * 10 + 9]), // 8-bit input: Channel 9 input bus
                // FIFO Control Signals: 1-bit (each) input: Clocks, Resets and Enables
                .RDCLK      (dfi_clkdiv2               ), // 1-bit input: Read clock
                .RDEN       (cmd_fifo_rden             ), // 1-bit input: Read enable
                .RESET      (io_fifo_rst               ), // 1-bit input: Active high reset
                .WRCLK      (dfi_clkdiv4               ), // 1-bit input: Write clock
                .WREN       (cmd_fifo_wren             )  // 1-bit input: Write enable
            );

        end
    endgenerate

    generate
        for (genvar ba_i = 0; ba_i < 3; ba_i++) begin : gen_ba

            logic ba_oser_oq;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (                  ), // 1-bit output: Feedback path for data
                .OQ       (ba_oser_oq        ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                  ),
                .SHIFTOUT2(                  ),
                .TBYTEOUT (                  ), // 1-bit output: Byte group tristate
                .TFB      (                  ), // 1-bit output: 3-state control
                .TQ       (                  ), // 1-bit output: 3-state control
                .CLK      (dfi_clk           ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2       ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (ba_oser_d[ba_i][0]),
                .D2       (ba_oser_d[ba_i][1]),
                .D3       (ba_oser_d[ba_i][2]),
                .D4       (ba_oser_d[ba_i][3]),
                .D5       (                  ),
                .D6       (                  ),
                .D7       (                  ),
                .D8       (                  ),
                .OCE      (phy_oser_oce      ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst      ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                  ),
                .SHIFTIN2 (                  ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                  ),
                .T2       (                  ),
                .T3       (                  ),
                .T4       (                  ),
                .TBYTEIN  (                  ), // 1-bit input: Byte group tristate
                .TCE      (                  )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUF_inst (
                .O(ddr_ba[ba_i]), // Buffer output (connect directly to top-level port)
                .I(ba_oser_oq  )  // Buffer input
            );

        end
    endgenerate

    generate
        for (genvar addr_i = 0; addr_i < 16; addr_i++) begin : gen_addr

            logic addr_oser_oq;


            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (                      ), // 1-bit output: Feedback path for data
                .OQ       (addr_oser_oq          ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                      ),
                .SHIFTOUT2(                      ),
                .TBYTEOUT (                      ), // 1-bit output: Byte group tristate
                .TFB      (                      ), // 1-bit output: 3-state control
                .TQ       (                      ), // 1-bit output: 3-state control
                .CLK      (dfi_clk               ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2           ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (addr_oser_d[addr_i][0]),
                .D2       (addr_oser_d[addr_i][1]),
                .D3       (addr_oser_d[addr_i][2]),
                .D4       (addr_oser_d[addr_i][3]),
                .D5       (                      ),
                .D6       (                      ),
                .D7       (                      ),
                .D8       (                      ),
                .OCE      (phy_oser_oce          ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst          ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                      ),
                .SHIFTIN2 (                      ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                      ),
                .T2       (                      ),
                .T3       (                      ),
                .T4       (                      ),
                .TBYTEIN  (                      ), // 1-bit input: Byte group tristate
                .TCE      (                      )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUF_inst (
                .O(ddr_addr[addr_i]), // Buffer output (connect directly to top-level port)
                .I(addr_oser_oq    )  // Buffer input
            );

        end
    endgenerate

    logic ras_oser_oq;

    OSERDESE2 #(
        .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
        .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
        .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
        .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
    ) ras_OSERDESE2_inst (
        .OFB      (             ), // 1-bit output: Feedback path for data
        .OQ       (ras_oser_oq  ), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(             ),
        .SHIFTOUT2(             ),
        .TBYTEOUT (             ), // 1-bit output: Byte group tristate
        .TFB      (             ), // 1-bit output: 3-state control
        .TQ       (             ), // 1-bit output: 3-state control
        .CLK      (dfi_clk      ), // 1-bit input: High speed clock
        .CLKDIV   (dfi_clkdiv2  ), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1       (ras_oser_d[0]),
        .D2       (ras_oser_d[1]),
        .D3       (ras_oser_d[2]),
        .D4       (ras_oser_d[3]),
        .D5       (             ),
        .D6       (             ),
        .D7       (             ),
        .D8       (             ),
        .OCE      (phy_oser_oce ), // 1-bit input: Output data clock enable
        .RST      (phy_oser_rst ), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1 (             ),
        .SHIFTIN2 (             ),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1       (             ),
        .T2       (             ),
        .T3       (             ),
        .T4       (             ),
        .TBYTEIN  (             ), // 1-bit input: Byte group tristate
        .TCE      (             )  // 1-bit input: 3-state clock enable
    );

    OBUF #(
        .DRIVE     (12      ), // Specify the output drive strength
        .IOSTANDARD("SSTL15"), // Specify the output I/O standard
        .SLEW      ("FAST"  )  // Specify the output slew rate
    ) ras_OBUF_inst (
        .O(ddr_ras_n  ), // Buffer output (connect directly to top-level port)
        .I(ras_oser_oq)  // Buffer input
    );

    logic cas_oser_oq;

    OSERDESE2 #(
        .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
        .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
        .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
        .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
    ) cas_OSERDESE2_inst (
        .OFB      (             ), // 1-bit output: Feedback path for data
        .OQ       (cas_oser_oq  ), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(             ),
        .SHIFTOUT2(             ),
        .TBYTEOUT (             ), // 1-bit output: Byte group tristate
        .TFB      (             ), // 1-bit output: 3-state control
        .TQ       (             ), // 1-bit output: 3-state control
        .CLK      (dfi_clk      ), // 1-bit input: High speed clock
        .CLKDIV   (dfi_clkdiv2  ), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1       (cas_oser_d[0]),
        .D2       (cas_oser_d[1]),
        .D3       (cas_oser_d[2]),
        .D4       (cas_oser_d[3]),
        .D5       (             ),
        .D6       (             ),
        .D7       (             ),
        .D8       (             ),
        .OCE      (phy_oser_oce ), // 1-bit input: Output data clock enable
        .RST      (phy_oser_rst ), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1 (             ),
        .SHIFTIN2 (             ),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1       (             ),
        .T2       (             ),
        .T3       (             ),
        .T4       (             ),
        .TBYTEIN  (             ), // 1-bit input: Byte group tristate
        .TCE      (             )  // 1-bit input: 3-state clock enable
    );

    OBUF #(
        .DRIVE     (12      ), // Specify the output drive strength
        .IOSTANDARD("SSTL15"), // Specify the output I/O standard
        .SLEW      ("FAST"  )  // Specify the output slew rate
    ) cas_n_OBUF_inst (
        .O(ddr_cas_n  ), // Buffer output (connect directly to top-level port)
        .I(cas_oser_oq)  // Buffer input
    );

    logic we_oser_oq;

    OSERDESE2 #(
        .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
        .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
        .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
        .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
    ) we_OSERDESE2_inst (
        .OFB      (            ), // 1-bit output: Feedback path for data
        .OQ       (we_oser_oq  ), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(            ),
        .SHIFTOUT2(            ),
        .TBYTEOUT (            ), // 1-bit output: Byte group tristate
        .TFB      (            ), // 1-bit output: 3-state control
        .TQ       (            ), // 1-bit output: 3-state control
        .CLK      (dfi_clk     ), // 1-bit input: High speed clock
        .CLKDIV   (dfi_clkdiv2 ), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1       (we_oser_d[0]),
        .D2       (we_oser_d[1]),
        .D3       (we_oser_d[2]),
        .D4       (we_oser_d[3]),
        .D5       (            ),
        .D6       (            ),
        .D7       (            ),
        .D8       (            ),
        .OCE      (phy_oser_oce), // 1-bit input: Output data clock enable
        .RST      (phy_oser_rst), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1 (            ),
        .SHIFTIN2 (            ),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1       (            ),
        .T2       (            ),
        .T3       (            ),
        .T4       (            ),
        .TBYTEIN  (            ), // 1-bit input: Byte group tristate
        .TCE      (            )  // 1-bit input: 3-state clock enable
    );

    OBUF #(
        .DRIVE     (12      ), // Specify the output drive strength
        .IOSTANDARD("SSTL15"), // Specify the output I/O standard
        .SLEW      ("FAST"  )  // Specify the output slew rate
    ) we_n_OBUF_inst (
        .O(ddr_we_n  ), // Buffer output (connect directly to top-level port)
        .I(we_oser_oq)  // Buffer input
    );

    logic reset_oser_oq;

    OSERDESE2 #(
        .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
        .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
        .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
        .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
    ) reset_OSERDESE2_inst (
        .OFB      (               ), // 1-bit output: Feedback path for data
        .OQ       (reset_oser_oq  ), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(               ),
        .SHIFTOUT2(               ),
        .TBYTEOUT (               ), // 1-bit output: Byte group tristate
        .TFB      (               ), // 1-bit output: 3-state control
        .TQ       (               ), // 1-bit output: 3-state control
        .CLK      (dfi_clk        ), // 1-bit input: High speed clock
        .CLKDIV   (dfi_clkdiv2    ), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1       (reset_oser_d[0]),
        .D2       (reset_oser_d[1]),
        .D3       (reset_oser_d[2]),
        .D4       (reset_oser_d[3]),
        .D5       (               ),
        .D6       (               ),
        .D7       (               ),
        .D8       (               ),
        .OCE      (phy_oser_oce   ), // 1-bit input: Output data clock enable
        .RST      (phy_oser_rst   ), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1 (               ),
        .SHIFTIN2 (               ),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1       (               ),
        .T2       (               ),
        .T3       (               ),
        .T4       (               ),
        .TBYTEIN  (               ), // 1-bit input: Byte group tristate
        .TCE      (               )  // 1-bit input: 3-state clock enable
    );

    OBUF #(
        .DRIVE     (12      ), // Specify the output drive strength
        .IOSTANDARD("SSTL15"), // Specify the output I/O standard
        .SLEW      ("FAST"  )  // Specify the output slew rate
    ) reset_n_OBUF_inst (
        .O(ddr_reset_n  ), // Buffer output (connect directly to top-level port)
        .I(reset_oser_oq)  // Buffer input
    );

    generate
        for (genvar cke_i = 0; cke_i < 2; cke_i++) begin : gen_cke

            logic cke_oser_oq;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (                    ), // 1-bit output: Feedback path for data
                .OQ       (cke_oser_oq         ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                    ),
                .SHIFTOUT2(                    ),
                .TBYTEOUT (                    ), // 1-bit output: Byte group tristate
                .TFB      (                    ), // 1-bit output: 3-state control
                .TQ       (                    ), // 1-bit output: 3-state control
                .CLK      (dfi_clk             ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2         ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (cke_oser_d[cke_i][0]),
                .D2       (cke_oser_d[cke_i][1]),
                .D3       (cke_oser_d[cke_i][2]),
                .D4       (cke_oser_d[cke_i][3]),
                .D5       (                    ),
                .D6       (                    ),
                .D7       (                    ),
                .D8       (                    ),
                .OCE      (phy_oser_oce        ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst        ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                    ),
                .SHIFTIN2 (                    ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                    ),
                .T2       (                    ),
                .T3       (                    ),
                .T4       (                    ),
                .TBYTEIN  (                    ), // 1-bit input: Byte group tristate
                .TCE      (                    )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) cke_OBUF_inst (
                .O(ddr_cke[cke_i]), // Buffer output (connect directly to top-level port)
                .I(cke_oser_oq   )  // Buffer input
            );

        end
    endgenerate

    generate
        for (genvar cs_n_i = 0; cs_n_i < 2; cs_n_i++) begin : gen_cs_n

            logic cs_n_oser_oq;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (                      ), // 1-bit output: Feedback path for data
                .OQ       (cs_n_oser_oq          ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                      ),
                .SHIFTOUT2(                      ),
                .TBYTEOUT (                      ), // 1-bit output: Byte group tristate
                .TFB      (                      ), // 1-bit output: 3-state control
                .TQ       (                      ), // 1-bit output: 3-state control
                .CLK      (dfi_clk               ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2           ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (cs_n_oser_d[cs_n_i][0]),
                .D2       (cs_n_oser_d[cs_n_i][1]),
                .D3       (cs_n_oser_d[cs_n_i][2]),
                .D4       (cs_n_oser_d[cs_n_i][3]),
                .D5       (                      ),
                .D6       (                      ),
                .D7       (                      ),
                .D8       (                      ),
                .OCE      (phy_oser_oce          ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst          ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                      ),
                .SHIFTIN2 (                      ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                      ),
                .T2       (                      ),
                .T3       (                      ),
                .T4       (                      ),
                .TBYTEIN  (                      ), // 1-bit input: Byte group tristate
                .TCE      (                      )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUF_inst (
                .O(ddr_cs_n[cs_n_i]), // Buffer output (connect directly to top-level port)
                .I(cs_n_oser_oq    )  // Buffer input
            );

        end
    endgenerate

    generate
        for (genvar dm_i = 0; dm_i < 8; dm_i++) begin : gen_dm

            logic dm_oser_oq;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) dm_OSERDESE2_inst (
                .OFB      (                  ), // 1-bit output: Feedback path for data
                .OQ       (dm_oser_oq        ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                  ),
                .SHIFTOUT2(                  ),
                .TBYTEOUT (                  ), // 1-bit output: Byte group tristate
                .TFB      (                  ), // 1-bit output: 3-state control
                .TQ       (                  ), // 1-bit output: 3-state control
                .CLK      (dfi_clk           ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2       ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (dm_oser_d[dm_i][0]),
                .D2       (dm_oser_d[dm_i][1]),
                .D3       (dm_oser_d[dm_i][2]),
                .D4       (dm_oser_d[dm_i][3]),
                .D5       (                  ),
                .D6       (                  ),
                .D7       (                  ),
                .D8       (                  ),
                .OCE      (phy_oser_oce      ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst      ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                  ),
                .SHIFTIN2 (                  ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                  ),
                .T2       (                  ),
                .T3       (                  ),
                .T4       (                  ),
                .TBYTEIN  (                  ), // 1-bit input: Byte group tristate
                .TCE      (                  )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUF_inst (
                .O(ddr_dm[dm_i]), // Buffer output (connect directly to top-level port)
                .I(dm_oser_oq  )  // Buffer input
            );

        end
    endgenerate

    generate
        for (genvar odt_i = 0; odt_i < 2; odt_i++) begin : gen_odt

            logic odt_oser_oq;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (                    ), // 1-bit output: Feedback path for data
                .OQ       (odt_oser_oq         ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                    ),
                .SHIFTOUT2(                    ),
                .TBYTEOUT (                    ), // 1-bit output: Byte group tristate
                .TFB      (                    ), // 1-bit output: 3-state control
                .TQ       (                    ), // 1-bit output: 3-state control
                .CLK      (dfi_clk             ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2         ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (odt_oser_d[odt_i][0]),
                .D2       (odt_oser_d[odt_i][1]),
                .D3       (odt_oser_d[odt_i][2]),
                .D4       (odt_oser_d[odt_i][3]),
                .D5       (                    ),
                .D6       (                    ),
                .D7       (                    ),
                .D8       (                    ),
                .OCE      (phy_oser_oce        ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst        ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                    ),
                .SHIFTIN2 (                    ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                    ),
                .T2       (                    ),
                .T3       (                    ),
                .T4       (                    ),
                .TBYTEIN  (                    ), // 1-bit input: Byte group tristate
                .TCE      (                    )  // 1-bit input: 3-state clock enable
            );

            OBUF #(
                .DRIVE     (12      ), // Specify the output drive strength
                .IOSTANDARD("SSTL15"), // Specify the output I/O standard
                .SLEW      ("FAST"  )  // Specify the output slew rate
            ) OBUF_inst (
                .O(ddr_odt[odt_i]), // Buffer output (connect directly to top-level port)
                .I(odt_oser_oq   )  // Buffer input
            );

        end
    endgenerate

    (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

        IDELAYCTRL bank32_IDELAYCTRL_inst (
            .RDY   (bank32_idlyctrl_rdy), // 1-bit output: Ready output
            .REFCLK(clk_300mhz         ), // 1-bit input: Reference clock input
            .RST   (idlyctrl_rst       )  // 1-bit input: Active high reset input
        );

    (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

        IDELAYCTRL bank34_IDELAYCTRL_inst (
            .RDY   (bank34_idlyctrl_rdy), // 1-bit output: Ready output
            .REFCLK(clk_300mhz         ), // 1-bit input: Reference clock input
            .RST   (idlyctrl_rst       )  // 1-bit input: Active high reset input
        );

    logic [7:0] in_fifo_aempty;
    logic [7:0] in_fifo_afull ;
    logic [7:0] in_fifo_empty ;
    logic [7:0] in_fifo_full  ;

    logic [7:0] out_fifo_aempty;
    logic [7:0] out_fifo_afull ;
    logic [7:0] out_fifo_empty ;
    logic [7:0] out_fifo_full  ;

    logic in_fifo_rden ;
    logic out_fifo_rden;

    logic [7:0][7:0][3:0] out_fifo_q;

    logic [63:0][3:0] dq_iser_q;

    logic [7:0] dqs_bufio_p;
    logic [7:0] dqs_bufio_n;

    generate
        for (genvar io_fifo_i = 0; io_fifo_i < 8; io_fifo_i++) begin : gen_dq_io_fifo

            OUT_FIFO #(
                .ALMOST_EMPTY_VALUE(1                 ), // Almost empty offset (1-2)
                .ALMOST_FULL_VALUE (1                 ), // Almost full offset (1-2)
                .ARRAY_MODE        ("ARRAY_MODE_8_X_4"), // ARRAY_MODE_8_X_4, ARRAY_MODE_4_X_4
                .OUTPUT_DISABLE    ("FALSE"           ), // Disable output (FALSE, TRUE)
                .SYNCHRONOUS_MODE  ("FALSE"           )  // Must always be set to false.
            ) OUT_FIFO_inst (
                // FIFO Status Flags: 1-bit (each) output: Flags and other FIFO status outputs
                .ALMOSTEMPTY(out_fifo_aempty[io_fifo_i]                                                 ), // 1-bit output: Almost empty flag
                .ALMOSTFULL (out_fifo_afull[io_fifo_i]                                                  ), // 1-bit output: Almost full flag
                .EMPTY      (out_fifo_empty[io_fifo_i]                                                  ), // 1-bit output: Empty flag
                .FULL       (out_fifo_full[io_fifo_i]                                                   ), // 1-bit output: Full flag
                // Q0-Q9: 4-bit (each) output: FIFO Outputs
                .Q0         (out_fifo_q[io_fifo_i][0]                                                   ), // 4-bit output: Channel 0 output bus
                .Q1         (out_fifo_q[io_fifo_i][1]                                                   ), // 4-bit output: Channel 1 output bus
                .Q2         (out_fifo_q[io_fifo_i][2]                                                   ), // 4-bit output: Channel 2 output bus
                .Q3         (out_fifo_q[io_fifo_i][3]                                                   ), // 4-bit output: Channel 3 output bus
                .Q4         (out_fifo_q[io_fifo_i][4]                                                   ), // 4-bit output: Channel 4 output bus
                .Q5         (out_fifo_q[io_fifo_i][5]                                                   ), // 8-bit output: Channel 5 output bus
                .Q6         (out_fifo_q[io_fifo_i][6]                                                   ), // 8-bit output: Channel 6 output bus
                .Q7         (out_fifo_q[io_fifo_i][7]                                                   ), // 4-bit output: Channel 7 output bus
                .Q8         (                                                                           ), // 4-bit output: Channel 8 output bus
                .Q9         (                                                                           ), // 4-bit output: Channel 9 output bus
                // D0-D9: 8-bit (each) input: FIFO inputs
                .D0         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 0], s_dfi.dfi_wrdata[8 * io_fifo_i + 64]}), // 8-bit input: Channel 0 input bus
                .D1         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 1], s_dfi.dfi_wrdata[8 * io_fifo_i + 65]}), // 8-bit input: Channel 1 input bus
                .D2         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 2], s_dfi.dfi_wrdata[8 * io_fifo_i + 66]}), // 8-bit input: Channel 2 input bus
                .D3         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 3], s_dfi.dfi_wrdata[8 * io_fifo_i + 67]}), // 8-bit input: Channel 3 input bus
                .D4         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 4], s_dfi.dfi_wrdata[8 * io_fifo_i + 68]}), // 8-bit input: Channel 4 input bus
                .D5         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 5], s_dfi.dfi_wrdata[8 * io_fifo_i + 69]}), // 8-bit input: Channel 5 input bus
                .D6         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 6], s_dfi.dfi_wrdata[8 * io_fifo_i + 70]}), // 8-bit input: Channel 6 input bus
                .D7         ({s_dfi.dfi_wrdata[8 * io_fifo_i + 7], s_dfi.dfi_wrdata[8 * io_fifo_i + 71]}), // 8-bit input: Channel 7 input bus
                .D8         (                                                                           ), // 8-bit input: Channel 8 input bus
                .D9         (                                                                           ), // 8-bit input: Channel 9 input bus
                // FIFO Control Signals: 1-bit (each) input: Clocks, Resets and Enables
                .RDCLK      (dfi_clkdiv2                                                                ), // 1-bit input: Read clock
                .RDEN       (io_fifo_rden                                                               ), // 1-bit input: Read enable
                .RESET      (io_fifo_rst                                                                ), // 1-bit input: Active high reset
                .WRCLK      (dfi_clkdiv4                                                                ), // 1-bit input: Write clock
                .WREN       (io_fifo_wren                                                               )  // 1-bit input: Write enable
            );

            IN_FIFO #(
                .ALMOST_EMPTY_VALUE(1                 ), // Almost empty offset (1-2)
                .ALMOST_FULL_VALUE (1                 ), // Almost full offset (1-2)
                .ARRAY_MODE        ("ARRAY_MODE_4_X_8"), // ARRAY_MODE_4_X_8, ARRAY_MODE_4_X_4
                .SYNCHRONOUS_MODE  ("FALSE"           )  // Clock synchronous (FALSE)
            ) IN_FIFO_inst (
                // FIFO Status Flags: 1-bit (each) output: Flags and other FIFO status outputs
                .ALMOSTEMPTY(in_fifo_aempty[io_fifo_i]                                                  ), // 1-bit output: Almost empty
                .ALMOSTFULL (in_fifo_afull[io_fifo_i]                                                   ), // 1-bit output: Almost full
                .EMPTY      (in_fifo_empty[io_fifo_i]                                                   ), // 1-bit output: Empty
                .FULL       (in_fifo_full[io_fifo_i]                                                    ), // 1-bit output: Full
                // Q0-Q9: 8-bit (each) output: FIFO Outputs
                .Q0         ({s_dfi.dfi_rddata[8 * io_fifo_i + 0], s_dfi.dfi_rddata[8 * io_fifo_i + 64]}), // 8-bit output: Channel 0
                .Q1         ({s_dfi.dfi_rddata[8 * io_fifo_i + 1], s_dfi.dfi_rddata[8 * io_fifo_i + 65]}), // 8-bit output: Channel 1
                .Q2         ({s_dfi.dfi_rddata[8 * io_fifo_i + 2], s_dfi.dfi_rddata[8 * io_fifo_i + 66]}), // 8-bit output: Channel 2
                .Q3         ({s_dfi.dfi_rddata[8 * io_fifo_i + 3], s_dfi.dfi_rddata[8 * io_fifo_i + 67]}), // 8-bit output: Channel 3
                .Q4         ({s_dfi.dfi_rddata[8 * io_fifo_i + 4], s_dfi.dfi_rddata[8 * io_fifo_i + 68]}), // 8-bit output: Channel 4
                .Q5         ({s_dfi.dfi_rddata[8 * io_fifo_i + 5], s_dfi.dfi_rddata[8 * io_fifo_i + 69]}), // 8-bit output: Channel 5
                .Q6         ({s_dfi.dfi_rddata[8 * io_fifo_i + 6], s_dfi.dfi_rddata[8 * io_fifo_i + 70]}), // 8-bit output: Channel 6
                .Q7         ({s_dfi.dfi_rddata[8 * io_fifo_i + 7], s_dfi.dfi_rddata[8 * io_fifo_i + 71]}), // 8-bit output: Channel 7
                .Q8         (                                                                           ), // 8-bit output: Channel 8
                .Q9         (                                                                           ), // 8-bit output: Channel 9
                // D0-D9: 4-bit (each) input: FIFO inputs
                .D0         (dq_iser_q[8 * io_fifo_i + 0]                                               ), // 4-bit input: Channel 0
                .D1         (dq_iser_q[8 * io_fifo_i + 1]                                               ), // 4-bit input: Channel 1
                .D2         (dq_iser_q[8 * io_fifo_i + 2]                                               ), // 4-bit input: Channel 2
                .D3         (dq_iser_q[8 * io_fifo_i + 3]                                               ), // 4-bit input: Channel 3
                .D4         (dq_iser_q[8 * io_fifo_i + 4]                                               ), // 4-bit input: Channel 4
                .D5         (dq_iser_q[8 * io_fifo_i + 5]                                               ), // 8-bit input: Channel 5
                .D6         (dq_iser_q[8 * io_fifo_i + 6]                                               ), // 8-bit input: Channel 6
                .D7         (dq_iser_q[8 * io_fifo_i + 7]                                               ), // 4-bit input: Channel 7
                .D8         (                                                                           ), // 4-bit input: Channel 8
                .D9         (                                                                           ), // 4-bit input: Channel 9
                // FIFO Control Signals: 1-bit (each) input: Clocks, Resets and Enables
                .RDCLK      (dfi_clkdiv2                                                                ), // 1-bit input: Read clock
                .RDEN       (io_fifo_rden                                                               ), // 1-bit input: Read enable
                .RESET      (io_fifo_rst                                                                ), // 1-bit input: Reset
                .WRCLK      (dfi_clkdiv4                                                                ), // 1-bit input: Write clock
                .WREN       (io_fifo_wren                                                               )  // 1-bit input: Write enable
            );

        end
    endgenerate

    generate
        for (genvar dq_i = 0; dq_i < 32; dq_i++) begin : gen_dq_32

            logic dq_oser_ofb;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (dq_oser_ofb                  ), // 1-bit output: Feedback path for data
                .OQ       (                             ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                             ),
                .SHIFTOUT2(                             ),
                .TBYTEOUT (                             ), // 1-bit output: Byte group tristate
                .TFB      (                             ), // 1-bit output: 3-state control
                .TQ       (                             ), // 1-bit output: 3-state control
                .CLK      (dfi_clk                      ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2                  ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (out_fifo_q[dq_i/8][dq_i%8][0]),
                .D2       (out_fifo_q[dq_i/8][dq_i%8][1]),
                .D3       (out_fifo_q[dq_i/8][dq_i%8][2]),
                .D4       (out_fifo_q[dq_i/8][dq_i%8][3]),
                .D5       (                             ),
                .D6       (                             ),
                .D7       (                             ),
                .D8       (                             ),
                .OCE      (phy_oser_oce                 ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst                  ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                             ),
                .SHIFTIN2 (                             ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                             ),
                .T2       (                             ),
                .T3       (                             ),
                .T4       (                             ),
                .TBYTEIN  (                             ), // 1-bit input: Byte group tristate
                .TCE      (                             )  // 1-bit input: 3-state clock enable
            );

            logic dq_delayed;

            (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                ODELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("ODATAIN" ), // Delay input (ODATAIN, CLKIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .ODELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .ODELAY_VALUE         (0         ), // Output delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) ODELAYE2_inst (
                    .CNTVALUEOUT(dq_odly_cntout[dq_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dq_delayed          ), // 1-bit output: Delayed data/clock output
                    .C          (dfi_clkdiv4         ), // 1-bit input: Clock input
                    .CE         (dq_odly_ce[dq_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                ), // 1-bit input: Dynamic clock inversion input
                    .CLKIN      (1'b0                ), // 1-bit input: Clock delay input
                    .CNTVALUEIN (dq_odly_cntin[dq_i] ), // 5-bit input: Counter value input
                    .INC        (dq_odly_inc[dq_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dq_odly_ld[dq_i]    ), // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN
                    .LDPIPEEN   (1'b0                ), // 1-bit input: Enables the pipeline register to load data
                    .ODATAIN    (dq_oser_ofb         ), // 1-bit input: Output delay data input
                    .REGRST     (dq_odly_rst         )  // 1-bit input: Active-high reset tap-delay input
                );

            logic dq_in;

            IOBUF_DCIEN #(
                .DRIVE          (12            ), // Specify the output drive strength
                .IBUF_LOW_PWR   ("TRUE"        ), // Low Power - "TRUE", High Performance = "FALSE"
                .IOSTANDARD     ("SSTL15_T_DCI"), // Specify the I/O standard
                .SLEW           ("FAST"        ), // Specify the output slew rate
                .USE_IBUFDISABLE("TRUE"        )  // Use IBUFDISABLE function, "TRUE" or "FALSE"
            ) IOBUF_DCIEN_inst (
                .O             (dq_in       ), // Buffer output
                .IO            (ddr_dq[dq_i]), // Buffer inout port (connect directly to top-level port)
                .DCITERMDISABLE(dq_iobuf_dci), // DCI Termination enable input
                .I             (dq_delayed  ), // Buffer input
                .IBUFDISABLE   (dq_iobuf_id ), // Input disable input, low=disable
                .T             (dq_iobuf_t  )  // 3-state enable input, high=input, low=output
            );

            logic dq_in_delayed;

            (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst (
                    .CNTVALUEOUT(dq_idly_cntout[dq_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dq_in_delayed       ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4         ), // 1-bit input: Clock input
                    .CE         (dq_idly_ce[dq_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dq_idly_cntin[dq_i] ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dq_in               ), // 1-bit input: Data input from the I/O
                    .INC        (dq_idly_inc[dq_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dq_idly_ld[dq_i]    ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dq_idly_rst         )  // 1-bit input: Active-high reset tap-delay input
                );

            ISERDESE2 #(
                .DATA_RATE        ("DDR"   ), // DDR, SDR
                .DATA_WIDTH       (4       ), // Parallel data width (2-8,10,14)
                .DYN_CLKDIV_INV_EN("FALSE" ), // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
                .DYN_CLK_INV_EN   ("FALSE" ), // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
                // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
                .INIT_Q1          (1'b0    ),
                .INIT_Q2          (1'b0    ),
                .INIT_Q3          (1'b0    ),
                .INIT_Q4          (1'b0    ),
                .INTERFACE_TYPE   ("MEMORY"), // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
                .IOBDELAY         ("BOTH"  ), // NONE, BOTH, IBUF, IFD
                .NUM_CE           (2       ), // Number of clock enables (1,2)
                .OFB_USED         ("FALSE" ), // Select OFB path (FALSE, TRUE)
                .SERDES_MODE      ("MASTER"), // MASTER, SLAVE
                // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
                .SRVAL_Q1         (1'b0    ),
                .SRVAL_Q2         (1'b0    ),
                .SRVAL_Q3         (1'b0    ),
                .SRVAL_Q4         (1'b0    )
            ) ISERDESE2_inst (
                .O           (                    ), // 1-bit output: Combinatorial output
                // Q1 - Q8: 1-bit (each) output: Registered data outputs
                .Q1          (dq_iser_q[dq_i][0]  ),
                .Q2          (dq_iser_q[dq_i][1]  ),
                .Q3          (dq_iser_q[dq_i][2]  ),
                .Q4          (dq_iser_q[dq_i][3]  ),
                .Q5          (                    ),
                .Q6          (                    ),
                .Q7          (                    ),
                .Q8          (                    ),
                // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
                .SHIFTOUT1   (                    ),
                .SHIFTOUT2   (                    ),
                .BITSLIP     (1'b0                ), // 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                // CLKDIV when asserted (active High). Subsequently, the data seen on the Q1
                // to Q8 output ports will shift, as in a barrel-shifter operation, one
                // position every time Bitslip is invoked (DDR operation is different from
                // SDR).

                // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
                .CE1         (1'b1                ),
                .CE2         (1'b1                ),
                .CLKDIVP     (                    ), // 1-bit input: TBD
                // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
                .CLK         (dqs_bufio_p[dq_i/8] ), // 1-bit input: High-speed clock
                .CLKB        (~dqs_bufio_p[dq_i/8]), // 1-bit input: High-speed secondary clock
                .CLKDIV      (dfi_clkdiv2         ), // 1-bit input: Divided clock
                .OCLK        (dfi_clk             ), // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
                // Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
                .DYNCLKDIVSEL(                    ), // 1-bit input: Dynamic CLKDIV inversion
                .DYNCLKSEL   (                    ), // 1-bit input: Dynamic CLK/CLKB inversion
                // Input Data: 1-bit (each) input: ISERDESE2 data input ports
                .D           (1'b0                ), // 1-bit input: Data input
                .DDLY        (dq_in_delayed       ), // 1-bit input: Serial data from IDELAYE2
                .OFB         (                    ), // 1-bit input: Data feedback from OSERDESE2
                .OCLKB       (                    ), // 1-bit input: High speed negative edge output clock
                .RST         (phy_iser_rst         ), // 1-bit input: Active high asynchronous reset
                // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
                .SHIFTIN1    (                    ),
                .SHIFTIN2    (                    )
            );

        end
    endgenerate

    generate
        for (genvar dq_i = 32; dq_i < 64; dq_i++) begin : gen_dq_34

            logic dq_oser_ofb;

            OSERDESE2 #(
                .DATA_RATE_OQ  ("DDR"   ), // DDR, SDR
                .DATA_RATE_TQ  ("DDR"   ), // DDR, BUF, SDR
                .DATA_WIDTH    (4       ), // Parallel data width (2-8,10,14)
                .INIT_OQ       (1'b0    ), // Initial value of OQ output (1'b0,1'b1)
                .INIT_TQ       (1'b0    ), // Initial value of TQ output (1'b0,1'b1)
                .SERDES_MODE   ("MASTER"), // MASTER, SLAVE
                .SRVAL_OQ      (1'b0    ), // OQ output value when SR is used (1'b0,1'b1)
                .SRVAL_TQ      (1'b0    ), // TQ output value when SR is used (1'b0,1'b1)
                .TBYTE_CTL     ("FALSE" ), // Enable tristate byte operation (FALSE, TRUE)
                .TBYTE_SRC     ("FALSE" ), // Tristate byte source (FALSE, TRUE)
                .TRISTATE_WIDTH(4       )  // 3-state converter width (1,4)
            ) OSERDESE2_inst (
                .OFB      (dq_oser_ofb                  ), // 1-bit output: Feedback path for data
                .OQ       (                             ), // 1-bit output: Data path output
                // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
                .SHIFTOUT1(                             ),
                .SHIFTOUT2(                             ),
                .TBYTEOUT (                             ), // 1-bit output: Byte group tristate
                .TFB      (                             ), // 1-bit output: 3-state control
                .TQ       (                             ), // 1-bit output: 3-state control
                .CLK      (dfi_clk                      ), // 1-bit input: High speed clock
                .CLKDIV   (dfi_clkdiv2                  ), // 1-bit input: Divided clock
                // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
                .D1       (out_fifo_q[dq_i/8][dq_i%8][0]),
                .D2       (out_fifo_q[dq_i/8][dq_i%8][1]),
                .D3       (out_fifo_q[dq_i/8][dq_i%8][2]),
                .D4       (out_fifo_q[dq_i/8][dq_i%8][3]),
                .D5       (                             ),
                .D6       (                             ),
                .D7       (                             ),
                .D8       (                             ),
                .OCE      (phy_oser_oce                 ), // 1-bit input: Output data clock enable
                .RST      (phy_oser_rst                  ), // 1-bit input: Reset
                // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
                .SHIFTIN1 (                             ),
                .SHIFTIN2 (                             ),
                // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
                .T1       (                             ),
                .T2       (                             ),
                .T3       (                             ),
                .T4       (                             ),
                .TBYTEIN  (                             ), // 1-bit input: Byte group tristate
                .TCE      (                             )  // 1-bit input: 3-state clock enable
            );

            logic dq_delayed;

            (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                ODELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("ODATAIN" ), // Delay input (ODATAIN, CLKIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .ODELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .ODELAY_VALUE         (0         ), // Output delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) ODELAYE2_inst (
                    .CNTVALUEOUT(dq_odly_cntout[dq_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dq_delayed          ), // 1-bit output: Delayed data/clock output
                    .C          (dfi_clkdiv4         ), // 1-bit input: Clock input
                    .CE         (dq_odly_ce[dq_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                ), // 1-bit input: Dynamic clock inversion input
                    .CLKIN      (1'b0                ), // 1-bit input: Clock delay input
                    .CNTVALUEIN (dq_odly_cntin[dq_i] ), // 5-bit input: Counter value input
                    .INC        (dq_odly_inc[dq_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dq_odly_ld[dq_i]    ), // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN
                    .LDPIPEEN   (1'b0                ), // 1-bit input: Enables the pipeline register to load data
                    .ODATAIN    (dq_oser_ofb         ), // 1-bit input: Output delay data input
                    .REGRST     (dq_odly_rst         )  // 1-bit input: Active-high reset tap-delay input
                );

            logic dq_in;

            IOBUF_DCIEN #(
                .DRIVE          (12            ), // Specify the output drive strength
                .IBUF_LOW_PWR   ("TRUE"        ), // Low Power - "TRUE", High Performance = "FALSE"
                .IOSTANDARD     ("SSTL15_T_DCI"), // Specify the I/O standard
                .SLEW           ("FAST"        ), // Specify the output slew rate
                .USE_IBUFDISABLE("TRUE"        )  // Use IBUFDISABLE function, "TRUE" or "FALSE"
            ) IOBUF_DCIEN_inst (
                .O             (dq_in       ), // Buffer output
                .IO            (ddr_dq[dq_i]), // Buffer inout port (connect directly to top-level port)
                .DCITERMDISABLE(dq_iobuf_dci), // DCI Termination enable input
                .I             (dq_delayed  ), // Buffer input
                .IBUFDISABLE   (dq_iobuf_id ), // Input disable input, low=disable
                .T             (dq_iobuf_t  )  // 3-state enable input, high=input, low=output
            );

            logic dq_in_delayed;

            (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst (
                    .CNTVALUEOUT(dq_idly_cntout[dq_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dq_in_delayed       ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4         ), // 1-bit input: Clock input
                    .CE         (dq_idly_ce[dq_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dq_idly_cntin[dq_i] ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dq_in               ), // 1-bit input: Data input from the I/O
                    .INC        (dq_idly_inc[dq_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dq_idly_ld[dq_i]    ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dq_idly_rst         )  // 1-bit input: Active-high reset tap-delay input
                );

            ISERDESE2 #(
                .DATA_RATE        ("DDR"   ), // DDR, SDR
                .DATA_WIDTH       (4       ), // Parallel data width (2-8,10,14)
                .DYN_CLKDIV_INV_EN("FALSE" ), // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
                .DYN_CLK_INV_EN   ("FALSE" ), // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
                // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
                .INIT_Q1          (1'b0    ),
                .INIT_Q2          (1'b0    ),
                .INIT_Q3          (1'b0    ),
                .INIT_Q4          (1'b0    ),
                .INTERFACE_TYPE   ("MEMORY"), // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
                .IOBDELAY         ("BOTH"  ), // NONE, BOTH, IBUF, IFD
                .NUM_CE           (2       ), // Number of clock enables (1,2)
                .OFB_USED         ("FALSE" ), // Select OFB path (FALSE, TRUE)
                .SERDES_MODE      ("MASTER"), // MASTER, SLAVE
                // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
                .SRVAL_Q1         (1'b0    ),
                .SRVAL_Q2         (1'b0    ),
                .SRVAL_Q3         (1'b0    ),
                .SRVAL_Q4         (1'b0    )
            ) ISERDESE2_inst (
                .O           (                   ), // 1-bit output: Combinatorial output
                // Q1 - Q8: 1-bit (each) output: Registered data outputs
                .Q1          (dq_iser_q[dq_i][0] ),
                .Q2          (dq_iser_q[dq_i][1] ),
                .Q3          (dq_iser_q[dq_i][2] ),
                .Q4          (dq_iser_q[dq_i][3] ),
                .Q5          (                   ),
                .Q6          (                   ),
                .Q7          (                   ),
                .Q8          (                   ),
                // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
                .SHIFTOUT1   (                   ),
                .SHIFTOUT2   (                   ),
                .BITSLIP     (1'b0               ), // 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                // CLKDIV when asserted (active High). Subsequently, the data seen on the Q1
                // to Q8 output ports will shift, as in a barrel-shifter operation, one
                // position every time Bitslip is invoked (DDR operation is different from
                // SDR).

                // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
                .CE1         (1'b1               ),
                .CE2         (1'b1               ),
                .CLKDIVP     (                   ), // 1-bit input: TBD
                // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
                .CLK         (dqs_bufio_p[dq_i/8]), // 1-bit input: High-speed clock
                .CLKB        (dqs_bufio_n[dq_i/8]), // 1-bit input: High-speed secondary clock
                .CLKDIV      (dfi_clkdiv2        ), // 1-bit input: Divided clock
                .OCLK        (dfi_clk            ), // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
                // Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
                .DYNCLKDIVSEL(                   ), // 1-bit input: Dynamic CLKDIV inversion
                .DYNCLKSEL   (                   ), // 1-bit input: Dynamic CLK/CLKB inversion
                // Input Data: 1-bit (each) input: ISERDESE2 data input ports
                .D           (1'b0               ), // 1-bit input: Data input
                .DDLY        (dq_in_delayed      ), // 1-bit input: Serial data from IDELAYE2
                .OFB         (                   ), // 1-bit input: Data feedback from OSERDESE2
                .OCLKB       (                   ), // 1-bit input: High speed negative edge output clock
                .RST         (phy_iser_rst        ), // 1-bit input: Active high asynchronous reset
                // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
                .SHIFTIN1    (                   ),
                .SHIFTIN2    (                   )
            );

        end
    endgenerate

    generate
        for (genvar dqs_i = 0; dqs_i < 4; dqs_i++) begin : gen_dqs_32

            logic dqs_oddr        ;
            logic dqs_out_delayed ;
            logic dqs_in_delayed_p;
            logic dqs_in_delayed_n;
            logic dqs_in_p        ;
            logic dqs_in_n        ;

            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
                .INIT        (1'b0       ), // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE      ("SYNC"     )  // Set/Reset type: "SYNC" or "ASYNC"
            ) ODDR_inst (
                .Q (dqs_oddr    ), // 1-bit DDR output
                .C (dfi_clk_90  ), // 1-bit clock input
                .CE(1'b1        ), // 1-bit clock enable input
                .D1(1'b1        ), // 1-bit data input (positive edge)
                .D2(1'b0        ), // 1-bit data input (negative edge)
                .R (dqs_oddr_rst), // 1-bit reset
                .S (1'b0        )  // 1-bit set
            );

            (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                ODELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("ODATAIN" ), // Delay input (ODATAIN, CLKIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .ODELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .ODELAY_VALUE         (0         ), // Output delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) ODELAYE2_inst (
                    .CNTVALUEOUT(dqs_odly_cntout[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_out_delayed           ), // 1-bit output: Delayed data/clock output
                    .C          (dfi_clkdiv4           ), // 1-bit input: Clock input
                    .CE         (dqs_odly_ce[dqs_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                  ), // 1-bit input: Dynamic clock inversion input
                    .CLKIN      (1'b0                  ), // 1-bit input: Clock delay input
                    .CNTVALUEIN (dqs_odly_cntin[dqs_i] ), // 5-bit input: Counter value input
                    .INC        (dqs_odly_inc[dqs_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_odly_ld[dqs_i]    ), // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN
                    .LDPIPEEN   (1'b0                  ), // 1-bit input: Enables the pipeline register to load data
                    .ODATAIN    (dqs_oddr              ), // 1-bit input: Output delay data input
                    .REGRST     (dqs_odly_rst          )  // 1-bit input: Active-high reset tap-delay input
                );

            IOBUFDS_DCIEN #(
                .DIFF_TERM      ("FALSE"            ), // Differential Termination ("TRUE"/"FALSE")
                .IBUF_LOW_PWR   ("TRUE"             ), // Low Power - "TRUE", High Performance = "FALSE"
                .IOSTANDARD     ("DIFF_SSTL15_T_DCI"), // Specify the I/O standard
                .SLEW           ("FAST"             ), // Specify the output slew rate
                .USE_IBUFDISABLE("TRUE"             )  // Use IBUFDISABLE function, "TRUE" or "FALSE"
            ) IOBUFDS_DCIEN_inst (
                .O             (dqs_in_p            ), // Buffer output
                .IO            (ddr_dqs_p[dqs_i]    ), // Diff_p inout (connect directly to top-level port)
                .IOB           (ddr_dqs_n[dqs_i]    ), // Diff_n inout (connect directly to top-level port)
                .DCITERMDISABLE(dqs_iobuf_dci[dqs_i]), // DCI Termination enable input
                .I             (dqs_out_delayed         ), // Buffer input
                .IBUFDISABLE   (dqs_iobuf_id[dqs_i] ), // Input disable input, low=disable
                .T             (dqs_iobuf_ts[dqs_i] )  // 3-state enable input, high=input, low=output
            );

            // IOBUFDS_DIFF_OUT_DCIEN #(
            //     .DIFF_TERM      ("FALSE"            ), // Differential Termination ("TRUE"/"FALSE")
            //     .IBUF_LOW_PWR   ("FALSE"            ), // Low Power - "TRUE", High Performance = "FALSE"
            //     .IOSTANDARD     ("DIFF_SSTL15_T_DCI"), // Specify the I/O standard
            //     .USE_IBUFDISABLE("TRUE"             )  // Use IBUFDISABLE function, "TRUE" or "FALSE"
            // ) IOBUFDS_DIFF_OUT_DCIEN_inst (
            //     .O             (dqs_in_p            ), // Buffer p-side output
            //     .OB            (dqs_in_n            ), // Buffer n-side output
            //     .IO            (ddr_dqs_p[dqs_i]    ), // Diff_p inout (connect directly to top-level port)
            //     .IOB           (ddr_dqs_n[dqs_i]    ), // Diff_n inout (connect directly to top-level port)
            //     .DCITERMDISABLE(dqs_iobuf_dci[dqs_i]), // DCI Termination enable input
            //     .I             (dqs_out_delayed         ), // Buffer input
            //     .IBUFDISABLE   (dqs_iobuf_id[dqs_i] ), // Input disable input, high=disable
            //     .TM            (dqs_iobuf_tm[dqs_i] ), // 3-state enable input, high=input, low=output
            //     .TS            (dqs_iobuf_ts[dqs_i] )  // 3-state enable input, high=input, low=output
            // );

            (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst_p (
                    .CNTVALUEOUT(dqs_idly_cntout_p[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_in_delayed_p        ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4             ), // 1-bit input: Clock input
                    .CE         (dqs_idly_ce[dqs_i]      ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                    ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dqs_idly_cntin[dqs_i]   ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                    ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dqs_in_p                ), // 1-bit input: Data input from the I/O
                    .INC        (dqs_idly_inc[dqs_i]     ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_idly_ld[dqs_i]      ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                    ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dqs_idly_rst            )  // 1-bit input: Active-high reset tap-delay input
                );

            (* IODELAY_GROUP = "iodelay_group_32" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst_n (
                    .CNTVALUEOUT(dqs_idly_cntout_n[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_in_delayed_n        ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4             ), // 1-bit input: Clock input
                    .CE         (dqs_idly_ce[dqs_i]      ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                    ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dqs_idly_cntin[dqs_i]   ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                    ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dqs_in_n                ), // 1-bit input: Data input from the I/O
                    .INC        (dqs_idly_inc[dqs_i]     ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_idly_ld[dqs_i]      ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                    ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dqs_idly_rst            )  // 1-bit input: Active-high reset tap-delay input
                );

            // BUFIO BUFIO_inst_p (
            //     .O(dqs_bufio_p[dqs_i]), // 1-bit output: Clock output (connect to I/O clock loads).
            //     .I(dqs_in_delayed_p  )  // 1-bit input: Clock input (connect to an IBUFG or BUFMR).
            // );

            // BUFIO BUFIO_inst_n (
            //     .O(dqs_bufio_n[dqs_i]), // 1-bit output: Clock output (connect to I/O clock loads).
            //     .I(dqs_in_delayed_n  )  // 1-bit input: Clock input (connect to an IBUFG or BUFMR).
            // );

            BUFR #(
                .BUFR_DIVIDE("BYPASS" ), // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
                .SIM_DEVICE ("7SERIES")  // Must be set to "7SERIES"
            ) BUFR_inst_p (
                .O  (dqs_bufio_p[dqs_i]), // 1-bit output: Clock output port
                .CE (1'b1              ), // 1-bit input: Active high, clock enable (Divided modes only)
                .CLR(1'b0              ), // 1-bit input: Active high, asynchronous clear (Divided modes only)
                .I  (dqs_in_delayed_p  )  // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
            );

            // BUFR #(
            //     .BUFR_DIVIDE("BYPASS" ), // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
            //     .SIM_DEVICE ("7SERIES")  // Must be set to "7SERIES"
            // ) BUFR_inst_n (
            //     .O  (dqs_bufio_n[dqs_i]), // 1-bit output: Clock output port
            //     .CE (1'b1              ), // 1-bit input: Active high, clock enable (Divided modes only)
            //     .CLR(1'b0              ), // 1-bit input: Active high, asynchronous clear (Divided modes only)
            //     .I  (dqs_in_delayed_n  )  // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
            // );

        end
    endgenerate

    generate
        for (genvar dqs_i = 4; dqs_i < 8; dqs_i++) begin : gen_dqs_34

            logic dqs_oddr        ;
            logic dqs_out_delayed     ;
            logic dqs_in_delayed_p;
            logic dqs_in_delayed_n;
            logic dqs_in_p        ;
            logic dqs_in_n        ;

            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
                .INIT        (1'b0       ), // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE      ("SYNC"     )  // Set/Reset type: "SYNC" or "ASYNC"
            ) ODDR_inst (
                .Q (dqs_oddr    ), // 1-bit DDR output
                .C (dfi_clk_90  ), // 1-bit clock input
                .CE(1'b1        ), // 1-bit clock enable input
                .D1(1'b1        ), // 1-bit data input (positive edge)
                .D2(1'b0        ), // 1-bit data input (negative edge)
                .R (dqs_oddr_rst), // 1-bit reset
                .S (1'b0        )  // 1-bit set
            );

            (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                ODELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("ODATAIN" ), // Delay input (ODATAIN, CLKIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .ODELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .ODELAY_VALUE         (0         ), // Output delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) ODELAYE2_inst (
                    .CNTVALUEOUT(dqs_odly_cntout[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_out_delayed       ), // 1-bit output: Delayed data/clock output
                    .C          (dfi_clkdiv4           ), // 1-bit input: Clock input
                    .CE         (dqs_odly_ce[dqs_i]    ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                  ), // 1-bit input: Dynamic clock inversion input
                    .CLKIN      (1'b0                  ), // 1-bit input: Clock delay input
                    .CNTVALUEIN (dqs_odly_cntin[dqs_i] ), // 5-bit input: Counter value input
                    .INC        (dqs_odly_inc[dqs_i]   ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_odly_ld[dqs_i]    ), // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN
                    .LDPIPEEN   (1'b0                  ), // 1-bit input: Enables the pipeline register to load data
                    .ODATAIN    (dqs_oddr              ), // 1-bit input: Output delay data input
                    .REGRST     (dqs_odly_rst          )  // 1-bit input: Active-high reset tap-delay input
                );

            IOBUFDS_DIFF_OUT_DCIEN #(
                .DIFF_TERM      ("FALSE"            ), // Differential Termination ("TRUE"/"FALSE")
                .IBUF_LOW_PWR   ("FALSE"            ), // Low Power - "TRUE", High Performance = "FALSE"
                .IOSTANDARD     ("DIFF_SSTL15_T_DCI"), // Specify the I/O standard
                .USE_IBUFDISABLE("TRUE"             )  // Use IBUFDISABLE function, "TRUE" or "FALSE"
            ) IOBUFDS_DIFF_OUT_DCIEN_inst (
                .O             (dqs_in_p            ), // Buffer p-side output
                .OB            (dqs_in_n            ), // Buffer n-side output
                .IO            (ddr_dqs_p[dqs_i]    ), // Diff_p inout (connect directly to top-level port)
                .IOB           (ddr_dqs_n[dqs_i]    ), // Diff_n inout (connect directly to top-level port)
                .DCITERMDISABLE(dqs_iobuf_dci[dqs_i]), // DCI Termination enable input
                .I             (dqs_out_delayed         ), // Buffer input
                .IBUFDISABLE   (dqs_iobuf_id[dqs_i] ), // Input disable input, high=disable
                .TM            (dqs_iobuf_tm[dqs_i] ), // 3-state enable input, high=input, low=output
                .TS            (dqs_iobuf_ts[dqs_i] )  // 3-state enable input, high=input, low=output
            );

            (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst_p (
                    .CNTVALUEOUT(dqs_idly_cntout_p[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_in_delayed_p        ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4             ), // 1-bit input: Clock input
                    .CE         (dqs_idly_ce[dqs_i]      ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                    ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dqs_idly_cntin[dqs_i]   ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                    ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dqs_in_p                ), // 1-bit input: Data input from the I/O
                    .INC        (dqs_idly_inc[dqs_i]     ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_idly_ld[dqs_i]      ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                    ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dqs_idly_rst            )  // 1-bit input: Active-high reset tap-delay input
                );

            (* IODELAY_GROUP = "iodelay_group_34" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL

                IDELAYE2 #(
                    .CINVCTRL_SEL         ("FALSE"   ), // Enable dynamic clock inversion (FALSE, TRUE)
                    .DELAY_SRC            ("IDATAIN" ), // Delay input (IDATAIN, DATAIN)
                    .HIGH_PERFORMANCE_MODE("TRUE"    ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    .IDELAY_TYPE          ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    .IDELAY_VALUE         (0         ), // Input delay tap setting (0-31)
                    .PIPE_SEL             ("FALSE"   ), // Select pipelined mode, FALSE, TRUE
                    .REFCLK_FREQUENCY     (300.0     ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    .SIGNAL_PATTERN       ("DATA"    )  // DATA, CLOCK input signal
                ) IDELAYE2_inst_n (
                    .CNTVALUEOUT(dqs_idly_cntout_n[dqs_i]), // 5-bit output: Counter value output
                    .DATAOUT    (dqs_in_delayed_n        ), // 1-bit output: Delayed data output
                    .C          (dfi_clkdiv4             ), // 1-bit input: Clock input
                    .CE         (dqs_idly_ce[dqs_i]      ), // 1-bit input: Active high enable increment/decrement input
                    .CINVCTRL   (1'b0                    ), // 1-bit input: Dynamic clock inversion input
                    .CNTVALUEIN (dqs_idly_cntin[dqs_i]   ), // 5-bit input: Counter value input
                    .DATAIN     (1'b0                    ), // 1-bit input: Internal delay data input
                    .IDATAIN    (dqs_in_n                ), // 1-bit input: Data input from the I/O
                    .INC        (dqs_idly_inc[dqs_i]     ), // 1-bit input: Increment / Decrement tap delay input
                    .LD         (dqs_idly_ld[dqs_i]      ), // 1-bit input: Load IDELAY_VALUE input
                    .LDPIPEEN   (1'b0                    ), // 1-bit input: Enable PIPELINE register to load data input
                    .REGRST     (dqs_idly_rst            )  // 1-bit input: Active-high reset tap-delay input
                );

            BUFR #(
                .BUFR_DIVIDE("BYPASS" ), // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
                .SIM_DEVICE ("7SERIES")  // Must be set to "7SERIES"
            ) BUFR_inst_p (
                .O  (dqs_bufio_p[dqs_i]), // 1-bit output: Clock output port
                .CE (1'b1              ), // 1-bit input: Active high, clock enable (Divided modes only)
                .CLR(1'b0              ), // 1-bit input: Active high, asynchronous clear (Divided modes only)
                .I  (dqs_in_delayed_p  )  // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
            );

            BUFR #(
                .BUFR_DIVIDE("BYPASS" ), // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
                .SIM_DEVICE ("7SERIES")  // Must be set to "7SERIES"
            ) BUFR_inst_n (
                .O  (dqs_bufio_n[dqs_i]), // 1-bit output: Clock output port
                .CE (1'b1              ), // 1-bit input: Active high, clock enable (Divided modes only)
                .CLR(1'b0              ), // 1-bit input: Active high, asynchronous clear (Divided modes only)
                .I  (dqs_in_delayed_n  )  // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
            );

        end
    endgenerate

endmodule // phy_top
