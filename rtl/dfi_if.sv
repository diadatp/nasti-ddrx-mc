/**
 * This file defines the DDR PHY interface signals for convenience.
 */

interface dfi_if #(
        C_ROW_WIDTH   = 16, // width of row address
        C_BANK_WIDTH  = 16, // width of bank address
        C_CKE_WIDTH   = 4 , // width of
        C_CK_WIDTH    = 1 ,
        C_CS_WIDTH    = 1 ,
        C_DQ_WIDTH    = 64,
        C_DQS_WIDTH   = 8 ,
        C_CS_PER_RANK = 8 ,
        C_DM_WIDTH    = 4 ,
        C_ODT_WIDTH   = 4
    );

    // DFI control interface
    logic [ C_ROW_WIDTH-1:0] dfi_address;
    logic [C_BANK_WIDTH-1:0] dfi_bank   ;
    logic [ C_CKE_WIDTH-1:0] dfi_ras_n  ;
    logic                    dfi_cas_n  ;
    logic                    dfi_we_n   ;
    logic                    dfi_cs_n   ;
    logic                    dfi_cke    ;
    logic                    dfi_odt    ;
    logic                    dfi_reset_n; // ddr3 only;

    // DFI write data interface
    logic dfi_wrdata_en  ;
    logic dfi_wrdata     ;
    logic dfi_wrdata_cs_n;
    logic dfi_wrdata_mask;

    // DFI read data interface
    logic dfi_rddata_en   ;
    logic dfi_rddata      ;
    logic dfi_rddata_cs_n ;
    logic dfi_rddata_valid;

    // DFI update interface
    logic dfi_ctrlupd_req;
    logic dfi_ctrlupd_ack;
    logic dfi_phyupd_req ;
    logic dfi_phyupd_type;
    logic dfi_phyupd_ack ;

    // DFI status interface
    logic       dfi_data_byte_disable;
    logic       dfi_dram_clk_disable ;
    logic [1:0] dfi_freq_ratio       ;
    logic       dfi_init_start       ;
    logic       dfi_init_complete    ;
    logic       dfi_parity_in        ;
    logic       dfi_alert_n          ;

    // DFI training interface
    logic dfi_rdlvl_req          ; // ddr3 only
    logic dfi_phy_rdlvl_cs_n     ; // ddr3 only
    logic dfi_rdlvl_en           ; // ddr3 only
    logic dfi_rdlvl_resp         ; // ddr3 only
    logic dfi_rdlvl_gate_req     ; // ddr3 only
    logic dfi_phy_rdlvl_gate_cs_n; // ddr3 only
    logic dfi_rdlvl_gate_en      ; // ddr3 only
    logic dfi_wrlvl_req          ; // ddr3 only
    logic dfi_phy_wrlvl_cs_n     ; // ddr3 only
    logic dfi_wrlvl_en           ; // ddr3 only
    logic dfi_wrlvl_strobe       ; // ddr3 only
    logic dfi_wrlvl_resp         ; // ddr3 only
    logic dfi_lvl_periodic       ;
    logic dfi_phylvl_req_cs_n    ;
    logic dfi_phylvl_ack_cs_n    ;

    // DFI low power control interface
    logic dfi_lp_ctrl_req;
    logic dfi_lp_data_req;
    logic dfi_lp_wakeup  ;
    logic dfi_lp_ack     ;

    // DFI error interface
    logic dfi_error     ;
    logic dfi_error_info;

    modport master (
        output dfi_address            ,
        output dfi_bank               ,
        output dfi_ras_n              ,
        output dfi_cas_n              ,
        output dfi_we_n               ,
        output dfi_cs_n               ,
        output dfi_cke                ,
        output dfi_odt                ,
        output dfi_reset_n            , // ddr3 only
        output dfi_wrdata_en          ,
        output dfi_wrdata             ,
        output dfi_wrdata_cs_n        ,
        output dfi_wrdata_mask        ,
        output dfi_rddata_en          ,
        input  dfi_rddata             ,
        output dfi_rddata_cs_n        ,
        input  dfi_rddata_valid       ,
        output dfi_ctrlupd_req        ,
        input  dfi_ctrlupd_ack        ,
        input  dfi_phyupd_req         ,
        input  dfi_phyupd_type        ,
        output dfi_phyupd_ack         ,
        output dfi_data_byte_disable  ,
        output dfi_dram_clk_disable   ,
        output dfi_freq_ratio         ,
        output dfi_init_start         ,
        input  dfi_init_complete      ,
        output dfi_parity_in          ,
        input  dfi_alert_n            ,
        input  dfi_rdlvl_req          , // ddr3 only
        input  dfi_phy_rdlvl_cs_n     , // ddr3 only
        output dfi_rdlvl_en           , // ddr3 only
        input  dfi_rdlvl_resp         , // ddr3 only
        input  dfi_rdlvl_gate_req     , // ddr3 only
        input  dfi_phy_rdlvl_gate_cs_n, // ddr3 only
        output dfi_rdlvl_gate_en      , // ddr3 only
        input  dfi_wrlvl_req          , // ddr3 only
        input  dfi_phy_wrlvl_cs_n     , // ddr3 only
        output dfi_wrlvl_en           , // ddr3 only
        output dfi_wrlvl_strobe       , // ddr3 only
        input  dfi_wrlvl_resp         , // ddr3 only
        output dfi_lvl_periodic       ,
        input  dfi_phylvl_req_cs_n    ,
        output dfi_phylvl_ack_cs_n    ,
        output dfi_lp_ctrl_req        ,
        output dfi_lp_data_req        ,
        output dfi_lp_wakeup          ,
        input  dfi_lp_ack             ,
        input  dfi_error              ,
        input  dfi_error_info
    );

    modport slave (
        input  dfi_address            ,
        input  dfi_bank               ,
        input  dfi_ras_n              ,
        input  dfi_cas_n              ,
        input  dfi_we_n               ,
        input  dfi_cs_n               ,
        input  dfi_cke                ,
        input  dfi_odt                ,
        input  dfi_reset_n            , // ddr3 only
        input  dfi_wrdata_en          ,
        input  dfi_wrdata             ,
        input  dfi_wrdata_cs_n        ,
        input  dfi_wrdata_mask        ,
        input  dfi_rddata_en          ,
        output dfi_rddata             ,
        input  dfi_rddata_cs_n        ,
        output dfi_rddata_valid       ,
        input  dfi_ctrlupd_req        ,
        output dfi_ctrlupd_ack        ,
        output dfi_phyupd_req         ,
        output dfi_phyupd_type        ,
        input  dfi_phyupd_ack         ,
        input  dfi_data_byte_disable  ,
        input  dfi_dram_clk_disable   ,
        input  dfi_freq_ratio         ,
        input  dfi_init_start         ,
        output dfi_init_complete      ,
        input  dfi_parity_in          ,
        output dfi_alert_n            ,
        output dfi_rdlvl_req          , // ddr3 only
        output dfi_phy_rdlvl_cs_n     , // ddr3 only
        input  dfi_rdlvl_en           , // ddr3 only
        output dfi_rdlvl_resp         , // ddr3 only
        output dfi_rdlvl_gate_req     , // ddr3 only
        output dfi_phy_rdlvl_gate_cs_n, // ddr3 only
        input  dfi_rdlvl_gate_en      , // ddr3 only
        output dfi_wrlvl_req          , // ddr3 only
        output dfi_phy_wrlvl_cs_n     , // ddr3 only
        input  dfi_wrlvl_en           , // ddr3 only
        input  dfi_wrlvl_strobe       , // ddr3 only
        output dfi_wrlvl_resp         , // ddr3 only
        input  dfi_lvl_periodic       ,
        output dfi_phylvl_req_cs_n    ,
        input  dfi_phylvl_ack_cs_n    ,
        input  dfi_lp_ctrl_req        ,
        input  dfi_lp_data_req        ,
        input  dfi_lp_wakeup          ,
        output dfi_lp_ack             ,
        output dfi_error              ,
        output dfi_error_info
    );

endinterface // dfi_if