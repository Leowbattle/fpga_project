GOWIN_ROOT = /opt/gowin/

GW_SH = LD_PRELOAD=/lib/x86_64-linux-gnu/libfreetype.so QT_QPA_PLATFORM=minimal $(GOWIN_ROOT)/bin/gw_sh

BITSTREAM_PATH = impl/pnr/fpga_project.fs

.PHONY: clean program format

$(BITSTREAM_PATH): build.tcl src/main.cst src/*.v
	$(GW_SH) build.tcl

program: $(BITSTREAM_PATH)
	openFPGALoader -b tangnano20k $(BITSTREAM_PATH)

console: program
	picocom /dev/ttyUSB1 -b 115200 --omap crlf

format:
	verible-verilog-format --inplace src/*.v test/*.v

clean::
	rm -rf impl
	rm -f *.gprj.user
