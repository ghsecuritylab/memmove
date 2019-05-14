/*
 * comblock_parameters.h
 *
 *  Created on: Feb 8, 2018
 *      Author: infolab
 */

#ifndef SRC_COMBLOCK_PARAMETERS_H_
#define SRC_COMBLOCK_PARAMETERS_H_

#include "xparameters.h"

#define comblock_reg_block_addr	XPAR_COMBLOCK_0_S00_AXI_BASEADDR
#define	comblock_reg_block_out_addr	comblock_reg_block_addr+4*16
#define	comblock_reg_block_in_addr	comblock_reg_block_addr


//Defining output register blocks address
#define comblock_reg_block_out_0 comblock_reg_block_out_addr+4*0
#define comblock_reg_block_out_1 comblock_reg_block_out_addr+4*1
#define comblock_reg_block_out_2 comblock_reg_block_out_addr+4*2
#define comblock_reg_block_out_3 comblock_reg_block_out_addr+4*3
#define comblock_reg_block_out_4 comblock_reg_block_out_addr+4*4
#define comblock_reg_block_out_5 comblock_reg_block_out_addr+4*5
#define comblock_reg_block_out_6 comblock_reg_block_out_addr+4*6
#define comblock_reg_block_out_7 comblock_reg_block_out_addr+4*7
#define comblock_reg_block_out_8 comblock_reg_block_out_addr+4*8
#define comblock_reg_block_out_9 comblock_reg_block_out_addr+4*9
#define comblock_reg_block_out_10 comblock_reg_block_out_addr+4*10
#define comblock_reg_block_out_11 comblock_reg_block_out_addr+4*11
#define comblock_reg_block_out_12 comblock_reg_block_out_addr+4*12
#define comblock_reg_block_out_13 comblock_reg_block_out_addr+4*13
#define comblock_reg_block_out_14 comblock_reg_block_out_addr+4*14
#define comblock_reg_block_out_15 comblock_reg_block_out_addr+4*15


//Defining input register blocks address
#define comblock_reg_block_in_0 comblock_reg_block_in_addr+4*0
#define comblock_reg_block_in_1 comblock_reg_block_in_addr+4*1
#define comblock_reg_block_in_2 comblock_reg_block_in_addr+4*2
#define comblock_reg_block_in_3 comblock_reg_block_in_addr+4*3
#define comblock_reg_block_in_4 comblock_reg_block_in_addr+4*4
#define comblock_reg_block_in_5 comblock_reg_block_in_addr+4*5
#define comblock_reg_block_in_6 comblock_reg_block_in_addr+4*6
#define comblock_reg_block_in_7 comblock_reg_block_in_addr+4*7
#define comblock_reg_block_in_8 comblock_reg_block_in_addr+4*8
#define comblock_reg_block_in_9 comblock_reg_block_in_addr+4*9
#define comblock_reg_block_in_10 comblock_reg_block_in_addr+4*10
#define comblock_reg_block_in_11 comblock_reg_block_in_addr+4*11
#define comblock_reg_block_in_12 comblock_reg_block_in_addr+4*12
#define comblock_reg_block_in_13 comblock_reg_block_in_addr+4*13
#define comblock_reg_block_in_14 comblock_reg_block_in_addr+4*14
#define comblock_reg_block_in_15 comblock_reg_block_in_addr+4*15


//Defining TDPR parameters

//#define comblock_TDPR_addr	XPAR_COMBLOCK_0_AXIF_DRAM_BASEADDR
#define comblock_TDPR_addr	XPAR_COMBLOCK_0_S01_AXI_BASEADDR
#define comblock_TDPR_highaddr XPAR_COMBLOCK_COMBLOCK_0_AXIF_DRAM_HIGHADDR

#define comblock_FIFO_RD XPAR_COMBLOCK_0_S02_AXI_BASEADDR
#define comblock_FIFO_STATUS comblock_FIFO_RD+0x4


#endif /* SRC_COMBLOCK_PARAMETERS_H_ */
