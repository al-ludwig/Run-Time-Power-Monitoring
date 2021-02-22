# Run Time Module Power Monitoring for FPGA Applications

This is a university project at TU Vienna in the SoC Lab.

## Abstract
The usage of field programmable gate arrays (FPGAs) in low power applications increases, so
the reduction of power consumption is of great importance. Although power analysis tools from
different vendors exist, it can be important to be aware of the run time dynamic power consumption of individual 
applications.The goal of this project is to create a design which can measure the power consumption of basic
modules or IP cores in run time by counting the toggling of specific signals. Counting the toggles
of each signal from a module can strongly increase the required board area for the measurement
unit. Therefore it is important to identify the most indicative signals. This can be done by sorting the signal 
activities based on previous generated switching activity files (.saif). The signals with the most activity are 
selected and a activity counter identifies the edges of these signals. Finally, a relationship between 
switching activity and power dissipation gives the power consumption. This method is described in more detail in 
the work of Lin et al. [[1]](#1).  
The following picture gives an idea of the structure. The "module-under-monitoring"
is enveloped by the power monitoring unit, which includes the activity counters and power consumption calculation.

![System overview](https://github.com/al-ludwig/Run-Time-Power-Monitoring/blob/main/doc/overview.PNG)

## How to use:

**Signal Selection:**
1) You need to have the rtl-design of the modul-to-be-monitored. A description in VHDL would be ideal, because otherwise we can not guarantee that vivado can generate a bitstream out of 2 different description languages.
2) You have to write a testbench for the vivado power report, which should be as close as possible to the real world application (for details see testbench)
3) Synthesize and create the implementation of the modul-to-be-monitored in vivado.
4) Go to simulation settings and add the name of the saif-file (simply by typing in the name of the file)
5) Run the functional simulation on the implemented design. In this step, the saif-file is actually created.
6) Create the power report - dont forget to include the generated saif-file.
7) In the power report - go to I/O and sort them by highest to lowest switching rate.
8) Select the I/Os with the highest activity. In our design (RAM), we selected the three signal with the highest activity. Please note: signals with a switching rate higher than FCLK/2 cannot be monitored by our activity-counters. To take that into account, the multiplier in "rtpm_pkg.vhd" can be adjusted. If the I/O has several bits, our way was to select the 4 bits with the highest rate, wich is of course highly dependent on the data wich is read from/written to the RAM.

**Adjustment of the monitoring-design:**
1) Set the "activity_count" constant in "rtpm_pkg.vhd". (e.g.: if you monitor 9 signals, set it to 9)
2) Connect the signals (you want to monitor) with a activity counter in "top.vhd". This is done by connecting the bits of the signal with "s_ac_inp".
3) Open the vivado project "PowerMonitoring", refresh the ip catalog and update the PowerMonitoring-IP.
4) Generate output products
5) Generate the bitstream
6) Export hardware (with bitstream!)
7) Launch Xilinx SDK (workspace has to be "local to project")

**Xilinx SDK:**
1) Actually you don't have to change anything in "main.c" if you want to read out the values via UART.

## Team organization

* Lead Architect: Alexander Ludwig (Team leader)  
Contact: e1525371@student.tuwien.ac.at
* Lead Hardware: Thomas Kotrba  
Contact: e1525909@student.tuwien.ac.at
* Lead Test and Integration: Luke Maher  
Contact: e1225441@student.tuwien.ac.at

## Timetable

| Task | Due Date | Status |
| :---        |    :----:   | :----: |
| Activitycounter RTL Design & Simulation | 17.11.2020 | Done |
| (Power) calculation RTL Design & Simulation | 24.11.2020 | Done |
| Create a signal selection algorithm | 15.12.2020 | Done |
| Selection of the module to be analyzed | 15.12.2020 | Done |
| Top module RTL Design & Simulation | 15.12.2020 | Done |
| Zedboard implementation (in vivado) | 12.01.2021 | Done |
| (Final) Testing and modifications | 23.02.2021 | Done |



## Prerequisites

* [ghdl](http://ghdl.free.fr/): for compiling and simulating VHDL code
* [GTKWave](http://gtkwave.sourceforge.net/): for viewing the simulation results
* [Vivado](https://www.xilinx.com/products/design-tools/vivado.html): for power report generation, bitstream generation
* [Xilinx SDK](https://www.xilinx.com/products/design-tools/embedded-software/sdk.html): for creating the embedded application
* [ModelSim](https://www.mentor.com/company/higher_ed/modelsim-student-edition): for compiling and simulating VHDL code

## References
<a id="1">[1]</a>
Z. Lin, W. Zhang, and S. Sharad. Decision tree based hardware power monitoring for run
time dynamic power management in fpga. In 2017 27th International Conference on Field
Programmable Logic and Applications (FPL), pages 1-8, 2017.