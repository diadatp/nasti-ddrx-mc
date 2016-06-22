/**
 *
 */

#ifndef VIP_NASTI_CHANNEL_H
#define VIP_NASTI_CHANNEL_H

#include <systemc.h>

#include "Vtop.h"

#include "vip_nasti_if.h"

class vip_nasti_channel : public vip_nasti_if, public sc_channel {

  public:

    sc_out<uint32_t>    aw_id;
    sc_out<vluint64_t>  aw_addr;
    sc_out<uint32_t>    aw_len;
    sc_out<uint32_t>    aw_size;
    sc_out<uint32_t>    aw_burst;
    sc_out<bool>        aw_lock;
    sc_out<uint32_t>    aw_cache;
    sc_out<uint32_t>    aw_prot;
    sc_out<uint32_t>    aw_qos;
    sc_out<uint32_t>    aw_region;
    sc_out<bool>        aw_user;
    sc_out<bool>        aw_valid;
    sc_in<bool>         aw_ready;

    sc_out<vluint64_t>  w_data;
    sc_out<uint32_t>    w_strb;
    sc_out<bool>        w_last;
    sc_out<bool>        w_user;
    sc_out<bool>        w_valid;
    sc_in<bool>         w_ready;

    sc_in<uint32_t>     b_id;
    sc_in<uint32_t>     b_resp;
    sc_in<bool>     b_user;
    sc_in<bool>         b_valid;
    sc_out<bool>        b_ready;

    sc_out<uint32_t>    ar_id;
    sc_out<vluint64_t>  ar_addr;
    sc_out<uint32_t>    ar_len;
    sc_out<uint32_t>    ar_size;
    sc_out<uint32_t>    ar_burst;
    sc_out<bool>        ar_lock;
    sc_out<uint32_t>    ar_cache;
    sc_out<uint32_t>    ar_prot;
    sc_out<uint32_t>    ar_qos;
    sc_out<uint32_t>    ar_region;
    sc_out<bool>        ar_user;
    sc_out<bool>        ar_valid;
    sc_in<bool>         ar_ready;

    sc_in<uint32_t>     r_id;
    sc_in<uint32_t>     r_resp;
    sc_in<bool>         r_last;
    sc_in<bool>         r_user;
    sc_in<bool>         r_valid;
    sc_out<bool>        r_ready;
    sc_in<vluint64_t>   r_data;

    vip_nasti_channel (sc_module_name name) :
        sc_channel(name),
        ar_id("ar_id"),
        ar_addr("ar_addr"),
        ar_len("ar_len"),
        ar_size("ar_size"),
        ar_burst("ar_burst"),
        ar_lock("ar_lock"),
        ar_cache("ar_cache"),
        ar_prot("ar_prot"),
        ar_qos("ar_qos"),
        ar_region("ar_region"),
        ar_user("ar_user"),
        ar_valid("ar_valid"),
        ar_ready("ar_ready")
    { }

    virtual bool burstRead( uint64_t id, uint64_t addr, uint64_t len );
    virtual bool burstWrite( uint64_t id, uint64_t addr, uint64_t len, sc_bv<8> *data );
    virtual void slaveBind( Vtop* );

  private:

    sc_signal<uint32_t>    aw_id_s;
    sc_signal<vluint64_t>  aw_addr_s;
    sc_signal<uint32_t>    aw_len_s;
    sc_signal<uint32_t>    aw_size_s;
    sc_signal<uint32_t>    aw_burst_s;
    sc_signal<bool>        aw_lock_s;
    sc_signal<uint32_t>    aw_cache_s;
    sc_signal<uint32_t>    aw_prot_s;
    sc_signal<uint32_t>    aw_qos_s;
    sc_signal<uint32_t>    aw_region_s;
    sc_signal<bool>    aw_user_s;
    sc_signal<bool>        aw_valid_s;
    sc_signal<bool>         aw_ready_s;
    sc_signal<vluint64_t>  w_data_s;
    sc_signal<uint32_t>    w_strb_s;
    sc_signal<bool>        w_last_s;
    sc_signal<bool>    w_user_s;
    sc_signal<bool>        w_valid_s;
    sc_signal<bool>         w_ready_s;
    sc_signal<uint32_t>     b_id_s;
    sc_signal<uint32_t>     b_resp_s;
    sc_signal<bool>     b_user_s;
    sc_signal<bool>         b_valid_s;
    sc_signal<bool>        b_ready_s;
    sc_signal<uint32_t>    ar_id_s;
    sc_signal<vluint64_t>  ar_addr_s;
    sc_signal<uint32_t>    ar_len_s;
    sc_signal<uint32_t>    ar_size_s;
    sc_signal<uint32_t>    ar_burst_s;
    sc_signal<bool>        ar_lock_s;
    sc_signal<uint32_t>    ar_cache_s;
    sc_signal<uint32_t>    ar_prot_s;
    sc_signal<uint32_t>    ar_qos_s;
    sc_signal<uint32_t>    ar_region_s;
    sc_signal<bool>    ar_user_s;
    sc_signal<bool>        ar_valid_s;
    sc_signal<bool>         ar_ready_s;
    sc_signal<uint32_t>     r_id_s;
    sc_signal<uint32_t>     r_resp_s;
    sc_signal<bool>         r_last_s;
    sc_signal<bool>         r_user_s;
    sc_signal<bool>         r_valid_s;
    sc_signal<bool>        r_ready_s;
    sc_signal<vluint64_t>   r_data_s;

};

#endif /* VIP_NASTI_CHANNEL_H */
