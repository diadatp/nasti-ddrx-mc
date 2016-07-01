/*
 *
 */

`include "defines.svh"

module top (
    // KC705 resources
    input         sysclk_p   ,
    input         sysclk_n   ,
    input         sysrst     ,
    // DDR3 interface
    inout  [63:0] ddr_dq     ,
    output [ 7:0] ddr_dqs_n  ,
    output [ 7:0] ddr_dqs_p  ,
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
    output [ 1:0] ddr_odt
);

    logic sysclk     ;
    logic dfi_clk    ;
    logic dfi_clkdiv2;
    logic dfi_clkdiv4;

    IBUFGDS #(
        .DIFF_TERM   ("FALSE"  ), // Differential Termination
        .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD  ("DEFAULT")  // Specify the input I/O standard
    ) sysclk_IBUFGDS_inst (
        .O (sysclk  ), // Clock buffer output
        .I (sysclk_p), // Diff_p clock buffer input (connect directly to top-level port)
        .IB(sysclk_n)  // Diff_n clock buffer input (connect directly to top-level port)
    );

    MMCME2_ADV #(
        .BANDWIDTH           ("OPTIMIZED"  ), // Jitter programming (OPTIMIZED, HIGH, LOW)
        .CLKFBOUT_MULT_F     (8.000        ), // Multiply value for all CLKOUT (2.000-64.000).
        .CLKFBOUT_PHASE      (0.0          ), // Phase offset in degrees of CLKFB (-360.000-360.000).
        // CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
        .CLKIN1_PERIOD       (5.000        ),
        .CLKIN2_PERIOD       (0.0          ),
        // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
        .CLKOUT1_DIVIDE      (4            ),
        .CLKOUT2_DIVIDE      (8            ),
        .CLKOUT3_DIVIDE      (1            ),
        .CLKOUT4_DIVIDE      (1            ),
        .CLKOUT5_DIVIDE      (1            ),
        .CLKOUT6_DIVIDE      (1            ),
        .CLKOUT0_DIVIDE_F    (2.000        ), // Divide amount for CLKOUT0 (1.000-128.000).
        // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
        .CLKOUT0_DUTY_CYCLE  (0.5          ),
        .CLKOUT1_DUTY_CYCLE  (0.5          ),
        .CLKOUT2_DUTY_CYCLE  (0.5          ),
        .CLKOUT3_DUTY_CYCLE  (0.5          ),
        .CLKOUT4_DUTY_CYCLE  (0.5          ),
        .CLKOUT5_DUTY_CYCLE  (0.5          ),
        .CLKOUT6_DUTY_CYCLE  (0.5          ),
        // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
        .CLKOUT0_PHASE       (0.0          ),
        .CLKOUT1_PHASE       (0.0          ),
        .CLKOUT2_PHASE       (0.0          ),
        .CLKOUT3_PHASE       (0.0          ),
        .CLKOUT4_PHASE       (0.0          ),
        .CLKOUT5_PHASE       (0.0          ),
        .CLKOUT6_PHASE       (0.0          ),
        .CLKOUT4_CASCADE     ("FALSE"      ), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
        .COMPENSATION        ("ZHOLD"      ), // ZHOLD, BUF_IN, EXTERNAL, INTERNAL
        .DIVCLK_DIVIDE       (1            ), // Master division value (1-106)
        // REF_JITTER: Reference input jitter in UI (0.000-0.999).
        .REF_JITTER1         (0.0          ),
        .REF_JITTER2         (0.0          ),
        .STARTUP_WAIT        ("FALSE"      ), // Delays DONE until MMCM is locked (FALSE, TRUE)
        // Spread Spectrum: Spread Spectrum Attributes
        .SS_EN               ("FALSE"      ), // Enables spread spectrum (FALSE, TRUE)
        .SS_MODE             ("CENTER_HIGH"), // CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
        .SS_MOD_PERIOD       (10000        ), // Spread spectrum modulation period (ns) (VALUES)
        // USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
        .CLKFBOUT_USE_FINE_PS("FALSE"      ),
        .CLKOUT0_USE_FINE_PS ("FALSE"      ),
        .CLKOUT1_USE_FINE_PS ("FALSE"      ),
        .CLKOUT2_USE_FINE_PS ("FALSE"      ),
        .CLKOUT3_USE_FINE_PS ("FALSE"      ),
        .CLKOUT4_USE_FINE_PS ("FALSE"      ),
        .CLKOUT5_USE_FINE_PS ("FALSE"      ),
        .CLKOUT6_USE_FINE_PS ("FALSE"      )
    ) MMCME2_ADV_inst (
        // Clock Outputs: 1-bit (each) output: User configurable clock outputs
        .CLKOUT0     (dfi_clk     ), // 1-bit output: CLKOUT0
        .CLKOUT0B    (            ), // 1-bit output: Inverted CLKOUT0
        .CLKOUT1     (dfi_clkdiv2 ), // 1-bit output: CLKOUT1
        .CLKOUT1B    (            ), // 1-bit output: Inverted CLKOUT1
        .CLKOUT2     (dfi_clkdiv4 ), // 1-bit output: CLKOUT2
        .CLKOUT2B    (            ), // 1-bit output: Inverted CLKOUT2
        .CLKOUT3     (            ), // 1-bit output: CLKOUT3
        .CLKOUT3B    (            ), // 1-bit output: Inverted CLKOUT3
        .CLKOUT4     (            ), // 1-bit output: CLKOUT4
        .CLKOUT5     (            ), // 1-bit output: CLKOUT5
        .CLKOUT6     (            ), // 1-bit output: CLKOUT6
        // DRP Ports: 16-bit (each) output: Dynamic reconfiguration ports
        .DO          (DO          ), // 16-bit output: DRP data
        .DRDY        (DRDY        ), // 1-bit output: DRP ready
        // Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
        .PSDONE      (PSDONE      ), // 1-bit output: Phase shift done
        // Feedback Clocks: 1-bit (each) output: Clock feedback ports
        .CLKFBOUT    (CLKFBOUT    ), // 1-bit output: Feedback clock
        .CLKFBOUTB   (CLKFBOUTB   ), // 1-bit output: Inverted CLKFBOUT
        // Status Ports: 1-bit (each) output: MMCM status ports
        .CLKFBSTOPPED(CLKFBSTOPPED), // 1-bit output: Feedback clock stopped
        .CLKINSTOPPED(CLKINSTOPPED), // 1-bit output: Input clock stopped
        .LOCKED      (LOCKED      ), // 1-bit output: LOCK
        // Clock Inputs: 1-bit (each) input: Clock inputs
        .CLKIN1      (sysclk      ), // 1-bit input: Primary clock
        .CLKIN2      (            ), // 1-bit input: Secondary clock
        // Control Ports: 1-bit (each) input: MMCM control ports
        .CLKINSEL    (1'b1        ), // 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
        .PWRDWN      (1'b0        ), // 1-bit input: Power-down
        .RST         (mmcm_rst    ), // 1-bit input: Reset
        // DRP Ports: 7-bit (each) input: Dynamic reconfiguration ports
        .DADDR       (            ), // 7-bit input: DRP address
        .DCLK        (            ), // 1-bit input: DRP clock
        .DEN         (            ), // 1-bit input: DRP enable
        .DI          (            ), // 16-bit input: DRP data
        .DWE         (            ), // 1-bit input: DRP write enable
        // Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
        .PSCLK       (            ), // 1-bit input: Phase shift clock
        .PSEN        (            ), // 1-bit input: Phase shift enable
        .PSINCDEC    (            ), // 1-bit input: Phase shift increment/decrement
        // Feedback Clocks: 1-bit (each) input: Clock feedback ports
        .CLKFBIN     (CLKFBIN     )  // 1-bit input: Feedback clock
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

    // nasti_ddrx_mc #(
    //     .C_NASTI_ID_WIDTH   (`C_NASTI_ID_WIDTH   ),
    //     .C_NASTI_ADDR_WIDTH (`C_NASTI_ADDR_WIDTH ),
    //     .C_NASTI_DATA_WIDTH (`C_NASTI_DATA_WIDTH ),
    //     .C_NASTI_USER_WIDTH (`C_NASTI_USER_WIDTH ),
    //     .C_NASTIL_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
    //     .C_NASTIL_DATA_WIDTH(`C_NASTIL_DATA_WIDTH)
    // ) i_nasti_ddrx_mc (
    //     .core_clk           (core_clk        ),
    //     .core_arstn         (core_arstn      ),
    //     .s_nastilite_clk    (s_nastil_clk    ),
    //     .s_nastilite_aresetn(s_nastil_aresetn),
    //     .s_nastilite        (nastilite       ),
    //     .s_nasti_clk        (s_nasti_clk     ),
    //     .s_nasti_aresetn    (s_nasti_aresetn ),
    //     .s_nasti            (nasti           ),
    //     .m_dfi              (dfi             )
    // );

    phy_top i_phy_top (
        .dfi_clk    (dfi_clk    ),
        .dfi_clkdiv2(dfi_clkdiv2),
        .dfi_clkdiv4(dfi_clkdiv4),
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
        .ddr_odt    (ddr_odt    )
    );

endmodule // top
