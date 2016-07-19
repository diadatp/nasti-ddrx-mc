/**
 *
 */

`include "timescale.svh"

module sfifo #(
    parameter C_DATA_WIDTH = 0,
    parameter C_ADDR_WIDTH = 0
) (
    input                     clk   ,
    input                     arstn ,
    input  [C_DATA_WIDTH-1:0] wdata ,
    output                    wfull ,
    input                     wren  ,
    output [C_DATA_WIDTH-1:0] rdata ,
    output                    rempty,
    input                     rden
);

    logic rst;
    assign rst = ~arstn;

    logic [upper:0] rempty_i;
    logic [upper:0] wfull_i ;

    assign rempty = |rempty_i;
    assign wfull  = |wfull_i;

    localparam upper = ceild(C_DATA_WIDTH, 72);

    logic [upper-1:0][71:0] rdata_mapped;
    logic [upper-1:0][71:0] wdata_mapped;

    generate
        for (genvar i = 0; i < C_DATA_WIDTH; i++) begin
            assign rdata[i] = rdata_mapped[i/72][i%72];
            assign wdata_mapped[i/72][i%72] = wdata[i];
        end
    endgenerate

    generate
        for (genvar i = 0; i < upper; i++) begin
            FIFO_SYNC_MACRO #(
                .DEVICE             ("7SERIES"), // Target Device: "7SERIES"
                .ALMOST_EMPTY_OFFSET(9'h080   ), // Sets the almost empty threshold
                .ALMOST_FULL_OFFSET (9'h080   ), // Sets almost full threshold
                .DATA_WIDTH         (72       ), // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
                .DO_REG             (1        ), // Optional output register (0 or 1)
                .FIFO_SIZE          ("36Kb"   )  // Target BRAM: "18Kb" or "36Kb"
            ) FIFO_SYNC_MACRO_inst (
                .ALMOSTEMPTY(               ), // 1-bit output almost empty
                .ALMOSTFULL (               ), // 1-bit output almost full
                .DO         (rdata_mapped[i]), // Output data, width defined by DATA_WIDTH parameter
                .EMPTY      (rempty_i[i]    ), // 1-bit output empty
                .FULL       (wfull_i[i]     ), // 1-bit output full
                .RDCOUNT    (               ), // Output read count, width determined by FIFO depth
                .RDERR      (               ), // 1-bit output read error
                .WRCOUNT    (               ), // Output write count, width determined by FIFO depth
                .WRERR      (               ), // 1-bit output write error
                .CLK        (clk            ), // 1-bit input clock
                .DI         (wdata_mapped[i]), // Input data, width defined by DATA_WIDTH parameter
                .RDEN       (rden           ), // 1-bit input read enable
                .RST        (rst            ), // 1-bit input reset
                .WREN       (wren           )  // 1-bit input write enable
            );
        end
    endgenerate

endmodule // sfifo
