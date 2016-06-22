/**
 *
 */

`timescale 1ps / 1ps

`include "defines.svh"

module top (
    input                                core_clk               ,
    input                                core_arstn             ,
    // NASTI interface
    input                                s_nasti_clk            ,
    input                                s_nasti_aresetn        ,
    //// NASTI slave write address channel
    input  [      `C_NASTI_ID_WIDTH-1:0] s_nasti_aw_id          ,
    input  [    `C_NASTI_ADDR_WIDTH-1:0] s_nasti_aw_addr        ,
    input  [                        7:0] s_nasti_aw_len         ,
    input  [                        2:0] s_nasti_aw_size        ,
    input  [                        1:0] s_nasti_aw_burst       ,
    input                                s_nasti_aw_lock        ,
    input  [                        3:0] s_nasti_aw_cache       ,
    input  [                        2:0] s_nasti_aw_prot        ,
    input  [                        3:0] s_nasti_aw_qos         ,
    input  [                        3:0] s_nasti_aw_region      ,
    input  [    `C_NASTI_USER_WIDTH-1:0] s_nasti_aw_user        ,
    input                                s_nasti_aw_valid       ,
    output                               s_nasti_aw_ready       ,
    //// NASTI slave write data channel
    input  [    `C_NASTI_DATA_WIDTH-1:0] s_nasti_w_data         ,
    input  [(`C_NASTI_DATA_WIDTH/8)-1:0] s_nasti_w_strb         ,
    input                                s_nasti_w_last         ,
    input  [    `C_NASTI_USER_WIDTH-1:0] s_nasti_w_user         ,
    input                                s_nasti_w_valid        ,
    output                               s_nasti_w_ready        ,
    //// NASTI slave write response channel
    output [      `C_NASTI_ID_WIDTH-1:0] s_nasti_b_id           ,
    output [                        1:0] s_nasti_b_resp         ,
    output [    `C_NASTI_USER_WIDTH-1:0] s_nasti_b_user         ,
    output                               s_nasti_b_valid        ,
    input                                s_nasti_b_ready        ,
    //// NASTI slave read address channel
    input  [      `C_NASTI_ID_WIDTH-1:0] s_nasti_ar_id          ,
    input  [    `C_NASTI_ADDR_WIDTH-1:0] s_nasti_ar_addr        ,
    input  [                        7:0] s_nasti_ar_len         ,
    input  [                        2:0] s_nasti_ar_size        ,
    input  [                        1:0] s_nasti_ar_burst       ,
    input  [                        0:0] s_nasti_ar_lock        ,
    input  [                        3:0] s_nasti_ar_cache       ,
    input  [                        2:0] s_nasti_ar_prot        ,
    input  [                        3:0] s_nasti_ar_qos         ,
    input  [                        3:0] s_nasti_ar_region      ,
    input  [    `C_NASTI_USER_WIDTH-1:0] s_nasti_ar_user        ,
    input                                s_nasti_ar_valid       ,
    output                               s_nasti_ar_ready       ,
    //// NASTI slave read data channel
    output [      `C_NASTI_ID_WIDTH-1:0] s_nasti_r_id           ,
    output [    `C_NASTI_DATA_WIDTH-1:0] s_nasti_r_data         ,
    output [                        1:0] s_nasti_r_resp         ,
    output                               s_nasti_r_last         ,
    output [    `C_NASTI_USER_WIDTH-1:0] s_nasti_r_user         ,
    output                               s_nasti_r_valid        ,
    input                                s_nasti_r_ready        ,
    // DFI interface
    //// DFI read interface
    output [      `C_DFI_ADDR_WIDTH-1:0] dfi_address            ,
    output [      `C_DFI_BANK_WIDTH-1:0] dfi_bank               ,
    output [      `C_DFI_CTRL_WIDTH-1:0] dfi_ras_n              ,
    output [      `C_DFI_CTRL_WIDTH-1:0] dfi_cas_n              ,
    output [      `C_DFI_CTRL_WIDTH-1:0] dfi_we_n               ,
    output [        `C_DFI_CS_WIDTH-1:0] dfi_cs_n               ,
    output [        `C_DFI_CS_WIDTH-1:0] dfi_cke                ,
    output [        `C_DFI_CS_WIDTH-1:0] dfi_odt                ,
    output [        `C_DFI_CS_WIDTH-1:0] dfi_reset_n            ,
    //// DFI write data interface
    output [    `C_DFI_DATAEN_WIDTH-1:0] dfi_wrdata_en          ,
    output [      `C_DFI_DATA_WIDTH-1:0] dfi_wrdata             ,
    output [      `C_DFI_DACS_WIDTH-1:0] dfi_wrdata_cs_n        ,
    output [        `C_DFI_DM_WIDTH-1:0] dfi_wrdata_mask        ,
    //// DFI read data interface
    output [    `C_DFI_DATAEN_WIDTH-1:0] dfi_rddata_en          ,
    input  [      `C_DFI_DATA_WIDTH-1:0] dfi_rddata             ,
    output [      `C_DFI_DACS_WIDTH-1:0] dfi_rddata_cs_n        ,
    input  [    `C_DFI_DATAEN_WIDTH-1:0] dfi_rddata_valid       ,
    //// DFI update interface
    output                               dfi_ctrlupd_req        ,
    input                                dfi_ctrlupd_ack        ,
    input                                dfi_phyupd_req         ,
    input                                dfi_phyupd_type        ,
    output                               dfi_phyupd_ack         ,
    //// DFI status interface
    output                               dfi_data_byte_disable  ,
    output                               dfi_dram_clk_disable   ,
    output [                        1:0] dfi_freq_ratio         ,
    output                               dfi_init_start         ,
    input                                dfi_init_complete      ,
    output                               dfi_parity_in          ,
    input                                dfi_alert_n            ,
    //// DFI training interface
    input                                dfi_rdlvl_req          ,
    input                                dfi_phy_rdlvl_cs_n     ,
    output                               dfi_rdlvl_en           ,
    input                                dfi_rdlvl_resp         ,
    input                                dfi_rdlvl_gate_req     ,
    input                                dfi_phy_rdlvl_gate_cs_n,
    output                               dfi_rdlvl_gate_en      ,
    input                                dfi_wrlvl_req          ,
    input                                dfi_phy_wrlvl_cs_n     ,
    output                               dfi_wrlvl_en           ,
    output                               dfi_wrlvl_strobe       ,
    input                                dfi_wrlvl_resp         ,
    output                               dfi_lvl_periodic       ,
    input                                dfi_phylvl_req_cs_n    ,
    output                               dfi_phylvl_ack_cs_n    ,
    //// DFI low power control interface
    output                               dfi_lp_ctrl_req        ,
    output                               dfi_lp_data_req        ,
    output                               dfi_lp_wakeup          ,
    input                                dfi_lp_ack             ,
    //// DFI error interface
    input  [       `C_DFI_ERR_WIDTH-1:0] dfi_error              ,
    input  [   (4*`C_DFI_ERR_WIDTH)-1:0] dfi_error_info
);

    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH  ),
        .C_NASTI_ADDR_WIDTH(`C_NASTI_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTI_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH)
    ) nasti ();

    logic s_nastilite_clk    ;
    logic s_nastilite_aresetn;
    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH   ),
        .C_NASTI_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTIL_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH )
    ) nastilite ();

    logic core_clk  ;
    logic core_arstn;
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
        .C_DFI_ERR_WIDTH    (`C_DFI_ERR_WIDTH   )
    ) dfi ();

    nasti_ddrx_mc #(
        .C_NASTI_ID_WIDTH   (`C_NASTI_ID_WIDTH   ),
        .C_NASTI_ADDR_WIDTH (`C_NASTI_ADDR_WIDTH ),
        .C_NASTI_DATA_WIDTH (`C_NASTI_DATA_WIDTH ),
        .C_NASTI_USER_WIDTH (`C_NASTI_USER_WIDTH ),
        .C_NASTIL_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
        .C_NASTIL_DATA_WIDTH(`C_NASTIL_DATA_WIDTH)
    ) i_nasti_ddrx_mc (
        .core_clk           (core_clk           ),
        .core_arstn         (core_arstn         ),
        .s_nastilite_clk    (s_nastilite_clk    ),
        .s_nastilite_aresetn(s_nastilite_aresetn),
        .s_nastilite        (nastilite          ),
        .s_nasti_clk        (s_nasti_clk        ),
        .s_nasti_aresetn    (s_nasti_aresetn    ),
        .s_nasti            (nasti              ),
        .m_dfi              (dfi                )
    );

endmodule // top
