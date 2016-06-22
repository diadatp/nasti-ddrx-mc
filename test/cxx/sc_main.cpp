#include <iostream>

#include <sys/times.h>
#include <sys/stat.h>

#include <systemc.h>
#include <scv.h>

#include "verilated.h"
#include "verilated_vcd_sc.h"

#include "vip_nasti_channel.h"
#include "vip_dfi_channel.h"

#include "Vtop.h"

int sc_main (int argc, char* argv[]) {

    // pass command line arguments to verilator
    Verilated::commandArgs(argc, argv);

    // randomize all uninitialized signals
    Verilated::randReset(2);

    // should be called before sc_time
    sc_set_time_resolution(1, SC_PS);

    // define clock periods
    sc_time s_nastil_clk_period(100, SC_NS); // 10 MHz
    sc_time s_nasti_clk_period(2, SC_NS);   // 500 MHz
    sc_time core_clk_period(1.25, SC_NS);    // 800 MHz

    // define clocks
    sc_clock core_clk ("core_clk", core_clk_period);
    sc_clock s_nasti_clk ("s_nasti_clk", s_nasti_clk_period);
    sc_clock s_nastil_clk ("s_nastil_clk", s_nastil_clk_period);

    // define top level signals
    sc_signal<bool> core_arstn;
    sc_signal<bool> s_nasti_aresetn;
    sc_signal<bool> s_nastil_aresetn;

    // create instance of DUT and perform interconnect
    Vtop* dut = new Vtop("dut");

    vip_nasti_channel* nasti_channel = new vip_nasti_channel("nasti_channel");
    nasti_channel->slaveBind(dut);

    vip_dfi_channel* dfi_channel = new vip_dfi_channel("dfi_channel");
    dfi_channel->masterBind(dut);

    dut->core_arstn(core_arstn);
    dut->s_nasti_aresetn(s_nasti_aresetn);
    // dut->s_nastil_aresetn(s_nastil_aresetn);

    dut->core_clk(core_clk);
    dut->s_nasti_clk(s_nasti_clk);

    // initialize simulation inputs
    s_nasti_aresetn = 0;
    s_nastil_aresetn = 0;
    core_arstn = 0;

    // init trace dump
    Verilated::traceEverOn(true);

    // one evaluation before enabling waves
    sc_start(1, SC_NS);

    VerilatedVcdSc* tfp = new VerilatedVcdSc;
    dut->trace(tfp, 99);
    tfp->open("dump.vcd");

    // run simulation for 100 clock periods
    while (VL_TIME_Q() < 100) {
        if (VL_TIME_Q() > 10) {
            s_nasti_aresetn = 1;
            s_nastil_aresetn = 1;
            core_arstn = 1;
        }
        sc_start(1, SC_NS);
        // tfp->dump(core_clk);
    }

    if (tfp) {
        tfp->flush();
    }

    sc_stop();

    // test done, close VCD dump and exit
    tfp->close();

    // write coverage data
    VerilatedCov::write("coverage.dat");

    return (0);
}
