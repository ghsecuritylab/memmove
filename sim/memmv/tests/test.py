import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

from simtools import ROM, delay

@cocotb.coroutine
def reset(dut):
    dut.start <= 0
    dut.din <= 0
    dut.rst <= 1
    yield Timer(1500)
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_memmove(dut):

    rom_src = ROM(dut.clk, dut.address, dut.din, dut.rd_rq, size=2048)
    rom_src.load(list(range(10, 2058)))

    rom_cmd = ROM(dut.clk, dut.cmd_addr, dut.cmd_in, dut.cmd_fetch, size=2048)

    # move 50 words from position 0 of source to position 80 of destination
    # with source incrementing of 2 and destination incrementing of 1
    rom_cmd.load({0:0,          #src address
                  1:0x80,         #dst address
                  2:0x00020001, #src incr | dst incr
                  3:50})        #move size
    dut._log.info('Instruction loaded on ROM')

    # wr_en is a delayed copy of rd_rq
    cocotb.fork(delay(dut.clk, dut.rd_rq, dut.wr_en))

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())

    yield reset(dut)
    dut.start <= 1
    yield RisingEdge(dut.clk)
    dut.start <= 0
    
    #yield RisingEdge(dut.done) # our work here is done
    
    for _ in range(1000):
        yield RisingEdge(dut.clk)
    

    
