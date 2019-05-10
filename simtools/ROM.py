import cocotb
from cocotb.triggers import RisingEdge

class ROM():
    
    def __init__(self, clk, address, dout, rd_en, size=2048):
        self.clk = clk
        self.address = address
        self.dout = dout
        self.rd_en = rd_en
        self.size = size

        self.clear()

        cocotb.fork(self.__dout())

    def load(self, data):
        if isinstance(data, list):
            d = dict(enumerate(data))
        elif isinstance(data, dict):
            d = data
        else:
            raise TypeError('{} not supported'.format(type(data)))
        
        for address, v in d.items():
            #print("address: {} data: {}".format(address,v))
            self.array[address] = v

    @cocotb.coroutine
    def __dout(self):
        while True:
            yield RisingEdge(self.clk)
            if not any((c in self.address.value.binstr) for c in 'UX'):
                self.dout <= self.array[self.address.value.integer]

    def clear(self):
        self.array = [0 for _ in range(self.size)]
