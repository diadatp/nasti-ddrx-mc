/**
 *
 */

interface nastilite_if #(
        C_NASTI_ADDR_WIDTH = 3, // width of address
        C_NASTI_DATA_WIDTH = 64, // width of data, must be either 32 or 64
        C_NASTI_USER_WIDTH = 1   // width of user field, must > 0, let synthesizer trim it if not in use
    );

    initial begin
        assert((32 == C_NASTI_DATA_WIDTH) || (64 == C_NASTI_DATA_WIDTH)) else $fatal(1, "[nastilite interface] Data field must be either 32 or 64 bits wide!");
    end

    // write/read address
    logic [C_NASTI_ADDR_WIDTH-1:0] aw_addr,   ar_addr;
    logic [                   2:0] aw_prot,   ar_prot;
    logic [                   3:0] aw_qos,    ar_qos;
    logic [                   3:0] aw_region, ar_region;
    logic [C_NASTI_USER_WIDTH-1:0] aw_user,   ar_user;
    logic                          aw_valid,  ar_valid;
    logic                          aw_ready,  ar_ready;

    // write/read data
    logic [  C_NASTI_DATA_WIDTH-1:0] w_data,  r_data;
    logic [C_NASTI_DATA_WIDTH/8-1:0] w_strb ;
    logic [  C_NASTI_USER_WIDTH-1:0] w_user ;
    logic                            w_valid;
    logic                            w_ready;

    // write/read response
    logic [                   1:0] b_resp,    r_resp;
    logic [C_NASTI_USER_WIDTH-1:0] b_user,    r_user;
    logic                          b_valid,   r_valid;
    logic                          b_ready,   r_ready;

    modport master (
        // write/read address
        output aw_addr,   ar_addr,
        output aw_prot,   ar_prot,
        output aw_qos,    ar_qos,
        output aw_region, ar_region,
        output aw_user,   ar_user,
        output aw_valid,  ar_valid,
        input  aw_ready,  ar_ready,
        // write data
        output w_data,
        output w_strb,
        output w_user,
        output w_valid,
        input  w_ready,
        // read data
        input  r_data,
        // write/read response
        input  b_resp,  r_resp,
        input  b_user,  r_user,
        input  b_valid, r_valid,
        output b_ready, r_ready
    );

    modport slave (
        // write/read address
        input  aw_addr,   ar_addr,
        input  aw_prot,   ar_prot,
        input  aw_qos,    ar_qos,
        input  aw_region, ar_region,
        input  aw_user,   ar_user,
        input  aw_valid,  ar_valid,
        output aw_ready,  ar_ready,
        // write data
        input  w_data,
        input  w_strb,
        input  w_user,
        input  w_valid,
        output w_ready,
        // read data
        output r_data,
        // write/read response
        output b_resp,  r_resp,
        output b_user,  r_user,
        output b_valid, r_valid,
        input  b_ready, r_ready
    );

endinterface // nastilite_if
