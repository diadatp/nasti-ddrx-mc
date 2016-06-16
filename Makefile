
proj_dir = $(abspath .)

setup:
	cd $(proj_dir)/sim/models/micron/ddr3/ && ./fetch.sh
	cd $(proj_dir)/sim/models/micron/ddr2/ && ./fetch.sh
	export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.1/lib-linux64/
	export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.1/include/
	export LD_LIBRARY_PATH=.:/usr/local/scv/lib-linux64/:/usr/local/systemc-2.3.1/lib-linux64/

build:
	cd $(proj_dir)/sim
	verilator --trace -I$(proj_dir)/include -I$(proj_dir)/rtl \
	--sc $(proj_dir)/test/sv/top.sv --exe $(proj_dir)/test/cxx/sc_main.cpp \
	--coverage --top-module top -Wno-lint
	make -C obj_dir -j -f Vtop.mk Vtop

run:
	./obj_dir/Vtop
