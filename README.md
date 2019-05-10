# memmove
FPGA IP Core for moving data between modules.

This module parses and executes a **UDMA** instruction for data moving within a system.
The instruction has the following form:

```
UDMA:
<src address> <dest address> <src increment> <dest increment> <# of words>

```

_The actual implementation has the following bit size:_

```
UDMA:
<src address> <dest address> <src increment> <dest increment> <# of words>
|- N bits --| |- N bits ---| |- N/2 bits --| |- N/2 bits ---| |- N bits -|

```

### Usage
The core will start parsing an instruction when the `start` signal is asserted. The instruction fields are meant to be read from a RAM memory (for example, the BRAM included within the `comblock`) in contiguous addresses.
When parsing starts, the `busy`signal is asserted. Consecuently, when instruction was executed, the `done` flag rises for one clock.

Within the code a `simple_interconnect` module is provided in order to assign slaves (i.e. organize the memory map). Check the _example_design_ in order to clarify usage.

### Current restrictions
* The core will expect exactly the amount of data stated in the UDMA instruction. This implies that if a peripheral does not respond, or if the amount of data in his answer is less than the number asked, the core will remain freezed waiting for data.
* Peripheral variable latency is no yet handled. The core is optimized to read/write in a similar timing scheme as a BRAM or a FIFO. Other latencies must be handled by the user. 

### Simulation

The simulation is guided via [cocotb](https://github.com/potentialventures/cocotb). 
cocotb execution is coordinated with a series of Makefiles and the simulation with the associated testbenchs is performed on a python framework. For installing and bootstraping cocotb, follow the steps provided in the respective documentation [site](https://cocotb.readthedocs.io/en/latest/quickstart.html).

Furthermore, cocotb needs a simulator. In particular, GHDL was used because of its availability, performance, conformance to standards, and open-sourceness. It is available [here](https://github.com/ghdl/ghdl). You are invited to use other simulator, but that requires tweaking the cocotb Makefiles.

To start the simulation just do:

```
make XILINXCORELIB=../xilinx/ghdl/xilinx-ise test-all
```

*Important*: For the simulation to work, the simulation libraries of Xilinx must be compiled with GHDL. To do this execute the script [compile-xilinx-ise.sh](https://github.com/ghdl/ghdl/tree/master/libraries/vendors) with the `--all` flag at the directory where you want to put the compiled libraries.
Then, don't forget to pass this location to the Makefile setting the variable `XILINXCORELIB` or hardcode it in the Makefile itself. The default location for this variable is `memmove/../xilinx/ghdl/xilinx-ise`.

Examples:
```
make XILINXCORELIB=../xilinx/ghdl/xilinx-ise memmv
make XILINXCORELIB=../xilinx/ghdl/xilinx-ise memmv-wave
make XILINXCORELIB=../xilinx/ghdl/xilinx-ise fsm_cmd
make XILINXCORELIB=../xilinx/ghdl/xilinx-ise fsm_cmd-wave
make clean-all
```

Feel free to explore and alter the Makefile to trigger others simulations.