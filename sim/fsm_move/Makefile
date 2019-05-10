export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

TOPLEVEL_LANG=vhdl
SIM=ghdl

VHDL_SOURCES=$(PROJECT_DIR)/hdl/memmv_params.vhd \
			 $(PROJECT_DIR)/hdl/modules/fsm_move.vhd \
			 $(PROJECT_DIR)/hdl/modules/fifo/fifo_generator_v9_3.vhd \
			 
TOPLEVEL=fsm_move

XILINXCORELIB := $(PROJECT_DIR)/../xilinx/ghdl/xilinx-ise

EXTRA_ARGS= --ieee=synopsys -fexplicit -P$(XILINXCORELIB) --warn-no-binding
SIM_ARGS=  --wave=fsm_move.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/fsm_move.ghw $(GTK_SAVEFILE)

