
################################################################
# This is a generated script based on design: distance_collinear
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
# source distance_collinear_script.tcl

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
set design_name distance_collinear

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
xilinx.com:ip:floating_point:7.1\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconcat:2.1\
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


# Hierarchical cell: p2cm_16
proc create_hier_cell_p2cm_16 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_p2cm_16() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I CLK
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_add_4, and set properties
  set exp_add_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 exp_add_4 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Constant {true} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {100} \
   CONFIG.B_Width {3} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {8} \
 ] $exp_add_4

  # Create instance: f_exp, and set properties
  set f_exp [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_exp ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {8} \
 ] $f_exp

  # Create instance: f_mant, and set properties
  set f_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {0} \
   CONFIG.DOUT_WIDTH {23} \
 ] $f_mant

  # Create instance: f_result, and set properties
  set f_result [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 f_result ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {23} \
   CONFIG.IN1_WIDTH {8} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $f_result

  # Create instance: f_sign, and set properties
  set f_sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $f_sign

  # Create instance: tap_1_mant, and set properties
  set tap_1_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_mant ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000000000000} \
   CONFIG.Width {23} \
 ] $tap_1_mant

  # Create instance: tap_1_sign, and set properties
  set tap_1_sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_sign ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_sign

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins exp_add_4/CLK] [get_bd_pins tap_1_mant/CLK] [get_bd_pins tap_1_sign/CLK]
  connect_bd_net -net Din_1 [get_bd_pins float_in] [get_bd_pins f_exp/Din] [get_bd_pins f_mant/Din] [get_bd_pins f_sign/Din]
  connect_bd_net -net exp_add_2_S [get_bd_pins exp_add_4/S] [get_bd_pins f_result/In1]
  connect_bd_net -net f_exp_Dout [get_bd_pins exp_add_4/A] [get_bd_pins f_exp/Dout]
  connect_bd_net -net f_mant_Dout [get_bd_pins f_mant/Dout] [get_bd_pins tap_1_mant/D]
  connect_bd_net -net f_result_dout [get_bd_pins float_out] [get_bd_pins f_result/dout]
  connect_bd_net -net f_sign_Dout [get_bd_pins f_sign/Dout] [get_bd_pins tap_1_sign/D]
  connect_bd_net -net tap_1_sign1_Q [get_bd_pins f_result/In0] [get_bd_pins tap_1_mant/Q]
  connect_bd_net -net tap_1_sign_Q [get_bd_pins f_result/In2] [get_bd_pins tap_1_sign/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: p2cm_4
proc create_hier_cell_p2cm_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_p2cm_4() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I CLK
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_add_2, and set properties
  set exp_add_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 exp_add_2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Constant {true} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {10} \
   CONFIG.B_Width {2} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {8} \
 ] $exp_add_2

  # Create instance: f_exp, and set properties
  set f_exp [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_exp ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {8} \
 ] $f_exp

  # Create instance: f_mant, and set properties
  set f_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {0} \
   CONFIG.DOUT_WIDTH {23} \
 ] $f_mant

  # Create instance: f_result, and set properties
  set f_result [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 f_result ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {23} \
   CONFIG.IN1_WIDTH {8} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $f_result

  # Create instance: f_sign, and set properties
  set f_sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 f_sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $f_sign

  # Create instance: tap_1_mant, and set properties
  set tap_1_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_mant ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000000000000000} \
   CONFIG.Width {23} \
 ] $tap_1_mant

  # Create instance: tap_1_sign, and set properties
  set tap_1_sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_sign ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_sign

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins exp_add_2/CLK] [get_bd_pins tap_1_mant/CLK] [get_bd_pins tap_1_sign/CLK]
  connect_bd_net -net Din_1 [get_bd_pins float_in] [get_bd_pins f_exp/Din] [get_bd_pins f_mant/Din] [get_bd_pins f_sign/Din]
  connect_bd_net -net exp_add_2_S [get_bd_pins exp_add_2/S] [get_bd_pins f_result/In1]
  connect_bd_net -net f_exp_Dout [get_bd_pins exp_add_2/A] [get_bd_pins f_exp/Dout]
  connect_bd_net -net f_mant_Dout [get_bd_pins f_mant/Dout] [get_bd_pins tap_1_mant/D]
  connect_bd_net -net f_result_dout [get_bd_pins float_out] [get_bd_pins f_result/dout]
  connect_bd_net -net f_sign_Dout [get_bd_pins f_sign/Dout] [get_bd_pins tap_1_sign/D]
  connect_bd_net -net tap_1_mant_Q [get_bd_pins f_result/In0] [get_bd_pins tap_1_mant/Q]
  connect_bd_net -net tap_1_sign_Q [get_bd_pins f_result/In2] [get_bd_pins tap_1_sign/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pixel_distances_11
proc create_hier_cell_pixel_distances_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pixel_distances_11() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 a
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 b
  create_bd_pin -dir I -from 31 -to 0 c
  create_bd_pin -dir O -from 31 -to 0 c_a
  create_bd_pin -dir O -from 31 -to 0 c_b
  create_bd_pin -dir I -from 31 -to 0 d
  create_bd_pin -dir O -from 31 -to 0 d_a
  create_bd_pin -dir O -from 31 -to 0 d_b
  create_bd_pin -dir O -from 31 -to 0 d_c
  create_bd_pin -dir I -from 31 -to 0 e
  create_bd_pin -dir O -from 31 -to 0 e_b
  create_bd_pin -dir O -from 31 -to 0 e_c

  # Create instance: c_a, and set properties
  set c_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 c_a ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $c_a

  # Create instance: c_b, and set properties
  set c_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 c_b ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $c_b

  # Create instance: d_a, and set properties
  set d_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 d_a ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $d_a

  # Create instance: d_b, and set properties
  set d_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 d_b ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $d_b

  # Create instance: d_c, and set properties
  set d_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 d_c ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $d_c

  # Create instance: e_b, and set properties
  set e_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 e_b ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $e_b

  # Create instance: e_c, and set properties
  set e_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 e_c ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $e_c

  # Create port connections
  connect_bd_net -net a_1 [get_bd_pins a] [get_bd_pins c_a/s_axis_b_tdata] [get_bd_pins d_a/s_axis_b_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins c_a/aclk] [get_bd_pins c_b/aclk] [get_bd_pins d_a/aclk] [get_bd_pins d_b/aclk] [get_bd_pins d_c/aclk] [get_bd_pins e_b/aclk] [get_bd_pins e_c/aclk]
  connect_bd_net -net b_1 [get_bd_pins b] [get_bd_pins c_b/s_axis_b_tdata] [get_bd_pins d_b/s_axis_b_tdata] [get_bd_pins e_b/s_axis_b_tdata]
  connect_bd_net -net c_1 [get_bd_pins c] [get_bd_pins c_a/s_axis_a_tdata] [get_bd_pins c_b/s_axis_a_tdata] [get_bd_pins d_c/s_axis_b_tdata] [get_bd_pins e_c/s_axis_b_tdata]
  connect_bd_net -net c_a_m_axis_result_tdata [get_bd_pins c_a] [get_bd_pins c_a/m_axis_result_tdata]
  connect_bd_net -net c_b_m_axis_result_tdata [get_bd_pins c_b] [get_bd_pins c_b/m_axis_result_tdata]
  connect_bd_net -net d_1 [get_bd_pins d] [get_bd_pins d_a/s_axis_a_tdata] [get_bd_pins d_b/s_axis_a_tdata] [get_bd_pins d_c/s_axis_a_tdata]
  connect_bd_net -net d_a_m_axis_result_tdata [get_bd_pins d_a] [get_bd_pins d_a/m_axis_result_tdata]
  connect_bd_net -net d_b_m_axis_result_tdata [get_bd_pins d_b] [get_bd_pins d_b/m_axis_result_tdata]
  connect_bd_net -net d_c_m_axis_result_tdata [get_bd_pins d_c] [get_bd_pins d_c/m_axis_result_tdata]
  connect_bd_net -net e_1 [get_bd_pins e] [get_bd_pins e_b/s_axis_a_tdata] [get_bd_pins e_c/s_axis_a_tdata]
  connect_bd_net -net e_b_m_axis_result_tdata [get_bd_pins e_b] [get_bd_pins e_b/m_axis_result_tdata]
  connect_bd_net -net e_c_m_axis_result_tdata [get_bd_pins e_c] [get_bd_pins e_c/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: crossratio_num_den_8
proc create_hier_cell_crossratio_num_den_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_crossratio_num_den_8() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 R1_den
  create_bd_pin -dir O -from 31 -to 0 R1_num
  create_bd_pin -dir O -from 31 -to 0 R5_den
  create_bd_pin -dir O -from 31 -to 0 R5_num
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 c_a
  create_bd_pin -dir I -from 31 -to 0 c_b
  create_bd_pin -dir I -from 31 -to 0 d_a
  create_bd_pin -dir I -from 31 -to 0 d_b
  create_bd_pin -dir I -from 31 -to 0 d_c
  create_bd_pin -dir I -from 31 -to 0 e_b
  create_bd_pin -dir I -from 31 -to 0 e_c

  # Create instance: R1_den, and set properties
  set R1_den [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1_den ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R1_den

  # Create instance: R1_num, and set properties
  set R1_num [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1_num ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R1_num

  # Create instance: R5_den, and set properties
  set R5_den [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R5_den ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R5_den

  # Create instance: R5_num, and set properties
  set R5_num [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R5_num ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R5_num

  # Create port connections
  connect_bd_net -net R1_den_m_axis_result_tdata [get_bd_pins R1_den] [get_bd_pins R1_den/m_axis_result_tdata]
  connect_bd_net -net R1_num_m_axis_result_tdata [get_bd_pins R1_num] [get_bd_pins R1_num/m_axis_result_tdata]
  connect_bd_net -net R5_den_m_axis_result_tdata [get_bd_pins R5_den] [get_bd_pins R5_den/m_axis_result_tdata]
  connect_bd_net -net R5_num_m_axis_result_tdata [get_bd_pins R5_num] [get_bd_pins R5_num/m_axis_result_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins R1_den/aclk] [get_bd_pins R1_num/aclk] [get_bd_pins R5_den/aclk] [get_bd_pins R5_num/aclk]
  connect_bd_net -net c_a_m_axis_result_tdata [get_bd_pins c_a] [get_bd_pins R1_den/s_axis_a_tdata]
  connect_bd_net -net c_b_m_axis_result_tdata [get_bd_pins c_b] [get_bd_pins R1_num/s_axis_a_tdata]
  connect_bd_net -net d_a_m_axis_result_tdata [get_bd_pins d_a] [get_bd_pins R1_num/s_axis_b_tdata]
  connect_bd_net -net d_b_m_axis_result_tdata [get_bd_pins d_b] [get_bd_pins R1_den/s_axis_b_tdata] [get_bd_pins R5_den/s_axis_b_tdata]
  connect_bd_net -net d_c_m_axis_result_tdata [get_bd_pins d_c] [get_bd_pins R5_num/s_axis_a_tdata]
  connect_bd_net -net e_b_m_axis_result_tdata [get_bd_pins e_b] [get_bd_pins R5_num/s_axis_b_tdata]
  connect_bd_net -net e_c_m_axis_result_tdata [get_bd_pins e_c] [get_bd_pins R5_den/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: crossratio_28
proc create_hier_cell_crossratio_28 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_crossratio_28() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 R1
  create_bd_pin -dir I -from 31 -to 0 R1_den
  create_bd_pin -dir I -from 31 -to 0 R1_num
  create_bd_pin -dir O -from 31 -to 0 R5
  create_bd_pin -dir I -from 31 -to 0 R5_den
  create_bd_pin -dir I -from 31 -to 0 R5_num
  create_bd_pin -dir I -type clk aclk

  # Create instance: R1, and set properties
  set R1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1 ]
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
 ] $R1

  # Create instance: R5, and set properties
  set R5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R5 ]
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
 ] $R5

  # Create port connections
  connect_bd_net -net R1_den_m_axis_result_tdata [get_bd_pins R1_den] [get_bd_pins R1/s_axis_b_tdata]
  connect_bd_net -net R1_m_axis_result_tdata [get_bd_pins R1] [get_bd_pins R1/m_axis_result_tdata]
  connect_bd_net -net R1_num_m_axis_result_tdata [get_bd_pins R1_num] [get_bd_pins R1/s_axis_a_tdata]
  connect_bd_net -net R5_den_m_axis_result_tdata [get_bd_pins R5_den] [get_bd_pins R5/s_axis_b_tdata]
  connect_bd_net -net R5_m_axis_result_tdata [get_bd_pins R5] [get_bd_pins R5/m_axis_result_tdata]
  connect_bd_net -net R5_num_m_axis_result_tdata [get_bd_pins R5_num] [get_bd_pins R5/s_axis_a_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins R1/aclk] [get_bd_pins R5/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: base_2_num_31
proc create_hier_cell_base_2_num_31 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_base_2_num_31() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 R1
  create_bd_pin -dir I -from 31 -to 0 R5
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 31 -to 0 base_2_num

  # Create instance: AE_2, and set properties
  set AE_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 AE_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $AE_2

  # Create instance: R1_R5, and set properties
  set R1_R5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1_R5 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R1_R5

  # Create instance: R1_R5_square, and set properties
  set R1_R5_square [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1_R5_square ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R1_R5_square

  # Create instance: float_4, and set properties
  set float_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 float_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0x40800000} \
   CONFIG.CONST_WIDTH {32} \
 ] $float_4

  # Create instance: p2cm_16
  create_hier_cell_p2cm_16 $hier_obj p2cm_16

  # Create port connections
  connect_bd_net -net AE_2_m_axis_result_tdata [get_bd_pins base_2_num] [get_bd_pins AE_2/m_axis_result_tdata]
  connect_bd_net -net R1_R5_m_axis_result_tdata [get_bd_pins R1_R5/m_axis_result_tdata] [get_bd_pins R1_R5_square/s_axis_a_tdata] [get_bd_pins R1_R5_square/s_axis_b_tdata]
  connect_bd_net -net R1_R5_square_m_axis_result_tdata [get_bd_pins R1_R5_square/m_axis_result_tdata] [get_bd_pins p2cm_16/float_in]
  connect_bd_net -net R1_m_axis_result_tdata [get_bd_pins R1] [get_bd_pins R1_R5/s_axis_a_tdata]
  connect_bd_net -net R5_m_axis_result_tdata [get_bd_pins R5] [get_bd_pins R1_R5/s_axis_b_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins AE_2/aclk] [get_bd_pins R1_R5/aclk] [get_bd_pins R1_R5_square/aclk] [get_bd_pins p2cm_16/CLK]
  connect_bd_net -net float_4_dout [get_bd_pins AE_2/s_axis_b_tdata] [get_bd_pins float_4/dout]
  connect_bd_net -net p2cm_16_float_out [get_bd_pins AE_2/s_axis_a_tdata] [get_bd_pins p2cm_16/float_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: base_2_den_38
proc create_hier_cell_base_2_den_38 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_base_2_den_38() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 a
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 31 -to 0 base_2_den
  create_bd_pin -dir I -from 31 -to 0 c_a
  create_bd_pin -dir I -from 31 -to 0 e
  create_bd_pin -dir I -from 31 -to 0 e_c
  create_bd_pin -dir I -from 31 -to 0 row

  # Create instance: a_e_c, and set properties
  set a_e_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a_e_c ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $a_e_c

  # Create instance: e_c_a, and set properties
  set e_c_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 e_c_a ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $e_c_a

  # Create instance: e_c_c_a, and set properties
  set e_c_c_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 e_c_c_a ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $e_c_c_a

  # Create instance: float_1, and set properties
  set float_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 float_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0x3F800000} \
   CONFIG.CONST_WIDTH {32} \
 ] $float_1

  # Create instance: n1, and set properties
  set n1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 n1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $n1

  # Create instance: n1_2, and set properties
  set n1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 n1_2 ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Single} \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_A_Exponent_Width {8} \
   CONFIG.C_A_Fraction_Width {24} \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $n1_2

  # Create instance: n1_n2_n3_2, and set properties
  set n1_n2_n3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 n1_n2_n3_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $n1_n2_n3_2

  # Create instance: n2_n3_2, and set properties
  set n2_n3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 n2_n3_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $n2_n3_2

  # Create instance: n3_2, and set properties
  set n3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 n3_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $n3_2

  # Create instance: row_2, and set properties
  set row_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 row_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $row_2

  # Create instance: row_2_1, and set properties
  set row_2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 row_2_1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $row_2_1

  # Create port connections
  connect_bd_net -net a_e_c_m_axis_result_tdata [get_bd_pins a_e_c/m_axis_result_tdata] [get_bd_pins n1/s_axis_a_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins a_e_c/aclk] [get_bd_pins e_c_a/aclk] [get_bd_pins e_c_c_a/aclk] [get_bd_pins n1/aclk] [get_bd_pins n1_2/aclk] [get_bd_pins n1_n2_n3_2/aclk] [get_bd_pins n2_n3_2/aclk] [get_bd_pins n3_2/aclk] [get_bd_pins row_2/aclk] [get_bd_pins row_2_1/aclk]
  connect_bd_net -net c_a_m_axis_result_tdata [get_bd_pins c_a] [get_bd_pins e_c_a/s_axis_b_tdata] [get_bd_pins e_c_c_a/s_axis_b_tdata]
  connect_bd_net -net e_c_a_m_axis_result_tdata [get_bd_pins e_c_a/m_axis_result_tdata] [get_bd_pins n1/s_axis_b_tdata]
  connect_bd_net -net e_c_c_a_m_axis_result_tdata [get_bd_pins e_c_c_a/m_axis_result_tdata] [get_bd_pins n3_2/s_axis_a_tdata] [get_bd_pins n3_2/s_axis_b_tdata]
  connect_bd_net -net e_c_m_axis_result_tdata [get_bd_pins e_c] [get_bd_pins a_e_c/s_axis_b_tdata] [get_bd_pins e_c_c_a/s_axis_a_tdata]
  connect_bd_net -net float_1_dout [get_bd_pins float_1/dout] [get_bd_pins row_2_1/s_axis_b_tdata]
  connect_bd_net -net n1_2_m_axis_result_tdata [get_bd_pins n1_2/m_axis_result_tdata] [get_bd_pins n1_n2_n3_2/s_axis_a_tdata]
  connect_bd_net -net n1_m_axis_result_tdata [get_bd_pins n1/m_axis_result_tdata] [get_bd_pins n1_2/s_axis_a_tdata] [get_bd_pins n1_2/s_axis_b_tdata]
  connect_bd_net -net n1_n2_n3_2_m_axis_result_tdata [get_bd_pins base_2_den] [get_bd_pins n1_n2_n3_2/m_axis_result_tdata]
  connect_bd_net -net n2_2_m_axis_result_tdata [get_bd_pins n1_n2_n3_2/s_axis_b_tdata] [get_bd_pins n2_n3_2/m_axis_result_tdata]
  connect_bd_net -net n3_2_m_axis_result_tdata [get_bd_pins n2_n3_2/s_axis_b_tdata] [get_bd_pins n3_2/m_axis_result_tdata]
  connect_bd_net -net row_2_1_m_axis_result_tdata [get_bd_pins n2_n3_2/s_axis_a_tdata] [get_bd_pins row_2_1/m_axis_result_tdata]
  connect_bd_net -net row_2_m_axis_result_tdata [get_bd_pins row_2/m_axis_result_tdata] [get_bd_pins row_2_1/s_axis_a_tdata]
  connect_bd_net -net tap_11_a_Q [get_bd_pins a] [get_bd_pins a_e_c/s_axis_a_tdata]
  connect_bd_net -net tap_11_e_Q [get_bd_pins e] [get_bd_pins e_c_a/s_axis_a_tdata]
  connect_bd_net -net tap_11_row_Q [get_bd_pins row] [get_bd_pins row_2/s_axis_a_tdata] [get_bd_pins row_2/s_axis_b_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: A_2_12
proc create_hier_cell_A_2_12 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_A_2_12() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 A_2
  create_bd_pin -dir I -from 31 -to 0 R1
  create_bd_pin -dir I aclk

  # Create instance: R1_4_2, and set properties
  set R1_4_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R1_4_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.Axi_Optimize_Goal {Resources} \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Result_Precision_Type {Single} \
 ] $R1_4_2

  # Create instance: float_2, and set properties
  set float_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 float_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0x40000000} \
   CONFIG.CONST_WIDTH {32} \
 ] $float_2

  # Create instance: p2cm_4
  create_hier_cell_p2cm_4 $hier_obj p2cm_4

  # Create port connections
  connect_bd_net -net R1_4_2_m_axis_result_tdata [get_bd_pins A_2] [get_bd_pins R1_4_2/m_axis_result_tdata]
  connect_bd_net -net R1_m_axis_result_tdata [get_bd_pins R1] [get_bd_pins p2cm_4/float_in]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins R1_4_2/aclk] [get_bd_pins p2cm_4/CLK]
  connect_bd_net -net f32_2_dout [get_bd_pins R1_4_2/s_axis_b_tdata] [get_bd_pins float_2/dout]
  connect_bd_net -net p2cm_4_float_out [get_bd_pins R1_4_2/s_axis_a_tdata] [get_bd_pins p2cm_4/float_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set A_2 [ create_bd_port -dir O -from 31 -to 0 A_2 ]
  set a [ create_bd_port -dir I -from 31 -to 0 a ]
  set aclk [ create_bd_port -dir I aclk ]
  set b [ create_bd_port -dir I -from 31 -to 0 b ]
  set c [ create_bd_port -dir I -from 31 -to 0 c ]
  set d [ create_bd_port -dir I -from 31 -to 0 d ]
  set e [ create_bd_port -dir I -from 31 -to 0 e ]
  set row [ create_bd_port -dir I -from 31 -to 0 row ]
  set valid_in [ create_bd_port -dir I valid_in ]
  set valid_out [ create_bd_port -dir O -from 0 -to 0 valid_out ]
  set xa [ create_bd_port -dir O -from 31 -to 0 xa ]
  set xe [ create_bd_port -dir O -from 31 -to 0 xe ]

  # Create instance: A_2_12
  create_hier_cell_A_2_12 [current_bd_instance .] A_2_12

  # Create instance: abs_c_a, and set properties
  set abs_c_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 abs_c_a ]
  set_property -dict [ list \
   CONFIG.A_Precision_Type {Single} \
   CONFIG.C_A_Exponent_Width {8} \
   CONFIG.C_A_Fraction_Width {24} \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_A_TLAST {false} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.RESULT_TLAST_Behv {Null} \
   CONFIG.Result_Precision_Type {Single} \
 ] $abs_c_a

  # Create instance: abs_e_c, and set properties
  set abs_e_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 abs_e_c ]
  set_property -dict [ list \
   CONFIG.C_Latency {0} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Absolute} \
   CONFIG.Result_Precision_Type {Single} \
 ] $abs_e_c

  # Create instance: base_28, and set properties
  set base_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 base_28 ]
  set_property -dict [ list \
   CONFIG.C_Latency {28} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Square_root} \
   CONFIG.Result_Precision_Type {Single} \
 ] $base_28

  # Create instance: base_2_8, and set properties
  set base_2_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 base_2_8 ]
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
 ] $base_2_8

  # Create instance: base_2_den_38
  create_hier_cell_base_2_den_38 [current_bd_instance .] base_2_den_38

  # Create instance: base_2_num_31
  create_hier_cell_base_2_num_31 [current_bd_instance .] base_2_num_31

  # Create instance: crossratio_28
  create_hier_cell_crossratio_28 [current_bd_instance .] crossratio_28

  # Create instance: crossratio_num_den_8
  create_hier_cell_crossratio_num_den_8 [current_bd_instance .] crossratio_num_den_8

  # Create instance: pixel_distances_11
  create_hier_cell_pixel_distances_11 [current_bd_instance .] pixel_distances_11

  # Create instance: reciprocal_29, and set properties
  set reciprocal_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 reciprocal_29 ]
  set_property -dict [ list \
   CONFIG.C_Latency {29} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Reciprocal} \
   CONFIG.Result_Precision_Type {Single} \
 ] $reciprocal_29

  # Create instance: tap_11_a, and set properties
  set tap_11_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_a ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_a

  # Create instance: tap_11_e, and set properties
  set tap_11_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_e ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_e

  # Create instance: tap_11_row, and set properties
  set tap_11_row [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_row ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_row

  # Create instance: tap_122, and set properties
  set tap_122 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_122 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {122} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_122

  # Create instance: tap_63_A_2, and set properties
  set tap_63_A_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_63_A_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {63} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_63_A_2

  # Create instance: tap_67_8_28_a_c, and set properties
  set tap_67_8_28_a_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_67_8_28_a_c ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {103} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_67_8_28_a_c

  # Create instance: tap_67_8_28_e_c, and set properties
  set tap_67_8_28_e_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_67_8_28_e_c ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {103} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_67_8_28_e_c

  # Create instance: xa_8, and set properties
  set xa_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 xa_8 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $xa_8

  # Create instance: xe_8, and set properties
  set xe_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 xe_8 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $xe_8

  # Create port connections
  connect_bd_net -net R1_4_2_m_axis_result_tdata [get_bd_pins A_2_12/A_2] [get_bd_pins tap_63_A_2/D]
  connect_bd_net -net R1_den_m_axis_result_tdata [get_bd_pins crossratio_28/R1_den] [get_bd_pins crossratio_num_den_8/R1_den]
  connect_bd_net -net R1_m_axis_result_tdata [get_bd_pins A_2_12/R1] [get_bd_pins base_2_num_31/R1] [get_bd_pins crossratio_28/R1]
  connect_bd_net -net R1_num_m_axis_result_tdata [get_bd_pins crossratio_28/R1_num] [get_bd_pins crossratio_num_den_8/R1_num]
  connect_bd_net -net R5_den_m_axis_result_tdata [get_bd_pins crossratio_28/R5_den] [get_bd_pins crossratio_num_den_8/R5_den]
  connect_bd_net -net R5_m_axis_result_tdata [get_bd_pins base_2_num_31/R5] [get_bd_pins crossratio_28/R5]
  connect_bd_net -net R5_num_m_axis_result_tdata [get_bd_pins crossratio_28/R5_num] [get_bd_pins crossratio_num_den_8/R5_num]
  connect_bd_net -net a_1 [get_bd_ports a] [get_bd_pins pixel_distances_11/a] [get_bd_pins tap_11_a/D]
  connect_bd_net -net abs_c_a_m_axis_result_tdata [get_bd_pins abs_c_a/m_axis_result_tdata] [get_bd_pins tap_67_8_28_a_c/D]
  connect_bd_net -net abs_e_c_m_axis_result_tdata [get_bd_pins abs_e_c/m_axis_result_tdata] [get_bd_pins tap_67_8_28_e_c/D]
  connect_bd_net -net aclk_1 [get_bd_ports aclk] [get_bd_pins A_2_12/aclk] [get_bd_pins base_28/aclk] [get_bd_pins base_2_8/aclk] [get_bd_pins base_2_den_38/aclk] [get_bd_pins base_2_num_31/aclk] [get_bd_pins crossratio_28/aclk] [get_bd_pins crossratio_num_den_8/aclk] [get_bd_pins pixel_distances_11/aclk] [get_bd_pins reciprocal_29/aclk] [get_bd_pins tap_11_a/CLK] [get_bd_pins tap_11_e/CLK] [get_bd_pins tap_11_row/CLK] [get_bd_pins tap_122/CLK] [get_bd_pins tap_63_A_2/CLK] [get_bd_pins tap_67_8_28_a_c/CLK] [get_bd_pins tap_67_8_28_e_c/CLK] [get_bd_pins xa_8/aclk] [get_bd_pins xe_8/aclk]
  connect_bd_net -net b_1 [get_bd_ports b] [get_bd_pins pixel_distances_11/b]
  connect_bd_net -net base_2_m_axis_result_tdata [get_bd_pins base_28/s_axis_a_tdata] [get_bd_pins base_2_8/m_axis_result_tdata]
  connect_bd_net -net base_2_num_31_base_2_num [get_bd_pins base_2_8/s_axis_a_tdata] [get_bd_pins base_2_num_31/base_2_num]
  connect_bd_net -net base_m_axis_result_tdata [get_bd_pins base_28/m_axis_result_tdata] [get_bd_pins xa_8/s_axis_b_tdata] [get_bd_pins xe_8/s_axis_b_tdata]
  connect_bd_net -net c_1 [get_bd_ports c] [get_bd_pins pixel_distances_11/c]
  connect_bd_net -net c_a_m_axis_result_tdata [get_bd_pins abs_c_a/s_axis_a_tdata] [get_bd_pins base_2_den_38/c_a] [get_bd_pins crossratio_num_den_8/c_a] [get_bd_pins pixel_distances_11/c_a]
  connect_bd_net -net c_b_m_axis_result_tdata [get_bd_pins crossratio_num_den_8/c_b] [get_bd_pins pixel_distances_11/c_b]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins tap_67_8_28_e_c/Q] [get_bd_pins xa_8/s_axis_a_tdata]
  connect_bd_net -net c_shift_ram_1_Q [get_bd_pins tap_67_8_28_a_c/Q] [get_bd_pins xe_8/s_axis_a_tdata]
  connect_bd_net -net d_1 [get_bd_ports d] [get_bd_pins pixel_distances_11/d]
  connect_bd_net -net d_a_m_axis_result_tdata [get_bd_pins crossratio_num_den_8/d_a] [get_bd_pins pixel_distances_11/d_a]
  connect_bd_net -net d_b_m_axis_result_tdata [get_bd_pins crossratio_num_den_8/d_b] [get_bd_pins pixel_distances_11/d_b]
  connect_bd_net -net d_c_m_axis_result_tdata [get_bd_pins crossratio_num_den_8/d_c] [get_bd_pins pixel_distances_11/d_c]
  connect_bd_net -net e_1 [get_bd_ports e] [get_bd_pins pixel_distances_11/e] [get_bd_pins tap_11_e/D]
  connect_bd_net -net e_b_m_axis_result_tdata [get_bd_pins crossratio_num_den_8/e_b] [get_bd_pins pixel_distances_11/e_b]
  connect_bd_net -net e_c_m_axis_result_tdata [get_bd_pins abs_e_c/s_axis_a_tdata] [get_bd_pins base_2_den_38/e_c] [get_bd_pins crossratio_num_den_8/e_c] [get_bd_pins pixel_distances_11/e_c]
  connect_bd_net -net f_distance_collinear_A_2 [get_bd_ports A_2] [get_bd_pins tap_63_A_2/Q]
  connect_bd_net -net f_distance_collinear_valid_out [get_bd_ports valid_out] [get_bd_pins tap_122/Q]
  connect_bd_net -net f_distance_collinear_xa [get_bd_ports xa] [get_bd_pins xa_8/m_axis_result_tdata]
  connect_bd_net -net f_distance_collinear_xe [get_bd_ports xe] [get_bd_pins xe_8/m_axis_result_tdata]
  connect_bd_net -net n1_n2_n3_2_m_axis_result_tdata [get_bd_pins base_2_den_38/base_2_den] [get_bd_pins reciprocal_29/s_axis_a_tdata]
  connect_bd_net -net reciprocal_29_m_axis_result_tdata [get_bd_pins base_2_8/s_axis_b_tdata] [get_bd_pins reciprocal_29/m_axis_result_tdata]
  connect_bd_net -net row_1 [get_bd_ports row] [get_bd_pins tap_11_row/D]
  connect_bd_net -net tap_11_a_Q [get_bd_pins base_2_den_38/a] [get_bd_pins tap_11_a/Q]
  connect_bd_net -net tap_11_e_Q [get_bd_pins base_2_den_38/e] [get_bd_pins tap_11_e/Q]
  connect_bd_net -net tap_11_row_Q [get_bd_pins base_2_den_38/row] [get_bd_pins tap_11_row/Q]
  connect_bd_net -net valid_in_1 [get_bd_ports valid_in] [get_bd_pins tap_122/D]

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


