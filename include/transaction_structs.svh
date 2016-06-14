/**
 * This file defines commonly used structures to encapsulate NASTI transactions.
 */

typedef struct {
    logic [  C_NASTI_ID_WIDTH-1:0] ar_id   ;
    logic [C_NASTI_ADDR_WIDTH-1:0] ar_addr ;
    logic [                   7:0] ar_len  ;
    logic [                   2:0] ar_size ;
    logic [                   1:0] ar_burst;
} ar_trans;

typedef struct {
    logic [C_NASTI_ADDR_WIDTH-1:0] aw_addr ;
    logic [                   7:0] aw_len  ;
    logic [                   2:0] aw_size ;
    logic [                   1:0] aw_burst;
} aw_trans;

typedef struct {
    logic [  C_NASTI_DATA_WIDTH-1:0] w_data;
    logic [C_NASTI_DATA_WIDTH/8-1:0] w_strb;
    logic                            w_last;
} w_trans;

typedef struct {
    logic [C_NASTI_DATA_WIDTH-1:0] r_data;
    logic                          r_last;
} r_trans;
