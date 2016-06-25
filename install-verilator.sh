#!/bin/sh

set -e

if [ ! -d "${HOME}/verilator/bin" ]; then
    wget https://github.com/diadatp/verilator/archive/verilator_3_882.tar.gz
    tar -xzvf verilator_3_882.tar.gz && cd verilator-verilator_3_882
    autoconf && ./configure --prefix="${HOME}/verilator" && make && make install
else
    echo "Using Verilator 3.882 from cached directory."
fi
