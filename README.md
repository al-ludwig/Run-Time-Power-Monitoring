# Run Time Module Power Monitoring for FPGA Applications

This is a university project at TU Vienna in the SoC Lab.

## Abstract
The usage of field programmable gate arrays (FPGAs) in low power applications increases, so
the reduction of power consumption is of great importance. Although power analysis tools from
different vendors exist, it can be important to be aware of the run time dynamic power consump-
tion of individual applications.  
The goal of this project is to create a design which can measure the power consumption of basic
modules or IP cores in run time by counting the toggling of specific signals. Counting the toggles
of each signal from a module can strongly increase the required board area for the measurement
unit. Therefore it is important to identify the most indicative signals. This can be done by sort-
ing the signal activities based on previous generated switching activity files (.saif). The signals
with the most activity are selected and a activity counter identifies the positive edges of these
signals. Finally, a relationship between switching activity and power dissipation gives the power
consumption. This method is described in more detail in the work of Lin et al. [[1]](#1).  
The following picture gives an idea of the structure. The "module-under-monitoring"
is enveloped by the power monitoring unit, which includes the activity counters and power con-
sumption calculation.

![System overview](https://github.com/al-ludwig/Run-Time-Power-Monitoring/blob/main/doc/overview.PNG)

## Team organization

* Lead Architect: Alexander Ludwig (Team leader)  
Contact: e1525371@student.tuwien.ac.at
* Lead Hardware: Thomas Kotrba  
Contact: e1525909@student.tuwien.ac.at
* Lead Test and Integration: Luke Maher  
Contact: e1225441@student.tuwien.ac.at

## References
<a id="1">[1]</a>
Z. Lin, W. Zhang, and S. Sharad. Decision tree based hardware power monitoring for run
time dynamic power management in fpga. In 2017 27th International Conference on Field
Programmable Logic and Applications (FPL), pages 1-8, 2017.