import cocotb
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue

class RAM():
    
    SIZES= {
        '2K' : 2048
    }

    def __init__(self, clk, address, din, wren, rden, dout=None, size=2048):
        self.clk = clk
        self.address = address
        self.rden = rden
        self.dout = dout
        self.din = din
        self.wren = wren
        self.size = RAM.SIZES[size]

        self.clear()

        if self.dout is not None:
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

    def read(self, addresses):
        if isinstance(addresses, list):
            return [self.array[address] for address in addresses]
        else:
            raise TypeError('{} not supported'.format(type(addresses)))
        
    @cocotb.coroutine
    def __dout(self):
        while True:
            yield RisingEdge(self.clk)
            if any((c in self.address.value.binstr) for c in 'UX'):
                self.dout <= BinaryValue('U', len(self.address.value))
            else:
                self.dout <= self.array[self.address.value.integer]

    @cocotb.coroutine
    def __din(self):
        while True:
            yield RisingEdge(self.clk)
            # the address must be valid
            if not any((c in self.address.value.binstr) for c in 'UX'):
                if self.wren == 1:
                    self.array[self.address.value.integer] = self.din.value.integer

    def dump(self, addresses=None):
        if addresses is None:
            addresses = range(self.size)
        print("### BEGIN DUMP ###")
        print("{:12} : {:12}".format('ADDRESS','DATA'))
        for address in addresses:
            print("0x{:010X} : 0x{:010X}".format(address,self.array[address]))
        print("### END DUMP ###")

    def clear(self):
        self.array = [0 for _ in range(self.size)]

