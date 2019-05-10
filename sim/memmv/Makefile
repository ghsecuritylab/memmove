export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

LANG=vhdl
SIM=ghdl

VHDL_SOURCES= $(PROJECT_DIR)/hdl/memmv_params.vhd \
			  $(PROJECT_DIR)/hdl/simple_interconnect.vhd \
			  $(PROJECT_DIR)/hdl/memmv.vhd \
			  $(PROJECT_DIR)/hdl/modules/fsm_move.vhd \
			  $(PROJECT_DIR)/sim/IPs/incoming_data_fifo.vhd \
			  $(PROJECT_DIR)/hdl/modules/fsm_cmd.vhd 

TOPLEVEL=memmv

EXTRA_ARGS= --ieee=synopsys -fexplicit -P$(XILINXCORELIB) --warn-no-binding
SIM_ARGS=  --wave=memmv.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/memmv.ghw $(GTK_SAVEFILE)

