/**
*
*/

`include "timescale.svh"
`include "defines.svh"

module top (
    // KC705 resources
    input             sysclk_p   ,
    input             sysclk_n   ,
    input             sysrst     ,
    output reg [ 7:0] gpio_led   ,
    // DDR3 interface
    inout      [63:0] ddr_dq     ,
    inout      [ 7:0] ddr_dqs_n  ,
    inout      [ 7:0] ddr_dqs_p  ,
    output     [15:0] ddr_addr   ,
    output     [ 2:0] ddr_ba     ,
    output            ddr_ras_n  ,
    output            ddr_cas_n  ,
    output            ddr_we_n   ,
    output            ddr_reset_n,
    output     [ 1:0] ddr_ck_p   ,
    output     [ 1:0] ddr_ck_n   ,
    output     [ 1:0] ddr_cke    ,
    output     [ 1:0] ddr_cs_n   ,
    output     [ 7:0] ddr_dm     ,
    output     [ 1:0] ddr_odt
);

    logic sysclk;

    IBUFGDS #(
        .DIFF_TERM   ("FALSE"  ), // Differential Termination
        .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD  ("DEFAULT")  // Specify the input I/O standard
    ) sysclk_IBUFGDS_inst (
        .O (sysclk  ), // Clock buffer output
        .I (sysclk_p), // Diff_p clock buffer input (connect directly to top-level port)
        .IB(sysclk_n)  // Diff_n clock buffer input (connect directly to top-level port)
    );

    logic mmcm_locked;
    logic mmcm_clkfb ;

    logic clk_ubuf    ;
    logic clk_90_ubuf ;
    logic clkdiv2_ubuf;
    logic clkdiv4_ubuf;

    (* LOC = "MMCME2_ADV_X1Y1" *)

        MMCME2_BASE #(
            .BANDWIDTH         ("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
            .CLKFBOUT_MULT_F   (6.000      ), // Multiply value for all CLKOUT (2.000-64.000).
            .CLKFBOUT_PHASE    (0.000      ), // Phase offset in degrees of CLKFB (-360.000-360.000).
            .CLKIN1_PERIOD     (5.000      ), // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
            .CLKOUT0_DIVIDE_F  (2.000      ), // Divide amount for CLKOUT0 (1.000-128.000).
            .CLKOUT1_DIVIDE    (2          ),
            .CLKOUT2_DIVIDE    (4          ),
            .CLKOUT3_DIVIDE    (8          ),
            .CLKOUT4_DIVIDE    (1          ),
            .CLKOUT5_DIVIDE    (1          ),
            .CLKOUT6_DIVIDE    (1          ),
            // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
            .CLKOUT0_DUTY_CYCLE(0.50       ),
            .CLKOUT1_DUTY_CYCLE(0.50       ),
            .CLKOUT2_DUTY_CYCLE(0.50       ),
            .CLKOUT3_DUTY_CYCLE(0.50       ),
            .CLKOUT4_DUTY_CYCLE(0.50       ),
            .CLKOUT5_DUTY_CYCLE(0.50       ),
            .CLKOUT6_DUTY_CYCLE(0.50       ),
            // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
            .CLKOUT0_PHASE     (000.000    ),
            .CLKOUT1_PHASE     (090.000    ),
            .CLKOUT2_PHASE     (000.000    ),
            .CLKOUT3_PHASE     (000.000    ),
            .CLKOUT4_PHASE     (000.000    ),
            .CLKOUT5_PHASE     (000.000    ),
            .CLKOUT6_PHASE     (000.000    ),
            .CLKOUT4_CASCADE   ("FALSE"    ), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
            .DIVCLK_DIVIDE     (1          ), // Master division value (1-106)
            .REF_JITTER1       (0.000      ), // Reference input jitter in UI (0.000-0.999).
            .STARTUP_WAIT      ("FALSE"    )  // Delays DONE until MMCM is locked (FALSE, TRUE)
        ) MMCME2_BASE_inst (
            // Clock Outputs: 1-bit (each) output: User configurable clock outputs
            .CLKOUT0  (clk_ubuf    ), // 1-bit output: CLKOUT0
            .CLKOUT0B (            ), // 1-bit output: Inverted CLKOUT0
            .CLKOUT1  (clk_90_ubuf ), // 1-bit output: CLKOUT1
            .CLKOUT1B (            ), // 1-bit output: Inverted CLKOUT1
            .CLKOUT2  (clkdiv2_ubuf), // 1-bit output: CLKOUT2
            .CLKOUT2B (            ), // 1-bit output: Inverted CLKOUT2
            .CLKOUT3  (clkdiv4_ubuf), // 1-bit output: CLKOUT3
            .CLKOUT3B (            ), // 1-bit output: Inverted CLKOUT3
            .CLKOUT4  (            ), // 1-bit output: CLKOUT4
            .CLKOUT5  (            ), // 1-bit output: CLKOUT5
            .CLKOUT6  (            ), // 1-bit output: CLKOUT6
            // Feedback Clocks: 1-bit (each) output: Clock feedback ports
            .CLKFBOUT (mmcm_clkfb  ), // 1-bit output: Feedback clock
            .CLKFBOUTB(            ), // 1-bit output: Inverted CLKFBOUT
            // Status Ports: 1-bit (each) output: MMCM status ports
            .LOCKED   (mmcm_locked ), // 1-bit output: LOCK
            // Clock Inputs: 1-bit (each) input: Clock input
            .CLKIN1   (sysclk      ), // 1-bit input: Clock
            // Control Ports: 1-bit (each) input: MMCM control ports
            .PWRDWN   (1'b0        ), // 1-bit input: Power-down
            .RST      (sysrst      ), // 1-bit input: Reset
            // Feedback Clocks: 1-bit (each) input: Clock feedback ports
            .CLKFBIN  (mmcm_clkfb  )  // 1-bit input: Feedback clock
        );

    logic clk    ;
    logic clk_90 ;
    logic clkdiv2;
    logic clkdiv4;

    BUFIO clk_BUFIO_inst (
        .O(clk     ), // 1-bit output: Clock output (connect to I/O clock loads).
        .I(clk_ubuf)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
    );

    BUFIO clk_90_BUFIO_inst (
        .O(clk_90     ), // 1-bit output: Clock output (connect to I/O clock loads).
        .I(clk_90_ubuf)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
    );

    BUFG clkdiv2_BUFG_inst (
        .O(clkdiv2     ), // 1-bit output: Clock output (connect to I/O clock loads).
        .I(clkdiv2_ubuf)  // 1-bit input: Clock input (connect to an IBUFG or BUFMR).
    );

    BUFG clkdiv4_BUFG_inst (
        .O(clkdiv4     ), // 1-bit output: Clock output (connect to I/O clock loads).
        .I(clkdiv4_ubuf)  // 1-bit input: Clock input (connect to an IBUFG or BUFMR).
    );

    logic clk_300mhz_ubuf;
    logic pll_clkfb;

    (* LOC = "PLLE2_ADV_X1Y1" *)

        PLLE2_BASE #(
            .BANDWIDTH         ("OPTIMIZED"), // OPTIMIZED, HIGH, LOW
            .CLKFBOUT_MULT     (6          ), // Multiply value for all CLKOUT, (2-64)
            .CLKFBOUT_PHASE    (0.0        ), // Phase offset in degrees of CLKFB, (-360.000-360.000).
            .CLKIN1_PERIOD     (5.000      ), // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
            .CLKOUT0_DIVIDE    (4          ),
            .CLKOUT1_DIVIDE    (1          ),
            .CLKOUT2_DIVIDE    (1          ),
            .CLKOUT3_DIVIDE    (1          ),
            .CLKOUT4_DIVIDE    (1          ),
            .CLKOUT5_DIVIDE    (1          ),
            // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
            .CLKOUT0_DUTY_CYCLE(0.5        ),
            .CLKOUT1_DUTY_CYCLE(0.5        ),
            .CLKOUT2_DUTY_CYCLE(0.5        ),
            .CLKOUT3_DUTY_CYCLE(0.5        ),
            .CLKOUT4_DUTY_CYCLE(0.5        ),
            .CLKOUT5_DUTY_CYCLE(0.5        ),
            // CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
            .CLKOUT0_PHASE     (0.0        ),
            .CLKOUT1_PHASE     (0.0        ),
            .CLKOUT2_PHASE     (0.0        ),
            .CLKOUT3_PHASE     (0.0        ),
            .CLKOUT4_PHASE     (0.0        ),
            .CLKOUT5_PHASE     (0.0        ),
            .DIVCLK_DIVIDE     (1          ), // Master division value, (1-56)
            .REF_JITTER1       (0.0        ), // Reference input jitter in UI, (0.000-0.999).
            .STARTUP_WAIT      ("FALSE"    )  // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
        ) PLLE2_BASE_inst (
            // Clock Outputs: 1-bit (each) output: User configurable clock outputs
            .CLKOUT0 (clk_300mhz_ubuf), // 1-bit output: CLKOUT0
            .CLKOUT1 (               ), // 1-bit output: CLKOUT1
            .CLKOUT2 (               ), // 1-bit output: CLKOUT2
            .CLKOUT3 (               ), // 1-bit output: CLKOUT3
            .CLKOUT4 (               ), // 1-bit output: CLKOUT4
            .CLKOUT5 (               ), // 1-bit output: CLKOUT5
            // Feedback Clocks: 1-bit (each) output: Clock feedback ports
            .CLKFBOUT(pll_clkfb      ), // 1-bit output: Feedback clock
            .LOCKED  (pll_locked     ), // 1-bit output: LOCK
            .CLKIN1  (sysclk         ), // 1-bit input: Input clock
            // Control Ports: 1-bit (each) input: PLL control ports
            .PWRDWN  (1'b0           ), // 1-bit input: Power-down
            .RST     (sysrst         ), // 1-bit input: Reset
            // Feedback Clocks: 1-bit (each) input: Clock feedback ports
            .CLKFBIN (pll_clkfb      )  // 1-bit input: Feedback clock
        );

    logic clk_300mhz;

    BUFG clk_300mhz_BUFG_inst (
        .O(clk_300mhz     ), // 1-bit output: Clock output (connect to I/O clock loads).
        .I(clk_300mhz_ubuf)  // 1-bit input: Clock input (connect to an IBUFG or BUFMR).
    );

    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH  ),
        .C_NASTI_ADDR_WIDTH(`C_NASTI_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTI_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH)
    ) nasti ();

    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH   ),
        .C_NASTI_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTIL_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH )
    ) nastilite ();

    dfi_if #(
        .C_DFI_FREQ_RATIO  (`C_DFI_FREQ_RATIO  ),
        .C_DFI_ADDR_WIDTH  (`C_DFI_ADDR_WIDTH  ),
        .C_DFI_BANK_WIDTH  (`C_DFI_BANK_WIDTH  ),
        .C_DFI_CTRL_WIDTH  (`C_DFI_CTRL_WIDTH  ),
        .C_DFI_CS_WIDTH    (`C_DFI_CS_WIDTH    ),
        .C_DFI_DATAEN_WIDTH(`C_DFI_DATAEN_WIDTH),
        .C_DFI_DATA_WIDTH  (`C_DFI_DATA_WIDTH  ),
        .C_DFI_WRDACS_WIDTH(`C_DFI_DACS_WIDTH  ),
        .C_DFI_DM_WIDTH    (`C_DFI_DM_WIDTH    ),
        .C_DFI_ALERT_WIDTH (`C_DFI_ALERT_WIDTH ),
        .C_DFI_ERR_WIDTH   (`C_DFI_ERR_WIDTH   )
    ) dfi ();

    logic dfi_arstn;
    logic axi_tg_irq_out;

    axi_traffic_gen_0 axi_traffic_gen_0_inst (
        .s_axi_aclk    (clkdiv4       ), // input wire s_axi_aclk
        .s_axi_aresetn (dfi_arstn     ), // input wire s_axi_aresetn
        .core_ext_start(1'b1          ), // input wire core_ext_start
        .m_axi_awid    (nasti.aw_id   ), // output wire [0 : 0] m_axi_awid
        .m_axi_awaddr  (nasti.aw_addr ), // output wire [31 : 0] m_axi_awaddr
        .m_axi_awlen   (nasti.aw_len  ), // output wire [7 : 0] m_axi_awlen
        .m_axi_awsize  (nasti.aw_size ), // output wire [2 : 0] m_axi_awsize
        .m_axi_awburst (nasti.aw_burst), // output wire [1 : 0] m_axi_awburst
        .m_axi_awlock  (nasti.aw_lock ), // output wire [0 : 0] m_axi_awlock
        .m_axi_awcache (nasti.aw_cache), // output wire [3 : 0] m_axi_awcache
        .m_axi_awprot  (nasti.aw_prot ), // output wire [2 : 0] m_axi_awprot
        .m_axi_awqos   (nasti.aw_qos  ), // output wire [3 : 0] m_axi_awqos
        .m_axi_awuser  (nasti.aw_user ), // output wire [7 : 0] m_axi_awuser
        .m_axi_awvalid (nasti.aw_valid), // output wire m_axi_awvalid
        .m_axi_awready (nasti.aw_ready), // input wire m_axi_awready
        .m_axi_wlast   (nasti.w_last  ), // output wire m_axi_wlast
        .m_axi_wdata   (nasti.w_data  ), // output wire [31 : 0] m_axi_wdata
        .m_axi_wstrb   (nasti.w_strb  ), // output wire [3 : 0] m_axi_wstrb
        .m_axi_wvalid  (nasti.w_valid ), // output wire m_axi_wvalid
        .m_axi_wready  (nasti.w_ready ), // input wire m_axi_wready
        .m_axi_bid     (nasti.b_id    ), // input wire [0 : 0] m_axi_bid
        .m_axi_bresp   (nasti.b_resp  ), // input wire [1 : 0] m_axi_bresp
        .m_axi_bvalid  (nasti.b_valid ), // input wire m_axi_bvalid
        .m_axi_bready  (nasti.b_ready ), // output wire m_axi_bready
        .m_axi_arid    (nasti.ar_id   ), // output wire [0 : 0] m_axi_arid
        .m_axi_araddr  (nasti.ar_addr ), // output wire [31 : 0] m_axi_araddr
        .m_axi_arlen   (nasti.ar_len  ), // output wire [7 : 0] m_axi_arlen
        .m_axi_arsize  (nasti.ar_size ), // output wire [2 : 0] m_axi_arsize
        .m_axi_arburst (nasti.ar_burst), // output wire [1 : 0] m_axi_arburst
        .m_axi_arlock  (nasti.ar_lock ), // output wire [0 : 0] m_axi_arlock
        .m_axi_arcache (nasti.ar_cache), // output wire [3 : 0] m_axi_arcache
        .m_axi_arprot  (nasti.ar_prot ), // output wire [2 : 0] m_axi_arprot
        .m_axi_arqos   (nasti.ar_qos  ), // output wire [3 : 0] m_axi_arqos
        .m_axi_aruser  (nasti.ar_user ), // output wire [7 : 0] m_axi_aruser
        .m_axi_arvalid (nasti.ar_valid), // output wire m_axi_arvalid
        .m_axi_arready (nasti.ar_ready), // input wire m_axi_arready
        .m_axi_rid     (nasti.r_id    ), // input wire [0 : 0] m_axi_rid
        .m_axi_rlast   (nasti.r_last  ), // input wire m_axi_rlast
        .m_axi_rdata   (nasti.r_data  ), // input wire [31 : 0] m_axi_rdata
        .m_axi_rresp   (nasti.r_resp  ), // input wire [1 : 0] m_axi_rresp
        .m_axi_rvalid  (nasti.r_valid ), // input wire m_axi_rvalid
        .m_axi_rready  (nasti.r_ready ), // output wire m_axi_rready
        .irq_out       (axi_tg_irq_out)  // output wire irq_out
    );

    logic [3:0] rst_counter;

    always_ff @(posedge sysclk or negedge mmcm_locked) begin : proc_reset
        if(sysrst) begin
            rst_counter <= 0;
            dfi_arstn   <= 0;
        end else if(~mmcm_locked) begin
            rst_counter <= 0;
            dfi_arstn   <= 0;
        end else begin
            if(15 == rst_counter) begin
                rst_counter <= rst_counter;
                dfi_arstn   <= 1;
            end else begin
                rst_counter <= rst_counter + 1;
                dfi_arstn   <= 0;
            end
        end
    end

    nasti_ddrx_mc #(
        .C_DFI_FREQ_RATIO   (`C_DFI_FREQ_RATIO   ),
        .C_NASTI_ID_WIDTH   (`C_NASTI_ID_WIDTH   ),
        .C_NASTI_ADDR_WIDTH (`C_NASTI_ADDR_WIDTH ),
        .C_NASTI_DATA_WIDTH (`C_NASTI_DATA_WIDTH ),
        .C_NASTI_USER_WIDTH (`C_NASTI_USER_WIDTH ),
        .C_NASTIL_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
        .C_NASTIL_DATA_WIDTH(`C_NASTIL_DATA_WIDTH),
        .C_DFI_ADDR_WIDTH   (`C_DFI_ADDR_WIDTH   ),
        .C_DFI_BANK_WIDTH   (`C_DFI_BANK_WIDTH   ),
        .C_DFI_CTRL_WIDTH   (`C_DFI_CTRL_WIDTH   ),
        .C_DFI_CS_WIDTH     (`C_DFI_CS_WIDTH     ),
        .C_DFI_DATAEN_WIDTH (`C_DFI_DATAEN_WIDTH ),
        .C_DFI_DATA_WIDTH   (`C_DFI_DATA_WIDTH   ),
        .C_DFI_WRDACS_WIDTH (`C_DFI_CS_WIDTH     ),
        .C_DFI_DM_WIDTH     (`C_DFI_DM_WIDTH     ),
        .C_DFI_ALERT_WIDTH  (`C_DFI_ALERT_WIDTH  ),
        .C_DFI_ERR_WIDTH    (`C_DFI_ERR_WIDTH    )
    ) i_nasti_ddrx_mc (
        .core_clk           (clkdiv4  ),
        .core_arstn         (dfi_arstn),
        .s_nastilite_clk    (clkdiv4  ),
        .s_nastilite_aresetn(dfi_arstn),
        .s_nastilite        (nastilite),
        .s_nasti_clk        (clkdiv4  ),
        .s_nasti_aresetn    (dfi_arstn),
        .s_nasti            (nasti    ),
        .m_dfi              (dfi      )
    );

    phy_top i_phy_top (
        .dfi_clk    (clk        ),
        .dfi_clk_90 (clk_90     ),
        .dfi_clkdiv2(clkdiv2    ),
        .dfi_clkdiv4(clkdiv4    ),
        .dfi_arstn  (dfi_arstn  ),
        .s_dfi      (dfi        ),
        .ddr_dq     (ddr_dq     ),
        .ddr_dqs_n  (ddr_dqs_n  ),
        .ddr_dqs_p  (ddr_dqs_p  ),
        .ddr_addr   (ddr_addr   ),
        .ddr_ba     (ddr_ba     ),
        .ddr_ras_n  (ddr_ras_n  ),
        .ddr_cas_n  (ddr_cas_n  ),
        .ddr_we_n   (ddr_we_n   ),
        .ddr_reset_n(ddr_reset_n),
        .ddr_ck_p   (ddr_ck_p   ),
        .ddr_ck_n   (ddr_ck_n   ),
        .ddr_cke    (ddr_cke    ),
        .ddr_cs_n   (ddr_cs_n   ),
        .ddr_dm     (ddr_dm     ),
        .ddr_odt    (ddr_odt    ),
        .clk_300mhz (clk_300mhz )
    );

    assign gpio_led[0] = mmcm_locked;
    assign gpio_led[1] = pll_locked;
    assign gpio_led[2] = axi_tg_irq_out;
    assign gpio_led[3] = mmcm_locked;
    assign gpio_led[4] = mmcm_locked;
    assign gpio_led[5] = mmcm_locked;
    assign gpio_led[6] = mmcm_locked;
    assign gpio_led[7] = mmcm_locked;

endmodule // top
