
proj_dir = $(abspath .)

setup:
	cd $(proj_dir)/sim/models/micron/ddr3/ && ./fetch.sh
	cd $(proj_dir)/sim/models/micron/ddr2/ && ./fetch.sh

build:
	cd $(proj_dir)/sim
	verilator -Wall --trace --cc $(proj_dir)/rtl/*.sv --exe $(proj_dir)/test/cxx/tb.cpp --coverage
	make -C obj_dir -j -f Vtop.mk Vtop

run:
	./obj_dir/Vtop
