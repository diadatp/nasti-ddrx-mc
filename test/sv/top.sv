/**
 *
 */

`timescale 1ps / 1ps

`include "constants.svh"

module top;

    logic s_nasti_clk    ;
    logic s_nasti_aresetn;
    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH  ),
        .C_NASTI_ADDR_WIDTH(`C_NASTI_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTI_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH)
    ) s_nasti ();

    logic s_nastilite_clk    ;
    logic s_nastilite_aresetn;
    nasti_if #(
        .C_NASTI_ID_WIDTH  (`C_NASTI_ID_WIDTH      ),
        .C_NASTI_ADDR_WIDTH(`C_NASTILITE_ADDR_WIDTH),
        .C_NASTI_DATA_WIDTH(`C_NASTILITE_DATA_WIDTH),
        .C_NASTI_USER_WIDTH(`C_NASTI_USER_WIDTH    )
    ) s_nastilite ();

    logic core_clk;
    logic core_arstn;
    dfi_if m_dfi();

    nasti_ddrx_mc #(
        .C_NASTI_ID_WIDTH      (`C_NASTI_ID_WIDTH      ),
        .C_NASTI_ADDR_WIDTH    (`C_NASTI_ADDR_WIDTH    ),
        .C_NASTI_DATA_WIDTH    (`C_NASTI_DATA_WIDTH    ),
        .C_NASTI_USER_WIDTH    (`C_NASTI_USER_WIDTH    ),
        .C_NASTILITE_ADDR_WIDTH(`C_NASTILITE_ADDR_WIDTH),
        .C_NASTILITE_DATA_WIDTH(`C_NASTILITE_DATA_WIDTH)
    ) i_nasti_ddrx_mc (
        .core_clk           (core_clk           ),
        .core_arstn         (core_arstn         ),
        .s_nastilite_clk    (s_nastilite_clk    ),
        .s_nastilite_aresetn(s_nastilite_aresetn),
        .s_nastilite        (s_nastilite        ),
        .s_nasti_clk        (s_nasti_clk        ),
        .s_nasti_aresetn    (s_nasti_aresetn    ),
        .s_nasti            (s_nasti            ),
        .m_dfi              (m_dfi              )
    );

endmodule // top