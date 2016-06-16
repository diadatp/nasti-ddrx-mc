/**
*
*/

`include "types.svh"

module nasti_ddrx_mc #(
      //
      C_NASTI_ID_WIDTH       = 9 ,
      C_NASTI_ADDR_WIDTH     = 32,
      C_NASTI_DATA_WIDTH     = 64,
      C_NASTI_USER_WIDTH     = 1 ,
      //
      C_NASTILITE_ADDR_WIDTH = 6 ,
      C_NASTILITE_DATA_WIDTH = 64,
      //
      C_CK_WIDTH             = 1 ,
      C_CS_WIDTH             = 1 ,
      C_CKE_WIDTH            = 1 ,
      C_DQ_WIDTH             = 64,
      C_DQS_WIDTH            = 8 ,
      C_ROW_WIDTH            = 16,
      C_BANK_WIDTH           = 3 ,
      C_nCS_PER_RANK         = 8 ,
      C_DM_WIDTH             = 4 ,
      C_ODT_WIDTH            = 4
) (
      input          core_clk           ,
      input          core_arstn         ,
      // NASTILite Interface
      input          s_nastilite_clk    ,
      input          s_nastilite_aresetn,
      nasti_if.slave s_nastilite        ,
      // NASTI Interface
      input          s_nasti_clk        ,
      input          s_nasti_aresetn    ,
      nasti_if.slave s_nasti            ,
      // DDR PHY Interface
      dfi_if.master  m_dfi
);

      `include "transaction_structs.svh"

      aw_trans rdata_aw ;
      logic    rempty_aw;
      logic    rinc_aw  ;

      w_trans rdata_w ;
      logic   rempty_w;
      logic   rinc_w  ;

      b_trans wdata_b;
      logic   wfull_b;
      logic   winc_b ;

      ar_trans rdata_ar ;
      logic    rempty_ar;
      logic    rinc_ar  ;

      r_trans wdata_r;
      logic   wfull_r;
      logic   winc_r ;

      nasti_frontend #(
            .C_NASTI_ID_WIDTH  (C_NASTI_ID_WIDTH  ),
            .C_NASTI_ADDR_WIDTH(C_NASTI_ADDR_WIDTH),
            .C_NASTI_DATA_WIDTH(C_NASTI_DATA_WIDTH),
            .C_NASTI_USER_WIDTH(C_NASTI_USER_WIDTH),
            .C_FIFO_DEPTH      (4                 )
      ) i_nasti_frontend (
            .core_clk       (core_clk       ),
            .core_arstn     (core_arstn     ),
            .s_nasti_clk    (s_nasti_clk    ),
            .s_nasti_aresetn(s_nasti_aresetn),
            .s_nasti        (s_nasti        ),
            .rdata_ar       (rdata_ar       ),
            .rempty_ar      (rempty_ar      ),
            .rinc_ar        (rinc_ar        ),
            .rdata_aw       (rdata_aw       ),
            .rempty_aw      (rempty_aw      ),
            .rinc_aw        (rinc_aw        ),
            .rdata_w        (rdata_w        ),
            .rempty_w       (rempty_w       ),
            .rinc_w         (rinc_w         ),
            .wdata_r        (wdata_r        ),
            .wfull_r        (wfull_r        ),
            .winc_r         (winc_r         ),
            .wdata_b        (wdata_b        ),
            .wfull_b        (wfull_b        ),
            .winc_b         (winc_b         )
      );

      logic [1:0] add_map;

      nastilite_frontend #(
            .C_NASTI_ADDR_WIDTH(C_NASTILITE_ADDR_WIDTH),
            .C_NASTI_DATA_WIDTH(C_NASTILITE_DATA_WIDTH)
      ) i_nastilite_frontend (
            .s_nastilite_clk    (s_nastilite_clk    ),
            .s_nastilite_aresetn(s_nastilite_aresetn),
            .s_nastilite        (s_nastilite        ),
            .add_map            (add_map            )
      );


      row_widths                          r_width   ;
      col_widths                          c_width   ;
      logic                               bor       ;
      logic      [C_NASTI_ADDR_WIDTH-1:0] nasti_addr;
      logic      [        C_CS_WIDTH-1:0] rank      ;
      reg        [      C_BANK_WIDTH-1:0] bank      ;
      reg        [       C_ROW_WIDTH-1:0] row       ;
      reg        [                  11:0] column    ;

      address_mapper #(
            .C_NASTI_ADDR_WIDTH(C_NASTI_ADDR_WIDTH),
            .C_NASTI_DATA_WIDTH(C_NASTI_DATA_WIDTH),
            .C_CS_WIDTH        (C_CS_WIDTH        ),
            .C_DQ_WIDTH        (C_DQ_WIDTH        ),
            .C_ROW_WIDTH       (C_ROW_WIDTH       ),
            .C_BANK_WIDTH      (C_BANK_WIDTH      )
      ) i_address_mapper (
            .r_width   (r_width   ),
            .c_width   (c_width   ),
            .bor       (bor       ),
            .nasti_addr(nasti_addr),
            .rank      (rank      ),
            .bank      (bank      ),
            .row       (row       ),
            .column    (column    )
      );


      logic       clk_1024khz;
      logic       rstn       ;
      logic       ref_req    ;
      logic [3:0] warning    ;
      reg         ref_do     ;

      refresh_controller i_refresh_controller (
            .clk_1024khz(clk_1024khz),
            .rstn       (rstn       ),
            .ref_req    (ref_req    ),
            .warning    (warning    ),
            .ref_do     (ref_do     )
      );

endmodule // nasti_ddrx_mc
