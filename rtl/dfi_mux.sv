/**
 *
 */

`include "timescale.svh"

module dfi_mux (
    dfi_if.slave  cali_dfi,
    dfi_if.slave  data_dfi,
    dfi_if.slave  init_dfi,
    dfi_if.slave  main_dfi,
    dfi_if.slave  tran_dfi,
    input [1:0]   sel     ,
    dfi_if.master m_dfi
);

    always_comb begin : proc_assign
        // data
        m_dfi.dfi_wrdata            = data_dfi.dfi_wrdata;
        data_dfi.dfi_rddata         = main_dfi.dfi_rddata;
        // init
        m_dfi.dfi_address           = init_dfi.dfi_address;
        m_dfi.dfi_bank              = init_dfi.dfi_bank;
        m_dfi.dfi_ras_n             = init_dfi.dfi_ras_n;
        m_dfi.dfi_cas_n             = init_dfi.dfi_cas_n;
        m_dfi.dfi_we_n              = init_dfi.dfi_we_n;
        m_dfi.dfi_cs_n              = init_dfi.dfi_cs_n;
        m_dfi.dfi_cke               = init_dfi.dfi_cke;
        m_dfi.dfi_odt               = init_dfi.dfi_odt;
        m_dfi.dfi_reset_n           = init_dfi.dfi_reset_n;
        m_dfi.dfi_dram_clk_disable  = init_dfi.dfi_dram_clk_disable;
        // main
        m_dfi.dfi_data_byte_disable = main_dfi.dfi_data_byte_disable;
        m_dfi.dfi_freq_ratio        = main_dfi.dfi_freq_ratio;
        m_dfi.dfi_init_start        = main_dfi.dfi_init_start;
        main_dfi.dfi_init_complete  = m_dfi.dfi_init_complete;
        // tran
        m_dfi.dfi_wrdata_en         = tran_dfi.dfi_wrdata_en;
        m_dfi.dfi_wrdata_cs_n       = tran_dfi.dfi_wrdata_cs_n;
        m_dfi.dfi_wrdata_mask       = tran_dfi.dfi_wrdata_mask;
        m_dfi.dfi_rddata_en         = tran_dfi.dfi_rddata_en;
        m_dfi.dfi_rddata_cs_n       = tran_dfi.dfi_rddata_cs_n;
        tran_dfi.dfi_rddata_valid   = main_dfi.dfi_rddata_valid;
    end

endmodule // dfi_mux
