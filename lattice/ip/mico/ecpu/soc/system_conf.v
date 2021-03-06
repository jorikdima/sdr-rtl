`define LATTICE_FAMILY "ECP5U"
`define LATTICE_FAMILY_ECP5U
`define LATTICE_DEVICE "All"
`ifndef SYSTEM_CONF
`define SYSTEM_CONF
`timescale 1ns / 100 ps
`ifndef SIMULATION
   `define CharIODevice
`endif
`ifndef SIMULATION
   `define DEBUG_ROM
`endif
`ifndef SIMULATION
   `define CFG_DEBUG_ENABLED
`endif
`define CFG_EBA_RESET 32'h0
`define CFG_DEBA_RESET 32'h10000
`define CFG_DISTRAM_POSEDGE_REGISTER_FILE
`define SHIFT_ENABLE
`define CFG_PL_BARREL_SHIFT_ENABLED
`ifndef SIMULATION
   `define CFG_WATCHPOINTS 32'h0
`endif
`ifndef SIMULATION
   `define CFG_JTAG_ENABLED
`endif
`ifndef SIMULATION
   `define CFG_JTAG_UART_ENABLED
`endif
`define INCLUDE_LM32
`define ADDRESS_LOCK
`define LM32_I_PC_WIDTH 18
`define ADDRESS_LOCK
`define spiMASTER
`define spiSLAVE_NUMBER 32'h1
`define spiCLOCK_SEL 7
`define spiCLKCNT_WIDTH 16
`define DELAY_TIME 3
`define spiINTERVAL_LENGTH 2
`define spiDATA_LENGTH 24
`define spiSHIFT_DIRECTION 1
`define spiCLOCK_PHASE 1
`define spiCLOCK_POLARITY 1
`define ADDRESS_LOCK
`define i2cm_ocSPEED 400
`define i2cm_ocSYSCLK 0
`define gpioGPIO_WB_DAT_WIDTH 32
`define gpioGPIO_WB_ADR_WIDTH 4
`define ADDRESS_LOCK
`define gpioOUTPUT_PORTS_ONLY
`define gpioDATA_WIDTH 32'h8
`define ADDRESS_LOCK
`define fifoMEM_WB_DAT_WIDTH 32
`define MEM_WB_SEL_WIDTH 4
`define fifoMEM_WB_ADR_WIDTH 32
`define ADDRESS_LOCK
`define ebrEBR_WB_DAT_WIDTH 32
`define ebrINIT_FILE_NAME "C:/work/sdr-rtl/lattice/ip/mico/ecpu/sw/meminit.mem"
`define ebrINIT_FILE_FORMAT "hex"
`endif // SYSTEM_CONF
