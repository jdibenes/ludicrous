
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-e
   set_property BOARD_PART xilinx.com:zcu102:part0:3.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_1 "Enter Comments here" [get_bd_designs $design_name]

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:floating_point:7.1\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set CLK2 [ create_bd_port -dir I -type clk CLK2 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {design_1_CLK} \
   CONFIG.FREQ_HZ {100000000} \
 ] $CLK2
  set a [ create_bd_port -dir O -from 23 -to 0 -type data a ]
  set b [ create_bd_port -dir O -from 23 -to 0 -type data b ]
  set c [ create_bd_port -dir O -from 23 -to 0 -type data c ]
  set d [ create_bd_port -dir O -from 23 -to 0 -type data d ]
  set e [ create_bd_port -dir O -from 23 -to 0 -type data e ]
  set edge_in [ create_bd_port -dir I -from 23 -to 0 -type data edge_in ]
  set eol [ create_bd_port -dir I -from 0 -to 0 -type data eol ]
  set pattern_ok [ create_bd_port -dir O -from 0 -to 0 pattern_ok ]
  set t_0 [ create_bd_port -dir I -from 31 -to 0 t_0 ]
  set t_1 [ create_bd_port -dir I -from 31 -to 0 t_1 ]
  set t_2 [ create_bd_port -dir I -from 31 -to 0 t_2 ]
  set t_3 [ create_bd_port -dir I -from 31 -to 0 t_3 ]
  set t_4 [ create_bd_port -dir I -from 31 -to 0 t_4 ]
  set t_5 [ create_bd_port -dir I -from 31 -to 0 t_5 ]
  set t_6 [ create_bd_port -dir I -from 31 -to 0 t_6 ]
  set t_7 [ create_bd_port -dir I -from 31 -to 0 t_7 ]
  set t_8 [ create_bd_port -dir I -from 31 -to 0 t_8 ]
  set t_9 [ create_bd_port -dir I -from 31 -to 0 t_9 ]
  set t_A [ create_bd_port -dir I -from 31 -to 0 t_A ]
  set t_B [ create_bd_port -dir I -from 31 -to 0 t_B ]
  set t_C [ create_bd_port -dir I -from 31 -to 0 t_C ]
  set t_D [ create_bd_port -dir I -from 31 -to 0 t_D ]
  set t_E [ create_bd_port -dir I -from 31 -to 0 t_E ]
  set thresh [ create_bd_port -dir I -from 31 -to 0 thresh ]
  set valid_in [ create_bd_port -dir I -type ce valid_in ]
  set valid_out [ create_bd_port -dir O -from 0 -to 0 -type data valid_out ]

  # Create instance: c_shift_ram_0, and set properties
  set c_shift_ram_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $c_shift_ram_0

  # Create instance: c_shift_ram_1, and set properties
  set c_shift_ram_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $c_shift_ram_1

  # Create instance: cr_0, and set properties
  set cr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_0 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_0

  # Create instance: cr_1, and set properties
  set cr_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_1

  # Create instance: cr_2, and set properties
  set cr_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_2

  # Create instance: cr_3, and set properties
  set cr_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_3

  # Create instance: cr_4, and set properties
  set cr_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_4 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_4

  # Create instance: cr_11, and set properties
  set cr_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_11 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_11

  # Create instance: cr_12, and set properties
  set cr_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_12 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_12

  # Create instance: cr_13, and set properties
  set cr_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_13 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_13

  # Create instance: cr_14, and set properties
  set cr_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_14 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_14

  # Create instance: cr_15, and set properties
  set cr_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_15 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_15

  # Create instance: cr_16, and set properties
  set cr_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_16 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_16

  # Create instance: cr_17, and set properties
  set cr_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_17 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_17

  # Create instance: cr_18, and set properties
  set cr_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_18 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_18

  # Create instance: cr_19, and set properties
  set cr_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_19 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_19

  # Create instance: cr_20, and set properties
  set cr_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 cr_20 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Divide} \
   CONFIG.Result_Precision_Type {Single} \
 ] $cr_20

  # Create instance: floating_point_0, and set properties
  set floating_point_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_0 ]
  set_property -dict [ list \
   CONFIG.C_Compare_Operation {Less_Than_Or_Equal} \
   CONFIG.C_Latency {2} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {1} \
   CONFIG.C_Result_Fraction_Width {0} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Compare} \
   CONFIG.Result_Precision_Type {Custom} \
 ] $floating_point_0

  # Create instance: floating_point_1, and set properties
  set floating_point_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_1 ]
  set_property -dict [ list \
   CONFIG.C_Compare_Operation {Less_Than} \
   CONFIG.C_Latency {2} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {1} \
   CONFIG.C_Result_Fraction_Width {0} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Compare} \
   CONFIG.Result_Precision_Type {Custom} \
 ] $floating_point_1

  # Create instance: floating_point_2, and set properties
  set floating_point_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_2

  # Create instance: floating_point_3, and set properties
  set floating_point_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_3

  # Create instance: floating_point_4, and set properties
  set floating_point_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_4 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_4

  # Create instance: floating_point_5, and set properties
  set floating_point_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_5 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_5

  # Create instance: floating_point_6, and set properties
  set floating_point_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_6 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_6

  # Create instance: floating_point_7, and set properties
  set floating_point_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_7

  # Create instance: floating_point_8, and set properties
  set floating_point_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_8 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_8

  # Create instance: floating_point_9, and set properties
  set floating_point_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_9 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_9

  # Create instance: floating_point_10, and set properties
  set floating_point_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_10 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_10

  # Create instance: floating_point_11, and set properties
  set floating_point_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_11 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_11

  # Create instance: floating_point_12, and set properties
  set floating_point_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_12 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_12

  # Create instance: floating_point_13, and set properties
  set floating_point_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_13 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_13

  # Create instance: floating_point_14, and set properties
  set floating_point_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_14 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_14

  # Create instance: floating_point_15, and set properties
  set floating_point_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_15 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_15

  # Create instance: floating_point_16, and set properties
  set floating_point_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_16 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_16

  # Create instance: floating_point_17, and set properties
  set floating_point_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_17 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_17

  # Create instance: floating_point_18, and set properties
  set floating_point_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_18 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_18

  # Create instance: floating_point_19, and set properties
  set floating_point_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_19 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_19

  # Create instance: floating_point_20, and set properties
  set floating_point_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_20 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_20

  # Create instance: floating_point_21, and set properties
  set floating_point_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_21 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_21

  # Create instance: floating_point_22, and set properties
  set floating_point_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_22 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_22

  # Create instance: floating_point_23, and set properties
  set floating_point_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_23 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_23

  # Create instance: floating_point_24, and set properties
  set floating_point_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_24 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_24

  # Create instance: floating_point_25, and set properties
  set floating_point_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_25 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_25

  # Create instance: floating_point_26, and set properties
  set floating_point_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_26 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_26

  # Create instance: floating_point_27, and set properties
  set floating_point_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_27 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_27

  # Create instance: floating_point_28, and set properties
  set floating_point_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_28 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_28

  # Create instance: floating_point_29, and set properties
  set floating_point_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_29 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_29

  # Create instance: floating_point_30, and set properties
  set floating_point_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_30 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_30

  # Create instance: floating_point_31, and set properties
  set floating_point_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_31 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_31

  # Create instance: floating_point_32, and set properties
  set floating_point_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_32 ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_32

  # Create instance: floating_point_33, and set properties
  set floating_point_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_33 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_33

  # Create instance: floating_point_34, and set properties
  set floating_point_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_34 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_34

  # Create instance: floating_point_35, and set properties
  set floating_point_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_35 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_35

  # Create instance: floating_point_36, and set properties
  set floating_point_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_36 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_36

  # Create instance: floating_point_37, and set properties
  set floating_point_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_37 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_37

  # Create instance: floating_point_38, and set properties
  set floating_point_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_38 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_38

  # Create instance: floating_point_39, and set properties
  set floating_point_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_39 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_39

  # Create instance: floating_point_40, and set properties
  set floating_point_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_40 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_40

  # Create instance: floating_point_41, and set properties
  set floating_point_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_41 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_41

  # Create instance: floating_point_42, and set properties
  set floating_point_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_42 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_42

  # Create instance: floating_point_43, and set properties
  set floating_point_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_43 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_43

  # Create instance: floating_point_44, and set properties
  set floating_point_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_44 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_44

  # Create instance: floating_point_45, and set properties
  set floating_point_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_45 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $floating_point_45

  # Create instance: fp_a_e, and set properties
  set fp_a_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_e ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_e

  # Create instance: fp_a_e_c_m6, and set properties
  set fp_a_e_c_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_e_c_m6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_e_c_m6

  # Create instance: fp_a_e_c_m7, and set properties
  set fp_a_e_c_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_e_c_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_e_c_m7

  # Create instance: fp_a_m6, and set properties
  set fp_a_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m6 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m6

  # Create instance: fp_a_m6_c_m7, and set properties
  set fp_a_m6_c_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m6_c_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m6_c_m7

  # Create instance: fp_a_m6_e_m7, and set properties
  set fp_a_m6_e_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m6_e_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m6_e_m7

  # Create instance: fp_a_m7, and set properties
  set fp_a_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m7 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m7

  # Create instance: fp_a_m7_c_m6, and set properties
  set fp_a_m7_c_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m7_c_m6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m7_c_m6

  # Create instance: fp_a_m7_e_m6, and set properties
  set fp_a_m7_e_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m7_e_m6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m7_e_m6

  # Create instance: fp_a_m8, and set properties
  set fp_a_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_a_m8 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_a_m8

  # Create instance: fp_c_e, and set properties
  set fp_c_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_e ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_e

  # Create instance: fp_c_e1, and set properties
  set fp_c_e1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_e1 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_e1

  # Create instance: fp_c_e_a_m6, and set properties
  set fp_c_e_a_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_e_a_m6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_e_a_m6

  # Create instance: fp_c_e_a_m7, and set properties
  set fp_c_e_a_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_e_a_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_e_a_m7

  # Create instance: fp_c_m6, and set properties
  set fp_c_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6

  # Create instance: fp_c_m6_e_m7, and set properties
  set fp_c_m6_e_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m7

  # Create instance: fp_c_m6_e_m8, and set properties
  set fp_c_m6_e_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m8 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m8

  # Create instance: fp_c_m6_e_m9, and set properties
  set fp_c_m6_e_m9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m9 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m9

  # Create instance: fp_c_m6_e_m10, and set properties
  set fp_c_m6_e_m10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m10 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m10

  # Create instance: fp_c_m6_e_m11, and set properties
  set fp_c_m6_e_m11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m11 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m11

  # Create instance: fp_c_m6_e_m12, and set properties
  set fp_c_m6_e_m12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m12 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m12

  # Create instance: fp_c_m6_e_m13, and set properties
  set fp_c_m6_e_m13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m13 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m13

  # Create instance: fp_c_m6_e_m14, and set properties
  set fp_c_m6_e_m14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m14 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m14

  # Create instance: fp_c_m6_e_m15, and set properties
  set fp_c_m6_e_m15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m15 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m15

  # Create instance: fp_c_m6_e_m16, and set properties
  set fp_c_m6_e_m16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m16 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m16

  # Create instance: fp_c_m6_e_m17, and set properties
  set fp_c_m6_e_m17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m6_e_m17 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m6_e_m17

  # Create instance: fp_c_m7, and set properties
  set fp_c_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7

  # Create instance: fp_c_m7_e_m6, and set properties
  set fp_c_m7_e_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m6

  # Create instance: fp_c_m7_e_m7, and set properties
  set fp_c_m7_e_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m7 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m7

  # Create instance: fp_c_m7_e_m8, and set properties
  set fp_c_m7_e_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m8 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m8

  # Create instance: fp_c_m7_e_m9, and set properties
  set fp_c_m7_e_m9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m9 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m9

  # Create instance: fp_c_m7_e_m10, and set properties
  set fp_c_m7_e_m10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m10 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m10

  # Create instance: fp_c_m7_e_m11, and set properties
  set fp_c_m7_e_m11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m11 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m11

  # Create instance: fp_c_m7_e_m12, and set properties
  set fp_c_m7_e_m12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m12 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m12

  # Create instance: fp_c_m7_e_m13, and set properties
  set fp_c_m7_e_m13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m13 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m13

  # Create instance: fp_c_m7_e_m14, and set properties
  set fp_c_m7_e_m14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m14 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m14

  # Create instance: fp_c_m7_e_m15, and set properties
  set fp_c_m7_e_m15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m15 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m15

  # Create instance: fp_c_m7_e_m16, and set properties
  set fp_c_m7_e_m16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m7_e_m16 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m7_e_m16

  # Create instance: fp_c_m8, and set properties
  set fp_c_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_c_m8 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_c_m8

  # Create instance: fp_e_m6, and set properties
  set fp_e_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_e_m6 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_e_m6

  # Create instance: fp_e_m7, and set properties
  set fp_e_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_e_m7 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_e_m7

  # Create instance: fp_m6_m7, and set properties
  set fp_m6_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_m6_m7 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_m6_m7

  # Create instance: fp_m6_m8, and set properties
  set fp_m6_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 fp_m6_m8 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Custom} \
   CONFIG.C_A_Exponent_Width {13} \
   CONFIG.C_A_Fraction_Width {11} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {6} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $fp_m6_m8

  # Create instance: hold_a, and set properties
  set hold_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_a ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $hold_a

  # Create instance: hold_b, and set properties
  set hold_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_b ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $hold_b

  # Create instance: hold_c, and set properties
  set hold_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_c ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $hold_c

  # Create instance: hold_d, and set properties
  set hold_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_d ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $hold_d

  # Create instance: hold_e, and set properties
  set hold_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_e ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $hold_e

  # Create instance: hold_error, and set properties
  set hold_error [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 hold_error ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $hold_error

  # Create instance: sub_a_e, and set properties
  set sub_a_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_a_e ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_a_e

  # Create instance: sub_a_m6, and set properties
  set sub_a_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_a_m6 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_a_m6

  # Create instance: sub_a_m7, and set properties
  set sub_a_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_a_m7 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_a_m7

  # Create instance: sub_a_m8, and set properties
  set sub_a_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_a_m8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_a_m8

  # Create instance: sub_c_e, and set properties
  set sub_c_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_c_e ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_c_e

  # Create instance: sub_c_m6, and set properties
  set sub_c_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_c_m6 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_c_m6

  # Create instance: sub_c_m7, and set properties
  set sub_c_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_c_m7 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_c_m7

  # Create instance: sub_c_m8, and set properties
  set sub_c_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_c_m8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_c_m8

  # Create instance: sub_e_m6, and set properties
  set sub_e_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_e_m6 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_e_m6

  # Create instance: sub_e_m7, and set properties
  set sub_e_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_e_m7 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_e_m7

  # Create instance: sub_e_m8, and set properties
  set sub_e_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_e_m8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_e_m8

  # Create instance: sub_m6_m7, and set properties
  set sub_m6_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_m6_m7 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_m6_m7

  # Create instance: sub_m6_m8, and set properties
  set sub_m6_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_m6_m8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {24} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $sub_m6_m8

  # Create instance: tap_101_a, and set properties
  set tap_101_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_101_a ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {101} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $tap_101_a

  # Create instance: tap_101_b, and set properties
  set tap_101_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_101_b ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {101} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $tap_101_b

  # Create instance: tap_101_c, and set properties
  set tap_101_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_101_c ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {101} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $tap_101_c

  # Create instance: tap_101_d, and set properties
  set tap_101_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_101_d ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {101} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $tap_101_d

  # Create instance: tap_101_e, and set properties
  set tap_101_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_101_e ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {101} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $tap_101_e

  # Create instance: tap_1_101_1_2_eol, and set properties
  set tap_1_101_1_2_eol [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_101_1_2_eol ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {105} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_101_1_2_eol

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: wnd_a, and set properties
  set wnd_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_a ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_a

  # Create instance: wnd_b, and set properties
  set wnd_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_b ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_b

  # Create instance: wnd_c, and set properties
  set wnd_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_c ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_c

  # Create instance: wnd_d, and set properties
  set wnd_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_d ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_d

  # Create instance: wnd_e, and set properties
  set wnd_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_e ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_e

  # Create instance: wnd_m6, and set properties
  set wnd_m6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_m6 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_m6

  # Create instance: wnd_m7, and set properties
  set wnd_m7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_m7 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_m7

  # Create instance: wnd_m8, and set properties
  set wnd_m8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 wnd_m8 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $wnd_m8

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $xlslice_1

  # Create port connections
  connect_bd_net -net CLK2_1 [get_bd_ports CLK2] [get_bd_pins c_shift_ram_0/CLK] [get_bd_pins c_shift_ram_1/CLK] [get_bd_pins cr_0/aclk] [get_bd_pins cr_1/aclk] [get_bd_pins cr_11/aclk] [get_bd_pins cr_12/aclk] [get_bd_pins cr_13/aclk] [get_bd_pins cr_14/aclk] [get_bd_pins cr_15/aclk] [get_bd_pins cr_16/aclk] [get_bd_pins cr_17/aclk] [get_bd_pins cr_18/aclk] [get_bd_pins cr_19/aclk] [get_bd_pins cr_2/aclk] [get_bd_pins cr_20/aclk] [get_bd_pins cr_3/aclk] [get_bd_pins cr_4/aclk] [get_bd_pins floating_point_0/aclk] [get_bd_pins floating_point_1/aclk] [get_bd_pins floating_point_10/aclk] [get_bd_pins floating_point_12/aclk] [get_bd_pins floating_point_14/aclk] [get_bd_pins floating_point_16/aclk] [get_bd_pins floating_point_17/aclk] [get_bd_pins floating_point_19/aclk] [get_bd_pins floating_point_2/aclk] [get_bd_pins floating_point_21/aclk] [get_bd_pins floating_point_23/aclk] [get_bd_pins floating_point_25/aclk] [get_bd_pins floating_point_27/aclk] [get_bd_pins floating_point_29/aclk] [get_bd_pins floating_point_31/aclk] [get_bd_pins floating_point_33/aclk] [get_bd_pins floating_point_34/aclk] [get_bd_pins floating_point_35/aclk] [get_bd_pins floating_point_36/aclk] [get_bd_pins floating_point_37/aclk] [get_bd_pins floating_point_38/aclk] [get_bd_pins floating_point_39/aclk] [get_bd_pins floating_point_4/aclk] [get_bd_pins floating_point_40/aclk] [get_bd_pins floating_point_41/aclk] [get_bd_pins floating_point_42/aclk] [get_bd_pins floating_point_43/aclk] [get_bd_pins floating_point_44/aclk] [get_bd_pins floating_point_45/aclk] [get_bd_pins floating_point_6/aclk] [get_bd_pins floating_point_8/aclk] [get_bd_pins fp_a_e/aclk] [get_bd_pins fp_a_e_c_m6/aclk] [get_bd_pins fp_a_e_c_m7/aclk] [get_bd_pins fp_a_m6/aclk] [get_bd_pins fp_a_m6_c_m7/aclk] [get_bd_pins fp_a_m6_e_m7/aclk] [get_bd_pins fp_a_m7/aclk] [get_bd_pins fp_a_m7_c_m6/aclk] [get_bd_pins fp_a_m7_e_m6/aclk] [get_bd_pins fp_a_m8/aclk] [get_bd_pins fp_c_e/aclk] [get_bd_pins fp_c_e1/aclk] [get_bd_pins fp_c_e_a_m6/aclk] [get_bd_pins fp_c_e_a_m7/aclk] [get_bd_pins fp_c_m6/aclk] [get_bd_pins fp_c_m6_e_m10/aclk] [get_bd_pins fp_c_m6_e_m11/aclk] [get_bd_pins fp_c_m6_e_m12/aclk] [get_bd_pins fp_c_m6_e_m13/aclk] [get_bd_pins fp_c_m6_e_m14/aclk] [get_bd_pins fp_c_m6_e_m15/aclk] [get_bd_pins fp_c_m6_e_m16/aclk] [get_bd_pins fp_c_m6_e_m17/aclk] [get_bd_pins fp_c_m6_e_m7/aclk] [get_bd_pins fp_c_m6_e_m8/aclk] [get_bd_pins fp_c_m6_e_m9/aclk] [get_bd_pins fp_c_m7/aclk] [get_bd_pins fp_c_m7_e_m10/aclk] [get_bd_pins fp_c_m7_e_m11/aclk] [get_bd_pins fp_c_m7_e_m12/aclk] [get_bd_pins fp_c_m7_e_m13/aclk] [get_bd_pins fp_c_m7_e_m14/aclk] [get_bd_pins fp_c_m7_e_m15/aclk] [get_bd_pins fp_c_m7_e_m16/aclk] [get_bd_pins fp_c_m7_e_m6/aclk] [get_bd_pins fp_c_m7_e_m7/aclk] [get_bd_pins fp_c_m7_e_m8/aclk] [get_bd_pins fp_c_m7_e_m9/aclk] [get_bd_pins fp_c_m8/aclk] [get_bd_pins fp_e_m6/aclk] [get_bd_pins fp_e_m7/aclk] [get_bd_pins fp_m6_m7/aclk] [get_bd_pins fp_m6_m8/aclk] [get_bd_pins hold_a/CLK] [get_bd_pins hold_b/CLK] [get_bd_pins hold_c/CLK] [get_bd_pins hold_d/CLK] [get_bd_pins hold_e/CLK] [get_bd_pins hold_error/CLK] [get_bd_pins sub_a_e/CLK] [get_bd_pins sub_a_m6/CLK] [get_bd_pins sub_a_m7/CLK] [get_bd_pins sub_a_m8/CLK] [get_bd_pins sub_c_e/CLK] [get_bd_pins sub_c_m6/CLK] [get_bd_pins sub_c_m7/CLK] [get_bd_pins sub_c_m8/CLK] [get_bd_pins sub_e_m6/CLK] [get_bd_pins sub_e_m7/CLK] [get_bd_pins sub_e_m8/CLK] [get_bd_pins sub_m6_m7/CLK] [get_bd_pins sub_m6_m8/CLK] [get_bd_pins tap_101_a/CLK] [get_bd_pins tap_101_b/CLK] [get_bd_pins tap_101_c/CLK] [get_bd_pins tap_101_d/CLK] [get_bd_pins tap_101_e/CLK] [get_bd_pins tap_1_101_1_2_eol/CLK] [get_bd_pins wnd_a/CLK] [get_bd_pins wnd_b/CLK] [get_bd_pins wnd_c/CLK] [get_bd_pins wnd_d/CLK] [get_bd_pins wnd_e/CLK] [get_bd_pins wnd_m6/CLK] [get_bd_pins wnd_m7/CLK] [get_bd_pins wnd_m8/CLK]
  connect_bd_net -net a_1 [get_bd_pins sub_a_e/A] [get_bd_pins sub_a_m6/A] [get_bd_pins sub_a_m7/A] [get_bd_pins sub_a_m8/A] [get_bd_pins tap_101_a/D] [get_bd_pins wnd_a/Q]
  connect_bd_net -net a_m8_1 [get_bd_pins fp_a_m8/m_axis_result_tdata] [get_bd_pins fp_c_m7_e_m10/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m12/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m13/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m14/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m6/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m7/s_axis_a_tdata]
  connect_bd_net -net add13_addout [get_bd_pins c_shift_ram_1/D] [get_bd_pins floating_point_1/s_axis_a_tdata] [get_bd_pins floating_point_45/m_axis_result_tdata]
  connect_bd_net -net add8_addout [get_bd_pins floating_point_42/m_axis_result_tdata] [get_bd_pins floating_point_43/s_axis_a_tdata]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins sub_a_m8/B] [get_bd_pins sub_c_m8/B] [get_bd_pins sub_e_m8/B] [get_bd_pins sub_m6_m8/B] [get_bd_pins wnd_m7/D] [get_bd_pins wnd_m8/Q]
  connect_bd_net -net c_shift_ram_0_Q_1 [get_bd_pins c_shift_ram_0/Q] [get_bd_pins floating_point_39/s_axis_b_tdata]
  connect_bd_net -net c_shift_ram_1_Q [get_bd_pins sub_a_m7/B] [get_bd_pins sub_c_m7/B] [get_bd_pins sub_e_m7/B] [get_bd_pins sub_m6_m7/B] [get_bd_pins wnd_m6/D] [get_bd_pins wnd_m7/Q]
  connect_bd_net -net c_shift_ram_2_Q [get_bd_pins sub_a_m6/B] [get_bd_pins sub_c_m6/B] [get_bd_pins sub_e_m6/B] [get_bd_pins sub_m6_m7/A] [get_bd_pins sub_m6_m8/A] [get_bd_pins wnd_e/D] [get_bd_pins wnd_m6/Q]
  connect_bd_net -net c_shift_ram_3_Q [get_bd_pins sub_a_e/B] [get_bd_pins sub_c_e/B] [get_bd_pins sub_e_m6/A] [get_bd_pins sub_e_m7/A] [get_bd_pins sub_e_m8/A] [get_bd_pins tap_101_e/D] [get_bd_pins wnd_d/D] [get_bd_pins wnd_e/Q]
  connect_bd_net -net c_shift_ram_4_Q [get_bd_pins tap_101_d/D] [get_bd_pins wnd_c/D] [get_bd_pins wnd_d/Q]
  connect_bd_net -net c_shift_ram_5_Q [get_bd_pins sub_c_e/A] [get_bd_pins sub_c_m6/A] [get_bd_pins sub_c_m7/A] [get_bd_pins sub_c_m8/A] [get_bd_pins tap_101_c/D] [get_bd_pins wnd_b/D] [get_bd_pins wnd_c/Q]
  connect_bd_net -net c_shift_ram_6_Q [get_bd_pins tap_101_b/D] [get_bd_pins wnd_a/D] [get_bd_pins wnd_b/Q]
  connect_bd_net -net cr_1 [get_bd_pins cr_1/m_axis_result_tdata] [get_bd_pins floating_point_23/s_axis_a_tdata]
  connect_bd_net -net cr_2 [get_bd_pins cr_2/m_axis_result_tdata] [get_bd_pins floating_point_21/s_axis_a_tdata]
  connect_bd_net -net cr_3 [get_bd_pins cr_17/m_axis_result_tdata] [get_bd_pins floating_point_27/s_axis_a_tdata]
  connect_bd_net -net cr_4 [get_bd_pins cr_4/m_axis_result_tdata] [get_bd_pins floating_point_17/s_axis_a_tdata]
  connect_bd_net -net cr_5 [get_bd_pins cr_20/m_axis_result_tdata] [get_bd_pins floating_point_10/s_axis_a_tdata]
  connect_bd_net -net cr_6 [get_bd_pins cr_11/m_axis_result_tdata] [get_bd_pins floating_point_12/s_axis_a_tdata]
  connect_bd_net -net cr_7 [get_bd_pins cr_16/m_axis_result_tdata] [get_bd_pins floating_point_14/s_axis_a_tdata]
  connect_bd_net -net cr_8 [get_bd_pins cr_15/m_axis_result_tdata] [get_bd_pins floating_point_2/s_axis_a_tdata]
  connect_bd_net -net cr_9 [get_bd_pins cr_12/m_axis_result_tdata] [get_bd_pins floating_point_8/s_axis_a_tdata]
  connect_bd_net -net cr_10 [get_bd_pins cr_13/m_axis_result_tdata] [get_bd_pins floating_point_4/s_axis_a_tdata]
  connect_bd_net -net e_m8_1 [get_bd_pins fp_c_e1/m_axis_result_tdata] [get_bd_pins fp_c_m6_e_m12/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m13/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m17/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m7/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m9/s_axis_a_tdata]
  connect_bd_net -net edge_in_1 [get_bd_ports edge_in] [get_bd_pins wnd_m8/D]
  connect_bd_net -net eol_1 [get_bd_ports eol] [get_bd_pins tap_1_101_1_2_eol/D]
  connect_bd_net -net error_9_error [get_bd_pins c_shift_ram_0/D] [get_bd_pins floating_point_13/m_axis_result_tdata]
  connect_bd_net -net error_A_error [get_bd_pins floating_point_15/m_axis_result_tdata] [get_bd_pins floating_point_16/s_axis_b_tdata]
  connect_bd_net -net error_B_error [get_bd_pins floating_point_16/s_axis_a_tdata] [get_bd_pins floating_point_3/m_axis_result_tdata]
  connect_bd_net -net error_block_error [get_bd_pins c_shift_ram_1/Q] [get_bd_pins hold_error/D]
  connect_bd_net -net error_block_hold [get_bd_pins hold_a/CE] [get_bd_pins hold_b/CE] [get_bd_pins hold_c/CE] [get_bd_pins hold_d/CE] [get_bd_pins hold_e/CE] [get_bd_pins hold_error/CE] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins floating_point_0/m_axis_result_tdata] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_1 [get_bd_pins floating_point_1/m_axis_result_tdata] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_2 [get_bd_pins floating_point_2/m_axis_result_tdata] [get_bd_pins floating_point_3/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_3 [get_bd_pins floating_point_4/m_axis_result_tdata] [get_bd_pins floating_point_5/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_4 [get_bd_pins floating_point_6/m_axis_result_tdata] [get_bd_pins floating_point_7/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_5 [get_bd_pins floating_point_8/m_axis_result_tdata] [get_bd_pins floating_point_9/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_6 [get_bd_pins floating_point_10/m_axis_result_tdata] [get_bd_pins floating_point_11/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_7 [get_bd_pins floating_point_12/m_axis_result_tdata] [get_bd_pins floating_point_13/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_8 [get_bd_pins floating_point_14/m_axis_result_tdata] [get_bd_pins floating_point_15/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_9 [get_bd_pins floating_point_17/m_axis_result_tdata] [get_bd_pins floating_point_18/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_10 [get_bd_pins floating_point_19/m_axis_result_tdata] [get_bd_pins floating_point_20/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_11 [get_bd_pins floating_point_21/m_axis_result_tdata] [get_bd_pins floating_point_22/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_12 [get_bd_pins floating_point_23/m_axis_result_tdata] [get_bd_pins floating_point_24/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_13 [get_bd_pins floating_point_25/m_axis_result_tdata] [get_bd_pins floating_point_26/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_14 [get_bd_pins floating_point_27/m_axis_result_tdata] [get_bd_pins floating_point_28/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_15 [get_bd_pins floating_point_29/m_axis_result_tdata] [get_bd_pins floating_point_30/s_axis_a_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata_16 [get_bd_pins floating_point_31/m_axis_result_tdata] [get_bd_pins floating_point_32/s_axis_a_tdata]
  connect_bd_net -net fp_a_c_m6_m_axis_result_tdata [get_bd_pins fp_a_e_c_m6/s_axis_b_tdata] [get_bd_pins fp_a_m7_c_m6/s_axis_b_tdata] [get_bd_pins fp_c_m6/m_axis_result_tdata] [get_bd_pins fp_c_m6_e_m16/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m17/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m13/s_axis_b_tdata]
  connect_bd_net -net fp_a_e_c_m6_m_axis_result_tdata [get_bd_pins cr_0/s_axis_b_tdata] [get_bd_pins fp_a_e_c_m6/m_axis_result_tdata]
  connect_bd_net -net fp_a_e_c_m7_m_axis_result_tdata [get_bd_pins cr_1/s_axis_b_tdata] [get_bd_pins fp_a_e_c_m7/m_axis_result_tdata]
  connect_bd_net -net fp_a_e_m_axis_result_tdata [get_bd_pins fp_a_e/m_axis_result_tdata] [get_bd_pins fp_a_e_c_m6/s_axis_a_tdata] [get_bd_pins fp_a_e_c_m7/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m15/s_axis_a_tdata]
  connect_bd_net -net fp_a_m6_c_m7_m_axis_result_tdata [get_bd_pins cr_2/s_axis_b_tdata] [get_bd_pins fp_a_m6_c_m7/m_axis_result_tdata]
  connect_bd_net -net fp_a_m6_e_m7_m_axis_result_tdata [get_bd_pins cr_3/s_axis_b_tdata] [get_bd_pins fp_a_m6_e_m7/m_axis_result_tdata]
  connect_bd_net -net fp_a_m6_m_axis_result_tdata [get_bd_pins fp_a_m6/m_axis_result_tdata] [get_bd_pins fp_a_m6_c_m7/s_axis_a_tdata] [get_bd_pins fp_a_m6_e_m7/s_axis_a_tdata] [get_bd_pins fp_c_e_a_m6/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m14/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m7/s_axis_a_tdata]
  connect_bd_net -net fp_a_m7_c_m6_m_axis_result_tdata [get_bd_pins cr_2/s_axis_a_tdata] [get_bd_pins fp_a_m7_c_m6/m_axis_result_tdata]
  connect_bd_net -net fp_a_m7_e_m6_m_axis_result_tdata [get_bd_pins cr_3/s_axis_a_tdata] [get_bd_pins fp_a_m7_e_m6/m_axis_result_tdata]
  connect_bd_net -net fp_a_m7_m_axis_result_tdata [get_bd_pins fp_a_m7/m_axis_result_tdata] [get_bd_pins fp_a_m7_c_m6/s_axis_a_tdata] [get_bd_pins fp_a_m7_e_m6/s_axis_a_tdata] [get_bd_pins fp_c_e_a_m7/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m11/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m13/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m8/s_axis_a_tdata]
  connect_bd_net -net fp_c_e_a_m6_m_axis_result_tdata [get_bd_pins cr_0/s_axis_a_tdata] [get_bd_pins fp_c_e_a_m6/m_axis_result_tdata]
  connect_bd_net -net fp_c_e_a_m7_m_axis_result_tdata [get_bd_pins cr_1/s_axis_a_tdata] [get_bd_pins fp_c_e_a_m7/m_axis_result_tdata]
  connect_bd_net -net fp_c_e_m_axis_result_tdata [get_bd_pins fp_c_e/m_axis_result_tdata] [get_bd_pins fp_c_e_a_m6/s_axis_a_tdata] [get_bd_pins fp_c_e_a_m7/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m14/s_axis_a_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata [get_bd_pins cr_4/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m7/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_1 [get_bd_pins cr_11/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m8/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_2 [get_bd_pins cr_12/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m9/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_3 [get_bd_pins cr_13/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m10/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_4 [get_bd_pins cr_14/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m11/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_5 [get_bd_pins cr_15/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m12/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_6 [get_bd_pins cr_16/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m13/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_7 [get_bd_pins cr_17/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m14/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_8 [get_bd_pins cr_18/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m15/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_9 [get_bd_pins cr_19/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m16/m_axis_result_tdata]
  connect_bd_net -net fp_c_m6_e_m7_m_axis_result_tdata_10 [get_bd_pins cr_20/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m17/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata [get_bd_pins cr_4/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m6/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_1 [get_bd_pins cr_11/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m7/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_2 [get_bd_pins cr_12/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m8/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_3 [get_bd_pins cr_13/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m9/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_4 [get_bd_pins cr_14/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m10/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_5 [get_bd_pins cr_15/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m11/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_6 [get_bd_pins cr_16/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m12/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_7 [get_bd_pins cr_17/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m13/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_8 [get_bd_pins cr_18/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m14/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_9 [get_bd_pins cr_19/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m15/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_e_m6_m_axis_result_tdata_10 [get_bd_pins cr_20/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m16/m_axis_result_tdata]
  connect_bd_net -net fp_c_m7_m_axis_result_tdata [get_bd_pins fp_a_e_c_m7/s_axis_b_tdata] [get_bd_pins fp_a_m6_c_m7/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m12/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m9/s_axis_a_tdata] [get_bd_pins fp_c_m7/m_axis_result_tdata] [get_bd_pins fp_c_m7_e_m15/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m7/s_axis_b_tdata]
  connect_bd_net -net fp_e_m6_m_axis_result_tdata [get_bd_pins fp_a_m7_e_m6/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m15/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m16/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m6/s_axis_b_tdata] [get_bd_pins fp_e_m6/m_axis_result_tdata]
  connect_bd_net -net fp_e_m7_m_axis_result_tdata [get_bd_pins fp_a_m6_e_m7/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m10/s_axis_a_tdata] [get_bd_pins fp_c_m6_e_m16/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m11/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m12/s_axis_b_tdata] [get_bd_pins fp_e_m7/m_axis_result_tdata]
  connect_bd_net -net hold_a_Q [get_bd_ports a] [get_bd_pins hold_a/Q]
  connect_bd_net -net hold_b_Q [get_bd_ports b] [get_bd_pins hold_b/Q]
  connect_bd_net -net hold_c_Q [get_bd_ports c] [get_bd_pins hold_c/Q]
  connect_bd_net -net hold_d_Q [get_bd_ports d] [get_bd_pins hold_d/Q]
  connect_bd_net -net hold_e_Q [get_bd_ports e] [get_bd_pins hold_e/Q]
  connect_bd_net -net hold_error_Q [get_bd_pins floating_point_0/s_axis_a_tdata] [get_bd_pins floating_point_1/s_axis_b_tdata] [get_bd_pins hold_error/Q]
  connect_bd_net -net m6_m8_1 [get_bd_pins fp_c_m6_e_m10/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m11/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m9/s_axis_b_tdata] [get_bd_pins fp_m6_m8/m_axis_result_tdata]
  connect_bd_net -net s_axis_a_tdata_1 [get_bd_pins floating_point_20/m_axis_result_tdata] [get_bd_pins floating_point_36/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_2 [get_bd_pins floating_point_35/s_axis_a_tdata] [get_bd_pins floating_point_5/m_axis_result_tdata]
  connect_bd_net -net s_axis_a_tdata_3 [get_bd_pins floating_point_24/m_axis_result_tdata] [get_bd_pins floating_point_38/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_4 [get_bd_pins floating_point_26/m_axis_result_tdata] [get_bd_pins floating_point_34/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_5 [get_bd_pins floating_point_30/m_axis_result_tdata] [get_bd_pins floating_point_33/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_6 [get_bd_pins floating_point_18/m_axis_result_tdata] [get_bd_pins floating_point_37/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_7 [get_bd_pins floating_point_37/m_axis_result_tdata] [get_bd_pins floating_point_39/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_8 [get_bd_pins floating_point_34/m_axis_result_tdata] [get_bd_pins floating_point_42/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_9 [get_bd_pins floating_point_35/m_axis_result_tdata] [get_bd_pins floating_point_41/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_10 [get_bd_pins floating_point_16/m_axis_result_tdata] [get_bd_pins floating_point_40/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_11 [get_bd_pins floating_point_40/m_axis_result_tdata] [get_bd_pins floating_point_44/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_12 [get_bd_pins floating_point_44/m_axis_result_tdata] [get_bd_pins floating_point_45/s_axis_a_tdata]
  connect_bd_net -net s_axis_b_tdata_1 [get_bd_pins floating_point_36/s_axis_b_tdata] [get_bd_pins floating_point_9/m_axis_result_tdata]
  connect_bd_net -net s_axis_b_tdata_2 [get_bd_pins floating_point_32/m_axis_result_tdata] [get_bd_pins floating_point_35/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_3 [get_bd_pins floating_point_22/m_axis_result_tdata] [get_bd_pins floating_point_38/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_4 [get_bd_pins floating_point_34/s_axis_b_tdata] [get_bd_pins floating_point_7/m_axis_result_tdata]
  connect_bd_net -net s_axis_b_tdata_5 [get_bd_pins floating_point_28/m_axis_result_tdata] [get_bd_pins floating_point_33/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_6 [get_bd_pins floating_point_11/m_axis_result_tdata] [get_bd_pins floating_point_37/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_7 [get_bd_pins floating_point_33/m_axis_result_tdata] [get_bd_pins floating_point_42/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_8 [get_bd_pins floating_point_38/m_axis_result_tdata] [get_bd_pins floating_point_41/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_9 [get_bd_pins floating_point_36/m_axis_result_tdata] [get_bd_pins floating_point_40/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_10 [get_bd_pins floating_point_41/m_axis_result_tdata] [get_bd_pins floating_point_44/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_11 [get_bd_pins floating_point_39/m_axis_result_tdata] [get_bd_pins floating_point_43/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_12 [get_bd_pins floating_point_43/m_axis_result_tdata] [get_bd_pins floating_point_45/s_axis_b_tdata]
  connect_bd_net -net sub_a_e_S [get_bd_pins fp_a_e/s_axis_a_tdata] [get_bd_pins sub_a_e/S]
  connect_bd_net -net sub_a_m6_S [get_bd_pins fp_a_m6/s_axis_a_tdata] [get_bd_pins sub_a_m6/S]
  connect_bd_net -net sub_a_m7_S [get_bd_pins fp_a_m7/s_axis_a_tdata] [get_bd_pins sub_a_m7/S]
  connect_bd_net -net sub_a_m8_S [get_bd_pins fp_a_m8/s_axis_a_tdata] [get_bd_pins sub_a_m8/S]
  connect_bd_net -net sub_block_cr_0 [get_bd_pins cr_0/m_axis_result_tdata] [get_bd_pins floating_point_31/s_axis_a_tdata]
  connect_bd_net -net sub_block_cr_3 [get_bd_pins cr_3/m_axis_result_tdata] [get_bd_pins floating_point_25/s_axis_a_tdata]
  connect_bd_net -net sub_block_cr_4 [get_bd_pins cr_19/m_axis_result_tdata] [get_bd_pins floating_point_6/s_axis_a_tdata]
  connect_bd_net -net sub_block_cr_5 [get_bd_pins cr_18/m_axis_result_tdata] [get_bd_pins floating_point_29/s_axis_a_tdata]
  connect_bd_net -net sub_block_cr_C [get_bd_pins cr_14/m_axis_result_tdata] [get_bd_pins floating_point_19/s_axis_a_tdata]
  connect_bd_net -net sub_c_e_S [get_bd_pins fp_c_e/s_axis_a_tdata] [get_bd_pins sub_c_e/S]
  connect_bd_net -net sub_c_m6_S [get_bd_pins fp_c_m6/s_axis_a_tdata] [get_bd_pins sub_c_m6/S]
  connect_bd_net -net sub_c_m7_S [get_bd_pins fp_c_m7/s_axis_a_tdata] [get_bd_pins sub_c_m7/S]
  connect_bd_net -net sub_c_m8_S [get_bd_pins fp_c_m8/s_axis_a_tdata] [get_bd_pins sub_c_m8/S]
  connect_bd_net -net sub_e_m6_S [get_bd_pins fp_e_m6/s_axis_a_tdata] [get_bd_pins sub_e_m6/S]
  connect_bd_net -net sub_e_m7_S [get_bd_pins fp_e_m7/s_axis_a_tdata] [get_bd_pins sub_e_m7/S]
  connect_bd_net -net sub_e_m8_S [get_bd_pins fp_c_e1/s_axis_a_tdata] [get_bd_pins sub_e_m8/S]
  connect_bd_net -net sub_ff_c_m8 [get_bd_pins fp_c_m6_e_m14/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m15/s_axis_b_tdata] [get_bd_pins fp_c_m6_e_m8/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m11/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m16/s_axis_a_tdata] [get_bd_pins fp_c_m7_e_m8/s_axis_a_tdata] [get_bd_pins fp_c_m8/m_axis_result_tdata]
  connect_bd_net -net sub_ff_m6_m7 [get_bd_pins fp_c_m7_e_m10/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m8/s_axis_b_tdata] [get_bd_pins fp_c_m7_e_m9/s_axis_b_tdata] [get_bd_pins fp_m6_m7/m_axis_result_tdata]
  connect_bd_net -net sub_m6_m7_S [get_bd_pins fp_m6_m7/s_axis_a_tdata] [get_bd_pins sub_m6_m7/S]
  connect_bd_net -net sub_m6_m8_S [get_bd_pins fp_m6_m8/s_axis_a_tdata] [get_bd_pins sub_m6_m8/S]
  connect_bd_net -net t_0_1 [get_bd_ports t_0] [get_bd_pins floating_point_31/s_axis_b_tdata]
  connect_bd_net -net t_1 [get_bd_ports t_1] [get_bd_pins floating_point_23/s_axis_b_tdata]
  connect_bd_net -net t_2 [get_bd_ports t_2] [get_bd_pins floating_point_21/s_axis_b_tdata]
  connect_bd_net -net t_4 [get_bd_ports t_3] [get_bd_pins floating_point_25/s_axis_b_tdata]
  connect_bd_net -net t_5 [get_bd_ports t_4] [get_bd_pins floating_point_6/s_axis_b_tdata]
  connect_bd_net -net t_6 [get_bd_ports t_5] [get_bd_pins floating_point_29/s_axis_b_tdata]
  connect_bd_net -net t_7 [get_bd_ports t_6] [get_bd_pins floating_point_27/s_axis_b_tdata]
  connect_bd_net -net t_8 [get_bd_ports t_7] [get_bd_pins floating_point_17/s_axis_b_tdata]
  connect_bd_net -net t_9 [get_bd_ports t_8] [get_bd_pins floating_point_10/s_axis_b_tdata]
  connect_bd_net -net t_10 [get_bd_ports t_9] [get_bd_pins floating_point_12/s_axis_b_tdata]
  connect_bd_net -net t_11 [get_bd_ports t_A] [get_bd_pins floating_point_14/s_axis_b_tdata]
  connect_bd_net -net t_12 [get_bd_ports t_B] [get_bd_pins floating_point_2/s_axis_b_tdata]
  connect_bd_net -net t_13 [get_bd_ports t_C] [get_bd_pins floating_point_19/s_axis_b_tdata]
  connect_bd_net -net t_14 [get_bd_ports t_D] [get_bd_pins floating_point_8/s_axis_b_tdata]
  connect_bd_net -net t_15 [get_bd_ports t_E] [get_bd_pins floating_point_4/s_axis_b_tdata]
  connect_bd_net -net tap_101_a_Q [get_bd_pins hold_a/D] [get_bd_pins tap_101_a/Q]
  connect_bd_net -net tap_101_b_Q [get_bd_pins hold_b/D] [get_bd_pins tap_101_b/Q]
  connect_bd_net -net tap_101_c1_Q [get_bd_pins hold_d/D] [get_bd_pins tap_101_d/Q]
  connect_bd_net -net tap_101_c_Q [get_bd_pins hold_c/D] [get_bd_pins tap_101_c/Q]
  connect_bd_net -net tap_101_d1_Q [get_bd_pins hold_e/D] [get_bd_pins tap_101_e/Q]
  connect_bd_net -net tap_1_101_1_2_eol_Q [get_bd_ports valid_out] [get_bd_pins tap_1_101_1_2_eol/Q] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net thresh_1 [get_bd_ports thresh] [get_bd_pins floating_point_0/s_axis_b_tdata]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_ports pattern_ok] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net valid_1 [get_bd_ports valid_in] [get_bd_pins wnd_a/CE] [get_bd_pins wnd_b/CE] [get_bd_pins wnd_c/CE] [get_bd_pins wnd_d/CE] [get_bd_pins wnd_e/CE] [get_bd_pins wnd_m6/CE] [get_bd_pins wnd_m7/CE] [get_bd_pins wnd_m8/CE]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins util_vector_logic_0/Op1] [get_bd_pins xlslice_0/Dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


