/**
 *
 */

interface nasti_if  #(
        C_NASTI_ID_WIDTH   = 9,  // width of id
        C_NASTI_ADDR_WIDTH = 32, // width of address
        C_NASTI_DATA_WIDTH = 64, // width of data
        C_NASTI_USER_WIDTH = 1   // width of user field, must > 0, let synthesizer trim it if not in use
    );

    initial begin
        assert(C_NASTI_USER_WIDTH > 0) else $fatal(1, "[nasti interface] User field must have at least 1 bit!");
        // TODO fix
        // assert((32 == C_NASTI_DATA_WIDTH) || (64 == C_NASTI_DATA_WIDTH)) else $fatal(1, "[nastilite interface] Data field must be either 32 or 64 bits wide!");
    end

    // write/read address
    logic [  C_NASTI_ID_WIDTH-1:0] aw_id,     ar_id;
    logic [C_NASTI_ADDR_WIDTH-1:0] aw_addr,   ar_addr;
    logic [                   7:0] aw_len,    ar_len;
    logic [                   2:0] aw_size,   ar_size;
    logic [                   1:0] aw_burst,  ar_burst;
    logic                          aw_lock,   ar_lock;
    logic [                   3:0] aw_cache,  ar_cache;
    logic [                   2:0] aw_prot,   ar_prot;
    logic [                   3:0] aw_qos,    ar_qos;
    logic [                   3:0] aw_region, ar_region;
    logic [C_NASTI_USER_WIDTH-1:0] aw_user,   ar_user;
    logic                          aw_valid,  ar_valid;
    logic                          aw_ready,  ar_ready;

    // write/read data
    logic [  C_NASTI_DATA_WIDTH-1:0] w_data,  r_data;
    logic [C_NASTI_DATA_WIDTH/8-1:0] w_strb ;
    logic                            w_last,  r_last;
    logic [  C_NASTI_USER_WIDTH-1:0] w_user ;
    logic                            w_valid;
    logic                            w_ready;

    // write/read response
    logic [  C_NASTI_ID_WIDTH-1:0] b_id,      r_id;
    logic [                   1:0] b_resp,    r_resp;
    logic [C_NASTI_USER_WIDTH-1:0] b_user,    r_user;
    logic                          b_valid,   r_valid;
    logic                          b_ready,   r_ready;

    modport master (
        // write/read address
        output aw_id,     ar_id,
        output aw_addr,   ar_addr,
        output aw_len,    ar_len,
        output aw_size,   ar_size,
        output aw_burst,  ar_burst,
        output aw_lock,   ar_lock,
        output aw_cache,  ar_cache,
        output aw_prot,   ar_prot,
        output aw_qos,    ar_qos,
        output aw_region, ar_region,
        output aw_user,   ar_user,
        output aw_valid,  ar_valid,
        input  aw_ready,  ar_ready,
        // write data
        output w_data,
        output w_strb,
        output w_last,
        output w_user,
        output w_valid,
        input  w_ready,
        // read data
        input  r_data,
        input  r_last,
        // write/read response
        input  b_id,    r_id,
        input  b_resp,  r_resp,
        input  b_user,  r_user,
        input  b_valid, r_valid,
        output b_ready, r_ready
    );

    modport slave (
        // write/read address
        input  aw_id,     ar_id,
        input  aw_addr,   ar_addr,
        input  aw_len,    ar_len,
        input  aw_size,   ar_size,
        input  aw_burst,  ar_burst,
        input  aw_lock,   ar_lock,
        input  aw_cache,  ar_cache,
        input  aw_prot,   ar_prot,
        input  aw_qos,    ar_qos,
        input  aw_region, ar_region,
        input  aw_user,   ar_user,
        input  aw_valid,  ar_valid,
        output aw_ready,  ar_ready,
        // write data
        input  w_data,
        input  w_strb,
        input  w_last,
        input  w_user,
        input  w_valid,
        output w_ready,
        // read data
        output r_data,
        output r_last,
        // write/read response
        output b_id,    r_id,
        output b_resp,  r_resp,
        output b_user,  r_user,
        output b_valid, r_valid,
        input  b_ready, r_ready
    );

endinterface // nasti_if
