/**
 *
 */

`include "timescale.svh"

module datapath (
    input          core_clk  ,
    input          core_arstn,
    // read data
    output r_trans wdata_r   ,
    input          wfull_r   ,
    output         winc_r    ,
    // write data
    input  w_trans rdata_w   ,
    input          rempty_w  ,
    output         rinc_w    ,
    //
    input          r_id      ,
    input          r_last    ,
    input          r_resp    ,
    input          r_user    ,
    //
    input          b_id      ,
    input          b_resp    ,
    input          b_user    ,
    //
    dfi_if.master  m_dfi
);

    // read data and response
    r_trans rdata_r;
    assign rdata_r = '{
        r_id:r_id,
        r_data:,
        r_last:r_last,
        r_resp:r_resp,
        r_user:r_user
    };

    sfifo #(
        .C_DATA_WIDTH(`C_DFI_FREQ_RATIO*`C_DFI_DATA_WIDTH),
        .C_ADDR_WIDTH(5                              )
    ) i_sfifo_read (
        .clk   (core_clk              ),
        .rst   (core_arstn            ),
        .wdata (m_dfi.dfi_rddata      ),
        .wfull (wfull                 ),
        .winc  (m_dfi.dfi_rddata_valid),
        .rdata (rdata                 ),
        .rempty(rempty                ),
        .rinc  (rinc                  )
    );

    // write response
    b_trans rdata_b;
    assign rdata_b = '{
        b_id:b_id,
        b_resp:b_resp,
        b_user:b_user
    };

    sfifo #(
        .C_DATA_WIDTH(`C_DFI_FREQ_RATIO*`C_DFI_DATA_WIDTH),
        .C_ADDR_WIDTH(5                              )
    ) i_sfifo_write (
        .clk   (core_clk        ),
        .rst   (core_arstn      ),
        .wdata (wdata           ),
        .wfull (wfull           ),
        .winc  (winc            ),
        .rdata (m_dfi.dfi_wrdata),
        .rempty(rempty          ),
        .rinc  (rinc            )
    );

endmodule // datapath
