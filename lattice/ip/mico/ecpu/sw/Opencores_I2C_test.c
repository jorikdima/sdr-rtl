/****************************************************************************
**
**  Name: Opencores_I2C_test
**
**  Description:
**       Template that exercises Opencores I2C Master RTL (written by
**  Richard Herveille, available at Opencores.org) by accessing a connected
**  I2C flash memory device.
**
**       This targets Lattice ECP/ECP2 HPE-MINI boards but can be used on
**  other boards that satisfy memory behavior specified below in the code.
**
**  $Revision: $
**
** Disclaimer:
**
**   This source code is intended as a design reference which
**   illustrates how these types of functions can be implemented.  It
**   is the user's responsibility to verify their design for
**   consistency and functionality through the use of formal
**   verification methods.  Lattice Semiconductor provides no warranty
**   regarding the use or functionality of this code.
**
** --------------------------------------------------------------------
**
**                     Lattice Semiconductor Corporation
**                     5555 NE Moore Court
**                     Hillsboro, OR 97214
**                     U.S.A
**
**                     TEL: 1-800-Lattice (USA and Canada)
**                          (503)268-8001 (other locations)
**
**                     web:   http://www.latticesemi.com
**                     email: techsupport@latticesemi.com
**
** --------------------------------------------------------------------------
**
**  Change History (Latest changes on top)
**
**  Ver    Date        Description
** --------------------------------------------------------------------------
**
**  3.1   Jun-10-2008  Initial
**
**---------------------------------------------------------------------------
*****************************************************************************/

/*
 * Simple demonstration for ECP2/ECP LM32 HPE-MINI Boards
 * demonstrating Opencores i2c controller.
 * 
 * This demo accesses the Voltage supervisory chip's i2c
 * eeprom for simple memory-read/writes (8-bits)
 * 
 * LIMITATIONS IN OC_I2C_MEM.C:
 * 1. Assumes that there is a single i2c master hence
 *    no lost-arbitrations
 *
 * 2. Assumes that h/w wiring is correct and so there can be no
 *    faults when waiting for TIP deassertion in the opencores i2c
 *    core
 *-------------------------------------------------------------------
 * 
 * Assumptions on the I2C Memory behavior:
 *  - Write operations:
 *    1. issue a start
 *    2. write the device address
 *    3. write the location to write to
 *    4. write the data to write at the location
 *    5. issue stop to start programming the byte-data
 *    6. wait for T(wr) before issuing any commands to the 
 *       memory
 * 
 * - Read operations: Assumes memory supports sequential reads
 *    1. issue a start
 *    2. write device address
 *    3. write location to read byte-data from
 *    4. issue a start
 *    5. read data < n -1 times > w/ ACK
 *    6. read data n w/ NACK
 *    7. issue stop
 */
#include<stdio.h>
#include "DDStructs.h"
#include "OpenCoresI2CMaster.h"
#include "MicoUtils.h"
#include "string.h"

/*****************************************************************************
 *                                                                           *
 *                                                                           *
 *                              MANIFEST CONSTANTS                           *
 *                                                                           *
 *                                                                           *
 *****************************************************************************/

/* VOLTAGE SUPERVISORY CIRCUIT'S ADDRESS ON ECP/ECP2 HPE MINI BOARD */
#define DEV_ADDR                            (0xA0 >> 1)
/* time to wait on issuing a write-byte before issuing any other commands */
#define I2C_MEM_Twr_msecs                   (20)


/* OPENCORES I2C CONTROLLER INSTANCE */
#define OPENCORES_I2C_FLASH_MEM_INST        (i2cm_opencores_i2cm_oc)
#define ptr_OPEN_CORES_I2C_FLASH_MEM_INST   (&(OPENCORES_I2C_FLASH_MEM_INST))


/* char constants */
#define MAX_STR_LEN    (32)

/* STRING1 and STRING2 shouldn't exceed MAX_STR_LEN-1 */
const char *STRING1 = "Lattice says hello";
const char *STRING2 = "hello, from Lattice";


static void i2c_mem_rd_str( unsigned char offset, unsigned int ct, char *str )
{
    unsigned char block[2];

    /* prepare a write to tell the memory what offset to read from */
    block[0] = offset;
    
    /* perform a block-write:
     * - all write/read operations issue a start so no
     *   need to explicitly issue a start.  The return
     *   value isn't inspected as the only master on the 
     *   bus is the single Opencores I2C master
     */
    OpenCoresI2CMasterWrite(ptr_OPEN_CORES_I2C_FLASH_MEM_INST,
                                                DEV_ADDR,
                                                1,
                                                block);

    /* now start reading a block of data
     * NOTE: this may be memory-specific
     */
    OpenCoresI2CMasterRead(ptr_OPEN_CORES_I2C_FLASH_MEM_INST,
                            DEV_ADDR,
                            ct,
                            (unsigned char *)str );

    /* give up the bus */
    OpenCoresI2CMasterStop( ptr_OPEN_CORES_I2C_FLASH_MEM_INST );

    return;
}

static void i2c_mem_wr_str(unsigned char mem_offset, const char * str )
{   
    while(1)
    {
        /*
         * prepare block-data:
         * - offset within flash device
         * - byte to write at that offset
         */
        unsigned char block[2];
        block[0] = mem_offset;
        block[1] = *str;


        /* perform a block-write:
         * - all write/read operations issue a start so no
         *   need to explicitly issue a start.  The return
         *   value isn't inspected as the only master on the 
         *   bus is the single Opencores I2C master
         */
        OpenCoresI2CMasterWrite(ptr_OPEN_CORES_I2C_FLASH_MEM_INST,
                                                    DEV_ADDR,
                                                    2,
                                                    block);


        /* issue a stop: this causes flash memory to start a write-cycle  */
        OpenCoresI2CMasterStop(ptr_OPEN_CORES_I2C_FLASH_MEM_INST);


        /* Wait for T(wr) before issuing a new command */
        MicoSleepMilliSecs(I2C_MEM_Twr_msecs);

        if( *str == '\0' )
        {
            break;
        }
        else
        {
            /* increment sources */
            ++mem_offset;
            ++str;
        }
    }

    /* all done*/
    return;
}

int main(void)
{
    char data[MAX_STR_LEN];

    printf("\nstarting i2c mem. operation\n");

    /* read contents at offset 0 */
    i2c_mem_rd_str( 0, MAX_STR_LEN-1, data );


    /* replace existing string */
    if( strncmp( data, STRING1, strlen(STRING1) ) == 0 )
    {
        i2c_mem_wr_str( 0, STRING2 );
    }
    else
    {
        i2c_mem_wr_str( 0, STRING1 );
    }

    /* display the prior string */
    data[MAX_STR_LEN-1] = '\0';
    printf("old str: %s\n", data);


    /* read string again */
    i2c_mem_rd_str( 0, MAX_STR_LEN-1, data );

    /* display new contents */
    data[MAX_STR_LEN-1] = '\0';
    printf("new str: %s\n", data );

    return 0;
}

