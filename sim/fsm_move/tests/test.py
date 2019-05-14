import cocotb
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
def test_fsm_move(dut):

    rom_src = ROM(clk=dut.clk, 
              address=dut.address, 
              rden= dut.rd_rq,
              dout=dut.din, 
              size='2K')
    rom_src.load(list(range(10, 2058))) 

    ram_dst = RAM(clk=dut.clk,
                  address=dut.address,
                  din=dut.dout,
                  rden = 0,
                  wren=dut.dv,
                  size='2K')

    # wr_en is a delayed copy of rd_rq
    cocotb.fork(delay(dut.clk, dut.rd_rq, dut.wr_en))
    cocotb.fork(Clock(dut.clk, 10, units='ns').start())

    dut._log.info('Instruction loaded on ROM')

    dut.source_addr <= 0
    dut.dest_addr   <= 500
    dut.source_incr <= 1
    dut.dest_incr   <= 1
    dut.move_size   <= 20

    yield reset(dut)
    dut.start <= 1
    yield RisingEdge(dut.clk)
    dut.start <= 0
    
    yield RisingEdge(dut.done) # our work here is done
    
    for _ in range(5):
        yield RisingEdge(dut.clk)

    src = rom_src.read(range(0,20,1))
    dst = ram_dst.read(range(500,520,1))
    if not src == dst:
        rom_src.dump(range(0,20,1))
        ram_dst.dump(range(500,520,1))
        raise TestFailure("move error")

