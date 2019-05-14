import cocotb
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue

class ROM():
    
    SIZES = {
        '1K' : 2**10,
        '2K' : 2**11,
        '4K' : 2**12,
        '8K' : 2**13,
        '16K': 2**14,
        '32K': 2**15
    }

    def __init__(self, clk, address, rden, dout=None, size='2K'):
        self.clk = clk
        self.address = address
        self.rden = rden
        self.size = ROM.SIZES[size]
        self.dout = dout

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

    def dump(self, addresses=None):
        if addresses is None:
            addresses = range(self.size)
        print("### BEGIN DUMP ###")
        print("{:12} : {:12}".format('ADDRESS','DATA'))
        for address in addresses:
            print("0x{:010X} : 0x{:010X}".format(address,self.array[address]))
        print("### END DUMP ###")

    @cocotb.coroutine
    def __dout(self):
        while True:
            yield RisingEdge(self.clk)
            if any((c in self.address.value.binstr) for c in 'UX'):
                self.dout <= BinaryValue('U', len(self.address.value))
            else:
                self.dout <= self.array[self.address.value.integer]

    def clear(self):
        self.array = [0 for _ in range(self.size)]
