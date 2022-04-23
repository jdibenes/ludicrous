
################################################################
# This is a generated script based on design: pxp
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
# source pxp_script.tcl

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
set design_name pxp

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
x38:x38:distance_collinear:1.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:floating_point:7.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:util_vector_logic:2.0\
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


# Hierarchical cell: y3_sign
proc create_hier_cell_y3_sign { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_y3_sign() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 LT
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_mant, and set properties
  set exp_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 exp_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DOUT_WIDTH {31} \
 ] $exp_mant

  # Create instance: sign, and set properties
  set sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign

  # Create instance: sign_flipped_float, and set properties
  set sign_flipped_float [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sign_flipped_float ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {31} \
   CONFIG.IN1_WIDTH {1} \
 ] $sign_flipped_float

  # Create instance: sign_xor, and set properties
  set sign_xor [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sign_xor ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $sign_xor

  # Create port connections
  connect_bd_net -net LT_1 [get_bd_pins LT] [get_bd_pins sign_xor/Op2]
  connect_bd_net -net float_in_1 [get_bd_pins float_in] [get_bd_pins exp_mant/Din] [get_bd_pins sign/Din]
  connect_bd_net -net sign_flipped_float_dout [get_bd_pins float_out] [get_bd_pins sign_flipped_float/dout]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins sign_flipped_float/In1] [get_bd_pins sign_xor/Res]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sign/Dout] [get_bd_pins sign_xor/Op1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins exp_mant/Dout] [get_bd_pins sign_flipped_float/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: y2_sign
proc create_hier_cell_y2_sign { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_y2_sign() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 LT
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_mant, and set properties
  set exp_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 exp_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DOUT_WIDTH {31} \
 ] $exp_mant

  # Create instance: sign, and set properties
  set sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign

  # Create instance: sign_flipped_float, and set properties
  set sign_flipped_float [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sign_flipped_float ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {31} \
   CONFIG.IN1_WIDTH {1} \
 ] $sign_flipped_float

  # Create instance: sign_xor, and set properties
  set sign_xor [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sign_xor ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $sign_xor

  # Create port connections
  connect_bd_net -net LT_1 [get_bd_pins LT] [get_bd_pins sign_xor/Op2]
  connect_bd_net -net float_in_1 [get_bd_pins float_in] [get_bd_pins exp_mant/Din] [get_bd_pins sign/Din]
  connect_bd_net -net sign_flipped_float_dout [get_bd_pins float_out] [get_bd_pins sign_flipped_float/dout]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins sign_flipped_float/In1] [get_bd_pins sign_xor/Res]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sign/Dout] [get_bd_pins sign_xor/Op1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins exp_mant/Dout] [get_bd_pins sign_flipped_float/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: y1_sign
proc create_hier_cell_y1_sign { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_y1_sign() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 LT
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_mant, and set properties
  set exp_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 exp_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DOUT_WIDTH {31} \
 ] $exp_mant

  # Create instance: sign, and set properties
  set sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign

  # Create instance: sign_flipped_float, and set properties
  set sign_flipped_float [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sign_flipped_float ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {31} \
   CONFIG.IN1_WIDTH {1} \
 ] $sign_flipped_float

  # Create instance: sign_xor, and set properties
  set sign_xor [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sign_xor ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $sign_xor

  # Create port connections
  connect_bd_net -net LT_1 [get_bd_pins LT] [get_bd_pins sign_xor/Op2]
  connect_bd_net -net float_in_1 [get_bd_pins float_in] [get_bd_pins exp_mant/Din] [get_bd_pins sign/Din]
  connect_bd_net -net sign_flipped_float_dout [get_bd_pins float_out] [get_bd_pins sign_flipped_float/dout]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins sign_flipped_float/In1] [get_bd_pins sign_xor/Res]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sign/Dout] [get_bd_pins sign_xor/Op1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins exp_mant/Dout] [get_bd_pins sign_flipped_float/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sign_3
proc create_hier_cell_sign_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sign_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 31 -to 0 float_in
  create_bd_pin -dir O -from 31 -to 0 float_out

  # Create instance: exp_mant, and set properties
  set exp_mant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 exp_mant ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DOUT_WIDTH {31} \
 ] $exp_mant

  # Create instance: sign, and set properties
  set sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {31} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create port connections
  connect_bd_net -net exp_mant_Dout [get_bd_pins exp_mant/Dout] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net float_in_1 [get_bd_pins float_in] [get_bd_pins exp_mant/Din] [get_bd_pins sign/Din]
  connect_bd_net -net sign_Dout [get_bd_pins sign/Dout] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins float_out] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sum_3
