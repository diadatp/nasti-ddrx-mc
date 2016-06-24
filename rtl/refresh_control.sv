/**
* This module is responsible for timing refresh requests.
*/

module refresh_controller #(LOC           = 5) (
    input            clk_1024khz, // period = 78.125 us/8
    input            rstn       ,
    // scheduler side
    input            ref_req    ,
    output     [3:0] warning    ,
    // command generator side
    output reg       ref_do
);

    logic [15:0] count;

    logic [3:0] preponed ;
    logic [3:0] postponed;

    always_ff @(posedge clk_1024khz) begin : proc_count
        if(~rstn) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    always_ff @(posedge clk_1024khz) begin : proc_refresh
        if(rstn) begin
            if((4'b1000 == postponed) && (3'b000 == count[2:0])) begin
                // force a request, waited the maximum allowable time
                ref_do <= 1'b1;
            end else if((1'b1 == ref_req) && (3'b000 != count[2:0]) && (preponed < 4'b1000)) begin
                // wants to do a request before necessary, fulfill if possible
                preponed <= preponed + 1;
                ref_do   <= 1'b1;
            end else if(3'b000 == count[2:0]) begin
                postponed <= postponed + 1;
            end
        end
    end

    assign warning = postponed;

endmodule
