# FPGA Implementation

TCL scripts for generating the block diagrams (BD) of the 10-point solver and its IP dependencies. The scripts are for Vivado 2017.4.

## pxp.tcl

BD of the 10-point solver implementation.

## distance_collinear.tcl

IP used by the pxp BD. Computes depths from 5 collinear points.

## pxp_hw_test.tcl

BD of the test design used to evaluate the numerical accuracy of the 10-point solver implementation.

## pxp_axi_slave.vhd

VHDL module used by the pxp_hw_test BD. Used to pass calibration and precaptured measurement data to the 10-point solver via memory mapped I/O.
