/**
 *
 */

#include "vip_dfi_channel.h"

void vip_dfi_channel::read() {

}

void vip_dfi_channel::write( sc_bv<8>* ) {

}

void vip_dfi_channel::masterBind(Vtop* dut) {

    dut->dfi_bank(dfi_bank);
    dut->dfi_ras_n(dfi_ras_n);
    dut->dfi_cas_n(dfi_cas_n);
    dut->dfi_we_n(dfi_we_n);
    dut->dfi_wrdata_en(dfi_wrdata_en);
    dut->dfi_rddata_en(dfi_rddata_en);
    dut->dfi_rddata_valid(dfi_rddata_valid);
    dut->dfi_ctrlupd_req(dfi_ctrlupd_req);
    dut->dfi_ctrlupd_ack(dfi_ctrlupd_ack);
    dut->dfi_phyupd_req(dfi_phyupd_req);
    dut->dfi_phyupd_type(dfi_phyupd_type);
    dut->dfi_phyupd_ack(dfi_phyupd_ack);
    dut->dfi_data_byte_disable(dfi_data_byte_disable);
    dut->dfi_dram_clk_disable(dfi_dram_clk_disable);
    dut->dfi_freq_ratio(dfi_freq_ratio);
    dut->dfi_init_start(dfi_init_start);
    dut->dfi_init_complete(dfi_init_complete);
    dut->dfi_parity_in(dfi_parity_in);
    dut->dfi_alert_n(dfi_alert_n);
    dut->dfi_rdlvl_req(dfi_rdlvl_req);
    dut->dfi_phy_rdlvl_cs_n(dfi_phy_rdlvl_cs_n);
    dut->dfi_rdlvl_en(dfi_rdlvl_en);
    dut->dfi_rdlvl_resp(dfi_rdlvl_resp);
    dut->dfi_rdlvl_gate_req(dfi_rdlvl_gate_req);
    dut->dfi_phy_rdlvl_gate_cs_n(dfi_phy_rdlvl_gate_cs_n);
    dut->dfi_rdlvl_gate_en(dfi_rdlvl_gate_en);
    dut->dfi_wrlvl_req(dfi_wrlvl_req);
    dut->dfi_phy_wrlvl_cs_n(dfi_phy_wrlvl_cs_n);
    dut->dfi_wrlvl_en(dfi_wrlvl_en);
    dut->dfi_wrlvl_strobe(dfi_wrlvl_strobe);
    dut->dfi_wrlvl_resp(dfi_wrlvl_resp);
    dut->dfi_lvl_periodic(dfi_lvl_periodic);
    dut->dfi_phylvl_req_cs_n(dfi_phylvl_req_cs_n);
    dut->dfi_phylvl_ack_cs_n(dfi_phylvl_ack_cs_n);
    dut->dfi_lp_ctrl_req(dfi_lp_ctrl_req);
    dut->dfi_lp_data_req(dfi_lp_data_req);
    dut->dfi_lp_wakeup(dfi_lp_wakeup);
    dut->dfi_lp_ack(dfi_lp_ack);
    dut->dfi_address(dfi_address);
    dut->dfi_cs_n(dfi_cs_n);
    dut->dfi_cke(dfi_cke);
    dut->dfi_odt(dfi_odt);
    dut->dfi_reset_n(dfi_reset_n);
    dut->dfi_wrdata_mask(dfi_wrdata_mask);
    dut->dfi_error(dfi_error);
    dut->dfi_error_info(dfi_error_info);
    dut->dfi_wrdata(dfi_wrdata);
    dut->dfi_wrdata_cs_n(dfi_wrdata_cs_n);
    dut->dfi_rddata(dfi_rddata);
    dut->dfi_rddata_cs_n(dfi_rddata_cs_n);

    // dfi_bank(dfi_bank_s);
    // dfi_ras_n(dfi_ras_n_s);
    // dfi_cas_n(dfi_cas_n_s);
    // dfi_we_n(dfi_we_n_s);
    // dfi_wrdata_en(dfi_wrdata_en_s);
    // dfi_rddata_en(dfi_rddata_en_s);
    // dfi_rddata_valid(dfi_rddata_valid_s);
    // dfi_ctrlupd_req(dfi_ctrlupd_req_s);
    // dfi_ctrlupd_ack(dfi_ctrlupd_ack_s);
    // dfi_phyupd_req(dfi_phyupd_req_s);
    // dfi_phyupd_type(dfi_phyupd_type_s);
    // dfi_phyupd_ack(dfi_phyupd_ack_s);
    // dfi_data_byte_disable(dfi_data_byte_disable_s);
    // dfi_dram_clk_disable(dfi_dram_clk_disable_s);
    // dfi_freq_ratio(dfi_freq_ratio_s);
    // dfi_init_start(dfi_init_start_s);
    // dfi_init_complete(dfi_init_complete_s);
    // dfi_parity_in(dfi_parity_in_s);
    // dfi_alert_n(dfi_alert_n_s);
    // dfi_rdlvl_req(dfi_rdlvl_req_s);
    // dfi_phy_rdlvl_cs_n(dfi_phy_rdlvl_cs_n_s);
    // dfi_rdlvl_en(dfi_rdlvl_en_s);
    // dfi_rdlvl_resp(dfi_rdlvl_resp_s);
    // dfi_rdlvl_gate_req(dfi_rdlvl_gate_req_s);
    // dfi_phy_rdlvl_gate_cs_n(dfi_phy_rdlvl_gate_cs_n_s);
    // dfi_rdlvl_gate_en(dfi_rdlvl_gate_en_s);
    // dfi_wrlvl_req(dfi_wrlvl_req_s);
    // dfi_phy_wrlvl_cs_n(dfi_phy_wrlvl_cs_n_s);
    // dfi_wrlvl_en(dfi_wrlvl_en_s);
    // dfi_wrlvl_strobe(dfi_wrlvl_strobe_s);
    // dfi_wrlvl_resp(dfi_wrlvl_resp_s);
    // dfi_lvl_periodic(dfi_lvl_periodic_s);
    // dfi_phylvl_req_cs_n(dfi_phylvl_req_cs_n_s);
    // dfi_phylvl_ack_cs_n(dfi_phylvl_ack_cs_n_s);
    // dfi_lp_ctrl_req(dfi_lp_ctrl_req_s);
    // dfi_lp_data_req(dfi_lp_data_req_s);
    // dfi_lp_wakeup(dfi_lp_wakeup_s);
    // dfi_lp_ack(dfi_lp_ack_s);
    // dfi_address(dfi_address_s);
    // dfi_cs_n(dfi_cs_n_s);
    // dfi_cke(dfi_cke_s);
    // dfi_odt(dfi_odt_s);
    // dfi_reset_n(dfi_reset_n_s);
    // dfi_wrdata_mask(dfi_wrdata_mask_s);
    // dfi_error(dfi_error_s);
    // dfi_error_info(dfi_error_info_s);
    // dfi_wrdata(dfi_wrdata_s);
    // dfi_wrdata_cs_n(dfi_wrdata_cs_n_s);
    // dfi_rddata(dfi_rddata_s);
    // dfi_rddata_cs_n(dfi_rddata_cs_n_s);
}
