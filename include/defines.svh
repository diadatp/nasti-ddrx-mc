/**
 * This file defines macros that are used to configure the memory controller.
 */

// The clock cycle period of the core_clk signal in 1n/1p.
`define C_CORE_CLK_PERIOD 5.000

// The number of identification tags bits to be supported by the slave.
`define C_NASTI_ID_WIDTH 1

// The width of the address bus on the NASTI interface. For flexibility in
// dynamic SDRAM density support, a minimum of xx is required.
`define C_NASTI_ADDR_WIDTH  30

// The width of the data bus on the NASTI interface. This is critical to the
// efficiency of the design.
`define C_NASTI_DATA_WIDTH  64

// The width of User-defined signals. Usused but set to 1, trimmed by synthesis.
`define C_NASTI_USER_WIDTH  1

// The width of the NASTI-Lite address bus. Do not touch this value.
`define C_NASTIL_ADDR_WIDTH 6

// The width of the NASTI-Lite data bus. Set to either 32 or 64. 64 preferred.
`define C_NASTIL_DATA_WIDTH 64

// The width of User-defined signals. Usused but set to 1, trimmed by synthesis.
`define C_NASTIL_USER_WIDTH  1

// The number of address bits on the DFI interface. This is the number of
// address bits on the DRAM device. Generall A0-A15.
`define C_DFI_ADDR_WIDTH 16

// The number of bank bits on the DFI interface. This is the number of bank pins
// on the DRAM device. DDR3 has a fixed 8 bank configuration while DDR2 can be
// either 4 or 8.
`define C_DFI_BANK_WIDTH 3

//  The number of bits required to control the DRAMs, usually a single bit.A
`define C_DFI_CTRL_WIDTH 1

// The number of chip select bits on the DFI interface. This is the number of
// chip select pins on the DRAM bus. It is set to 2 to accomidate a dual rank
// DIMM.
`define C_DFI_CS_WIDTH 2

// The width of the datapath on the DFI interface. This is generally twice the
// DRAM data width to accomidate for DDR timing.
`define C_DFI_DATA_WIDTH 128

// The width of the datapath enable signals on the DFI interface. For PHYs with
// an 8-bit slice, this is generally 1/16th of the DFI Data Width to provide a
// single enable bit per memory data slice, but may be 1/4, 1/8, 1/32, or any
// other ratio. Bit zero corresponds to the lowest segment.
`define C_DFI_DATAEN_WIDTH (`C_DFI_DATA_WIDTH/16)

`define C_DFI_DACS_WIDTH (`C_DFI_CS_WIDTH*`C_DFI_DATAEN_WIDTH)

// The number of data mask bits on the DFI interface. One per 8 bits of data.
`define C_DFI_DM_WIDTH (`C_DFI_DATA_WIDTH/8)

// The width of the alert signal on the DFI interface. Typically the PHY would
// drive an alert signal per slice and the alert is typically 1-bit.
`define C_DFI_ALERT_WIDTH 1

// The width of the error signal on the DFI interface.
`define C_DFI_ERR_WIDTH 1

`define C_FREQ_RATIO 4
