# NASTI DDRx MC [![Build Status](https://travis-ci.org/diadatp/nasti-ddrx-mc.svg?branch=master)](https://travis-ci.org/diadatp/nasti-ddrx-mc)

This project is a high performance memory controller that provides a configurable NASTI slave memory mapped interface to DDR2/3 SDRAM (through DFI 3.1). It is a single channel controller with one NASTI slave port. It has been designed to support a wide range of SDRAM configurations from single chip to multi-rank modules.

## Getting Started

Clone the repository and run 'make setup', this will download and unpack all external project resources. Once this is done run 'make build & make sim' to simulate the controller.