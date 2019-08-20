#!/usr/bin/python
#
# Copyright (C) 2018 INTI
# Copyright (C) 2018 Bruno Valinoti

import socket, argparse, re
from struct import *
from cmd import Cmd

READ_ADDR  = 0
READ_MEM   = 1
WRITE_ADDR = 2
WRITE_MEM  = 3


class MyPrompt(Cmd):

  def do_hello(self,args):
    if len(args) == 0:
      name = 'NN'
    else:
      name = args
    print ("Hello, %s" % name)


  def do_quit(self, args):
    print ("Exiting.")
    raise SystemExit

#################
## connect     ##
#################
  def do_connect(self, args):
    if len(args) == 0:
      TCP_IP = '192.168.1.10'
      PORT   = 7
    else:
      TCP_IP=args.split(":")[0]
      PORT=int(args.split(":")[1])
      print("Address: %s" % (TCP_IP))
      print("Port:    %s" % (PORT))
      
    try:
      self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      self.s.connect((TCP_IP, PORT))
    except:
      print("Connection refused")
      exit()

#############
## x_read  ##
#############
  def do_x_read(self,args):
    if not self.s:
      print("Please set the ethernet connection up with connect function.")
      return
    nargs = args.count(" ")
    outf = 'a'   #default output format
    if nargs == 0:
      addr=args
    elif nargs == 2:
      addr=args.split(" ")[0]
      outf=args.split("-r ")[1]
    else:
      print("Bad parameters.")
      return
    print("Address: %s" % (addr))
    print("format   %s" % (outf))
    addr = int(addr,16)             #format address to decimal value
    tx_buf  = pack("<ii",READ_ADDR,addr)   #first data is package type
    self.s.send(tx_buf)
    rx_buf = self.s.recv(4)
    rx_dat = unpack('<i',rx_buf)
    if outf == 'b':
      print(bin(rx_dat[0]))
    elif outf == 'h':
      print(hex(rx_dat[0]))
    else: 
      print(rx_dat[0])
      

################
## x_read_mem ##
################
  def do_x_read_mem(self,args):
    if len(args) == 0:
      addr = '0x00000000'
      outf = 'a'
      N    = 1
      inc  = 1
    else:
      addr = args.split(" ")[0]
      N    = args.split(" ")[1]
      inc  = args.split(" ")[2]
      outf = args.split("-r ")[1]
    print("Address: %s" % (addr))
    print("N: %s" % (N))
    print("inc: %s" % (inc))
    print("Port: %s" % (outf))
    
    


##############
## x_write  ##
##############
#\textbf{x$\_$write} $<addr>  <data>$
  def do_x_write(self,args):
    if not self.s:
      print("Please set the ethernet connection up with connect function.")
      return
    nargs = args.count(" ")
    if nargs == 1:
      addr=args.split(" ")[0]
      data=args.split(" ")[1]
    else:
      print("Bad parameters.")
      return
    
    addr = int(addr,16)             #format address to decimal value
    tx_buf  = pack("<iii",WRITE_ADDR,addr,int(data))  #first data is package type
    print(tx_buf)
    self.s.send(tx_buf)

#################
## x_write_mem ##
#################
#\textbf{x$\_$write$\_$mem} $<addr>  <data>$
  def do_x_write_mem(self,args):
    if not self.s:
      print("Please set the ethernet connection up with connect function.")
      return
    nargs = args.count(" ")
    if nargs == 4:
      addr=args.split(" ")[0]
      data=args.split(" ")[1:]
    else:
      print("Bad parameters.")
      return
    
    addr = int(addr,16)             #format address to decimal value
    tx_buf  = pack("<iiiiii",WRITE_MEM,addr,int(data[0]),int(data[1]),int(data[2]),int(data[3]))  #first data is package type
    print(addr)
    for dato in data:
        print(dato)
    print(tx_buf)
    self.s.send(tx_buf)

  def do_test(self, args):
    if not self.s:
      print("Please set the ethernet connection up with connect function.")
      return
    data = [0x10000000, 0x00001000, 0x00000001, 5]
    
    # Mem
    addr = int(str(0), 16)             #format address to decimal value
    tx_buf  = pack("<iiiiii",WRITE_MEM,addr,int(data[0]),int(data[1]),int(data[2]),int(data[3]))  #first data is package type
    print(addr)
    for dato in data:
        print(dato)
    print(tx_buf)
    self.s.send(tx_buf)
    # Regs
    addr = int(str(0),16)             #format address to decimal value
    tx_buf  = pack("<iii",WRITE_ADDR,addr,int(1))  #first data is package type
    print(tx_buf)
    self.s.send(tx_buf)
    tx_buf  = pack("<iii",WRITE_ADDR,addr,int(0))  # clear bit
    print(tx_buf)
    self.s.send(tx_buf)

if __name__ == '__main__':
    s=0
    prompt = MyPrompt()
    prompt.prompt = '> '
    prompt.cmdloop('Configure Address and port, example: connect 192.168.1.10:7')
    
