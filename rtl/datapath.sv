/**
 *
 */

`include "timescale.svh"

module datapath #(
    C_DFI_FREQ_RATIO = 0,
    C_DFI_DATA_WIDTH = 0
) (
    input                                            core_clk  ,
    input                                            core_arstn,
    // tm side
    input                                            w_wren    ,
    output                                           w_wfull   ,
    input  [(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH)-1:0] w_wdata   ,
    input                                            r_rden    ,
    output                                           r_rempty  ,
    output [(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH)-1:0] r_rdata   ,
    // tc side
    output                                           r_wfull   ,
    output                                           w_rempty  ,
    input                                            w_rden    ,
    //
    dfi_if.master                                    data_dfi
);

    sfifo #(
        .C_DATA_WIDTH(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH),
        .C_ADDR_WIDTH(15                               )
    ) i_sfifo_read (
        .clk   (core_clk                 ),
        .arstn (core_arstn               ),
        .wdata (data_dfi.dfi_rddata      ),
        .wfull (r_wfull                  ),
        .wren  (data_dfi.dfi_rddata_valid),
        .rdata (r_rdata                  ),
        .rempty(r_rempty                 ),
        .rden  (r_rden                   )
    );

    sfifo #(
        .C_DATA_WIDTH(C_DFI_FREQ_RATIO*C_DFI_DATA_WIDTH),
        .C_ADDR_WIDTH(15                               )
    ) i_sfifo_write (
        .clk   (core_clk        ),
        .arstn (core_arstn      ),
        .wdata (w_wdata         ),
        .wfull (w_wfull         ),
        .wren  (w_wren          ),
        .rdata (m_dfi.dfi_wrdata),
        .rempty(w_rempty        ),
        .rden  (w_rden          )
    );

endmodule // datapath
