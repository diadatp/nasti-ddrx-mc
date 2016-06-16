/**
 * This module is responsible for mapping a NASTI address to SDRAM addressing.
 */

// `include "types.svh"

module address_mapper #(
    C_NASTI_ADDR_WIDTH = 32,
    C_NASTI_DATA_WIDTH = 64,
    C_CS_WIDTH         = 1 ,
    C_DQ_WIDTH         = 64,
    C_ROW_WIDTH        = 16,
    C_BANK_WIDTH       = 3
) (
    input  row_widths                   r_width   ,
    input  col_widths                   c_width   ,
    input                               bor       , // bank or rank at msb
    //
    input      [C_NASTI_ADDR_WIDTH-1:0] nasti_addr,
    output     [        C_CS_WIDTH-1:0] rank      ,
    output reg [      C_BANK_WIDTH-1:0] bank      ,
    output reg [       C_ROW_WIDTH-1:0] row       ,
    output reg [                  11:0] column
);

    initial begin
        // TODO fix in later revision
        assert(C_NASTI_DATA_WIDTH >= C_DQ_WIDTH) else $fatal(1, "[mc] NASTI data width is too small.");
    end

    localparam OFFSET_BITS = C_DQ_WIDTH/8;

    int i;

    logic [C_NASTI_ADDR_WIDTH-1:0] second_stage;

    always_comb begin : proc_column
        for(i = 0; i < 12; i++) begin
            unique case (c_width)
                c9 : if(i < 10) begin
                    column[i] <= nasti_addr[i + OFFSET_BITS];
                end else begin
                    column[i] <= 1'b0;
                end
                c10 : if(i < 11) begin
                    column[i] <= nasti_addr[i + OFFSET_BITS];
                end else begin
                    column[i] <= 1'b0;
                end
                c11 : begin
                    column[i] <= nasti_addr[i + OFFSET_BITS];
                end
            endcase
        end
    end

    always_comb begin : proc_second_stage
        for(i = 0; i < C_NASTI_ADDR_WIDTH - 12; i++) begin
            unique case (c_width)
                c9  : second_stage[i] <= nasti_addr[i + 10];
                c10 : second_stage[i] <= nasti_addr[i + 11];
                c11 : second_stage[i] <= nasti_addr[i + 12];
            endcase
        end
    end

    always_comb begin : proc_row
        for(i = 0; i < C_ROW_WIDTH; i++) begin
            unique case (r_width)
                r11 : if(i < 12) begin
                    row[i] <= second_stage[i];
                end else begin
                    row[i] <= 1'b0;
                end
                r12 : if(i < 13) begin
                    row[i] <= second_stage[i];
                end else begin
                    row[i] <= 1'b0;
                end
                r13 : if(i < 14) begin
                    row[i] <= second_stage[i];
                end else begin
                    row[i] <= 1'b0;
                end
                r14 : if(i < 15) begin
                    row[i] <= second_stage[i];
                end else begin
                    row[i] <= 1'b0;
                end
                r15 : row[i] <= second_stage[i];
            endcase
        end
    end

    always_comb begin : proc_bank
        for(i = 0; i < C_BANK_WIDTH; i++) begin
            unique case (r_width)
                r11 : bank[i] <= second_stage[i + 12];
                r12 : bank[i] <= second_stage[i + 13];
                r13 : bank[i] <= second_stage[i + 14];
                r14 : bank[i] <= second_stage[i + 15];
                r15 : bank[i] <= second_stage[i + 16];
            endcase
        end
    end

endmodule // address_mapper
