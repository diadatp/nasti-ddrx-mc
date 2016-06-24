/**
 *
 */

#ifndef VIP_NASTI_IF_H
#define VIP_NASTI_IF_H

#include <systemc.h>
#include <scv.h>

// #include "vip_nasti_trans.h"

class vip_nasti_if : virtual public sc_interface {

  public:

    typedef sc_bv<10> aid_t;
    typedef sc_uint<64> addr_t;
    typedef sc_uint<8> len_t;
    typedef sc_bv<3> asize_t;
    typedef sc_bv<2> burst_t;

    struct read_t {
        aid_t id;
        addr_t addr;
        len_t len;
        asize_t size;
        burst_t burst;
    };

    virtual bool burstRead( uint64_t id, uint64_t addr, uint64_t len ) = 0;
    virtual bool burstWrite( uint64_t id, uint64_t addr, uint64_t len, sc_bv<8> *data ) = 0;

};

SCV_EXTENSIONS(vip_nasti_if::read_t) {
public:
    scv_extensions< vip_nasti_if::aid_t > id;
    scv_extensions< vip_nasti_if::addr_t > addr;
    scv_extensions< vip_nasti_if::len_t > len;
    scv_extensions< vip_nasti_if::asize_t > size;
    scv_extensions< vip_nasti_if::burst_t > burst;

    SCV_EXTENSIONS_CTOR(vip_nasti_if::read_t) {
        SCV_FIELD(id);
        SCV_FIELD(addr);
        SCV_FIELD(len);
        SCV_FIELD(size);
        SCV_FIELD(burst);
    }
};

#endif /* VIP_NASTI_IF_H */
