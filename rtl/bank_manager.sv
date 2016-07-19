/**
 * This module is responsible keeping track of open rows and banks.
 * TODO Implement open row vs. closed row priority.
 */

`include "timescale.svh"

module bank_manager #(C_ROW_WIDTH = 14) (
    input                          core_clk   ,
    input                          core_arstn ,
    //
    input                          update_row ,
    input        [C_ROW_WIDTH-1:0] new_row    ,
    output logic [C_ROW_WIDTH-1:0] current_row,
    //
    input                          toggle_bank,
    output logic                   bank_open
);

    always_ff @(posedge core_clk or negedge core_arstn) begin : proc_bank
        if(~core_arstn) begin
            current_row <= '0;
            bank_open   <= '0;
        end else begin
            if(1'b1 == update_row) begin
                current_row <= new_row;
            end
            if(1'b1 == toggle_bank) begin
                bank_open <= ~bank_open;
            end
        end
    end

endmodule