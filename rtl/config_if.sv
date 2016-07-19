/**
 *
 */

`include "timescale.svh"

interface config_if;

    logic [12:0] msr0        ;
    logic [12:0] msr1        ;
    logic [12:0] msr2        ;
    logic [12:0] msr3        ;
    logic [ 3:0] tAL         ;
    logic [ 3:0] tBURST      ;
    logic [ 3:0] tCCD        ;
    logic [ 3:0] tCL         ;
    logic [ 3:0] tCMD        ;
    logic [ 3:0] tCWD        ;
    logic [ 3:0] tCWL        ;
    logic [ 3:0] tFAW        ;
    logic [ 3:0] tMOD        ;
    logic [ 3:0] tMRD        ;
    logic [ 3:0] tOST        ;
    logic [ 3:0] tphy_rdcslat;
    logic [ 3:0] tphy_rdlat  ;
    logic [ 3:0] tRAS        ;
    logic [ 3:0] tRC         ;
    logic [ 3:0] tRCD        ;
    logic [ 3:0] trdata_en   ;
    logic [ 3:0] tRFC        ;
    logic [ 3:0] tRP         ;
    logic [ 3:0] tRRD        ;
    logic [ 3:0] tRTP        ;
    logic [ 3:0] tRTRS       ;
    logic [ 3:0] tWR         ;
    logic [ 3:0] tWTR        ;
    logic [ 3:0] tZQinit     ;
    logic [ 4:0] tXPR        ;

    modport master (
        output msr0,
        output msr1,
        output msr2,
        output msr3,
        output tAL,
        output tBURST,
        output tCCD,
        output tCL,
        output tCMD,
        output tCWD,
        output tCWL,
        output tFAW,
        output tMOD,
        output tMRD,
        output tOST,
        output tphy_rdcslat,
        output tphy_rdlat,
        output tRAS,
        output tRC,
        output tRCD,
        output trdata_en,
        output tRFC,
        output tRP,
        output tRRD,
        output tRTP,
        output tRTRS,
        output tWR,
        output tWTR,
        output tZQinit,
        output tXPR
    );

    modport slave (
        input msr0,
        input msr1,
        input msr2,
        input msr3,
        input tAL,
        input tBURST,
        input tCCD,
        input tCL,
        input tCMD,
        input tCWD,
        input tCWL,
        input tFAW,
        input tMOD,
        input tMRD,
        input tOST,
        input tphy_rdcslat,
        input tphy_rdlat,
        input tRAS,
        input tRC,
        input tRCD,
        input trdata_en,
        input tRFC,
        input tRP,
        input tRRD,
        input tRTP,
        input tRTRS,
        input tWR,
        input tWTR,
        input tZQinit,
        input tXPR
    );

endinterface // config_if
