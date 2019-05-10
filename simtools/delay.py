import cocotb
from cocotb.triggers import RisingEdge

@cocotb.coroutine
def delay(clk, s, s_delayed, clocks=1):
    while True:
        for _ in range(clocks):
            yield RisingEdge(clk)
        s_delayed <= s.value

