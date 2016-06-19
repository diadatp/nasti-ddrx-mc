#include <iostream>

#include <sys/times.h>
#include <sys/stat.h>

#include <systemc.h>
#include <scv.h>

#include "verilated.h"
#include "verilated_vcd_sc.h"

#include "Vtop.h"

int sc_main (int argc, char* argv[]) {

    // pass command line arguments to verilator
    Verilated::commandArgs(argc, argv);

    // randomize all uninitialized signals
    Verilated::randReset(2);

    // define clock periods
    sc_time s_nasti_clk_period(10, SC_NS);
    sc_time core_clk_period(2, SC_NS);

    // define clocks
    sc_clock core_clk ("core_clk", core_clk_period);
    sc_clock s_nasti_clk ("s_nasti_clk", s_nasti_clk_period);

    // define top level signals
    sc_signal<bool> s_nasti_aresetn;
    sc_signal<bool> s_nastilite_aresetn;

    // create instance of DUV and perform interconnect
    Vtop* top = new Vtop("top");
    top->s_nasti_aresetn(s_nasti_aresetn);

    // initialize simulation inputs
    s_nasti_aresetn = 0;

    // init trace dump
    Verilated::traceEverOn(true);

    sc_start(1, SC_NS);

    VerilatedVcdSc* tfp = new VerilatedVcdSc;
    top->trace (tfp, 99);
    tfp->open ("dump.vcd");

    // run simulation for 100 clock periods
    while (VL_TIME_Q() < 60) {
        tfp->dump (core_clk);
    }

    // test done, close VCD dump and exit
    tfp->close();
    exit(0);
}
