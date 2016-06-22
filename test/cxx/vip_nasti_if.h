/**
 *
 */

#ifndef VIP_NASTI_IF_H
#define VIP_NASTI_IF_H

#include <systemc.h>

// #include "vip_nasti_trans.h"

class vip_nasti_if : virtual public sc_interface {

  public:

    virtual bool burstRead( uint64_t id, uint64_t addr, uint64_t len ) = 0;
    virtual bool burstWrite( uint64_t id, uint64_t addr, uint64_t len, sc_bv<8> *data ) = 0;

    // virtual vip_nasti_trans read() = 0;
    // virtual void write(vip_nasti_trans) = 0;

};

#endif /* VIP_NASTI_IF_H */
