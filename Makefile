
proj_dir = $(abspath .)

default:
	echo "make build"

setup:
	cd $(proj_dir)/sim/models/micron/ddr3/ && ./fetch.sh
	cd $(proj_dir)/sim/models/micron/ddr2/ && ./fetch.sh

build:
	cd $(proj_dir)

	verilator -f input.vc -I$(proj_dir)/include -I$(proj_dir)/rtl \
	--sc $(proj_dir)/test/sv/top.sv --top-module top \
	--exe $(proj_dir)/test/cxx/sc_main.cpp -CFLAGS "-I /usr/local/scv/include/"

	make -C obj_dir -j $(JOBS) -f Vtop.mk Vtop

run:
	./obj_dir/Vtop

