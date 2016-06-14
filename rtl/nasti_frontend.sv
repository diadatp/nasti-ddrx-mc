/**
 *
 */

module nasti_frontend #(
    C_FIFO_DEPTH = 3, // depth of the NASTI FIFOs
    C_AR_WIDTH   = 1,
    C_AW_WIDTH   = 1,
    C_B_WIDTH    = 1,
    C_R_WIDTH    = 1,
    C_W_WIDTH    = 1
) (
    // clocking and reset
    input                   core_clk       ,
    input                   core_arstn     ,
    // NASTI Interface
    input                   s_nasti_clk    ,
    input                   s_nasti_aresetn,
    nasti_if.slave          s_nasti        ,
    // read address and control fifo
    output [C_AR_WIDTH-1:0] rdata_ar       ,
    output                  rempty_ar      ,
    input                   rinc_ar        ,
    // write address and control fifo
    output [C_AW_WIDTH-1:0] rdata_aw       ,
    output                  rempty_aw      ,
    input                   rinc_aw        ,
    // write data fifo
    output [ C_W_WIDTH-1:0] rdata_w        ,
    output                  rempty_w       ,
    input                   rinc_w         ,
    // read data fifo
    input  [ C_R_WIDTH-1:0] wdata_r        ,
    output                  wfull_r        ,
    input                   winc_r         ,
    // write response fifo
    input  [ C_B_WIDTH-1:0] wdata_b        ,
    output                  wfull_b        ,
    input                   winc_b
);

    // read address and control

    logic [C_AW_WIDTH-1:0] wdata_ar;
    assign wdata_ar = {s_nasti.ar_id, s_nasti.ar_addr, s_nasti.ar_len, s_nasti.ar_size, s_nasti.ar_burst};

    logic wfull_ar;
    assign s_nasti.ar_ready = ~wfull_ar;

    afifo #(
        .C_DATA_WIDTH(C_AR_WIDTH  ),
        .C_ADDR_WIDTH(C_FIFO_DEPTH)
    ) i_afifo_ar (
        .wdata (wdata_ar        ),
        .wfull (wfull_ar        ),
        .winc  (s_nasti.ar_valid),
        .wclk  (s_nasti_clk     ),
        .wrst_n(s_nasti_aresetn ),
        .rdata (rdata_ar        ),
        .rempty(rempty_ar       ),
        .rinc  (rinc_ar         ),
        .rclk  (core_clk        ),
        .rrst_n(core_arstn      )
    );

    // write addresss and control

    logic [C_AW_WIDTH-1:0] wdata_aw;
    assign wdata_aw = {s_nasti.aw_id, s_nasti.aw_addr, s_nasti.aw_len, s_nasti.aw_size, s_nasti.aw_burst};

    logic wfull_aw;
    assign s_nasti.aw_ready = ~wfull_aw;

    afifo #(
        .C_DATA_WIDTH(C_AW_WIDTH  ),
        .C_ADDR_WIDTH(C_FIFO_DEPTH)
    ) i_afifo_aw (
        .wdata (wdata_aw        ),
        .wfull (wfull_aw        ),
        .winc  (s_nasti.aw_valid),
        .wclk  (s_nasti_clk     ),
        .wrst_n(s_nasti_aresetn ),
        .rdata (rdata_aw        ),
        .rempty(rempty_aw       ),
        .rinc  (rinc_aw         ),
        .rclk  (core_clk        ),
        .rrst_n(core_arstn      )
    );

    // write data

    logic [C_W_WIDTH-1:0] wdata_w;
    assign wdata_aw = {s_nasti.w_data, s_nasti.w_strb};

    logic wfull_w;
    assign s_nasti.w_ready = ~wfull_w;

    afifo #(
        .C_DATA_WIDTH(C_W_WIDTH   ),
        .C_ADDR_WIDTH(C_FIFO_DEPTH)
    ) i_afifo_w (
        .wdata (wdata_w        ),

        .wfull (wfull_w        ),
        .winc  (s_nasti.w_valid),
        .wclk  (s_nasti_clk    ),
        .wrst_n(s_nasti_aresetn),
        .rdata (rdata_w        ),
        .rempty(rempty_w       ),
        .rinc  (rinc_w         ),
        .rclk  (core_clk       ),
        .rrst_n(core_arstn     )
    );

    // write response

    logic rempty_b;
    assign s_nasti.b_ready = ~rempty_b;

    afifo #(
        .C_DATA_WIDTH(C_B_WIDTH   ),
        .C_ADDR_WIDTH(C_FIFO_DEPTH)
    ) i_afifo_b (
        .wdata (wdata_b        ),
        .wfull (wfull_b        ),
        .winc  (winc_b         ),
        .wclk  (core_clk       ),
        .wrst_n(core_arstn     ),
        .rdata (s_nasti.b_resp ),
        .rempty(rempty_b       ),
        .rinc  (s_nasti.b_valid),
        .rclk  (s_nasti_clk    ),
        .rrst_n(s_nasti_aresetn)
    );

    // read data

    logic rempty_r;
    assign s_nasti.r_ready = ~rempty_r;

    afifo #(
        .C_DATA_WIDTH(C_R_WIDTH   ),
        .C_ADDR_WIDTH(C_FIFO_DEPTH)
    ) i_afifo_r (
        .wdata (wdata_r        ),
        .wfull (wfull_r        ),
        .winc  (winc_r         ),
        .wclk  (core_clk       ),
        .wrst_n(core_arstn     ),
        .rdata (s_nasti.r_data ),
        .rempty(rempty_r       ),
        .rinc  (s_nasti.r_valid),
        .rclk  (s_nasti_clk    ),
        .rrst_n(s_nasti_aresetn)
    );

endmodule // nasti_frontend
