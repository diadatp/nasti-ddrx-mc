/**
 * This is the top module for the memory controller.
 * tcmd_lat = 1
 */

`include "timescale.svh"
`include "defines.svh"
`include "enums.svh"
`include "functions.svh"
`include "structs.svh"

module nasti_ddrx_mc #(
      C_DFI_ADDR_WIDTH    = 0,
      C_DFI_ALERT_WIDTH   = 0,
      C_DFI_BANK_WIDTH    = 0,
      C_DFI_CS_WIDTH      = 0,
      C_DFI_CTRL_WIDTH    = 0,
      C_DFI_DATA_WIDTH    = 0,
      C_DFI_DATAEN_WIDTH  = 0,
      C_DFI_DM_WIDTH      = 0,
      C_DFI_ERR_WIDTH     = 0,
      C_DFI_FREQ_RATIO    = 0,
      C_DFI_WRDACS_WIDTH  = 0,
      C_NASTI_ADDR_WIDTH  = 0,
      C_NASTI_DATA_WIDTH  = 0,
      C_NASTI_ID_WIDTH    = 0,
      C_NASTI_USER_WIDTH  = 0,
      C_NASTIL_ADDR_WIDTH = 0,
      C_NASTIL_DATA_WIDTH = 0
) (
      input          core_clk           ,
      input          core_arstn         ,
      // NASTI-Lite interface
      input          s_nastilite_clk    ,
      input          s_nastilite_aresetn,
      nasti_if.slave s_nastilite        ,
      // NASTI interface
      input          s_nasti_clk        ,
      input          s_nasti_aresetn    ,
      nasti_if.slave s_nasti            ,
      // DDR PHY interface
      dfi_if.master  m_dfi
);

      config_if cfg ();

      dfi_if #(
            .C_DFI_FREQ_RATIO  (C_DFI_FREQ_RATIO  ),
            .C_DFI_ADDR_WIDTH  (C_DFI_ADDR_WIDTH  ),
            .C_DFI_BANK_WIDTH  (C_DFI_BANK_WIDTH  ),
            .C_DFI_CTRL_WIDTH  (C_DFI_CTRL_WIDTH  ),
            .C_DFI_CS_WIDTH    (C_DFI_CS_WIDTH    ),
            .C_DFI_DATAEN_WIDTH(C_DFI_DATAEN_WIDTH),
            .C_DFI_DATA_WIDTH  (C_DFI_DATA_WIDTH  ),
            .C_DFI_WRDACS_WIDTH(C_DFI_CS_WIDTH    ),
            .C_DFI_DM_WIDTH    (C_DFI_DM_WIDTH    ),
            .C_DFI_ALERT_WIDTH (C_DFI_ALERT_WIDTH ),
            .C_DFI_ERR_WIDTH   (C_DFI_ERR_WIDTH   )
      ) cali_dfi (), data_dfi(), init_dfi(), main_dfi(), tran_dfi();

      nastilite_frontend #(
            .C_NASTI_ADDR_WIDTH(C_NASTI_ADDR_WIDTH),
            .C_NASTI_DATA_WIDTH(C_NASTI_DATA_WIDTH)
      ) i_nastilite_frontend (
            .s_nastilite_clk    (s_nastilite_clk    ),
            .s_nastilite_aresetn(s_nastilite_aresetn),
            .s_nastilite        (s_nastilite        ),
            .m_cfg              (cfg                )
      );

      ar_trans ar_rdata ;
      logic    ar_rempty;
      logic    ar_rden  ;

      r_trans r_wdata;
      logic   r_wfull;
      logic   r_wren ;

      aw_trans aw_rdata ;
      logic    aw_rempty;
      logic    aw_rden  ;

      w_trans w_rdata ;
      logic   w_rempty;
      logic   w_rden  ;

      b_trans b_wdata;
      logic   b_wfull;
      logic   b_wren ;

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
            .ar_rdata       (ar_rdata       ),
            .ar_rempty      (ar_rempty      ),
            .ar_rden        (ar_rden        ),
            .aw_rdata       (aw_rdata       ),
            .aw_rempty      (aw_rempty      ),
            .aw_rden        (aw_rden        ),
            .w_rdata        (w_rdata        ),
            .w_rempty       (w_rempty       ),
            .w_rden         (w_rden         ),
            .r_wdata        (r_wdata        ),
            .r_wfull        (r_wfull        ),
            .r_wren         (r_wren         ),
            .b_wdata        (b_wdata        ),
            .b_wfull        (b_wfull        ),
            .b_wren         (b_wren         )
      );

      sdram_trans tr_wdata;
      logic       tr_wfull;
      logic       tr_wren ;

      tran_mapper #(
            .C_DFI_CS_WIDTH    (C_DFI_CS_WIDTH    ),
            .C_DFI_DATA_WIDTH  (C_DFI_DATA_WIDTH  ),
            .C_NASTI_ADDR_WIDTH(C_NASTI_ADDR_WIDTH),
            .C_NASTI_DATA_WIDTH(C_NASTI_DATA_WIDTH)
      ) i_tran_mapper (
            .core_clk  (core_clk  ),
            .core_arstn(core_arstn),
            .aw_rdata  (aw_rdata  ),
            .aw_rempty (aw_rempty ),
            .aw_rden   (aw_rden   ),
            .w_rdata   (w_rdata   ),
            .w_rempty  (w_rempty  ),
            .w_rden    (w_rden    ),
            .b_wdata   (b_wdata   ),
            .b_wfull   (b_wfull   ),
            .b_wren    (b_wren    ),
            .ar_rdata  (ar_rdata  ),
            .ar_rempty (ar_rempty ),
            .ar_rden   (ar_rden   ),
            .r_wdata   (r_wdata   ),
            .r_wfull   (r_wfull   ),
            .r_wren    (r_wren    ),
            .tr_wdata  (tr_wdata  ),
            .tr_wfull  (tr_wfull  ),
            .tr_wren   (tr_wren   ),
            .s_cfg     (cfg       )
      );

      sdram_trans tr_rdata ;
      logic       tr_rempty;
      logic       tr_rden  ;

      sfifo #(
            .C_DATA_WIDTH($bits(sdram_trans)),
            .C_ADDR_WIDTH(8                 )
      ) i_sfifo_tran_fifo (
            .clk   (core_clk  ),
            .arstn (core_arstn),
            .wdata (tr_wdata  ),
            .wfull (tr_wfull  ),
            .wren  (tr_wren   ),
            .rdata (tr_rdata  ),
            .rempty(tr_rempty ),
            .rden  (tr_rden   )
      );

      logic [(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH)-1:0] r_rdata ;
      logic                                           r_rempty;
      logic                                           r_rden  ;
      logic [(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH)-1:0] w_wdata ;
      logic                                           w_wfull ;
      logic                                           w_wren  ;

      // datapath #(
      //       .C_DFI_FREQ_RATIO(C_DFI_FREQ_RATIO),
      //       .C_DFI_DATA_WIDTH(C_DFI_DATA_WIDTH)
      // ) i_datapath (
      //       .core_clk  (core_clk  ),
      //       .core_arstn(core_arstn),
      //       .r_rdata   (r_rdata   ),
      //       .r_rempty  (r_rempty  ),
      //       .r_rden    (r_rden    ),
      //       .w_wdata   (w_wdata   ),
      //       .w_wfull   (w_wfull   ),
      //       .w_wren    (w_wren    ),
      //       .data_dfi  (data_dfi  )
      // );

      // logic       tran_do;
      // sdram_trans tr_data;
      // logic tr_rinc;
      // tran_control i_tran_control (
      //       .core_clk  (core_clk  ),
      //       .core_arstn(core_arstn),
      //       .tran_do   (tran_do   ),
      //       .s_cfg     (s_cfg     ),
      //       .tran_dfi  (tran_dfi  ),
      //       .tr_data   (tr_data   ),
      //       .tr_rempty (tr_rempty ),
      //       .tr_rinc   (tr_rinc   )
      // );


      // generate
      //       for (genvar i = 0; i < C_DFI_BANK_WIDTH; i++) begin
      //             bank_manager i_bank_manager (
      //                   .core_clk  (core_clk  ),
      //                   .core_arstn(core_arstn),
      //                   .row       (row       ),
      //                   .dsa       (dsa       )
      //             );
      //       end
      // endgenerate

      logic       r_empty       ;
      logic       ddr_init_start;
      logic       ddr_init_done ;
      logic       tran_start    ;
      logic       tran_pause    ;
      logic [1:0] sel           ;
      logic       cali_start    ;
      logic       cali_done     ;
      logic       tran_done     ;

      main_control i_main_control (
            .core_clk      (core_clk      ),
            .core_arstn    (core_arstn    ),
            .r_empty       (r_empty       ),
            .ddr_init_start(ddr_init_start),
            .ddr_init_done (ddr_init_done ),
            .cali_start    (cali_start    ),
            .cali_done     (cali_done     ),
            .tran_start    (tran_start    ),
            .tran_done     (tran_done     ),
            .s_cfg         (cfg           ),
            .sel           (sel           ),
            .main_dfi      (main_dfi      )
      );

      init_control i_init_control (
            .core_clk      (core_clk      ),
            .core_arstn    (core_arstn    ),
            .ddr_init_start(ddr_init_start),
            .ddr_init_done (ddr_init_done ),
            .s_cfg         (cfg           ),
            .init_dfi      (init_dfi      )
      );

      // tran_control i_tran_control (
      //       .core_clk  (core_clk  ),
      //       .core_arstn(core_arstn),
      //       .tran_start(tran_start),
      //       .tran_pause(tran_pause),
      //       .s_cfg     (cfg       ),
      //       .tran_dfi  (tran_dfi  )
      // );

      // logic       clk_1024khz;
      // logic       rstn       ;
      // logic       ref_req    ;
      // logic [3:0] warning    ;
      // reg         ref_do     ;

      // refresh_controller i_refresh_controller (
      //       .clk_1024khz(clk_1024khz),
      //       .rstn       (rstn       ),
      //       .ref_req    (ref_req    ),
      //       .warning    (warning    ),
      //       .ref_do     (ref_do     )
      // );

      dfi_mux i_dfi_mux (
            .cali_dfi(cali_dfi),
            .data_dfi(data_dfi),
            .init_dfi(init_dfi),
            .main_dfi(main_dfi),
            .tran_dfi(tran_dfi),
            .sel     (sel     ),
            .m_dfi   (m_dfi   )
      );

endmodule // nasti_ddrx_mc
