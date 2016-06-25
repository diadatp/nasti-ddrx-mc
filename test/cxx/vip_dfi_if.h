/**
 *
 */

#ifndef VIP_DFI_IF_H
#define VIP_DFI_IF_H


#include "systemc.h"

class vip_dfi_if : virtual public sc_interface {

  public:

    virtual void read() = 0;
    virtual void write( sc_bv<8> *data ) = 0;

};

#endif /* VIP_DFI_IF_H */