proc create_hier_cell_sum_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sum_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -from 31 -to 0 sum
  create_bd_pin -dir I -from 31 -to 0 x1
  create_bd_pin -dir I -from 31 -to 0 x2
  create_bd_pin -dir I -from 31 -to 0 x3

  # Create instance: tap_11_x3, and set properties
  set tap_11_x3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_x3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_x3

  # Create instance: x_1_2, and set properties
  set x_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2

  # Create instance: x_1_2_3, and set properties
  set x_1_2_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2_3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins tap_11_x3/CLK] [get_bd_pins x_1_2/aclk] [get_bd_pins x_1_2_3/aclk]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins tap_11_x3/Q] [get_bd_pins x_1_2_3/s_axis_b_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins x_1_2/m_axis_result_tdata] [get_bd_pins x_1_2_3/s_axis_a_tdata]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x_1_2/s_axis_a_tdata]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x_1_2/s_axis_b_tdata]
  connect_bd_net -net x3_1 [get_bd_pins x3] [get_bd_pins tap_11_x3/D]
  connect_bd_net -net x_1_2_3_m_axis_result_tdata [get_bd_pins sum] [get_bd_pins x_1_2_3/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sum_2
proc create_hier_cell_sum_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sum_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -from 31 -to 0 sum
  create_bd_pin -dir I -from 31 -to 0 x1
  create_bd_pin -dir I -from 31 -to 0 x2
  create_bd_pin -dir I -from 31 -to 0 x3

  # Create instance: tap_11_x3, and set properties
  set tap_11_x3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_x3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_x3

  # Create instance: x_1_2, and set properties
  set x_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2

  # Create instance: x_1_2_3, and set properties
  set x_1_2_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2_3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins tap_11_x3/CLK] [get_bd_pins x_1_2/aclk] [get_bd_pins x_1_2_3/aclk]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins tap_11_x3/Q] [get_bd_pins x_1_2_3/s_axis_b_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins x_1_2/m_axis_result_tdata] [get_bd_pins x_1_2_3/s_axis_a_tdata]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x_1_2/s_axis_a_tdata]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x_1_2/s_axis_b_tdata]
  connect_bd_net -net x3_1 [get_bd_pins x3] [get_bd_pins tap_11_x3/D]
  connect_bd_net -net x_1_2_3_m_axis_result_tdata [get_bd_pins sum] [get_bd_pins x_1_2_3/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sum_1
proc create_hier_cell_sum_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sum_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -from 31 -to 0 sum
  create_bd_pin -dir I -from 31 -to 0 x1
  create_bd_pin -dir I -from 31 -to 0 x2
  create_bd_pin -dir I -from 31 -to 0 x3

  # Create instance: tap_11_x3, and set properties
  set tap_11_x3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_x3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_x3

  # Create instance: x_1_2, and set properties
  set x_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2

  # Create instance: x_1_2_3, and set properties
  set x_1_2_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x_1_2_3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x_1_2_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins tap_11_x3/CLK] [get_bd_pins x_1_2/aclk] [get_bd_pins x_1_2_3/aclk]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins tap_11_x3/Q] [get_bd_pins x_1_2_3/s_axis_b_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins x_1_2/m_axis_result_tdata] [get_bd_pins x_1_2_3/s_axis_a_tdata]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x_1_2/s_axis_a_tdata]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x_1_2/s_axis_b_tdata]
  connect_bd_net -net x3_1 [get_bd_pins x3] [get_bd_pins tap_11_x3/D]
  connect_bd_net -net x_1_2_3_m_axis_result_tdata [get_bd_pins sum] [get_bd_pins x_1_2_3/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: y_sign_0
proc create_hier_cell_y_sign_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_y_sign_0() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 LT
  create_bd_pin -dir O -from 31 -to 0 ny1
  create_bd_pin -dir O -from 31 -to 0 ny2
  create_bd_pin -dir O -from 31 -to 0 ny3
  create_bd_pin -dir I -from 31 -to 0 y1
  create_bd_pin -dir I -from 31 -to 0 y2
  create_bd_pin -dir I -from 31 -to 0 y3

  # Create instance: y1_sign
  create_hier_cell_y1_sign $hier_obj y1_sign

  # Create instance: y2_sign
  create_hier_cell_y2_sign $hier_obj y2_sign

  # Create instance: y3_sign
  create_hier_cell_y3_sign $hier_obj y3_sign

  # Create port connections
  connect_bd_net -net pA1_pA2_1_m_axis_result_tdata [get_bd_pins y1] [get_bd_pins y1_sign/float_in]
  connect_bd_net -net pA1_pA2_2_m_axis_result_tdata [get_bd_pins y2] [get_bd_pins y2_sign/float_in]
  connect_bd_net -net pA1_pA2_3_m_axis_result_tdata [get_bd_pins y3] [get_bd_pins y3_sign/float_in]
  connect_bd_net -net tap_17_11_Q [get_bd_pins LT] [get_bd_pins y1_sign/LT] [get_bd_pins y2_sign/LT] [get_bd_pins y3_sign/LT]
  connect_bd_net -net y1_sign_float_out [get_bd_pins ny1] [get_bd_pins y1_sign/float_out]
  connect_bd_net -net y2_sign_float_out [get_bd_pins ny2] [get_bd_pins y2_sign/float_out]
  connect_bd_net -net y3_sign_float_out [get_bd_pins ny3] [get_bd_pins y3_sign/float_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: y_11
proc create_hier_cell_y_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_y_11() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 pA1_1
  create_bd_pin -dir I -from 31 -to 0 pA1_2
  create_bd_pin -dir I -from 31 -to 0 pA1_3
  create_bd_pin -dir I -from 31 -to 0 pA2_1
  create_bd_pin -dir I -from 31 -to 0 pA2_2
  create_bd_pin -dir I -from 31 -to 0 pA2_3
  create_bd_pin -dir O -from 31 -to 0 y1
  create_bd_pin -dir O -from 31 -to 0 y2
  create_bd_pin -dir O -from 31 -to 0 y3

  # Create instance: pA1_pA2_1, and set properties
  set pA1_pA2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pA1_pA2_1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pA1_pA2_1

  # Create instance: pA1_pA2_2, and set properties
  set pA1_pA2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pA1_pA2_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pA1_pA2_2

  # Create instance: pA1_pA2_3, and set properties
  set pA1_pA2_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pA1_pA2_3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pA1_pA2_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins pA1_pA2_1/aclk] [get_bd_pins pA1_pA2_2/aclk] [get_bd_pins pA1_pA2_3/aclk]
  connect_bd_net -net pA1_1_1 [get_bd_pins pA1_1] [get_bd_pins pA1_pA2_1/s_axis_a_tdata]
  connect_bd_net -net pA1_2_1 [get_bd_pins pA1_2] [get_bd_pins pA1_pA2_2/s_axis_a_tdata]
  connect_bd_net -net pA1_3_1 [get_bd_pins pA1_3] [get_bd_pins pA1_pA2_3/s_axis_a_tdata]
  connect_bd_net -net pA1_pA2_1_m_axis_result_tdata [get_bd_pins y1] [get_bd_pins pA1_pA2_1/m_axis_result_tdata]
  connect_bd_net -net pA1_pA2_2_m_axis_result_tdata [get_bd_pins y2] [get_bd_pins pA1_pA2_2/m_axis_result_tdata]
  connect_bd_net -net pA1_pA2_3_m_axis_result_tdata [get_bd_pins y3] [get_bd_pins pA1_pA2_3/m_axis_result_tdata]
  connect_bd_net -net pA2_19_v1 [get_bd_pins pA2_1] [get_bd_pins pA1_pA2_1/s_axis_b_tdata]
  connect_bd_net -net pA2_19_v2 [get_bd_pins pA2_2] [get_bd_pins pA1_pA2_2/s_axis_b_tdata]
  connect_bd_net -net pA2_19_v3 [get_bd_pins pA2_3] [get_bd_pins pA1_pA2_3/s_axis_b_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: xy_11
proc create_hier_cell_xy_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_xy_11() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 pA1_1
  create_bd_pin -dir I -from 31 -to 0 pA1_2
  create_bd_pin -dir I -from 31 -to 0 pA1_3
  create_bd_pin -dir I -from 31 -to 0 pE1_1
  create_bd_pin -dir I -from 31 -to 0 pE1_2
  create_bd_pin -dir I -from 31 -to 0 pE1_3
  create_bd_pin -dir O -from 31 -to 0 xy_1
  create_bd_pin -dir O -from 31 -to 0 xy_2
  create_bd_pin -dir O -from 31 -to 0 xy_3

  # Create instance: pE1_pA1_1, and set properties
  set pE1_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pE1_pA1_1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pE1_pA1_1

  # Create instance: pE1_pA1_2, and set properties
  set pE1_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pE1_pA1_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pE1_pA1_2

  # Create instance: pE1_pA1_3, and set properties
  set pE1_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 pE1_pA1_3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
 ] $pE1_pA1_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins pE1_pA1_1/aclk] [get_bd_pins pE1_pA1_2/aclk] [get_bd_pins pE1_pA1_3/aclk]
  connect_bd_net -net pA1_1_1 [get_bd_pins pA1_1] [get_bd_pins pE1_pA1_1/s_axis_b_tdata]
  connect_bd_net -net pA1_2_1 [get_bd_pins pA1_2] [get_bd_pins pE1_pA1_2/s_axis_b_tdata]
  connect_bd_net -net pA1_3_1 [get_bd_pins pA1_3] [get_bd_pins pE1_pA1_3/s_axis_b_tdata]
  connect_bd_net -net pE1_8_v1 [get_bd_pins pE1_1] [get_bd_pins pE1_pA1_1/s_axis_a_tdata]
  connect_bd_net -net pE1_8_v2 [get_bd_pins pE1_2] [get_bd_pins pE1_pA1_2/s_axis_a_tdata]
  connect_bd_net -net pE1_8_v3 [get_bd_pins pE1_3] [get_bd_pins pE1_pA1_3/s_axis_a_tdata]
  connect_bd_net -net pE1_pA1_1_m_axis_result_tdata [get_bd_pins xy_1] [get_bd_pins pE1_pA1_1/m_axis_result_tdata]
  connect_bd_net -net pE1_pA1_2_m_axis_result_tdata [get_bd_pins xy_2] [get_bd_pins pE1_pA1_2/m_axis_result_tdata]
  connect_bd_net -net pE1_pA1_3_m_axis_result_tdata [get_bd_pins xy_3] [get_bd_pins pE1_pA1_3/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: unit_z_70
proc create_hier_cell_unit_z_70 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_unit_z_70() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 v1
  create_bd_pin -dir O -from 31 -to 0 v1_u
  create_bd_pin -dir I -from 31 -to 0 v2
  create_bd_pin -dir O -from 31 -to 0 v2_u
  create_bd_pin -dir I -from 31 -to 0 v3
  create_bd_pin -dir O -from 31 -to 0 v3_u

  # Create instance: r_sqrt_y, and set properties
  set r_sqrt_y [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r_sqrt_y ]
  set_property -dict [ list \
   CONFIG.C_Latency {32} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Rec_Square_Root} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r_sqrt_y

  # Create instance: tap_11_v3_2, and set properties
  set tap_11_v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_v3_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_v3_2

  # Create instance: tap_8_11_11_32_v1, and set properties
  set tap_8_11_11_32_v1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v1

  # Create instance: tap_8_11_11_32_v2, and set properties
  set tap_8_11_11_32_v2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v2

  # Create instance: tap_8_11_11_32_v3, and set properties
  set tap_8_11_11_32_v3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v3

  # Create instance: v1_2, and set properties
  set v1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1_2

  # Create instance: v1_u, and set properties
  set v1_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1_u

  # Create instance: v1_v2_2, and set properties
  set v1_v2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_v2_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $v1_v2_2

  # Create instance: v1_v2_v3_2, and set properties
  set v1_v2_v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_v2_v3_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $v1_v2_v3_2

  # Create instance: v2_2, and set properties
  set v2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2_2

  # Create instance: v2_u, and set properties
  set v2_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2_u

  # Create instance: v3_2, and set properties
  set v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3_2

  # Create instance: v3_u, and set properties
  set v3_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3_u

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins r_sqrt_y/aclk] [get_bd_pins tap_11_v3_2/CLK] [get_bd_pins tap_8_11_11_32_v1/CLK] [get_bd_pins tap_8_11_11_32_v2/CLK] [get_bd_pins tap_8_11_11_32_v3/CLK] [get_bd_pins v1_2/aclk] [get_bd_pins v1_u/aclk] [get_bd_pins v1_v2_2/aclk] [get_bd_pins v1_v2_v3_2/aclk] [get_bd_pins v2_2/aclk] [get_bd_pins v2_u/aclk] [get_bd_pins v3_2/aclk] [get_bd_pins v3_u/aclk]
  connect_bd_net -net pA1_pA2_1_m_axis_result_tdata [get_bd_pins v1] [get_bd_pins tap_8_11_11_32_v1/D] [get_bd_pins v1_2/s_axis_a_tdata] [get_bd_pins v1_2/s_axis_b_tdata]
  connect_bd_net -net pA1_pA2_2_m_axis_result_tdata [get_bd_pins v2] [get_bd_pins tap_8_11_11_32_v2/D] [get_bd_pins v2_2/s_axis_a_tdata] [get_bd_pins v2_2/s_axis_b_tdata]
  connect_bd_net -net pA1_pA2_3_m_axis_result_tdata [get_bd_pins v3] [get_bd_pins tap_8_11_11_32_v3/D] [get_bd_pins v3_2/s_axis_a_tdata] [get_bd_pins v3_2/s_axis_b_tdata]
  connect_bd_net -net r_sqrt_y_m_axis_result_tdata [get_bd_pins r_sqrt_y/m_axis_result_tdata] [get_bd_pins v1_u/s_axis_b_tdata] [get_bd_pins v2_u/s_axis_b_tdata] [get_bd_pins v3_u/s_axis_b_tdata]
  connect_bd_net -net tap_11_v3_2_Q [get_bd_pins tap_11_v3_2/Q] [get_bd_pins v1_v2_v3_2/s_axis_b_tdata]
  connect_bd_net -net tap_8_11_11_32_Q [get_bd_pins tap_8_11_11_32_v1/Q] [get_bd_pins v1_u/s_axis_a_tdata]
  connect_bd_net -net tap_8_11_11_32_v2_Q [get_bd_pins tap_8_11_11_32_v2/Q] [get_bd_pins v2_u/s_axis_a_tdata]
  connect_bd_net -net tap_8_11_11_32_v3_Q [get_bd_pins tap_8_11_11_32_v3/Q] [get_bd_pins v3_u/s_axis_a_tdata]
  connect_bd_net -net y1_2_m_axis_result_tdata [get_bd_pins v1_2/m_axis_result_tdata] [get_bd_pins v1_v2_2/s_axis_a_tdata]
  connect_bd_net -net y1_u_m_axis_result_tdata [get_bd_pins v1_u] [get_bd_pins v1_u/m_axis_result_tdata]
  connect_bd_net -net y1_y2_2_m_axis_result_tdata [get_bd_pins v1_v2_2/m_axis_result_tdata] [get_bd_pins v1_v2_v3_2/s_axis_a_tdata]
  connect_bd_net -net y1_y2_y3_2_m_axis_result_tdata [get_bd_pins r_sqrt_y/s_axis_a_tdata] [get_bd_pins v1_v2_v3_2/m_axis_result_tdata]
  connect_bd_net -net y2_2_m_axis_result_tdata [get_bd_pins v1_v2_2/s_axis_b_tdata] [get_bd_pins v2_2/m_axis_result_tdata]
  connect_bd_net -net y2_u_m_axis_result_tdata [get_bd_pins v2_u] [get_bd_pins v2_u/m_axis_result_tdata]
  connect_bd_net -net y3_2_m_axis_result_tdata [get_bd_pins tap_11_v3_2/D] [get_bd_pins v3_2/m_axis_result_tdata]
  connect_bd_net -net y3_u_m_axis_result_tdata [get_bd_pins v3_u] [get_bd_pins v3_u/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: unit_y_70
proc create_hier_cell_unit_y_70 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_unit_y_70() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 v1
  create_bd_pin -dir O -from 31 -to 0 v1_u
  create_bd_pin -dir I -from 31 -to 0 v2
  create_bd_pin -dir O -from 31 -to 0 v2_u
  create_bd_pin -dir I -from 31 -to 0 v3
  create_bd_pin -dir O -from 31 -to 0 v3_u

  # Create instance: r_sqrt_y, and set properties
  set r_sqrt_y [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r_sqrt_y ]
  set_property -dict [ list \
   CONFIG.C_Latency {32} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Rec_Square_Root} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r_sqrt_y

  # Create instance: tap_11_v3_2, and set properties
  set tap_11_v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_v3_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_v3_2

  # Create instance: tap_8_11_11_32_v1, and set properties
  set tap_8_11_11_32_v1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v1

  # Create instance: tap_8_11_11_32_v2, and set properties
  set tap_8_11_11_32_v2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v2

  # Create instance: tap_8_11_11_32_v3, and set properties
  set tap_8_11_11_32_v3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_32_v3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {62} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_32_v3

  # Create instance: v1_2, and set properties
  set v1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1_2

  # Create instance: v1_u, and set properties
  set v1_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1_u

  # Create instance: v1_v2_2, and set properties
  set v1_v2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_v2_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $v1_v2_2

  # Create instance: v1_v2_v3_2, and set properties
  set v1_v2_v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_v2_v3_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $v1_v2_v3_2

  # Create instance: v2_2, and set properties
  set v2_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2_2

  # Create instance: v2_u, and set properties
  set v2_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2_u

  # Create instance: v3_2, and set properties
  set v3_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3_2

  # Create instance: v3_u, and set properties
  set v3_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3_u ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3_u

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins r_sqrt_y/aclk] [get_bd_pins tap_11_v3_2/CLK] [get_bd_pins tap_8_11_11_32_v1/CLK] [get_bd_pins tap_8_11_11_32_v2/CLK] [get_bd_pins tap_8_11_11_32_v3/CLK] [get_bd_pins v1_2/aclk] [get_bd_pins v1_u/aclk] [get_bd_pins v1_v2_2/aclk] [get_bd_pins v1_v2_v3_2/aclk] [get_bd_pins v2_2/aclk] [get_bd_pins v2_u/aclk] [get_bd_pins v3_2/aclk] [get_bd_pins v3_u/aclk]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins tap_11_v3_2/Q] [get_bd_pins v1_v2_v3_2/s_axis_b_tdata]
  connect_bd_net -net pA1_pA2_1_m_axis_result_tdata [get_bd_pins v1] [get_bd_pins tap_8_11_11_32_v1/D] [get_bd_pins v1_2/s_axis_a_tdata] [get_bd_pins v1_2/s_axis_b_tdata]
  connect_bd_net -net pA1_pA2_2_m_axis_result_tdata [get_bd_pins v2] [get_bd_pins tap_8_11_11_32_v2/D] [get_bd_pins v2_2/s_axis_a_tdata] [get_bd_pins v2_2/s_axis_b_tdata]
  connect_bd_net -net pA1_pA2_3_m_axis_result_tdata [get_bd_pins v3] [get_bd_pins tap_8_11_11_32_v3/D] [get_bd_pins v3_2/s_axis_a_tdata] [get_bd_pins v3_2/s_axis_b_tdata]
  connect_bd_net -net r_sqrt_y_m_axis_result_tdata [get_bd_pins r_sqrt_y/m_axis_result_tdata] [get_bd_pins v1_u/s_axis_b_tdata] [get_bd_pins v2_u/s_axis_b_tdata] [get_bd_pins v3_u/s_axis_b_tdata]
  connect_bd_net -net tap_8_11_11_32_Q [get_bd_pins tap_8_11_11_32_v1/Q] [get_bd_pins v1_u/s_axis_a_tdata]
  connect_bd_net -net tap_8_11_11_32_v2_Q [get_bd_pins tap_8_11_11_32_v2/Q] [get_bd_pins v2_u/s_axis_a_tdata]
  connect_bd_net -net tap_8_11_11_32_v3_Q [get_bd_pins tap_8_11_11_32_v3/Q] [get_bd_pins v3_u/s_axis_a_tdata]
  connect_bd_net -net v3_2_m_axis_result_tdata [get_bd_pins tap_11_v3_2/D] [get_bd_pins v3_2/m_axis_result_tdata]
  connect_bd_net -net y1_2_m_axis_result_tdata [get_bd_pins v1_2/m_axis_result_tdata] [get_bd_pins v1_v2_2/s_axis_a_tdata]
  connect_bd_net -net y1_u_m_axis_result_tdata [get_bd_pins v1_u] [get_bd_pins v1_u/m_axis_result_tdata]
  connect_bd_net -net y1_y2_2_m_axis_result_tdata [get_bd_pins v1_v2_2/m_axis_result_tdata] [get_bd_pins v1_v2_v3_2/s_axis_a_tdata]
  connect_bd_net -net y1_y2_y3_2_m_axis_result_tdata [get_bd_pins r_sqrt_y/s_axis_a_tdata] [get_bd_pins v1_v2_v3_2/m_axis_result_tdata]
  connect_bd_net -net y2_2_m_axis_result_tdata [get_bd_pins v1_v2_2/s_axis_b_tdata] [get_bd_pins v2_2/m_axis_result_tdata]
  connect_bd_net -net y2_u_m_axis_result_tdata [get_bd_pins v2_u] [get_bd_pins v2_u/m_axis_result_tdata]
  connect_bd_net -net y3_u_m_axis_result_tdata [get_bd_pins v3_u] [get_bd_pins v3_u/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: unit_x_19
proc create_hier_cell_unit_x_19 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_unit_x_19() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -from 31 -to 0 x
  create_bd_pin -dir I -from 31 -to 0 x1
  create_bd_pin -dir I -from 31 -to 0 x2
  create_bd_pin -dir O -from 31 -to 0 y
  create_bd_pin -dir I -from 31 -to 0 y1
  create_bd_pin -dir I -from 31 -to 0 y2
  create_bd_pin -dir O -from 31 -to 0 z
  create_bd_pin -dir I -from 31 -to 0 z1
  create_bd_pin -dir I -from 31 -to 0 z2

  # Create instance: x1y2, and set properties
  set x1y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1y2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x1y2

  # Create instance: x1y2_x2y1, and set properties
  set x1y2_x2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1y2_x2y1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x1y2_x2y1

  # Create instance: x1z2, and set properties
  set x1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1z2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x1z2

  # Create instance: x2y1, and set properties
  set x2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2y1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x2y1

  # Create instance: x2z1, and set properties
  set x2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2z1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x2z1

  # Create instance: x2z1_x1z2, and set properties
  set x2z1_x1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2z1_x1z2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x2z1_x1z2

  # Create instance: y1z2, and set properties
  set y1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y1z2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $y1z2

  # Create instance: y1z2_y2z1, and set properties
  set y1z2_y2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y1z2_y2z1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $y1z2_y2z1

  # Create instance: y2z1, and set properties
  set y2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y2z1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $y2z1

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins x1y2/aclk] [get_bd_pins x1y2_x2y1/aclk] [get_bd_pins x1z2/aclk] [get_bd_pins x2y1/aclk] [get_bd_pins x2z1/aclk] [get_bd_pins x2z1_x1z2/aclk] [get_bd_pins y1z2/aclk] [get_bd_pins y1z2_y2z1/aclk] [get_bd_pins y2z1/aclk]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x1y2/s_axis_a_tdata] [get_bd_pins x1z2/s_axis_a_tdata]
  connect_bd_net -net x1y2_m_axis_result_tdata [get_bd_pins x1y2/m_axis_result_tdata] [get_bd_pins x1y2_x2y1/s_axis_a_tdata]
  connect_bd_net -net x1y2_x2y1_m_axis_result_tdata [get_bd_pins z] [get_bd_pins x1y2_x2y1/m_axis_result_tdata]
  connect_bd_net -net x1z2_m_axis_result_tdata [get_bd_pins x1z2/m_axis_result_tdata] [get_bd_pins x2z1_x1z2/s_axis_b_tdata]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x2y1/s_axis_a_tdata] [get_bd_pins x2z1/s_axis_a_tdata]
  connect_bd_net -net x2y1_m_axis_result_tdata [get_bd_pins x1y2_x2y1/s_axis_b_tdata] [get_bd_pins x2y1/m_axis_result_tdata]
  connect_bd_net -net x2z1_m_axis_result_tdata [get_bd_pins x2z1/m_axis_result_tdata] [get_bd_pins x2z1_x1z2/s_axis_a_tdata]
  connect_bd_net -net x2z1_x1z2_m_axis_result_tdata [get_bd_pins y] [get_bd_pins x2z1_x1z2/m_axis_result_tdata]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins x2y1/s_axis_b_tdata] [get_bd_pins y1z2/s_axis_a_tdata]
  connect_bd_net -net y1z2_m_axis_result_tdata [get_bd_pins y1z2/m_axis_result_tdata] [get_bd_pins y1z2_y2z1/s_axis_a_tdata]
  connect_bd_net -net y1z2_y2z1_m_axis_result_tdata [get_bd_pins x] [get_bd_pins y1z2_y2z1/m_axis_result_tdata]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins x1y2/s_axis_b_tdata] [get_bd_pins y2z1/s_axis_a_tdata]
  connect_bd_net -net y2z1_m_axis_result_tdata [get_bd_pins y1z2_y2z1/s_axis_b_tdata] [get_bd_pins y2z1/m_axis_result_tdata]
  connect_bd_net -net z1_1 [get_bd_pins z1] [get_bd_pins x2z1/s_axis_b_tdata] [get_bd_pins y2z1/s_axis_b_tdata]
  connect_bd_net -net z2_1 [get_bd_pins z2] [get_bd_pins x1z2/s_axis_b_tdata] [get_bd_pins y1z2/s_axis_b_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: t_11
proc create_hier_cell_t_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_t_11() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 31 -to 0 A1_2
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 sum1
  create_bd_pin -dir I -from 31 -to 0 sum2
  create_bd_pin -dir I -from 31 -to 0 sum3
  create_bd_pin -dir O -from 31 -to 0 t_1
  create_bd_pin -dir O -from 31 -to 0 t_2
  create_bd_pin -dir O -from 31 -to 0 -type data t_3

  # Create instance: float_m1, and set properties
  set float_m1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 float_m1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0xBF800000} \
   CONFIG.CONST_WIDTH {32} \
 ] $float_m1

  # Create instance: sign_3
  create_hier_cell_sign_3 $hier_obj sign_3

  # Create instance: t_1, and set properties
  set t_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 t_1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $t_1

  # Create instance: t_2, and set properties
  set t_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 t_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $t_2

  # Create instance: tap_11_t3, and set properties
  set tap_11_t3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_t3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_t3

  # Create port connections
  connect_bd_net -net R_A1_8_sum [get_bd_pins sum1] [get_bd_pins t_1/s_axis_b_tdata]
  connect_bd_net -net R_A1_8_sum1 [get_bd_pins sum2] [get_bd_pins t_2/s_axis_b_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins t_1/aclk] [get_bd_pins t_2/aclk] [get_bd_pins tap_11_t3/CLK]
  connect_bd_net -net c_shift_ram_0_Q1 [get_bd_pins t_3] [get_bd_pins tap_11_t3/Q]
  connect_bd_net -net f32_m1_dout [get_bd_pins float_m1/dout] [get_bd_pins t_1/s_axis_a_tdata]
  connect_bd_net -net float_in_1 [get_bd_pins sum3] [get_bd_pins sign_3/float_in]
  connect_bd_net -net t_t_1 [get_bd_pins t_1] [get_bd_pins t_1/m_axis_result_tdata]
  connect_bd_net -net t_t_2 [get_bd_pins t_2] [get_bd_pins t_2/m_axis_result_tdata]
  connect_bd_net -net t_t_3 [get_bd_pins sign_3/float_out] [get_bd_pins tap_11_t3/D]
  connect_bd_net -net tap_8_11_11_19_70_19_30_Q [get_bd_pins A1_2] [get_bd_pins t_2/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pE1_8
proc create_hier_cell_pE1_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pE1_8() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 31 -to 0 row
  create_bd_pin -dir I -from 31 -to 0 u
  create_bd_pin -dir O -from 31 -to 0 v1
  create_bd_pin -dir O -from 31 -to 0 v2
  create_bd_pin -dir O -from 31 -to 0 v3
  create_bd_pin -dir I -from 31 -to 0 x

  # Create instance: tap_8_x, and set properties
  set tap_8_x [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_x ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {8} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_x

  # Create instance: v1, and set properties
  set v1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1

  # Create instance: v2, and set properties
  set v2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins tap_8_x/CLK] [get_bd_pins v1/aclk] [get_bd_pins v2/aclk]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins v1] [get_bd_pins v1/m_axis_result_tdata]
  connect_bd_net -net row_1 [get_bd_pins row] [get_bd_pins v2/s_axis_b_tdata]
  connect_bd_net -net tap_8_x_Q [get_bd_pins v3] [get_bd_pins tap_8_x/Q]
  connect_bd_net -net u_1 [get_bd_pins u] [get_bd_pins v1/s_axis_b_tdata]
  connect_bd_net -net v2_m_axis_result_tdata [get_bd_pins v2] [get_bd_pins v2/m_axis_result_tdata]
  connect_bd_net -net x_1 [get_bd_pins x] [get_bd_pins tap_8_x/D] [get_bd_pins v1/s_axis_a_tdata] [get_bd_pins v2/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pA2_19
proc create_hier_cell_pA2_19 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pA2_19() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 31 -to 0 row
  create_bd_pin -dir I -from 31 -to 0 t2_1
  create_bd_pin -dir I -from 31 -to 0 t2_2
  create_bd_pin -dir I -from 31 -to 0 t2_3
  create_bd_pin -dir I -from 31 -to 0 u
  create_bd_pin -dir O -from 31 -to 0 v1
  create_bd_pin -dir O -from 31 -to 0 v2
  create_bd_pin -dir O -from 31 -to 0 v3
  create_bd_pin -dir I -from 31 -to 0 w
  create_bd_pin -dir I -from 31 -to 0 x

  # Create instance: v1, and set properties
  set v1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1

  # Create instance: v1_t2, and set properties
  set v1_t2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1_t2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1_t2

  # Create instance: v2, and set properties
  set v2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2

  # Create instance: v2_t2, and set properties
  set v2_t2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2_t2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2_t2

  # Create instance: v3, and set properties
  set v3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3

  # Create instance: v3_t2, and set properties
  set v3_t2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v3_t2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Add_Subtract} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v3_t2

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins v1/aclk] [get_bd_pins v1_t2/aclk] [get_bd_pins v2/aclk] [get_bd_pins v2_t2/aclk] [get_bd_pins v3/aclk] [get_bd_pins v3_t2/aclk]
  connect_bd_net -net row_1 [get_bd_pins row] [get_bd_pins v2/s_axis_b_tdata]
  connect_bd_net -net t2_1_1 [get_bd_pins t2_1] [get_bd_pins v1_t2/s_axis_b_tdata]
  connect_bd_net -net t2_2_1 [get_bd_pins t2_2] [get_bd_pins v2_t2/s_axis_b_tdata]
  connect_bd_net -net t2_3_1 [get_bd_pins t2_3] [get_bd_pins v3_t2/s_axis_b_tdata]
  connect_bd_net -net u_1 [get_bd_pins u] [get_bd_pins v1/s_axis_b_tdata]
  connect_bd_net -net v1_m_axis_result_tdata [get_bd_pins v1/m_axis_result_tdata] [get_bd_pins v1_t2/s_axis_a_tdata]
  connect_bd_net -net v1_t2_m_axis_result_tdata [get_bd_pins v1] [get_bd_pins v1_t2/m_axis_result_tdata]
  connect_bd_net -net v2_m_axis_result_tdata [get_bd_pins v2/m_axis_result_tdata] [get_bd_pins v2_t2/s_axis_a_tdata]
  connect_bd_net -net v2_t2_m_axis_result_tdata [get_bd_pins v2] [get_bd_pins v2_t2/m_axis_result_tdata]
  connect_bd_net -net v3_m_axis_result_tdata [get_bd_pins v3/m_axis_result_tdata] [get_bd_pins v3_t2/s_axis_a_tdata]
  connect_bd_net -net v3_t2_m_axis_result_tdata [get_bd_pins v3] [get_bd_pins v3_t2/m_axis_result_tdata]
  connect_bd_net -net w_1 [get_bd_pins w] [get_bd_pins v3/s_axis_b_tdata]
  connect_bd_net -net x_1 [get_bd_pins x] [get_bd_pins v1/s_axis_a_tdata] [get_bd_pins v2/s_axis_a_tdata] [get_bd_pins v3/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pA1_8
proc create_hier_cell_pA1_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pA1_8() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 31 -to 0 row
  create_bd_pin -dir I -from 31 -to 0 u
  create_bd_pin -dir O -from 31 -to 0 v1
  create_bd_pin -dir O -from 31 -to 0 v2
  create_bd_pin -dir O -from 31 -to 0 v3
  create_bd_pin -dir I -from 31 -to 0 x

  # Create instance: tap_8_x, and set properties
  set tap_8_x [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_x ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {8} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_x

  # Create instance: v1, and set properties
  set v1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v1

  # Create instance: v2, and set properties
  set v2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 v2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $v2

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins tap_8_x/CLK] [get_bd_pins v1/aclk] [get_bd_pins v2/aclk]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins v3] [get_bd_pins tap_8_x/Q]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_pins v1] [get_bd_pins v1/m_axis_result_tdata]
  connect_bd_net -net row_1 [get_bd_pins row] [get_bd_pins v2/s_axis_b_tdata]
  connect_bd_net -net u_1 [get_bd_pins u] [get_bd_pins v1/s_axis_b_tdata]
  connect_bd_net -net v2_m_axis_result_tdata [get_bd_pins v2] [get_bd_pins v2/m_axis_result_tdata]
  connect_bd_net -net x_1 [get_bd_pins x] [get_bd_pins tap_8_x/D] [get_bd_pins v1/s_axis_a_tdata] [get_bd_pins v2/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cross_xy_y_19
proc create_hier_cell_cross_xy_y_19 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cross_xy_y_19() - Empty argument(s)!"}
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
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -from 31 -to 0 x
  create_bd_pin -dir I -from 31 -to 0 x1
  create_bd_pin -dir I -from 31 -to 0 x2
  create_bd_pin -dir O -from 31 -to 0 y
  create_bd_pin -dir I -from 31 -to 0 y1
  create_bd_pin -dir I -from 31 -to 0 y2
  create_bd_pin -dir O -from 31 -to 0 z
  create_bd_pin -dir I -from 31 -to 0 z1
  create_bd_pin -dir I -from 31 -to 0 z2

  # Create instance: x1y2, and set properties
  set x1y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1y2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x1y2

  # Create instance: x1y2_x2y1, and set properties
  set x1y2_x2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1y2_x2y1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x1y2_x2y1

  # Create instance: x1z2, and set properties
  set x1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x1z2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x1z2

  # Create instance: x2y1, and set properties
  set x2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2y1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x2y1

  # Create instance: x2z1, and set properties
  set x2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2z1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $x2z1

  # Create instance: x2z1_x1z2, and set properties
  set x2z1_x1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 x2z1_x1z2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $x2z1_x1z2

  # Create instance: y1z2, and set properties
  set y1z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y1z2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $y1z2

  # Create instance: y1z2_y2z1, and set properties
  set y1z2_y2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y1z2_y2z1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $y1z2_y2z1

  # Create instance: y2z1, and set properties
  set y2z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 y2z1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $y2z1

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins x1y2/aclk] [get_bd_pins x1y2_x2y1/aclk] [get_bd_pins x1z2/aclk] [get_bd_pins x2y1/aclk] [get_bd_pins x2z1/aclk] [get_bd_pins x2z1_x1z2/aclk] [get_bd_pins y1z2/aclk] [get_bd_pins y1z2_y2z1/aclk] [get_bd_pins y2z1/aclk]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x1y2/s_axis_a_tdata] [get_bd_pins x1z2/s_axis_a_tdata]
  connect_bd_net -net x1y2_m_axis_result_tdata [get_bd_pins x1y2/m_axis_result_tdata] [get_bd_pins x1y2_x2y1/s_axis_a_tdata]
  connect_bd_net -net x1y2_x2y1_m_axis_result_tdata [get_bd_pins z] [get_bd_pins x1y2_x2y1/m_axis_result_tdata]
  connect_bd_net -net x1z2_m_axis_result_tdata [get_bd_pins x1z2/m_axis_result_tdata] [get_bd_pins x2z1_x1z2/s_axis_b_tdata]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x2y1/s_axis_a_tdata] [get_bd_pins x2z1/s_axis_a_tdata]
  connect_bd_net -net x2y1_m_axis_result_tdata [get_bd_pins x1y2_x2y1/s_axis_b_tdata] [get_bd_pins x2y1/m_axis_result_tdata]
  connect_bd_net -net x2z1_m_axis_result_tdata [get_bd_pins x2z1/m_axis_result_tdata] [get_bd_pins x2z1_x1z2/s_axis_a_tdata]
  connect_bd_net -net x2z1_x1z2_m_axis_result_tdata [get_bd_pins y] [get_bd_pins x2z1_x1z2/m_axis_result_tdata]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins x2y1/s_axis_b_tdata] [get_bd_pins y1z2/s_axis_a_tdata]
  connect_bd_net -net y1z2_m_axis_result_tdata [get_bd_pins y1z2/m_axis_result_tdata] [get_bd_pins y1z2_y2z1/s_axis_a_tdata]
  connect_bd_net -net y1z2_y2z1_m_axis_result_tdata [get_bd_pins x] [get_bd_pins y1z2_y2z1/m_axis_result_tdata]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins x1y2/s_axis_b_tdata] [get_bd_pins y2z1/s_axis_a_tdata]
  connect_bd_net -net y2z1_m_axis_result_tdata [get_bd_pins y1z2_y2z1/s_axis_b_tdata] [get_bd_pins y2z1/m_axis_result_tdata]
  connect_bd_net -net z1_1 [get_bd_pins z1] [get_bd_pins x2z1/s_axis_b_tdata] [get_bd_pins y2z1/s_axis_b_tdata]
  connect_bd_net -net z2_1 [get_bd_pins z2] [get_bd_pins x1z2/s_axis_b_tdata] [get_bd_pins y1z2/s_axis_b_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: R_A1_30
proc create_hier_cell_R_A1_30 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_R_A1_30() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 31 -to 0 R_11
  create_bd_pin -dir I -from 31 -to 0 R_12
  create_bd_pin -dir I -from 31 -to 0 R_13
  create_bd_pin -dir I -from 31 -to 0 R_21
  create_bd_pin -dir I -from 31 -to 0 R_22
  create_bd_pin -dir I -from 31 -to 0 R_23
  create_bd_pin -dir I -from 31 -to 0 R_31
  create_bd_pin -dir I -from 31 -to 0 R_32
  create_bd_pin -dir I -from 31 -to 0 R_33
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 31 -to 0 pA1_1
  create_bd_pin -dir I -from 31 -to 0 pA1_2
  create_bd_pin -dir I -from 31 -to 0 pA1_3
  create_bd_pin -dir O -from 31 -to 0 sum1
  create_bd_pin -dir O -from 31 -to 0 sum2
  create_bd_pin -dir O -from 31 -to 0 sum3

  # Create instance: r11_pA1_1, and set properties
  set r11_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r11_pA1_1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r11_pA1_1

  # Create instance: r12_pA1_2, and set properties
  set r12_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r12_pA1_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r12_pA1_2

  # Create instance: r13_pA1_3, and set properties
  set r13_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r13_pA1_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r13_pA1_3

  # Create instance: r21_pA1_1, and set properties
  set r21_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r21_pA1_1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r21_pA1_1

  # Create instance: r22_pA1_2, and set properties
  set r22_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r22_pA1_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r22_pA1_2

  # Create instance: r23_pA1_3, and set properties
  set r23_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r23_pA1_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r23_pA1_3

  # Create instance: r31_pA1_1, and set properties
  set r31_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r31_pA1_1 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r31_pA1_1

  # Create instance: r32_pA1_2, and set properties
  set r32_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r32_pA1_2 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r32_pA1_2

  # Create instance: r33_pA1_3, and set properties
  set r33_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r33_pA1_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $r33_pA1_3

  # Create instance: sum_1
  create_hier_cell_sum_1 $hier_obj sum_1

  # Create instance: sum_2
  create_hier_cell_sum_2 $hier_obj sum_2

  # Create instance: sum_3
  create_hier_cell_sum_3 $hier_obj sum_3

  # Create port connections
  connect_bd_net -net R_11_1 [get_bd_pins R_11] [get_bd_pins r11_pA1_1/s_axis_a_tdata]
  connect_bd_net -net R_12_1 [get_bd_pins R_12] [get_bd_pins r12_pA1_2/s_axis_a_tdata]
  connect_bd_net -net R_13_1 [get_bd_pins R_13] [get_bd_pins r13_pA1_3/s_axis_a_tdata]
  connect_bd_net -net R_31_1 [get_bd_pins R_31] [get_bd_pins r31_pA1_1/s_axis_a_tdata]
  connect_bd_net -net R_32_1 [get_bd_pins R_32] [get_bd_pins r32_pA1_2/s_axis_a_tdata]
  connect_bd_net -net R_33_1 [get_bd_pins R_33] [get_bd_pins r33_pA1_3/s_axis_a_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins r11_pA1_1/aclk] [get_bd_pins r12_pA1_2/aclk] [get_bd_pins r13_pA1_3/aclk] [get_bd_pins r21_pA1_1/aclk] [get_bd_pins r22_pA1_2/aclk] [get_bd_pins r23_pA1_3/aclk] [get_bd_pins r31_pA1_1/aclk] [get_bd_pins r32_pA1_2/aclk] [get_bd_pins r33_pA1_3/aclk] [get_bd_pins sum_1/aclk] [get_bd_pins sum_2/aclk] [get_bd_pins sum_3/aclk]
  connect_bd_net -net r11_pA1_1_m_axis_result_tdata [get_bd_pins r11_pA1_1/m_axis_result_tdata] [get_bd_pins sum_1/x1]
  connect_bd_net -net r12_pA1_2_m_axis_result_tdata [get_bd_pins r12_pA1_2/m_axis_result_tdata] [get_bd_pins sum_1/x2]
  connect_bd_net -net r13_pA1_3_m_axis_result_tdata [get_bd_pins r13_pA1_3/m_axis_result_tdata] [get_bd_pins sum_1/x3]
  connect_bd_net -net r21_pA1_1_m_axis_result_tdata [get_bd_pins r21_pA1_1/m_axis_result_tdata] [get_bd_pins sum_2/x1]
  connect_bd_net -net r22_pA1_2_m_axis_result_tdata [get_bd_pins r22_pA1_2/m_axis_result_tdata] [get_bd_pins sum_2/x2]
  connect_bd_net -net r23_pA1_3_m_axis_result_tdata [get_bd_pins r23_pA1_3/m_axis_result_tdata] [get_bd_pins sum_2/x3]
  connect_bd_net -net r31_pA1_1_m_axis_result_tdata [get_bd_pins r31_pA1_1/m_axis_result_tdata] [get_bd_pins sum_3/x1]
  connect_bd_net -net r32_pA1_2_m_axis_result_tdata [get_bd_pins r32_pA1_2/m_axis_result_tdata] [get_bd_pins sum_3/x2]
  connect_bd_net -net r33_pA1_3_m_axis_result_tdata [get_bd_pins r33_pA1_3/m_axis_result_tdata] [get_bd_pins sum_3/x3]
  connect_bd_net -net sum_1_sum [get_bd_pins sum1] [get_bd_pins sum_1/sum]
  connect_bd_net -net sum_2_sum [get_bd_pins sum2] [get_bd_pins sum_2/sum]
  connect_bd_net -net sum_3_sum [get_bd_pins sum3] [get_bd_pins sum_3/sum]
  connect_bd_net -net tap_11_19_70_19_Q [get_bd_pins pA1_1] [get_bd_pins r11_pA1_1/s_axis_b_tdata] [get_bd_pins r21_pA1_1/s_axis_b_tdata] [get_bd_pins r31_pA1_1/s_axis_b_tdata]
  connect_bd_net -net tap_11_19_70_19_pA1_2_Q [get_bd_pins pA1_2] [get_bd_pins r12_pA1_2/s_axis_b_tdata] [get_bd_pins r22_pA1_2/s_axis_b_tdata] [get_bd_pins r32_pA1_2/s_axis_b_tdata]
  connect_bd_net -net tap_11_19_70_19_pA1_3_Q [get_bd_pins pA1_3] [get_bd_pins r13_pA1_3/s_axis_b_tdata] [get_bd_pins r23_pA1_3/s_axis_b_tdata] [get_bd_pins r33_pA1_3/s_axis_b_tdata]
  connect_bd_net -net tap_19_y1_Q [get_bd_pins R_21] [get_bd_pins r21_pA1_1/s_axis_a_tdata]
  connect_bd_net -net unit_y_v2_u [get_bd_pins R_22] [get_bd_pins r22_pA1_2/s_axis_a_tdata]
  connect_bd_net -net unit_y_v3_u [get_bd_pins R_23] [get_bd_pins r23_pA1_3/s_axis_a_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: R2_A2_30
proc create_hier_cell_R2_A2_30 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_R2_A2_30() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 31 -to 0 R2_1
  create_bd_pin -dir I -from 31 -to 0 R2_11
  create_bd_pin -dir I -from 31 -to 0 R2_12
  create_bd_pin -dir I -from 31 -to 0 R2_13
  create_bd_pin -dir I -from 31 -to 0 R2_21
  create_bd_pin -dir I -from 31 -to 0 R2_22
  create_bd_pin -dir I -from 31 -to 0 R2_23
  create_bd_pin -dir I -from 31 -to 0 R2_31
  create_bd_pin -dir I -from 31 -to 0 R2_32
  create_bd_pin -dir I -from 31 -to 0 R2_33
  create_bd_pin -dir O -from 31 -to 0 R2_a2
  create_bd_pin -dir O -from 31 -to 0 R2_row2
  create_bd_pin -dir I -from 31 -to 0 a2
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 31 -to 0 row2

  # Create instance: R2_a2, and set properties
  set R2_a2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R2_a2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $R2_a2

  # Create instance: R2_row2, and set properties
  set R2_row2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R2_row2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $R2_row2

  # Create instance: R2_row3, and set properties
  set R2_row3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 R2_row3 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $R2_row3

  # Create instance: a2_r11, and set properties
  set a2_r11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r11 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $a2_r11

  # Create instance: a2_r11_row2_r12, and set properties
  set a2_r11_row2_r12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r11_row2_r12 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $a2_r11_row2_r12

  # Create instance: a2_r21, and set properties
  set a2_r21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r21 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $a2_r21

  # Create instance: a2_r21_row2_r22, and set properties
  set a2_r21_row2_r22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r21_row2_r22 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $a2_r21_row2_r22

  # Create instance: a2_r31, and set properties
  set a2_r31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r31 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $a2_r31

  # Create instance: a2_r31_row2_r32, and set properties
  set a2_r31_row2_r32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 a2_r31_row2_r32 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {11} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
 ] $a2_r31_row2_r32

  # Create instance: row2_r12, and set properties
  set row2_r12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 row2_r12 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $row2_r12

  # Create instance: row2_r22, and set properties
  set row2_r22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 row2_r22 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $row2_r22

  # Create instance: row2_r32, and set properties
  set row2_r32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 row2_r32 ]
  set_property -dict [ list \
   CONFIG.C_Latency {8} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $row2_r32

  # Create port connections
  connect_bd_net -net R2_12_1 [get_bd_pins R2_12] [get_bd_pins row2_r12/s_axis_a_tdata]
  connect_bd_net -net R2_13_1 [get_bd_pins R2_13] [get_bd_pins R2_a2/s_axis_b_tdata]
  connect_bd_net -net R2_1_1_1 [get_bd_pins R2_11] [get_bd_pins a2_r11/s_axis_a_tdata]
  connect_bd_net -net R2_21_1 [get_bd_pins R2_21] [get_bd_pins a2_r21/s_axis_a_tdata]
  connect_bd_net -net R2_23_1 [get_bd_pins R2_23] [get_bd_pins R2_row2/s_axis_b_tdata]
  connect_bd_net -net R2_31_1 [get_bd_pins R2_31] [get_bd_pins a2_r31/s_axis_a_tdata]
  connect_bd_net -net R2_32_1 [get_bd_pins R2_32] [get_bd_pins row2_r32/s_axis_a_tdata]
  connect_bd_net -net R2_33_1 [get_bd_pins R2_33] [get_bd_pins R2_row3/s_axis_b_tdata]
  connect_bd_net -net R2_a2_m_axis_result_tdata [get_bd_pins R2_a2] [get_bd_pins R2_a2/m_axis_result_tdata]
  connect_bd_net -net R2_row2_m_axis_result_tdata [get_bd_pins R2_row2] [get_bd_pins R2_row2/m_axis_result_tdata]
  connect_bd_net -net R2_row3_m_axis_result_tdata [get_bd_pins R2_1] [get_bd_pins R2_row3/m_axis_result_tdata]
  connect_bd_net -net a2_1 [get_bd_pins a2] [get_bd_pins a2_r11/s_axis_b_tdata] [get_bd_pins a2_r21/s_axis_b_tdata] [get_bd_pins a2_r31/s_axis_b_tdata]
  connect_bd_net -net a2_r11_m_axis_result_tdata [get_bd_pins a2_r11/m_axis_result_tdata] [get_bd_pins a2_r11_row2_r12/s_axis_a_tdata]
  connect_bd_net -net a2_r11_row2_r12_m_axis_result_tdata [get_bd_pins R2_a2/s_axis_a_tdata] [get_bd_pins a2_r11_row2_r12/m_axis_result_tdata]
  connect_bd_net -net a2_r21_m_axis_result_tdata [get_bd_pins a2_r21/m_axis_result_tdata] [get_bd_pins a2_r21_row2_r22/s_axis_a_tdata]
  connect_bd_net -net a2_r21_row2_r22_m_axis_result_tdata [get_bd_pins R2_row2/s_axis_a_tdata] [get_bd_pins a2_r21_row2_r22/m_axis_result_tdata]
  connect_bd_net -net a2_r31_m_axis_result_tdata [get_bd_pins a2_r31/m_axis_result_tdata] [get_bd_pins a2_r31_row2_r32/s_axis_a_tdata]
  connect_bd_net -net a2_r31_row2_r32_m_axis_result_tdata [get_bd_pins R2_row3/s_axis_a_tdata] [get_bd_pins a2_r31_row2_r32/m_axis_result_tdata]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins R2_a2/aclk] [get_bd_pins R2_row2/aclk] [get_bd_pins R2_row3/aclk] [get_bd_pins a2_r11/aclk] [get_bd_pins a2_r11_row2_r12/aclk] [get_bd_pins a2_r21/aclk] [get_bd_pins a2_r21_row2_r22/aclk] [get_bd_pins a2_r31/aclk] [get_bd_pins a2_r31_row2_r32/aclk] [get_bd_pins row2_r12/aclk] [get_bd_pins row2_r22/aclk] [get_bd_pins row2_r32/aclk]
  connect_bd_net -net row2_1 [get_bd_pins row2] [get_bd_pins row2_r12/s_axis_b_tdata] [get_bd_pins row2_r22/s_axis_b_tdata] [get_bd_pins row2_r32/s_axis_b_tdata]
  connect_bd_net -net row2_r12_m_axis_result_tdata [get_bd_pins a2_r11_row2_r12/s_axis_b_tdata] [get_bd_pins row2_r12/m_axis_result_tdata]
  connect_bd_net -net row2_r22_1 [get_bd_pins R2_22] [get_bd_pins row2_r22/s_axis_a_tdata]
  connect_bd_net -net row2_r22_m_axis_result_tdata [get_bd_pins a2_r21_row2_r22/s_axis_b_tdata] [get_bd_pins row2_r22/m_axis_result_tdata]
  connect_bd_net -net row2_r32_m_axis_result_tdata [get_bd_pins a2_r31_row2_r32/s_axis_b_tdata] [get_bd_pins row2_r32/m_axis_result_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: A1_A2_sign_2
proc create_hier_cell_A1_A2_sign_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_A1_A2_sign_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 31 -to 0 A1_2
  create_bd_pin -dir I -from 31 -to 0 A2_2
  create_bd_pin -dir O -from 0 -to 0 LT
  create_bd_pin -dir I -type clk aclk

  # Create instance: A1_A2_sign, and set properties
  set A1_A2_sign [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 A1_A2_sign ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_Compare_Operation {Less_Than} \
   CONFIG.C_Latency {2} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {1} \
   CONFIG.C_Result_Fraction_Width {0} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {true} \
   CONFIG.Operation_Type {Compare} \
   CONFIG.Result_Precision_Type {Custom} \
 ] $A1_A2_sign

  # Create instance: LT, and set properties
  set LT [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 LT ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $LT

  # Create port connections
  connect_bd_net -net A1_2_1 [get_bd_pins A1_2] [get_bd_pins A1_A2_sign/s_axis_a_tdata]
  connect_bd_net -net A1_A2_sign_2_m_axis_result_tdata [get_bd_pins A1_A2_sign/m_axis_result_tdata] [get_bd_pins LT/Din]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins A1_A2_sign/aclk]
  connect_bd_net -net distance_collinear_1_122_A_2 [get_bd_pins A2_2] [get_bd_pins A1_A2_sign/s_axis_b_tdata]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins LT] [get_bd_pins LT/Dout]

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
  set R2_11 [ create_bd_port -dir I -from 31 -to 0 R2_11 ]
  set R2_12 [ create_bd_port -dir I -from 31 -to 0 R2_12 ]
  set R2_13 [ create_bd_port -dir I -from 31 -to 0 R2_13 ]
  set R2_21 [ create_bd_port -dir I -from 31 -to 0 R2_21 ]
  set R2_22 [ create_bd_port -dir I -from 31 -to 0 R2_22 ]
  set R2_23 [ create_bd_port -dir I -from 31 -to 0 R2_23 ]
  set R2_31 [ create_bd_port -dir I -from 31 -to 0 R2_31 ]
  set R2_32 [ create_bd_port -dir I -from 31 -to 0 R2_32 ]
  set R2_33 [ create_bd_port -dir I -from 31 -to 0 R2_33 ]
  set R_11 [ create_bd_port -dir O -from 31 -to 0 R_11 ]
  set R_12 [ create_bd_port -dir O -from 31 -to 0 R_12 ]
  set R_13 [ create_bd_port -dir O -from 31 -to 0 R_13 ]
  set R_21 [ create_bd_port -dir O -from 31 -to 0 R_21 ]
  set R_22 [ create_bd_port -dir O -from 31 -to 0 R_22 ]
  set R_23 [ create_bd_port -dir O -from 31 -to 0 R_23 ]
  set R_31 [ create_bd_port -dir O -from 31 -to 0 R_31 ]
  set R_32 [ create_bd_port -dir O -from 31 -to 0 R_32 ]
  set R_33 [ create_bd_port -dir O -from 31 -to 0 R_33 ]
  set a1 [ create_bd_port -dir I -from 31 -to 0 a1 ]
  set a2 [ create_bd_port -dir I -from 31 -to 0 a2 ]
  set aclk [ create_bd_port -dir I -type clk aclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $aclk
  set b1 [ create_bd_port -dir I -from 31 -to 0 b1 ]
  set b2 [ create_bd_port -dir I -from 31 -to 0 b2 ]
  set c1 [ create_bd_port -dir I -from 31 -to 0 c1 ]
  set c2 [ create_bd_port -dir I -from 31 -to 0 c2 ]
  set d1 [ create_bd_port -dir I -from 31 -to 0 d1 ]
  set d2 [ create_bd_port -dir I -from 31 -to 0 d2 ]
  set e1 [ create_bd_port -dir I -from 31 -to 0 e1 ]
  set e2 [ create_bd_port -dir I -from 31 -to 0 e2 ]
  set row1 [ create_bd_port -dir I -from 31 -to 0 row1 ]
  set row2 [ create_bd_port -dir I -from 31 -to 0 row2 ]
  set t2_1 [ create_bd_port -dir I -from 31 -to 0 t2_1 ]
  set t2_2 [ create_bd_port -dir I -from 31 -to 0 t2_2 ]
  set t2_3 [ create_bd_port -dir I -from 31 -to 0 t2_3 ]
  set t_1 [ create_bd_port -dir O -from 31 -to 0 t_1 ]
  set t_2 [ create_bd_port -dir O -from 31 -to 0 t_2 ]
  set t_3 [ create_bd_port -dir O -from 31 -to 0 t_3 ]
  set valid_in [ create_bd_port -dir I valid_in ]
  set valid_out [ create_bd_port -dir O -from 0 -to 0 -type data valid_out ]

  # Create instance: A1_A2_sign_2
  create_hier_cell_A1_A2_sign_2 [current_bd_instance .] A1_A2_sign_2

  # Create instance: R2_A2_30
  create_hier_cell_R2_A2_30 [current_bd_instance .] R2_A2_30

  # Create instance: R_A1_30
  create_hier_cell_R_A1_30 [current_bd_instance .] R_A1_30

  # Create instance: cross_xy_y_19
  create_hier_cell_cross_xy_y_19 [current_bd_instance .] cross_xy_y_19

  # Create instance: distance_collinear_0_122, and set properties
  set distance_collinear_0_122 [ create_bd_cell -type ip -vlnv x38:x38:distance_collinear:1.0 distance_collinear_0_122 ]

  # Create instance: distance_collinear_1_122, and set properties
  set distance_collinear_1_122 [ create_bd_cell -type ip -vlnv x38:x38:distance_collinear:1.0 distance_collinear_1_122 ]

  # Create instance: pA1_8
  create_hier_cell_pA1_8 [current_bd_instance .] pA1_8

  # Create instance: pA2_19
  create_hier_cell_pA2_19 [current_bd_instance .] pA2_19

  # Create instance: pE1_8
  create_hier_cell_pE1_8 [current_bd_instance .] pE1_8

  # Create instance: t_11
  create_hier_cell_t_11 [current_bd_instance .] t_11

  # Create instance: tap2_19_y1, and set properties
  set tap2_19_y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_y1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_y1

  # Create instance: tap2_19_y2, and set properties
  set tap2_19_y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_y2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_y2

  # Create instance: tap2_19_y3, and set properties
  set tap2_19_y3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_y3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_y3

  # Create instance: tap2_19_z1, and set properties
  set tap2_19_z1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_z1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_z1

  # Create instance: tap2_19_z2, and set properties
  set tap2_19_z2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_z2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_z2

  # Create instance: tap2_19_z3, and set properties
  set tap2_19_z3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap2_19_z3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap2_19_z3

  # Create instance: tap_11_19_70_19_pA1_1, and set properties
  set tap_11_19_70_19_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_19_70_19_pA1_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {119} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_19_70_19_pA1_1

  # Create instance: tap_11_19_70_19_pA1_2, and set properties
  set tap_11_19_70_19_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_19_70_19_pA1_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {119} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_19_70_19_pA1_2

  # Create instance: tap_11_19_70_19_pA1_3, and set properties
  set tap_11_19_70_19_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_19_70_19_pA1_3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {119} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_19_70_19_pA1_3

  # Create instance: tap_11_pA1_1, and set properties
  set tap_11_pA1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_pA1_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_pA1_1

  # Create instance: tap_11_pA1_2, and set properties
  set tap_11_pA1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_pA1_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_pA1_2

  # Create instance: tap_11_pA1_3, and set properties
  set tap_11_pA1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_pA1_3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_pA1_3

  # Create instance: tap_11_xy_1, and set properties
  set tap_11_xy_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_xy_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_xy_1

  # Create instance: tap_11_xy_2, and set properties
  set tap_11_xy_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_xy_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_xy_2

  # Create instance: tap_11_xy_3, and set properties
  set tap_11_xy_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_11_xy_3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {11} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_11_xy_3

  # Create instance: tap_122_19_11_89_19_41_valid, and set properties
  set tap_122_19_11_89_19_41_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_122_19_11_89_19_41_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {301} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_122_19_11_89_19_41_valid

  # Create instance: tap_122_a1, and set properties
  set tap_122_a1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_122_a1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {122} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_122_a1

  # Create instance: tap_122_e1, and set properties
  set tap_122_e1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_122_e1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {122} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_122_e1

  # Create instance: tap_122_row1, and set properties
  set tap_122_row1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_122_row1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {122} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_122_row1

  # Create instance: tap_17_11_LT, and set properties
  set tap_17_11_LT [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_17_11_LT ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {28} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_17_11_LT

  # Create instance: tap_19_y1, and set properties
  set tap_19_y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_19_y1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_19_y1

  # Create instance: tap_19_y2, and set properties
  set tap_19_y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_19_y2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_19_y2

  # Create instance: tap_19_y3, and set properties
  set tap_19_y3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_19_y3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {19} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_19_y3

  # Create instance: tap_30_11_R_11, and set properties
  set tap_30_11_R_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_11 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_11

  # Create instance: tap_30_11_R_12, and set properties
  set tap_30_11_R_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_12 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_12

  # Create instance: tap_30_11_R_13, and set properties
  set tap_30_11_R_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_13 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_13

  # Create instance: tap_30_11_R_21, and set properties
  set tap_30_11_R_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_21 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_21

  # Create instance: tap_30_11_R_22, and set properties
  set tap_30_11_R_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_22 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_22

  # Create instance: tap_30_11_R_23, and set properties
  set tap_30_11_R_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_23 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_23

  # Create instance: tap_30_11_R_31, and set properties
  set tap_30_11_R_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_31 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_31

  # Create instance: tap_30_11_R_32, and set properties
  set tap_30_11_R_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_32 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_32

  # Create instance: tap_30_11_R_33, and set properties
  set tap_30_11_R_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_11_R_33 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {41} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_30_11_R_33

  # Create instance: tap_8_11_11_19_70_19_30_A1_2, and set properties
  set tap_8_11_11_19_70_19_30_A1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_8_11_11_19_70_19_30_A1_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {168} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_8_11_11_19_70_19_30_A1_2

  # Create instance: tap_92_a2, and set properties
  set tap_92_a2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_92_a2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {92} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_92_a2

  # Create instance: tap_92_row2, and set properties
  set tap_92_row2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_92_row2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000} \
   CONFIG.Depth {92} \
   CONFIG.SyncInitVal {00000000000000000000000000000000} \
   CONFIG.Width {32} \
 ] $tap_92_row2

  # Create instance: unit_x_19
  create_hier_cell_unit_x_19 [current_bd_instance .] unit_x_19

  # Create instance: unit_y_70
  create_hier_cell_unit_y_70 [current_bd_instance .] unit_y_70

  # Create instance: unit_z_70
  create_hier_cell_unit_z_70 [current_bd_instance .] unit_z_70

  # Create instance: xy_11
  create_hier_cell_xy_11 [current_bd_instance .] xy_11

  # Create instance: y_11
  create_hier_cell_y_11 [current_bd_instance .] y_11

  # Create instance: y_sign_0
  create_hier_cell_y_sign_0 [current_bd_instance .] y_sign_0

  # Create instance: z_1, and set properties
  set z_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 z_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $z_1

  # Create port connections
  connect_bd_net -net A1_2_1 [get_bd_pins A1_A2_sign_2/A1_2] [get_bd_pins distance_collinear_0_122/A_2] [get_bd_pins tap_8_11_11_19_70_19_30_A1_2/D]
  connect_bd_net -net R2_11_1 [get_bd_ports R2_11] [get_bd_pins R2_A2_30/R2_11]
  connect_bd_net -net R2_12_1 [get_bd_ports R2_12] [get_bd_pins R2_A2_30/R2_12]
  connect_bd_net -net R2_13_1 [get_bd_ports R2_13] [get_bd_pins R2_A2_30/R2_13]
  connect_bd_net -net R2_21_1 [get_bd_ports R2_21] [get_bd_pins R2_A2_30/R2_21]
  connect_bd_net -net R2_22_1 [get_bd_ports R2_22] [get_bd_pins R2_A2_30/R2_22]
  connect_bd_net -net R2_23_1 [get_bd_ports R2_23] [get_bd_pins R2_A2_30/R2_23]
  connect_bd_net -net R2_31_1 [get_bd_ports R2_31] [get_bd_pins R2_A2_30/R2_31]
  connect_bd_net -net R2_32_1 [get_bd_ports R2_32] [get_bd_pins R2_A2_30/R2_32]
  connect_bd_net -net R2_33_1 [get_bd_ports R2_33] [get_bd_pins R2_A2_30/R2_33]
  connect_bd_net -net R2_A2_R2_row2 [get_bd_pins R2_A2_30/R2_row2] [get_bd_pins pA2_19/row]
  connect_bd_net -net R_11_1 [get_bd_pins R_A1_30/R_11] [get_bd_pins tap_30_11_R_11/D] [get_bd_pins unit_x_19/x]
  connect_bd_net -net R_12_1 [get_bd_pins R_A1_30/R_12] [get_bd_pins tap_30_11_R_12/D] [get_bd_pins unit_x_19/y]
  connect_bd_net -net R_13_1 [get_bd_pins R_A1_30/R_13] [get_bd_pins tap_30_11_R_13/D] [get_bd_pins unit_x_19/z]
  connect_bd_net -net R_31_1 [get_bd_pins tap2_19_z1/D] [get_bd_pins unit_x_19/x2] [get_bd_pins unit_z_70/v1_u]
  connect_bd_net -net R_32_1 [get_bd_pins tap2_19_z2/D] [get_bd_pins unit_x_19/y2] [get_bd_pins unit_z_70/v2_u]
  connect_bd_net -net R_33_1 [get_bd_pins tap2_19_z3/D] [get_bd_pins unit_x_19/z2] [get_bd_pins unit_z_70/v3_u]
  connect_bd_net -net R_A1_8_sum [get_bd_pins R_A1_30/sum1] [get_bd_pins t_11/sum1]
  connect_bd_net -net R_A1_8_sum1 [get_bd_pins R_A1_30/sum2] [get_bd_pins t_11/sum2]
  connect_bd_net -net a1_1 [get_bd_ports a1] [get_bd_pins distance_collinear_0_122/a] [get_bd_pins tap_122_a1/D]
  connect_bd_net -net a2_1 [get_bd_ports a2] [get_bd_pins distance_collinear_1_122/a] [get_bd_pins tap_92_a2/D]
  connect_bd_net -net aclk_1 [get_bd_ports aclk] [get_bd_pins A1_A2_sign_2/aclk] [get_bd_pins R2_A2_30/aclk] [get_bd_pins R_A1_30/aclk] [get_bd_pins cross_xy_y_19/aclk] [get_bd_pins distance_collinear_0_122/aclk] [get_bd_pins distance_collinear_1_122/aclk] [get_bd_pins pA1_8/aclk] [get_bd_pins pA2_19/aclk] [get_bd_pins pE1_8/aclk] [get_bd_pins t_11/aclk] [get_bd_pins tap2_19_y1/CLK] [get_bd_pins tap2_19_y2/CLK] [get_bd_pins tap2_19_y3/CLK] [get_bd_pins tap2_19_z1/CLK] [get_bd_pins tap2_19_z2/CLK] [get_bd_pins tap2_19_z3/CLK] [get_bd_pins tap_11_19_70_19_pA1_1/CLK] [get_bd_pins tap_11_19_70_19_pA1_2/CLK] [get_bd_pins tap_11_19_70_19_pA1_3/CLK] [get_bd_pins tap_11_pA1_1/CLK] [get_bd_pins tap_11_pA1_2/CLK] [get_bd_pins tap_11_pA1_3/CLK] [get_bd_pins tap_11_xy_1/CLK] [get_bd_pins tap_11_xy_2/CLK] [get_bd_pins tap_11_xy_3/CLK] [get_bd_pins tap_122_19_11_89_19_41_valid/CLK] [get_bd_pins tap_122_a1/CLK] [get_bd_pins tap_122_e1/CLK] [get_bd_pins tap_122_row1/CLK] [get_bd_pins tap_17_11_LT/CLK] [get_bd_pins tap_19_y1/CLK] [get_bd_pins tap_19_y2/CLK] [get_bd_pins tap_19_y3/CLK] [get_bd_pins tap_30_11_R_11/CLK] [get_bd_pins tap_30_11_R_12/CLK] [get_bd_pins tap_30_11_R_13/CLK] [get_bd_pins tap_30_11_R_21/CLK] [get_bd_pins tap_30_11_R_22/CLK] [get_bd_pins tap_30_11_R_23/CLK] [get_bd_pins tap_30_11_R_31/CLK] [get_bd_pins tap_30_11_R_32/CLK] [get_bd_pins tap_30_11_R_33/CLK] [get_bd_pins tap_8_11_11_19_70_19_30_A1_2/CLK] [get_bd_pins tap_92_a2/CLK] [get_bd_pins tap_92_row2/CLK] [get_bd_pins unit_x_19/aclk] [get_bd_pins unit_y_70/aclk] [get_bd_pins unit_z_70/aclk] [get_bd_pins xy_11/aclk] [get_bd_pins y_11/aclk]
  connect_bd_net -net b1_1 [get_bd_ports b1] [get_bd_pins distance_collinear_0_122/b]
  connect_bd_net -net b2_1 [get_bd_ports b2] [get_bd_pins distance_collinear_1_122/b]
  connect_bd_net -net c1_1 [get_bd_ports c1] [get_bd_pins distance_collinear_0_122/c]
  connect_bd_net -net c2_1 [get_bd_ports c2] [get_bd_pins distance_collinear_1_122/c]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins R2_A2_30/a2] [get_bd_pins tap_92_a2/Q]
  connect_bd_net -net c_shift_ram_0_Q1 [get_bd_ports t_3] [get_bd_pins t_11/t_3]
  connect_bd_net -net cross_xy_y_x [get_bd_pins cross_xy_y_19/x] [get_bd_pins unit_z_70/v1]
  connect_bd_net -net cross_xy_y_y [get_bd_pins cross_xy_y_19/y] [get_bd_pins unit_z_70/v2]
  connect_bd_net -net cross_xy_y_z [get_bd_pins cross_xy_y_19/z] [get_bd_pins unit_z_70/v3]
  connect_bd_net -net d1_1 [get_bd_ports d1] [get_bd_pins distance_collinear_0_122/d]
  connect_bd_net -net d2_1 [get_bd_ports d2] [get_bd_pins distance_collinear_1_122/d]
  connect_bd_net -net distance_collinear_0_xa [get_bd_pins distance_collinear_0_122/xa] [get_bd_pins pA1_8/x]
  connect_bd_net -net distance_collinear_1_122_A_2 [get_bd_pins A1_A2_sign_2/A2_2] [get_bd_pins distance_collinear_1_122/A_2]
  connect_bd_net -net e1_1 [get_bd_ports e1] [get_bd_pins distance_collinear_0_122/e] [get_bd_pins tap_122_e1/D]
  connect_bd_net -net e2_1 [get_bd_ports e2] [get_bd_pins distance_collinear_1_122/e]
  connect_bd_net -net float_in_1 [get_bd_pins R_A1_30/sum3] [get_bd_pins t_11/sum3]
  connect_bd_net -net pA1_1_1 [get_bd_pins pA1_8/v1] [get_bd_pins tap_11_pA1_1/D] [get_bd_pins xy_11/pA1_1]
  connect_bd_net -net pA1_2_1 [get_bd_pins pA1_8/v2] [get_bd_pins tap_11_pA1_2/D] [get_bd_pins xy_11/pA1_2]
  connect_bd_net -net pA1_3_1 [get_bd_pins pA1_8/v3] [get_bd_pins tap_11_pA1_3/D] [get_bd_pins xy_11/pA1_3]
  connect_bd_net -net pA1_pA2_1_m_axis_result_tdata [get_bd_pins y_11/y1] [get_bd_pins y_sign_0/y1]
  connect_bd_net -net pA1_pA2_2_m_axis_result_tdata [get_bd_pins y_11/y2] [get_bd_pins y_sign_0/y2]
  connect_bd_net -net pA1_pA2_3_m_axis_result_tdata [get_bd_pins y_11/y3] [get_bd_pins y_sign_0/y3]
  connect_bd_net -net pA2_19_v1 [get_bd_pins pA2_19/v1] [get_bd_pins y_11/pA2_1]
  connect_bd_net -net pA2_19_v2 [get_bd_pins pA2_19/v2] [get_bd_pins y_11/pA2_2]
  connect_bd_net -net pA2_19_v3 [get_bd_pins pA2_19/v3] [get_bd_pins y_11/pA2_3]
  connect_bd_net -net pE1_8_v1 [get_bd_pins pE1_8/v1] [get_bd_pins xy_11/pE1_1]
  connect_bd_net -net pE1_8_v2 [get_bd_pins pE1_8/v2] [get_bd_pins xy_11/pE1_2]
  connect_bd_net -net pE1_8_v3 [get_bd_pins pE1_8/v3] [get_bd_pins xy_11/pE1_3]
  connect_bd_net -net pE1_pA1_1_m_axis_result_tdata [get_bd_pins tap_11_xy_1/D] [get_bd_pins xy_11/xy_1]
  connect_bd_net -net pE1_pA1_2_m_axis_result_tdata [get_bd_pins tap_11_xy_2/D] [get_bd_pins xy_11/xy_2]
  connect_bd_net -net pE1_pA1_3_m_axis_result_tdata [get_bd_pins tap_11_xy_3/D] [get_bd_pins xy_11/xy_3]
  connect_bd_net -net row1_1 [get_bd_ports row1] [get_bd_pins distance_collinear_0_122/row] [get_bd_pins tap_122_row1/D]
  connect_bd_net -net row2_1 [get_bd_ports row2] [get_bd_pins distance_collinear_1_122/row] [get_bd_pins tap_92_row2/D]
  connect_bd_net -net t2_1_1 [get_bd_ports t2_1] [get_bd_pins pA2_19/t2_1]
  connect_bd_net -net t2_2_1 [get_bd_ports t2_2] [get_bd_pins pA2_19/t2_2]
  connect_bd_net -net t2_3_1 [get_bd_ports t2_3] [get_bd_pins pA2_19/t2_3]
  connect_bd_net -net t_t_1 [get_bd_ports t_1] [get_bd_pins t_11/t_1]
  connect_bd_net -net t_t_2 [get_bd_ports t_2] [get_bd_pins t_11/t_2]
  connect_bd_net -net tap2_19_y1_Q [get_bd_pins R_A1_30/R_21] [get_bd_pins tap2_19_y1/Q] [get_bd_pins tap_30_11_R_21/D]
  connect_bd_net -net tap2_19_y2_Q [get_bd_pins R_A1_30/R_22] [get_bd_pins tap2_19_y2/Q] [get_bd_pins tap_30_11_R_22/D]
  connect_bd_net -net tap2_19_y3_Q [get_bd_pins R_A1_30/R_23] [get_bd_pins tap2_19_y3/Q] [get_bd_pins tap_30_11_R_23/D]
  connect_bd_net -net tap2_19_z1_Q [get_bd_pins R_A1_30/R_31] [get_bd_pins tap2_19_z1/Q] [get_bd_pins tap_30_11_R_31/D]
  connect_bd_net -net tap2_19_z2_Q [get_bd_pins R_A1_30/R_32] [get_bd_pins tap2_19_z2/Q] [get_bd_pins tap_30_11_R_32/D]
  connect_bd_net -net tap2_19_z3_Q [get_bd_pins R_A1_30/R_33] [get_bd_pins tap2_19_z3/Q] [get_bd_pins tap_30_11_R_33/D]
  connect_bd_net -net tap_11_19_70_19_Q [get_bd_pins R_A1_30/pA1_1] [get_bd_pins tap_11_19_70_19_pA1_1/Q]
  connect_bd_net -net tap_11_19_70_19_pA1_2_Q [get_bd_pins R_A1_30/pA1_2] [get_bd_pins tap_11_19_70_19_pA1_2/Q]
  connect_bd_net -net tap_11_19_70_19_pA1_3_Q [get_bd_pins R_A1_30/pA1_3] [get_bd_pins tap_11_19_70_19_pA1_3/Q]
  connect_bd_net -net tap_11_pA1_1_Q [get_bd_pins tap_11_19_70_19_pA1_1/D] [get_bd_pins tap_11_pA1_1/Q] [get_bd_pins y_11/pA1_1]
  connect_bd_net -net tap_11_pA1_2_Q [get_bd_pins tap_11_19_70_19_pA1_2/D] [get_bd_pins tap_11_pA1_2/Q] [get_bd_pins y_11/pA1_2]
  connect_bd_net -net tap_11_pA1_3_Q [get_bd_pins tap_11_19_70_19_pA1_3/D] [get_bd_pins tap_11_pA1_3/Q] [get_bd_pins y_11/pA1_3]
  connect_bd_net -net tap_11_xy_1_Q [get_bd_pins cross_xy_y_19/x1] [get_bd_pins tap_11_xy_1/Q]
  connect_bd_net -net tap_11_xy_2_Q [get_bd_pins cross_xy_y_19/y1] [get_bd_pins tap_11_xy_2/Q]
  connect_bd_net -net tap_11_xy_3_Q [get_bd_pins cross_xy_y_19/z1] [get_bd_pins tap_11_xy_3/Q]
  connect_bd_net -net tap_122_19_11_89_19_41_valid_Q [get_bd_ports valid_out] [get_bd_pins tap_122_19_11_89_19_41_valid/Q]
  connect_bd_net -net tap_122_a1_Q [get_bd_pins pA1_8/u] [get_bd_pins tap_122_a1/Q]
  connect_bd_net -net tap_122_e1_Q [get_bd_pins pE1_8/u] [get_bd_pins tap_122_e1/Q]
  connect_bd_net -net tap_122_row1_Q [get_bd_pins pA1_8/row] [get_bd_pins pE1_8/row] [get_bd_pins tap_122_row1/Q]
  connect_bd_net -net tap_17_11_Q [get_bd_pins tap_17_11_LT/Q] [get_bd_pins y_sign_0/LT]
  connect_bd_net -net tap_19_y1_Q [get_bd_pins tap2_19_y1/D] [get_bd_pins tap_19_y1/Q] [get_bd_pins unit_x_19/x1]
  connect_bd_net -net tap_19_y2_Q [get_bd_pins tap2_19_y2/D] [get_bd_pins tap_19_y2/Q] [get_bd_pins unit_x_19/y1]
  connect_bd_net -net tap_19_y3_Q [get_bd_pins tap2_19_y3/D] [get_bd_pins tap_19_y3/Q] [get_bd_pins unit_x_19/z1]
  connect_bd_net -net tap_30_11_R_11_Q [get_bd_ports R_11] [get_bd_pins tap_30_11_R_11/Q]
  connect_bd_net -net tap_30_11_R_12_Q [get_bd_ports R_12] [get_bd_pins tap_30_11_R_12/Q]
  connect_bd_net -net tap_30_11_R_13_Q [get_bd_ports R_13] [get_bd_pins tap_30_11_R_13/Q]
  connect_bd_net -net tap_30_11_R_21_Q [get_bd_ports R_21] [get_bd_pins tap_30_11_R_21/Q]
  connect_bd_net -net tap_30_11_R_22_Q [get_bd_ports R_22] [get_bd_pins tap_30_11_R_22/Q]
  connect_bd_net -net tap_30_11_R_23_Q [get_bd_ports R_23] [get_bd_pins tap_30_11_R_23/Q]
  connect_bd_net -net tap_30_11_R_31_Q [get_bd_ports R_31] [get_bd_pins tap_30_11_R_31/Q]
  connect_bd_net -net tap_30_11_R_32_Q [get_bd_ports R_32] [get_bd_pins tap_30_11_R_32/Q]
  connect_bd_net -net tap_30_11_R_33_Q [get_bd_ports R_33] [get_bd_pins tap_30_11_R_33/Q]
  connect_bd_net -net tap_8_11_11_19_70_19_30_Q [get_bd_pins t_11/A1_2] [get_bd_pins tap_8_11_11_19_70_19_30_A1_2/Q]
  connect_bd_net -net tap_92_a3_Q [get_bd_pins R2_A2_30/row2] [get_bd_pins tap_92_row2/Q]
  connect_bd_net -net u_1 [get_bd_pins R2_A2_30/R2_a2] [get_bd_pins pA2_19/u]
  connect_bd_net -net unit_y_v1_u [get_bd_pins tap_19_y1/D] [get_bd_pins unit_y_70/v1_u]
  connect_bd_net -net unit_y_v2_u [get_bd_pins tap_19_y2/D] [get_bd_pins unit_y_70/v2_u]
  connect_bd_net -net unit_y_v3_u [get_bd_pins tap_19_y3/D] [get_bd_pins unit_y_70/v3_u]
  connect_bd_net -net valid_in_1 [get_bd_ports valid_in] [get_bd_pins tap_122_19_11_89_19_41_valid/D]
  connect_bd_net -net w_1 [get_bd_pins R2_A2_30/R2_1] [get_bd_pins pA2_19/w]
  connect_bd_net -net x_1 [get_bd_pins distance_collinear_0_122/xe] [get_bd_pins pE1_8/x]
  connect_bd_net -net x_2 [get_bd_pins distance_collinear_1_122/xa] [get_bd_pins pA2_19/x]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins A1_A2_sign_2/LT] [get_bd_pins tap_17_11_LT/D]
  connect_bd_net -net y1_sign_float_out [get_bd_pins cross_xy_y_19/x2] [get_bd_pins unit_y_70/v1] [get_bd_pins y_sign_0/ny1]
  connect_bd_net -net y2_sign_float_out [get_bd_pins cross_xy_y_19/y2] [get_bd_pins unit_y_70/v2] [get_bd_pins y_sign_0/ny2]
  connect_bd_net -net y3_sign_float_out [get_bd_pins cross_xy_y_19/z2] [get_bd_pins unit_y_70/v3] [get_bd_pins y_sign_0/ny3]
  connect_bd_net -net z_1_dout [get_bd_pins distance_collinear_0_122/valid_in] [get_bd_pins distance_collinear_1_122/valid_in] [get_bd_pins z_1/dout]

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


