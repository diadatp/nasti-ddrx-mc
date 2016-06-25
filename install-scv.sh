#!/bin/sh

set -e

if [ ! -d "${HOME}/scv-2.0.0/lib-linux64" ]; then
    wget http://accellera.org/images/downloads/standards/systemc/scv-2.0.0.tgz
    tar -xzvf scv-2.0.0.tgz && cd scv-2.0.0
    ./configure --prefix="${HOME}/scv-2.0.0" --with-systemc="${SYSTEMC_HOME}"
    make && make check && make install
else
    echo "Using SCV 2.0.0 from cached directory."
fi
