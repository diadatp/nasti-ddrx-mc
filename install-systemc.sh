#!/bin/sh

set -e

if [ ! -d "${HOME}/systemc-2.3.1/lib-linux64" ]; then
    wget http://accellera.org/images/downloads/standards/systemc/systemc-2.3.1.tgz
    tar -xzvf systemc-2.3.1.tgz && cd systemc-2.3.1
    ./configure --prefix="${HOME}/systemc-2.3.1" && make && make check && make install
else
    echo "Using SystemC 2.3.1 from cached directory."
fi
