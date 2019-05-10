

export XILINXCORELIB ?= $(PROJECT_DIR)/../xilinx/ghdl/xilinx-ise

export PROJECT_DIR := $(PWD)
export PYTHONPATH:=$(realpath $(PROJECT_DIR)):$(PYTHONPATH)

TARGETS:= fsm_cmd fsm_move memmv
WAVE_TARGETS :=$(foreach word, $(TARGETS), $(word)-wave)
CLEAN_TARGETS:=$(foreach word, $(TARGETS), clean-$(word))

.PHONY: test-all clean-all $(TARGETS) $(CLEAN_TARGETS) $(WAVE_TARGETS)

test-all: $(TARGETS)
clean-all: $(CLEAN_TARGETS)

$(CLEAN_TARGETS):
	$(MAKE) -C sim/$(subst clean-,,$@) clean

$(TARGETS):
	$(MAKE) -C sim/$@

$(WAVE_TARGETS):
	$(MAKE) -C sim/$(subst -wave,,$@) gtkwave
