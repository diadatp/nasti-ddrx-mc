/**
 *
 */

module nasti_ddrx_mc #(
      C_NASTI_ID_WIDTH   = 9 ,
      C_NASTI_ADDR_WIDTH = 32,
      C_NASTI_DATA_WIDTH = 64,
      C_NASTI_USER_WIDTH = 1 ,
      //
      C_CK_WIDTH         = 1 ,
      C_CS_WIDTH         = 1 ,
      C_CKE_WIDTH        = 1 ,
      C_DQ_WIDTH         = 64,
      C_DQS_WIDTH        = 8 ,
      C_ROW_WIDTH        = 16,
      C_BANK_WIDTH       = 3 ,
      C_nCS_PER_RANK     = 8 ,
      C_DM_WIDTH         = 4 ,
      C_ODT_WIDTH        = 4
) (
      input              core_clk           ,
      input              core_arstn         ,
      // NASTILite Interface
      input              s_nastilite_clk    ,
      input              s_nastilite_aresetn,
      nastilite_if.slave s_nastilite        ,
      // NASTI Interface
      input              s_nasti_clk        ,
      input              s_nasti_aresetn    ,
      nasti_if.slave     s_nasti            ,
      // DDR PHY Interface
      dfi_if.master      m_dfi
);

      // TODO Document these selections. Make more generic.
      localparam C_AR_WIDTH = C_NASTI_ID_WIDTH + C_NASTI_ADDR_WIDTH + 8 + 3 + 2                 ;
      localparam C_AW_WIDTH = C_NASTI_ID_WIDTH + C_NASTI_ADDR_WIDTH + 8 + 3 + 2                 ;
      localparam C_B_WIDTH  = C_NASTI_ID_WIDTH + C_NASTI_DATA_WIDTH + 2                         ;
      localparam C_R_WIDTH  = C_NASTI_ID_WIDTH + C_NASTI_DATA_WIDTH + 2                         ;
      localparam C_W_WIDTH  = C_NASTI_ID_WIDTH + C_NASTI_DATA_WIDTH + (C_NASTI_DATA_WIDTH/8) + 2;

      logic [C_AR_WIDTH-1:0] rdata_ar ;
      logic                  rempty_ar;
      logic                  rinc_ar  ;
      logic [C_AW_WIDTH-1:0] rdata_aw ;
      logic                  rempty_aw;
      logic                  rinc_aw  ;
      logic [ C_W_WIDTH-1:0] rdata_w  ;
      logic                  rempty_w ;
      logic                  rinc_w   ;
      logic [ C_R_WIDTH-1:0] wdata_r  ;
      logic                  wfull_r  ;
      logic                  winc_r   ;
      logic [ C_B_WIDTH-1:0] wdata_b  ;
      logic                  wfull_b  ;
      logic                  winc_b   ;

      nasti_frontend #(
            .C_FIFO_DEPTH(3         ),
            .C_AR_WIDTH  (C_AR_WIDTH),
            .C_AW_WIDTH  (C_AW_WIDTH),
            .C_B_WIDTH   (C_B_WIDTH ),
            .C_R_WIDTH   (C_R_WIDTH ),
            .C_W_WIDTH   (C_W_WIDTH )
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

endmodule // nasti_ddrx_mc
