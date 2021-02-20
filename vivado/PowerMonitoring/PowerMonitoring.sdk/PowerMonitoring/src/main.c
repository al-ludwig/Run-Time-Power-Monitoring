/*
 * main.c
 *
 *  Created on: 24.01.2021
 *      Author: Alexander
 */

#include "xparameters.h"
#include "xil_types.h"
#include "xil_io.h"
#include "PowerMonitoringIP.h"
#include "sleep.h"
#include "xil_printf.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdint.h>
#include <stdbool.h>

void init(){
	//reset (active low, bit 1) and enable top (bit 0) -> 0x0001
	Xil_Out32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG0_OFFSET, 0x0001);
	sleep(0.5);
	//pull reset back to high (bit 1) -> 0x0003
	Xil_Out32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG0_OFFSET, 0x0003);
}

void WriteRAMDATA(u16 Data, u16 Address){
	//Address is mapped to the same register as reset_n, en and WR
	//-> left-shift the given address by 3
	u16 REG0 = Address << 3;

	//as left-shift fills the lsb with zeros, we have to set the 3 lowest bits to 1
	//WR=1, reset_n = 1, en = 1
	REG0 |= 0x0007;

	Xil_Out32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG0_OFFSET, REG0);
	Xil_Out32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG1_OFFSET, Data);
}

u32 ReadRAMData(){
	return Xil_In32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG2_OFFSET);
}

u32 ReadPower(){
	return Xil_In32(XPAR_POWERMONITORINGIP_0_S00_AXI_BASEADDR + POWERMONITORINGIP_S00_AXI_SLV_REG3_OFFSET);
}

void PrintRAMData(u32 RAM_DATA){
	xil_printf("RAM_DATA_OUT = 0x%04x \n\r", RAM_DATA);
}

bool bitset(int index, uint32_t num){
    unsigned long ref = 1;
    if (ref << index & num){
        return true;
    }
    else{
        return false;
    }
}

//to use the "pow"-function, go to
//Project->Properties: C/C++-Build->Settings->ARM v7 gcc linker->Libraries: add "m"
double conv_fxd_double(uint32_t fxd_value, uint32_t m, uint32_t ip, uint32_t fp){
    uint32_t i;
    long double result = 0;
    if (m != fp + ip){
        return -1;
    }
    for (i = 0; i < fp; i++){
        if (bitset(i, fxd_value)){
            result += 1 / pow(2.0, fp - i);
        }
    }
    for (i = fp; i < m; i++){
        if (bitset(i, fxd_value)){
            result += pow(2, i - fp);
        }
    }
    return result;
}

void PrintPower(u32 PDyn){
	//xil_printf("P_Dyn = 0x%08x \n\r", PDyn);
	printf("P_Dyn = %.14f W\n\r", conv_fxd_double(PDyn, 32, 4, 28));
}

int main(){
	u32 PDyn;

	srand(234987);   // Initialization, should only be called once.

	xil_printf("\nApplication: PowerMonitoring\n\r");
	xil_printf("Reset and enable ...\n\r");

	init();

	usleep(5000); // = 5ms

	xil_printf("Start monitoring: \n\r");

	int i=0;

	u16 random;

	while(i<1000){
		random = (u16)rand();      // Returns a pseudo-random integer between 0 and RAND_MAX.
		WriteRAMDATA(random, 0x00AF);
		usleep(1000); // = 10ms
		if(i == 999){
			i = 0;
			PDyn = ReadPower(); //read every second
			PrintPower(PDyn);
		}
		else{
			i = i + 1;
		}
	}
	xil_printf("Done! \n\r");

	return 0;
}
