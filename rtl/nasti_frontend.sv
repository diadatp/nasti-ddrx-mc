/**
 * This module presents a NASTI slave interface to transaction FIFOs and
 * facilitates a clock domain cross.
 */

`include "timescale.svh"
`include "structs.svh"

module nasti_frontend #(
    C_NASTI_ID_WIDTH   = 0,
    C_NASTI_ADDR_WIDTH = 0,
    C_NASTI_DATA_WIDTH = 0,
    C_NASTI_USER_WIDTH = 0,
    C_FIFO_DEPTH       = 4, // depth of the NASTI FIFOs
    C_MAX_PENDING      = 5
) (
    // clocking and reset
    input           core_clk       ,
    input           core_arstn     ,
    // NASTI Interface
    input           s_nasti_clk    ,
    input           s_nasti_aresetn,
    nasti_if.slave  s_nasti        ,
    // read address and control fifo
    output ar_trans ar_rdata       ,
    output          ar_rempty      ,
    input           ar_rinc        ,
    // write address and control fifo
    output aw_trans aw_rdata       ,
    output          aw_rempty      ,
    input           aw_rinc        ,
    // write data fifo
    output w_trans  w_rdata        ,
    output          w_rempty       ,
    input           w_rinc         ,
    // read data fifo
    input  r_trans  r_wdata        ,
    output          r_wfull        ,
    input           r_winc         ,
    // write response fifo
    input  b_trans  b_wdata        ,
    output          b_wfull        ,
    input           b_winc
);

    // write addresss and control
    aw_trans wdata_aw;
    assign wdata_aw = '{
        aw_id:s_nasti.aw_id,
        aw_addr:s_nasti.aw_addr,
        aw_len:s_nasti.aw_len,
        aw_size:s_nasti.aw_size,
        aw_burst:s_nasti.aw_burst,
        aw_user:s_nasti.aw_user
    };

    logic wfull_aw;
    assign s_nasti.aw_ready = ~wfull_aw;

    afifo #(
        .C_DATA_WIDTH($bits(aw_trans)),
        .C_ADDR_WIDTH(C_FIFO_DEPTH   )
    ) i_afifo_aw (
        .wdata (wdata_aw        ),
        .wfull (wfull_aw        ),
        .winc  (s_nasti.aw_valid),
        .wclk  (s_nasti_clk     ),
        .wrst_n(s_nasti_aresetn ),
        .rdata (aw_rdata        ),
        .rempty(aw_rempty       ),
        .rinc  (aw_rinc         ),
        .rclk  (core_clk        ),
        .rrst_n(core_arstn      )
    );

    // write data
    w_trans wdata_w;
    assign wdata_w = '{
        w_data:s_nasti.w_data,
        w_strb:s_nasti.w_strb,
        w_last:s_nasti.w_last,
        w_user:s_nasti.w_user
    };

    logic wfull_w;
    assign s_nasti.w_ready = ~wfull_w;

    afifo #(
        .C_DATA_WIDTH($bits(w_trans)),
        .C_ADDR_WIDTH(C_FIFO_DEPTH  )
    ) i_afifo_w (
        .wdata (wdata_w        ),
        .wfull (wfull_w        ),
        .winc  (s_nasti.w_valid),
        .wclk  (s_nasti_clk    ),
        .wrst_n(s_nasti_aresetn),
        .rdata (w_rdata        ),
        .rempty(w_rempty       ),
        .rinc  (w_rinc         ),
        .rclk  (core_clk       ),
        .rrst_n(core_arstn     )
    );

    // write response
    b_trans rdata_b;
    assign rdata_b = '{
        b_id:s_nasti.b_id,
        b_resp:s_nasti.b_resp,
        b_user:s_nasti.b_user
    };

    logic rempty_b;
    assign s_nasti.b_ready = ~rempty_b;

    afifo #(
        .C_DATA_WIDTH($bits(b_trans)),
        .C_ADDR_WIDTH(C_FIFO_DEPTH  )
    ) i_afifo_b (
        .wdata (b_wdata        ),
        .wfull (b_wfull        ),
        .winc  (b_winc         ),
        .wclk  (core_clk       ),
        .wrst_n(core_arstn     ),
        .rdata (rdata_b        ),
        .rempty(rempty_b       ),
        .rinc  (s_nasti.b_valid),
        .rclk  (s_nasti_clk    ),
        .rrst_n(s_nasti_aresetn)
    );

    // read address and control
    ar_trans wdata_ar;
    assign wdata_ar = '{
        ar_id:s_nasti.ar_id,
        ar_addr:s_nasti.ar_addr,
        ar_len:s_nasti.ar_len,
        ar_size:s_nasti.ar_size,
        ar_burst:s_nasti.ar_burst,
        ar_user:s_nasti.ar_user
    };

    logic wfull_ar;
    assign s_nasti.ar_ready = ~wfull_ar;

    afifo #(
        .C_DATA_WIDTH($bits(ar_trans)),
        .C_ADDR_WIDTH(C_FIFO_DEPTH   )
    ) i_afifo_ar (
        .wdata (wdata_ar        ),
        .wfull (wfull_ar        ),
        .winc  (s_nasti.ar_valid),
        .wclk  (s_nasti_clk     ),
        .wrst_n(s_nasti_aresetn ),
        .rdata (ar_rdata        ),
        .rempty(ar_rempty       ),
        .rinc  (ar_rinc         ),
        .rclk  (core_clk        ),
        .rrst_n(core_arstn      )
    );

    // read data and response
    r_trans rdata_r;
    assign rdata_r = '{
        r_id:s_nasti.r_id,
        r_data:s_nasti.r_data,
        r_last:s_nasti.r_last,
        r_resp:s_nasti.r_resp,
        r_user:s_nasti.r_user
    };

    logic rempty_r;
    assign s_nasti.r_ready = ~rempty_r;

    afifo #(
        .C_DATA_WIDTH($bits(r_trans)),
        .C_ADDR_WIDTH(C_FIFO_DEPTH  )
    ) i_afifo_r (
        .wdata (r_wdata        ),
        .wfull (r_wfull        ),
        .winc  (r_winc         ),
        .wclk  (core_clk       ),
        .wrst_n(core_arstn     ),
        .rdata (rdata_r        ),
        .rempty(rempty_r       ),
        .rinc  (s_nasti.r_valid),
        .rclk  (s_nasti_clk    ),
        .rrst_n(s_nasti_aresetn)
    );

endmodule // nasti_frontend
