import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

from simtools.ROM import ROM

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
def test_fsm_cmd(dut):

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)
    rom = ROM(dut.clk, dut.address, dut.din, dut.rd_en, size='2K')
    rom.load({0:0x40000000,  #src address
              1:0x50000000,  #dst address
              2:0x01000001,  #src incr | dst incr
              3:0x00000050}) #move size
    
    dut._log.info('Instruction loaded on ROM')

    dut.start <= 1
    yield RisingEdge(dut.clk)
    dut.start <= 0
    for _ in range(10):
        yield RisingEdge(dut.clk)    

    
