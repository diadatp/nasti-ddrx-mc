/**
 *
 */

#ifndef VIP_DFI_CHANNEL_H
#define VIP_DFI_CHANNEL_H

#include <systemc>

#include "Vtop.h"

#include "vip_dfi_if.h"

class vip_dfi_channel : public vip_dfi_if, public sc_channel {

  public:

    sc_signal<uint32_t> dfi_bank;
    sc_signal<bool> dfi_ras_n;
    sc_signal<bool> dfi_cas_n;
    sc_signal<bool> dfi_we_n;
    sc_signal<uint32_t> dfi_wrdata_en;
    sc_signal<uint32_t> dfi_rddata_en;
    sc_signal<uint32_t>    dfi_rddata_valid;
    sc_signal<bool> dfi_ctrlupd_req;
    sc_signal<bool>    dfi_ctrlupd_ack;
    sc_signal<bool>    dfi_phyupd_req;
    sc_signal<bool>    dfi_phyupd_type;
    sc_signal<bool> dfi_phyupd_ack;
    sc_signal<bool> dfi_data_byte_disable;
    sc_signal<bool> dfi_dram_clk_disable;
    sc_signal<uint32_t> dfi_freq_ratio;
    sc_signal<bool> dfi_init_start;
    sc_signal<bool>    dfi_init_complete;
    sc_signal<bool> dfi_parity_in;
    sc_signal<bool>    dfi_alert_n;
    sc_signal<bool>    dfi_rdlvl_req;
    sc_signal<bool>    dfi_phy_rdlvl_cs_n;
    sc_signal<bool> dfi_rdlvl_en;
    sc_signal<bool>    dfi_rdlvl_resp;
    sc_signal<bool>    dfi_rdlvl_gate_req;
    sc_signal<bool>    dfi_phy_rdlvl_gate_cs_n;
    sc_signal<bool> dfi_rdlvl_gate_en;
    sc_signal<bool>    dfi_wrlvl_req;
    sc_signal<bool>    dfi_phy_wrlvl_cs_n;
    sc_signal<bool> dfi_wrlvl_en;
    sc_signal<bool> dfi_wrlvl_strobe;
    sc_signal<bool>    dfi_wrlvl_resp;
    sc_signal<bool> dfi_lvl_periodic;
    sc_signal<bool>    dfi_phylvl_req_cs_n;
    sc_signal<bool> dfi_phylvl_ack_cs_n;
    sc_signal<bool> dfi_lp_ctrl_req;
    sc_signal<bool> dfi_lp_data_req;
    sc_signal<bool> dfi_lp_wakeup;
    sc_signal<bool>    dfi_lp_ack;
    sc_signal<uint32_t> dfi_address;
    sc_signal<uint32_t> dfi_cs_n;
    sc_signal<uint32_t> dfi_cke;
    sc_signal<uint32_t> dfi_odt;
    sc_signal<uint32_t> dfi_reset_n;
    sc_signal<uint32_t> dfi_wrdata_mask;
    sc_signal<uint32_t>    dfi_error;
    sc_signal<vluint64_t>  dfi_error_info;
    sc_signal<sc_bv<128> >  dfi_wrdata;
    sc_signal<sc_bv<128> >  dfi_wrdata_cs_n;
    sc_signal<sc_bv<128> > dfi_rddata;
    sc_signal<sc_bv<128> >  dfi_rddata_cs_n;

    vip_dfi_channel (sc_module_name name) :
        sc_channel(name) {
        dfi_rddata_valid = 0;
        dfi_ctrlupd_ack = 0;
        dfi_phyupd_req = 0;
        dfi_phyupd_type = 0;
        dfi_init_complete = 0;
        dfi_alert_n = 0;
        dfi_rdlvl_req = 0;
        dfi_phy_rdlvl_cs_n = 0;
        dfi_rdlvl_resp = 0;
        dfi_rdlvl_gate_req = 0;
        dfi_phy_rdlvl_gate_cs_n = 0;
        dfi_wrlvl_req = 0;
        dfi_phy_wrlvl_cs_n = 0;
        dfi_wrlvl_resp = 0;
        dfi_phylvl_req_cs_n = 0;
        dfi_lp_ack = 0;
        dfi_error = 0;
        dfi_error_info = 0;
        dfi_rddata = 0;
    }

