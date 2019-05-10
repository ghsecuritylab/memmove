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