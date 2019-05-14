import cocotb
import pprint
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure

from simtools import ROM, RAM, delay

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

    rom_cmd = ROM(clk=dut.clk, 
                  address=dut.cmd_addr,
                  dout=dut.cmd_in, 
                  rden=dut.cmd_fetch, 
                  size='2K')

    # move 50 words from position 0 of source to position 80 of destination
    # with source incrementing of 2 and destination incrementing of 1
    
    rom_cmd.load({0:0,          #src address
                  1:0x80,         #dst address
                  2:0x00020001, #src incr | dst incr
                  3:50})        #move size
    dut._log.info('Instruction loaded on ROM')

    rom_src = ROM(clk=dut.clk, 
                  address=dut.address, 
                  dout=dut.din, 
                  rden=dut.rd_rq, 
                  size='2K')
    
    rom_src.load(list(range(10, 2058)))

    ram_dst = RAM(clk=dut.clk,
                  address=dut.address,
                  din=dut.dout,
                  rden = 0,
                  wren=dut.wr_en,
                  size='2K')
    
    # wr_en is a delayed copy of rd_rq
    cocotb.fork(delay(dut.clk, dut.rd_rq, dut.wr_en))

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())

    yield reset(dut)
    dut.start <= 1
    yield RisingEdge(dut.clk)
    dut.start <= 0
    
    yield RisingEdge(dut.done) # our work here is done
    
    for _ in range(5):
        yield RisingEdge(dut.clk)

  

    src = rom_src.read(range(0,100,2))
    dst = ram_dst.read(range(0x80,0xB2,1))
    if not src == dst:
        rom_src.dump(range(0,100,2))
        ram_dst.dump(range(0x80,0xB2,1))
        raise TestFailure("move error")
        


    
    

    
