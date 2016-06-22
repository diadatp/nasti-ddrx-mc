
proj_dir = $(abspath .)

default:
	echo "make build"

setup:
	cd $(proj_dir)/sim/models/micron/ddr3/ && ./fetch.sh
	cd $(proj_dir)/sim/models/micron/ddr2/ && ./fetch.sh

build:
	cd $(proj_dir)

	verilator -f input.vc -I$(proj_dir)/include -I$(proj_dir)/rtl \
	$(proj_dir)/test/sv/top.sv $(proj_dir)/test/cxx/*.cpp \
	-CFLAGS "-I$(SCV_INCLUDE)"

	make -C obj_dir -j $(JOBS) -f Vtop.mk Vtop

run:
	./obj_dir/Vtop

coverage:
	verilator_coverage coverage.dat --rank --annotate coverage

clean:
	rm -rf obj_dir coverage dump.vcd coverage.dat
