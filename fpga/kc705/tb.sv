/**
 *
 */

`include "timescale.svh"

module tb;

    parameter CLKP = 5000;

    logic sysclk_p;
    logic sysclk_n;
    logic sysrst  ;

    always begin
        sysclk_p = 0;
        forever #(CLKP/2) sysclk_p = ~sysclk_p;
    end

    always begin
        sysclk_n = 1;
        forever #(CLKP/2) sysclk_n = ~sysclk_n;
    end

    initial begin
        sysrst = 1'b1;
        #50000;
        sysrst = 1'b0;
    end

    reg   [ 7:0] gpio_led   ;
    wire  [63:0] ddr_dq     ;
    wire  [ 7:0] ddr_dqs_n  ;
    wire  [ 7:0] ddr_dqs_p  ;
    logic [15:0] ddr_addr   ;
    logic [ 2:0] ddr_ba     ;
    logic        ddr_ras_n  ;
    logic        ddr_cas_n  ;
    logic        ddr_we_n   ;
    logic        ddr_reset_n;
    logic [ 1:0] ddr_ck_p   ;
    logic [ 1:0] ddr_ck_n   ;
    logic [ 1:0] ddr_cke    ;
    logic [ 1:0] ddr_cs_n   ;
    logic [ 7:0] ddr_dm     ;
    logic [ 1:0] ddr_odt    ;

    top i_top (
        .sysclk_p   (sysclk_p   ),
        .sysclk_n   (sysclk_n   ),
        .sysrst     (sysrst     ),
        .gpio_led   (gpio_led   ),
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

    logic       scl;
    wire        sda;
    wire  [7:0] cb ;
    logic [2:0] sa ;

    ddr3_dimm i_ddr3_dimm (
        .reset_n(ddr_reset_n),
        .ck     (ddr_ck_p   ),
        .ck_n   (ddr_ck_n   ),
        .cke    (ddr_cke    ),
        .s_n    (ddr_cs_n   ),
        .ras_n  (ddr_ras_n  ),
        .cas_n  (ddr_cas_n  ),
        .we_n   (ddr_we_n   ),
        .ba     (ddr_ba     ),
        .addr   (ddr_addr   ),
        .odt    (ddr_odt    ),
        .dqs    (ddr_dqs_p  ),
        .dqs_n  (ddr_dqs_n  ),
        .dq     (ddr_dq     ),
        .cb     (cb         ),
        .scl    (scl        ),
        .sa     (sa         ),
        .sda    (sda        )
    );

endmodule // tb
