/**
*
*/

`timescale 1ps / 1ps

`include "defines.svh"

module top (
    input                                 core_clk               ,
    input                                 core_arstn             ,
    // NASTI interface
    input                                 s_nasti_clk            ,
    input                                 s_nasti_aresetn        ,
    //// NASTI slave write address channel
    input  [       `C_NASTI_ID_WIDTH-1:0] s_nasti_aw_id          ,
    input  [     `C_NASTI_ADDR_WIDTH-1:0] s_nasti_aw_addr        ,
    input  [                         7:0] s_nasti_aw_len         ,
    input  [                         2:0] s_nasti_aw_size        ,
    input  [                         1:0] s_nasti_aw_burst       ,
    input                                 s_nasti_aw_lock        ,
    input  [                         3:0] s_nasti_aw_cache       ,
    input  [                         2:0] s_nasti_aw_prot        ,
    input  [                         3:0] s_nasti_aw_qos         ,
    input  [                         3:0] s_nasti_aw_region      ,
    input  [     `C_NASTI_USER_WIDTH-1:0] s_nasti_aw_user        ,
    input                                 s_nasti_aw_valid       ,
    output                                s_nasti_aw_ready       ,
    //// NASTI slave write data channel
    input  [     `C_NASTI_DATA_WIDTH-1:0] s_nasti_w_data         ,
    input  [ (`C_NASTI_DATA_WIDTH/8)-1:0] s_nasti_w_strb         ,
    input                                 s_nasti_w_last         ,
    input  [     `C_NASTI_USER_WIDTH-1:0] s_nasti_w_user         ,
    input                                 s_nasti_w_valid        ,
    output                                s_nasti_w_ready        ,
    //// NASTI slave write response channel
    output [       `C_NASTI_ID_WIDTH-1:0] s_nasti_b_id           ,
    output [                         1:0] s_nasti_b_resp         ,
    output [     `C_NASTI_USER_WIDTH-1:0] s_nasti_b_user         ,
    output                                s_nasti_b_valid        ,
    input                                 s_nasti_b_ready        ,
    //// NASTI slave read address channel
    input  [       `C_NASTI_ID_WIDTH-1:0] s_nasti_ar_id          ,
    input  [     `C_NASTI_ADDR_WIDTH-1:0] s_nasti_ar_addr        ,
    input  [                         7:0] s_nasti_ar_len         ,
    input  [                         2:0] s_nasti_ar_size        ,
    input  [                         1:0] s_nasti_ar_burst       ,
    input  [                         0:0] s_nasti_ar_lock        ,
    input  [                         3:0] s_nasti_ar_cache       ,
    input  [                         2:0] s_nasti_ar_prot        ,
    input  [                         3:0] s_nasti_ar_qos         ,
    input  [                         3:0] s_nasti_ar_region      ,
    input  [     `C_NASTI_USER_WIDTH-1:0] s_nasti_ar_user        ,
    input                                 s_nasti_ar_valid       ,
    output                                s_nasti_ar_ready       ,
    //// NASTI slave read data channel
    output [       `C_NASTI_ID_WIDTH-1:0] s_nasti_r_id           ,
    output [     `C_NASTI_DATA_WIDTH-1:0] s_nasti_r_data         ,
    output [                         1:0] s_nasti_r_resp         ,
    output                                s_nasti_r_last         ,
    output [     `C_NASTI_USER_WIDTH-1:0] s_nasti_r_user         ,
    output                                s_nasti_r_valid        ,
    input                                 s_nasti_r_ready        ,
    // // NASTI-Lite interface
    // input                                 s_nastil_clk           ,
    // input                                 s_nastil_aresetn       ,
    // //// NASTI-Lite slave write address channel
    // input  [    `C_NASTIL_ADDR_WIDTH-1:0] s_nastil_aw_addr       ,
    // input  [                         7:0] s_nastil_aw_len        ,
    // input  [                         2:0] s_nastil_aw_size       ,
    // input  [                         1:0] s_nastil_aw_burst      ,
    // input                                 s_nastil_aw_lock       ,
    // input  [                         3:0] s_nastil_aw_cache      ,
    // input  [                         2:0] s_nastil_aw_prot       ,
    // input  [                         3:0] s_nastil_aw_qos        ,
    // input  [                         3:0] s_nastil_aw_region     ,
    // input  [    `C_NASTIL_USER_WIDTH-1:0] s_nastil_aw_user       ,
    // input                                 s_nastil_aw_valid      ,
    // output                                s_nastil_aw_ready      ,
    // //// NASTI-Lite slave write data channel
    // input  [    `C_NASTIL_DATA_WIDTH-1:0] s_nastil_w_data        ,
    // input  [(`C_NASTIL_DATA_WIDTH/8)-1:0] s_nastil_w_strb        ,
    // input                                 s_nastil_w_last        ,
    // input  [    `C_NASTIL_USER_WIDTH-1:0] s_nastil_w_user        ,
    // input                                 s_nastil_w_valid       ,
    // output                                s_nastil_w_ready       ,
    // //// NASTI-Lite slave write response channel
    // output [                         1:0] s_nastil_b_resp        ,
    // output [    `C_NASTIL_USER_WIDTH-1:0] s_nastil_b_user        ,
    // output                                s_nastil_b_valid       ,
    // input                                 s_nastil_b_ready       ,
    // //// NASTI-Lite slave read address channel
    // input  [    `C_NASTIL_ADDR_WIDTH-1:0] s_nastil_ar_addr       ,
    // input  [                         7:0] s_nastil_ar_len        ,
    // input  [                         2:0] s_nastil_ar_size       ,
    // input  [                         1:0] s_nastil_ar_burst      ,
    // input  [                         0:0] s_nastil_ar_lock       ,
    // input  [                         3:0] s_nastil_ar_cache      ,
    // input  [                         2:0] s_nastil_ar_prot       ,
    // input  [                         3:0] s_nastil_ar_qos        ,
    // input  [                         3:0] s_nastil_ar_region     ,
    // input  [    `C_NASTIL_USER_WIDTH-1:0] s_nastil_ar_user       ,
    // input                                 s_nastil_ar_valid      ,
    // output                                s_nastil_ar_ready      ,
    // //// NASTI-Lite slave read data channel
    // output [    `C_NASTIL_DATA_WIDTH-1:0] s_nastil_r_data        ,
    // output [                         1:0] s_nastil_r_resp        ,
    // output                                s_nastil_r_last        ,
    // output [    `C_NASTIL_USER_WIDTH-1:0] s_nastil_r_user        ,
    // output                                s_nastil_r_valid       ,
    // input                                 s_nastil_r_ready       ,
    // DFI interface
    //// DFI read interface
    output [       `C_DFI_ADDR_WIDTH-1:0] dfi_address            ,
    output [       `C_DFI_BANK_WIDTH-1:0] dfi_bank               ,
    output [       `C_DFI_CTRL_WIDTH-1:0] dfi_ras_n              ,
    output [       `C_DFI_CTRL_WIDTH-1:0] dfi_cas_n              ,
    output [       `C_DFI_CTRL_WIDTH-1:0] dfi_we_n               ,
    output [         `C_DFI_CS_WIDTH-1:0] dfi_cs_n               ,
    output [         `C_DFI_CS_WIDTH-1:0] dfi_cke                ,
    output [         `C_DFI_CS_WIDTH-1:0] dfi_odt                ,
    output [         `C_DFI_CS_WIDTH-1:0] dfi_reset_n            ,
    //// DFI write data interface
    output [     `C_DFI_DATAEN_WIDTH-1:0] dfi_wrdata_en          ,
    output [       `C_DFI_DATA_WIDTH-1:0] dfi_wrdata             ,
    output [       `C_DFI_DACS_WIDTH-1:0] dfi_wrdata_cs_n        ,
    output [         `C_DFI_DM_WIDTH-1:0] dfi_wrdata_mask        ,
    //// DFI read data interface
    output [     `C_DFI_DATAEN_WIDTH-1:0] dfi_rddata_en          ,
    input  [       `C_DFI_DATA_WIDTH-1:0] dfi_rddata             ,
    output [       `C_DFI_DACS_WIDTH-1:0] dfi_rddata_cs_n        ,
    input  [     `C_DFI_DATAEN_WIDTH-1:0] dfi_rddata_valid       ,
    //// DFI update interface
    output                                dfi_ctrlupd_req        ,
    input                                 dfi_ctrlupd_ack        ,
    input                                 dfi_phyupd_req         ,
    input                                 dfi_phyupd_type        ,
    output                                dfi_phyupd_ack         ,
    //// DFI status interface
    output                                dfi_data_byte_disable  ,
    output                                dfi_dram_clk_disable   ,
    output [                         1:0] dfi_freq_ratio         ,
    output                                dfi_init_start         ,
    input                                 dfi_init_complete      ,
    output                                dfi_parity_in          ,
    input                                 dfi_alert_n            ,
    //// DFI training interface
    input                                 dfi_rdlvl_req          ,
    input                                 dfi_phy_rdlvl_cs_n     ,
    output                                dfi_rdlvl_en           ,
    input                                 dfi_rdlvl_resp         ,
    input                                 dfi_rdlvl_gate_req     ,
    input                                 dfi_phy_rdlvl_gate_cs_n,
    output                                dfi_rdlvl_gate_en      ,
    input                                 dfi_wrlvl_req          ,
    input                                 dfi_phy_wrlvl_cs_n     ,
    output                                dfi_wrlvl_en           ,
    output                                dfi_wrlvl_strobe       ,
    input                                 dfi_wrlvl_resp         ,
    output                                dfi_lvl_periodic       ,
    input                                 dfi_phylvl_req_cs_n    ,
    output                                dfi_phylvl_ack_cs_n    ,
    //// DFI low power control interface
    output                                dfi_lp_ctrl_req        ,
    output                                dfi_lp_data_req        ,
    output                                dfi_lp_wakeup          ,
    input                                 dfi_lp_ack             ,
    //// DFI error interface
    input  [        `C_DFI_ERR_WIDTH-1:0] dfi_error              ,
    input  [    (4*`C_DFI_ERR_WIDTH)-1:0] dfi_error_info
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

    nasti_ddrx_mc #(
        .C_NASTI_ID_WIDTH   (`C_NASTI_ID_WIDTH   ),
        .C_NASTI_ADDR_WIDTH (`C_NASTI_ADDR_WIDTH ),
        .C_NASTI_DATA_WIDTH (`C_NASTI_DATA_WIDTH ),
        .C_NASTI_USER_WIDTH (`C_NASTI_USER_WIDTH ),
        .C_NASTIL_ADDR_WIDTH(`C_NASTIL_ADDR_WIDTH),
        .C_NASTIL_DATA_WIDTH(`C_NASTIL_DATA_WIDTH)
    ) i_nasti_ddrx_mc (
        .core_clk           (core_clk        ),
        .core_arstn         (core_arstn      ),
        .s_nastilite_clk    (s_nastil_clk    ),
        .s_nastilite_aresetn(s_nastil_aresetn),
        .s_nastilite        (nastilite       ),
        .s_nasti_clk        (s_nasti_clk     ),
        .s_nasti_aresetn    (s_nasti_aresetn ),
        .s_nasti            (nasti           ),
        .m_dfi              (dfi             )
    );


    assign nasti.aw_id      = s_nasti_aw_id;
    assign nasti.aw_addr    = s_nasti_aw_addr;
    assign nasti.aw_len     = s_nasti_aw_len;
    assign nasti.aw_size    = s_nasti_aw_size;
    assign nasti.aw_burst   = s_nasti_aw_burst;
    assign nasti.aw_lock    = s_nasti_aw_lock;
    assign nasti.aw_cache   = s_nasti_aw_cache;
    assign nasti.aw_prot    = s_nasti_aw_prot;
    assign nasti.aw_qos     = s_nasti_aw_qos;
    assign nasti.aw_region  = s_nasti_aw_region;
    assign nasti.aw_user    = s_nasti_aw_user;
    assign nasti.aw_valid   = s_nasti_aw_valid;
    assign s_nasti_aw_ready = nasti.aw_ready;
    assign nasti.w_data     = s_nasti_w_data;
    assign nasti.w_strb     = s_nasti_w_strb;
    assign nasti.w_last     = s_nasti_w_last;
    assign nasti.w_user     = s_nasti_w_user;
    assign nasti.w_valid    = s_nasti_w_valid;
    assign s_nasti_w_ready  = nasti.w_ready;
    assign s_nasti_b_id     = nasti.b_id;
    assign s_nasti_b_resp   = nasti.b_resp;
    assign s_nasti_b_user   = nasti.b_user;
    assign s_nasti_b_valid  = nasti.b_valid;
    assign nasti.b_ready    = s_nasti_b_ready;
    assign nasti.ar_id      = s_nasti_ar_id;
    assign nasti.ar_addr    = s_nasti_ar_addr;
    assign nasti.ar_len     = s_nasti_ar_len;
    assign nasti.ar_size    = s_nasti_ar_size;
    assign nasti.ar_burst   = s_nasti_ar_burst;
    assign nasti.ar_lock    = s_nasti_ar_lock;
    assign nasti.ar_cache   = s_nasti_ar_cache;
    assign nasti.ar_prot    = s_nasti_ar_prot;
    assign nasti.ar_qos     = s_nasti_ar_qos;
    assign nasti.ar_region  = s_nasti_ar_region;
    assign nasti.ar_user    = s_nasti_ar_user;
    assign nasti.ar_valid   = s_nasti_ar_valid;
    assign s_nasti_ar_ready = nasti.ar_ready;
    assign s_nasti_r_id     = nasti.r_id;
    assign s_nasti_r_data   = nasti.r_data;
    assign s_nasti_r_resp   = nasti.r_resp;
    assign s_nasti_r_last   = nasti.r_last;
    assign s_nasti_r_user   = nasti.r_user;
    assign s_nasti_r_valid  = nasti.r_valid;
    assign nasti.r_ready    = s_nasti_r_ready;

    // assign nastilite.aw_addr   = s_nastil_aw_addr;
    // assign nastilite.aw_len    = s_nastil_aw_len;
    // assign nastilite.aw_size   = s_nastil_aw_size;
    // assign nastilite.aw_burst  = s_nastil_aw_burst;
    // assign nastilite.aw_lock   = s_nastil_aw_lock;
    // assign nastilite.aw_cache  = s_nastil_aw_cache;
    // assign nastilite.aw_prot   = s_nastil_aw_prot;
    // assign nastilite.aw_qos    = s_nastil_aw_qos;
    // assign nastilite.aw_region = s_nastil_aw_region;
    // assign nastilite.aw_user   = s_nastil_aw_user;
    // assign nastilite.aw_valid  = s_nastil_aw_valid;
    // assign s_nastil_aw_ready   = nastilite.aw_ready;
    // assign nastilite.w_data    = s_nastil_w_data;
    // assign nastilite.w_strb    = s_nastil_w_strb;
    // assign nastilite.w_last    = s_nastil_w_last;
    // assign nastilite.w_user    = s_nastil_w_user;
    // assign nastilite.w_valid   = s_nastil_w_valid;
    // assign s_nastil_w_ready    = nastilite.w_ready;
    // assign s_nastil_b_resp     = nastilite.b_resp;
    // assign s_nastil_b_user     = nastilite.b_user;
    // assign s_nastil_b_valid    = nastilite.b_valid;
    // assign nastilite.b_ready   = s_nastil_b_ready;
    // assign nastilite.ar_addr   = s_nastil_ar_addr;
    // assign nastilite.ar_len    = s_nastil_ar_len;
    // assign nastilite.ar_size   = s_nastil_ar_size;
    // assign nastilite.ar_burst  = s_nastil_ar_burst;
    // assign nastilite.ar_lock   = s_nastil_ar_lock;
    // assign nastilite.ar_cache  = s_nastil_ar_cache;
    // assign nastilite.ar_prot   = s_nastil_ar_prot;
    // assign nastilite.ar_qos    = s_nastil_ar_qos;
    // assign nastilite.ar_region = s_nastil_ar_region;
    // assign nastilite.ar_user   = s_nastil_ar_user;
    // assign nastilite.ar_valid  = s_nastil_ar_valid;
    // assign s_nastil_ar_ready   = nastilite.ar_ready;
    // assign s_nastil_r_data     = nastilite.r_data;
    // assign s_nastil_r_resp     = nastilite.r_resp;
    // assign s_nastil_r_last     = nastilite.r_last;
    // assign s_nastil_r_user     = nastilite.r_user;
    // assign s_nastil_r_valid    = nastilite.r_valid;
    // assign nastilite.r_ready   = s_nastil_r_ready;

    assign dfi_address                 = dfi.dfi_address;
    assign dfi_bank                    = dfi.dfi_bank;
    assign dfi_ras_n                   = dfi.dfi_ras_n;
    assign dfi_cas_n                   = dfi.dfi_cas_n;
    assign dfi_we_n                    = dfi.dfi_we_n;
    assign dfi_cs_n                    = dfi.dfi_cs_n;
    assign dfi_cke                     = dfi.dfi_cke;
    assign dfi_odt                     = dfi.dfi_odt;
    assign dfi_reset_n                 = dfi.dfi_reset_n;
    assign dfi_wrdata_en               = dfi.dfi_wrdata_en;
    assign dfi_wrdata                  = dfi.dfi_wrdata;
    assign dfi_wrdata_cs_n             = dfi.dfi_wrdata_cs_n;
    assign dfi_wrdata_mask             = dfi.dfi_wrdata_mask;
    assign dfi_rddata_en               = dfi.dfi_rddata_en;
    assign dfi.dfi_rddata              = dfi_rddata;
    assign dfi_rddata_cs_n             = dfi.dfi_rddata_cs_n;
    assign dfi.dfi_rddata_valid        = dfi_rddata_valid;
    assign dfi_ctrlupd_req             = dfi.dfi_ctrlupd_req;
    assign dfi.dfi_ctrlupd_ack         = dfi_ctrlupd_ack;
    assign dfi.dfi_phyupd_req          = dfi_phyupd_req;
    assign dfi.dfi_phyupd_type         = dfi_phyupd_type;
    assign dfi_phyupd_ack              = dfi.dfi_phyupd_ack;
    assign dfi_data_byte_disable       = dfi.dfi_data_byte_disable;
    assign dfi_dram_clk_disable        = dfi.dfi_dram_clk_disable;
    assign dfi_freq_ratio              = dfi.dfi_freq_ratio;
    assign dfi_init_start              = dfi.dfi_init_start;
    assign dfi.dfi_init_complete       = dfi_init_complete;
    assign dfi_parity_in               = dfi.dfi_parity_in;
    assign dfi.dfi_alert_n             = dfi_alert_n;
    assign dfi.dfi_rdlvl_req           = dfi_rdlvl_req;
    assign dfi.dfi_phy_rdlvl_cs_n      = dfi_phy_rdlvl_cs_n;
    assign dfi_rdlvl_en                = dfi.dfi_rdlvl_en;
    assign dfi.dfi_rdlvl_resp          = dfi_rdlvl_resp;
    assign dfi.dfi_rdlvl_gate_req      = dfi_rdlvl_gate_req;
    assign dfi.dfi_phy_rdlvl_gate_cs_n = dfi_phy_rdlvl_gate_cs_n;
    assign dfi_rdlvl_gate_en           = dfi.dfi_rdlvl_gate_en;
    assign dfi.dfi_wrlvl_req           = dfi_wrlvl_req;
    assign dfi.dfi_phy_wrlvl_cs_n      = dfi_phy_wrlvl_cs_n;
    assign dfi_wrlvl_en                = dfi.dfi_wrlvl_en;
    assign dfi_wrlvl_strobe            = dfi.dfi_wrlvl_strobe;
    assign dfi.dfi_wrlvl_resp          = dfi_wrlvl_resp;
    assign dfi_lvl_periodic            = dfi.dfi_lvl_periodic;
    assign dfi.dfi_phylvl_req_cs_n     = dfi_phylvl_req_cs_n;
    assign dfi_phylvl_ack_cs_n         = dfi.dfi_phylvl_ack_cs_n;
    assign dfi_lp_ctrl_req             = dfi.dfi_lp_ctrl_req;
    assign dfi_lp_data_req             = dfi.dfi_lp_data_req;
    assign dfi_lp_wakeup               = dfi.dfi_lp_wakeup;
    assign dfi.dfi_lp_ack              = dfi_lp_ack;
    assign dfi.dfi_error               = dfi_error;
    assign dfi.dfi_error_info          = dfi_error_info;

endmodule // top
