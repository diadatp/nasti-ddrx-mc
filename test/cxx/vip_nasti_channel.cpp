/**
 *
 */

#include "vip_nasti_channel.h"

bool vip_nasti_channel::burstRead( uint64_t id, uint64_t addr, uint64_t len ) {

    for (int i = 0; i < len; i++) {
        ar_id->write(id);
        ar_addr->write(addr);
        ar_len->write(len);
        ar_size->write(128);
        ar_burst->write(0);
        ar_lock->write(0);
        ar_cache->write(0);
        ar_prot->write(0);
        ar_qos->write(0);
        ar_region->write(0);
        ar_user->write(0);

        // NASTI handshake
        ar_valid->write(1);
        do {
            wait();
        } while (!ar_ready->read());
        ar_valid->write(0);
    }

    return true;

}

bool vip_nasti_channel::burstWrite( uint64_t id, uint64_t addr, uint64_t len, sc_bv<8> *data ) {

    return true;

}

void vip_nasti_channel::slaveBind(Vtop *dut) {

    dut->s_nasti_aw_id(aw_id_s);
    dut->s_nasti_aw_addr(aw_addr_s);
    dut->s_nasti_aw_len(aw_len_s);
    dut->s_nasti_aw_size(aw_size_s);
    dut->s_nasti_aw_burst(aw_burst_s);
    dut->s_nasti_aw_lock(aw_lock_s);
    dut->s_nasti_aw_cache(aw_cache_s);
    dut->s_nasti_aw_prot(aw_prot_s);
    dut->s_nasti_aw_qos(aw_qos_s);
    dut->s_nasti_aw_region(aw_region_s);
    dut->s_nasti_aw_user(aw_user_s);
    dut->s_nasti_aw_valid(aw_valid_s);
    dut->s_nasti_aw_ready(aw_ready_s);
    dut->s_nasti_w_data(w_data_s);
    dut->s_nasti_w_strb(w_strb_s);
    dut->s_nasti_w_last(w_last_s);
    dut->s_nasti_w_user(w_user_s);
    dut->s_nasti_w_valid(w_valid_s);
    dut->s_nasti_w_ready(w_ready_s);
    dut->s_nasti_b_id(b_id_s);
    dut->s_nasti_b_resp(b_resp_s);
    dut->s_nasti_b_user(b_user_s);
    dut->s_nasti_b_valid(b_valid_s);
    dut->s_nasti_b_ready(b_ready_s);
    dut->s_nasti_ar_id(ar_id_s);
    dut->s_nasti_ar_addr(ar_addr_s);
    dut->s_nasti_ar_len(ar_len_s);
    dut->s_nasti_ar_size(ar_size_s);
    dut->s_nasti_ar_burst(ar_burst_s);
    dut->s_nasti_ar_lock(ar_lock_s);
    dut->s_nasti_ar_cache(ar_cache_s);
    dut->s_nasti_ar_prot(ar_prot_s);
    dut->s_nasti_ar_qos(ar_qos_s);
    dut->s_nasti_ar_region(ar_region_s);
    dut->s_nasti_ar_user(ar_user_s);
    dut->s_nasti_ar_valid(ar_valid_s);
    dut->s_nasti_ar_ready(ar_ready_s);
    dut->s_nasti_r_id(r_id_s);
    dut->s_nasti_r_resp(r_resp_s);
    dut->s_nasti_r_last(r_last_s);
    dut->s_nasti_r_user(r_user_s);
    dut->s_nasti_r_valid(r_valid_s);
    dut->s_nasti_r_ready(r_ready_s);
    dut->s_nasti_r_data(r_data_s);

    aw_id(aw_id_s);
    aw_addr(aw_addr_s);
    aw_len(aw_len_s);
    aw_size(aw_size_s);
    aw_burst(aw_burst_s);
    aw_lock(aw_lock_s);
    aw_cache(aw_cache_s);
    aw_prot(aw_prot_s);
    aw_qos(aw_qos_s);
    aw_region(aw_region_s);
    aw_user(aw_user_s);
    aw_valid(aw_valid_s);
    aw_ready(aw_ready_s);
    w_data(w_data_s);
    w_strb(w_strb_s);
    w_last(w_last_s);
    w_user(w_user_s);
    w_valid(w_valid_s);
    w_ready(w_ready_s);
    b_id(b_id_s);
    b_resp(b_resp_s);
    b_user(b_user_s);
    b_valid(b_valid_s);
    b_ready(b_ready_s);
    ar_id(ar_id_s);
    ar_addr(ar_addr_s);
    ar_len(ar_len_s);
    ar_size(ar_size_s);
    ar_burst(ar_burst_s);
    ar_lock(ar_lock_s);
    ar_cache(ar_cache_s);
    ar_prot(ar_prot_s);
    ar_qos(ar_qos_s);
    ar_region(ar_region_s);
    ar_user(ar_user_s);
    ar_valid(ar_valid_s);
    ar_ready(ar_ready_s);
    r_id(r_id_s);
    r_resp(r_resp_s);
    r_last(r_last_s);
    r_user(r_user_s);
    r_valid(r_valid_s);
    r_ready(r_ready_s);
    r_data(r_data_s);

}
