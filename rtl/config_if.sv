/**
 *
 */

interface config_if;

    logic [18:0] msr0;
    logic [18:0] msr1;
    logic [18:0] msr2;
    logic [18:0] msr3;

    modport master (
        output msr0,
        output msr1,
        output msr2,
        output msr3
    );

    modport slave (
        input msr0,
        input msr1,
        input msr2,
        input msr3
    );

endinterface // config_if