    virtual void read();
    virtual void write( sc_bv<8>* );
    virtual void masterBind(Vtop*);

  private:

    sc_signal<uint32_t> dfi_bank_s;
    sc_signal<bool> dfi_ras_n_s;
    sc_signal<bool> dfi_cas_n_s;
    sc_signal<bool> dfi_we_n_s;
    sc_signal<uint32_t> dfi_wrdata_en_s;
    sc_signal<uint32_t> dfi_rddata_en_s;
    sc_signal<uint32_t>    dfi_rddata_valid_s;
    sc_signal<bool> dfi_ctrlupd_req_s;
    sc_signal<bool>    dfi_ctrlupd_ack_s;
    sc_signal<bool>    dfi_phyupd_req_s;
    sc_signal<bool>    dfi_phyupd_type_s;
    sc_signal<bool> dfi_phyupd_ack_s;
    sc_signal<bool> dfi_data_byte_disable_s;
    sc_signal<bool> dfi_dram_clk_disable_s;
    sc_signal<uint32_t> dfi_freq_ratio_s;
    sc_signal<bool> dfi_init_start_s;
    sc_signal<bool>    dfi_init_complete_s;
    sc_signal<bool> dfi_parity_in_s;
    sc_signal<bool>    dfi_alert_n_s;
    sc_signal<bool>    dfi_rdlvl_req_s;
    sc_signal<bool>    dfi_phy_rdlvl_cs_n_s;
    sc_signal<bool> dfi_rdlvl_en_s;
    sc_signal<bool>    dfi_rdlvl_resp_s;
    sc_signal<bool>    dfi_rdlvl_gate_req_s;
    sc_signal<bool>    dfi_phy_rdlvl_gate_cs_n_s;
    sc_signal<bool> dfi_rdlvl_gate_en_s;
    sc_signal<bool>    dfi_wrlvl_req_s;
    sc_signal<bool>    dfi_phy_wrlvl_cs_n_s;
    sc_signal<bool> dfi_wrlvl_en_s;
    sc_signal<bool> dfi_wrlvl_strobe_s;
    sc_signal<bool>    dfi_wrlvl_resp_s;
    sc_signal<bool> dfi_lvl_periodic_s;
    sc_signal<bool>    dfi_phylvl_req_cs_n_s;
    sc_signal<bool> dfi_phylvl_ack_cs_n_s;
    sc_signal<bool> dfi_lp_ctrl_req_s;
    sc_signal<bool> dfi_lp_data_req_s;
    sc_signal<bool> dfi_lp_wakeup_s;
    sc_signal<bool>    dfi_lp_ack_s;
    sc_signal<uint32_t> dfi_address_s;
    sc_signal<uint32_t> dfi_cs_n_s;
    sc_signal<uint32_t> dfi_cke_s;
    sc_signal<uint32_t> dfi_odt_s;
    sc_signal<uint32_t> dfi_reset_n_s;
    sc_signal<uint32_t> dfi_wrdata_mask_s;
    sc_signal<uint32_t>    dfi_error_s;
    sc_signal<vluint64_t>  dfi_error_info_s;
    sc_signal< sc_bv<128> >  dfi_wrdata_s;
    sc_signal< sc_bv<128> >  dfi_wrdata_cs_n_s;
    sc_signal< sc_bv<128> > dfi_rddata_s;
    sc_signal< sc_bv<128> >  dfi_rddata_cs_n_s;

};

#endif /* VIP_DFI_CHANNEL_H */
