/**
 *
 */

`timescale 1ps / 1ps

module top;

	logic s_nasti_clk    ;
	logic s_nasti_aresetn;
	nasti_if s_nasti ();

	logic s_nastilite_clk    ;
	logic s_nastilite_aresetn;
	nasti_if s_nastilite ();

	logic core_clk;
	dfi_if m_dfi();

	nasti_ddrx_mc i_nasti_ddrx_mc (
		.s_nastilite_clk    (s_nastilite_clk    ),
		.s_nastilite_aresetn(s_nastilite_aresetn),
		.s_nastilite        (s_nastilite        ),
		.s_nasti_clk        (s_nasti_clk        ),
		.s_nasti_aresetn    (s_nasti_aresetn    ),
		.s_nasti            (s_nasti            ),
		.core_clk           (core_clk           ),
		.m_dfi              (m_dfi              )
	);

endmodule // top