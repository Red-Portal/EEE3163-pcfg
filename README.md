# EEE3163 PC Function Generator Controller
Project of Sogang University EEE3163 Advanced Digital Circuit Design class.
Developed on a custom FPGA board with a on board ADC, DAC, and USB comm module.

## ip core
This repository does not include the ip core modules.
You need to generate the IP cores below.

### memory_block
A RAM block generated by the Xilinx memory block generator.
* Simple two-port RAM
* address 11 bits, data 8 bits
* enable a side, enable b side

### counter
A simple counter
* clock enable
* 11 bits

### load_counter
A simple counter with data load
* data load
* clock enable
* 11 bits

### accumulator
A accumulator register used in the average filter
* input 9 bits, output 19 bits
* add and substract
* clock enable

## Hierarchy
The top module is pcfg_top.vhd
All control signals are generated in control_signal_gen.vhd
Each function has its dedicated controller.
* PC mode: controller_pc.vhd
* AD mode: controller_ad.vhd
* DA mode: controller_da.vhd
* Data Transfer mode: controller_dt.vhd
* Average mode: controller_filter.vhd

## Test benches
files with the naming convention
* *_test.vhd
* tb_*.vhd
are test benches. Please exclude them from the implementation.

