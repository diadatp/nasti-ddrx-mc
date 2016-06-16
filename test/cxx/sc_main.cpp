#include <iostream>

#include <sys/times.h>
#include <sys/stat.h>

#include <scv.h>

#include "verilated.h"
#include "verilated_vcd_c.h"

#include "Vtop.h"

int sc_main (int argc, char* argv[]) {

    int i;
    int clk;
    Verilated::commandArgs(argc, argv);

    // init top verilog instance
    Vtop* top = new Vtop;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("dump.vcd");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;

    // run simulation for 100 clock periods
    for (i = 0; i < 20; i++) {
        top->rst = (i < 2);
        // dump variables into VCD file and toggle clock
        for (clk = 0; clk < 2; clk++) {
            tfp->dump (2 * i + clk);
            top->clk = !top->clk;
            top->eval ();
        }
        top->cen = (i > 5);
        top->wen = (i == 10);
        if (Verilated::gotFinish())  exit(0);
    }
    tfp->close();
    exit(0);
    return 0;
}
