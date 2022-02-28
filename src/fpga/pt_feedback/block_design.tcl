
################################################################
# This is a generated script based on design: system
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
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# GPIO_trigger_pulse, bram_delay_line, bram_delay_line, coarse_gain_and_limiter, coarse_gain_and_limiter, conditional_adder_4x2, decimate, decimate, edge_detector, red_pitaya_adc, coarse_gain_and_limiter, optical_trap_dc, optical_trap_feedback, mux_2x1, mux_8x2, red_pitaya_dac, biquad_filter, biquad_filter, biquad_filter, biquad_filter, biquad_filter, coarse_gain_and_limiter, fine_delay_line, fine_gain, mux_2x1_with_valid, mux_2x1_with_valid, mux_8x1, triggered_gate, biquad_filter, biquad_filter, biquad_filter, biquad_filter, biquad_filter, coarse_gain_and_limiter, fine_delay_line, fine_gain, mux_2x1_with_valid, mux_2x1_with_valid, mux_8x1, triggered_gate, biquad_filter, biquad_filter, biquad_filter, biquad_filter, biquad_filter, coarse_gain_and_limiter, fine_delay_line, fine_gain, mux_2x1_with_valid, mux_2x1_with_valid, mux_8x1, triggered_gate, biquad_filter, biquad_filter, biquad_filter, biquad_filter, biquad_filter, coarse_gain_and_limiter, fine_delay_line, fine_gain, mux_2x1_with_valid, mux_2x1_with_valid, mux_8x1, triggered_gate, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

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
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "(aom_control) By making sure that the input B of the
addition block is always negative,
we can keep only the the LSBs of the output.
Input B is sure to be negative b.c. the gain
multiplier's input A is negative, and B is unsigned" [get_bd_designs $design_name]

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:mult_gen:12.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_gpio:2.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
GPIO_trigger_pulse\
bram_delay_line\
bram_delay_line\
coarse_gain_and_limiter\
coarse_gain_and_limiter\
conditional_adder_4x2\
decimate\
decimate\
edge_detector\
red_pitaya_adc\
coarse_gain_and_limiter\
optical_trap_dc\
optical_trap_feedback\
mux_2x1\
mux_8x2\
red_pitaya_dac\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
coarse_gain_and_limiter\
fine_delay_line\
fine_gain\
mux_2x1_with_valid\
mux_2x1_with_valid\
mux_8x1\
triggered_gate\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
coarse_gain_and_limiter\
fine_delay_line\
fine_gain\
mux_2x1_with_valid\
mux_2x1_with_valid\
mux_8x1\
triggered_gate\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
coarse_gain_and_limiter\
fine_delay_line\
fine_gain\
mux_2x1_with_valid\
mux_2x1_with_valid\
mux_8x1\
triggered_gate\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
biquad_filter\
coarse_gain_and_limiter\
fine_delay_line\
fine_gain\
mux_2x1_with_valid\
mux_2x1_with_valid\
mux_8x1\
triggered_gate\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: multi_GPIO_4
proc create_hier_cell_multi_GPIO_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_4() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 24 -to 0 data0_o1
  create_bd_pin -dir O -from 24 -to 0 data0_o2
  create_bd_pin -dir O -from 2 -to 0 data0_o3
  create_bd_pin -dir O -from 24 -to 0 data1_o
  create_bd_pin -dir O -from 24 -to 0 data1_o1
  create_bd_pin -dir O -from 24 -to 0 data1_o2
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 24 -to 0 data2_o1
  create_bd_pin -dir O -from 24 -to 0 data2_o2
  create_bd_pin -dir O -from 4 -to 0 data2_o3
  create_bd_pin -dir O -from 16 -to 0 data3_o
  create_bd_pin -dir O -from 24 -to 0 data3_o1
  create_bd_pin -dir O -from 24 -to 0 data3_o2
  create_bd_pin -dir O -from 25 -to 0 data3_o3
  create_bd_pin -dir O -from 24 -to 0 data4_o
  create_bd_pin -dir O -from 24 -to 0 data4_o1
  create_bd_pin -dir O -from 24 -to 0 data4_o2
  create_bd_pin -dir O -from 25 -to 0 data4_o3
  create_bd_pin -dir O -from 24 -to 0 data5_o
  create_bd_pin -dir O -from 24 -to 0 data5_o1
  create_bd_pin -dir O -from 24 -to 0 data5_o2
  create_bd_pin -dir O -from 4 -to 0 data5_o3
  create_bd_pin -dir O -from 24 -to 0 data6_o
  create_bd_pin -dir O -from 24 -to 0 data6_o1
  create_bd_pin -dir O -from 24 -to 0 data6_o2
  create_bd_pin -dir O -from 25 -to 0 data6_o3
  create_bd_pin -dir O -from 24 -to 0 data7_o
  create_bd_pin -dir O -from 24 -to 0 data7_o1
  create_bd_pin -dir O -from 24 -to 0 data7_o2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: GPIO_mux_0, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_0
  if { [catch {set GPIO_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH_0 {1} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {1} \
   CONFIG.DATA_WIDTH_3 {17} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_0

  # Create instance: GPIO_mux_1, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_1
  if { [catch {set GPIO_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {1} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_1

  # Create instance: GPIO_mux_2, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_2
  if { [catch {set GPIO_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {2} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_2

  # Create instance: GPIO_mux_3, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_3
  if { [catch {set GPIO_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {3} \
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {5} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {26} \
 ] $GPIO_mux_3

  # Create instance: GPIO_super_mux_0, and set properties
  set block_name GPIO_super_mux
  set block_cell_name GPIO_super_mux_0
  if { [catch {set GPIO_super_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_super_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_4, and set properties
  set axi_gpio_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_4 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_4

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_4/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_data0_o [get_bd_pins data0_o1] [get_bd_pins GPIO_mux_1/data0_o]
  connect_bd_net -net GPIO_mux_1_data1_o [get_bd_pins data1_o1] [get_bd_pins GPIO_mux_1/data1_o]
  connect_bd_net -net GPIO_mux_1_data2_o [get_bd_pins data2_o1] [get_bd_pins GPIO_mux_1/data2_o]
  connect_bd_net -net GPIO_mux_1_data3_o [get_bd_pins data3_o1] [get_bd_pins GPIO_mux_1/data3_o]
  connect_bd_net -net GPIO_mux_1_data4_o [get_bd_pins data4_o1] [get_bd_pins GPIO_mux_1/data4_o]
  connect_bd_net -net GPIO_mux_1_data5_o [get_bd_pins data5_o1] [get_bd_pins GPIO_mux_1/data5_o]
  connect_bd_net -net GPIO_mux_1_data6_o [get_bd_pins data6_o1] [get_bd_pins GPIO_mux_1/data6_o]
  connect_bd_net -net GPIO_mux_1_data7_o [get_bd_pins data7_o1] [get_bd_pins GPIO_mux_1/data7_o]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_data0_o [get_bd_pins data0_o2] [get_bd_pins GPIO_mux_2/data0_o]
  connect_bd_net -net GPIO_mux_2_data1_o [get_bd_pins data1_o2] [get_bd_pins GPIO_mux_2/data1_o]
  connect_bd_net -net GPIO_mux_2_data2_o [get_bd_pins data2_o2] [get_bd_pins GPIO_mux_2/data2_o]
  connect_bd_net -net GPIO_mux_2_data3_o [get_bd_pins data3_o2] [get_bd_pins GPIO_mux_2/data3_o]
  connect_bd_net -net GPIO_mux_2_data4_o [get_bd_pins data4_o2] [get_bd_pins GPIO_mux_2/data4_o]
  connect_bd_net -net GPIO_mux_2_data5_o [get_bd_pins data5_o2] [get_bd_pins GPIO_mux_2/data5_o]
  connect_bd_net -net GPIO_mux_2_data6_o [get_bd_pins data6_o2] [get_bd_pins GPIO_mux_2/data6_o]
  connect_bd_net -net GPIO_mux_2_data7_o [get_bd_pins data7_o2] [get_bd_pins GPIO_mux_2/data7_o]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_data0_o [get_bd_pins data0_o3] [get_bd_pins GPIO_mux_3/data0_o]
  connect_bd_net -net GPIO_mux_3_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_3/data1_o]
  connect_bd_net -net GPIO_mux_3_data2_o [get_bd_pins data2_o3] [get_bd_pins GPIO_mux_3/data2_o]
  connect_bd_net -net GPIO_mux_3_data3_o [get_bd_pins data3_o3] [get_bd_pins GPIO_mux_3/data3_o]
  connect_bd_net -net GPIO_mux_3_data4_o [get_bd_pins data4_o3] [get_bd_pins GPIO_mux_3/data4_o]
  connect_bd_net -net GPIO_mux_3_data5_o [get_bd_pins data5_o3] [get_bd_pins GPIO_mux_3/data5_o]
  connect_bd_net -net GPIO_mux_3_data6_o [get_bd_pins data6_o3] [get_bd_pins GPIO_mux_3/data6_o]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_4/gpio2_io_i]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_4/gpio_io_o]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_4/s_axi_aresetn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_4/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_3
proc create_hier_cell_multi_GPIO_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 24 -to 0 data0_o1
  create_bd_pin -dir O -from 24 -to 0 data0_o2
  create_bd_pin -dir O -from 2 -to 0 data0_o3
  create_bd_pin -dir O -from 24 -to 0 data1_o
  create_bd_pin -dir O -from 24 -to 0 data1_o1
  create_bd_pin -dir O -from 24 -to 0 data1_o2
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 24 -to 0 data2_o1
  create_bd_pin -dir O -from 24 -to 0 data2_o2
  create_bd_pin -dir O -from 4 -to 0 data2_o3
  create_bd_pin -dir O -from 16 -to 0 data3_o
  create_bd_pin -dir O -from 24 -to 0 data3_o1
  create_bd_pin -dir O -from 24 -to 0 data3_o2
  create_bd_pin -dir O -from 25 -to 0 data3_o3
  create_bd_pin -dir O -from 24 -to 0 data4_o
  create_bd_pin -dir O -from 24 -to 0 data4_o1
  create_bd_pin -dir O -from 24 -to 0 data4_o2
  create_bd_pin -dir O -from 25 -to 0 data4_o3
  create_bd_pin -dir O -from 24 -to 0 data5_o
  create_bd_pin -dir O -from 24 -to 0 data5_o1
  create_bd_pin -dir O -from 24 -to 0 data5_o2
  create_bd_pin -dir O -from 4 -to 0 data5_o3
  create_bd_pin -dir O -from 24 -to 0 data6_o
  create_bd_pin -dir O -from 24 -to 0 data6_o1
  create_bd_pin -dir O -from 24 -to 0 data6_o2
  create_bd_pin -dir O -from 25 -to 0 data6_o3
  create_bd_pin -dir O -from 24 -to 0 data7_o
  create_bd_pin -dir O -from 24 -to 0 data7_o1
  create_bd_pin -dir O -from 24 -to 0 data7_o2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: GPIO_mux_0, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_0
  if { [catch {set GPIO_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH_0 {1} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {1} \
   CONFIG.DATA_WIDTH_3 {17} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_0

  # Create instance: GPIO_mux_1, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_1
  if { [catch {set GPIO_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {1} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_1

  # Create instance: GPIO_mux_2, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_2
  if { [catch {set GPIO_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {2} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_2

  # Create instance: GPIO_mux_3, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_3
  if { [catch {set GPIO_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {3} \
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {5} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {26} \
 ] $GPIO_mux_3

  # Create instance: GPIO_super_mux_0, and set properties
  set block_name GPIO_super_mux
  set block_cell_name GPIO_super_mux_0
  if { [catch {set GPIO_super_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_super_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_3

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_3/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_data0_o [get_bd_pins data0_o1] [get_bd_pins GPIO_mux_1/data0_o]
  connect_bd_net -net GPIO_mux_1_data1_o [get_bd_pins data1_o1] [get_bd_pins GPIO_mux_1/data1_o]
  connect_bd_net -net GPIO_mux_1_data2_o [get_bd_pins data2_o1] [get_bd_pins GPIO_mux_1/data2_o]
  connect_bd_net -net GPIO_mux_1_data3_o [get_bd_pins data3_o1] [get_bd_pins GPIO_mux_1/data3_o]
  connect_bd_net -net GPIO_mux_1_data4_o [get_bd_pins data4_o1] [get_bd_pins GPIO_mux_1/data4_o]
  connect_bd_net -net GPIO_mux_1_data5_o [get_bd_pins data5_o1] [get_bd_pins GPIO_mux_1/data5_o]
  connect_bd_net -net GPIO_mux_1_data6_o [get_bd_pins data6_o1] [get_bd_pins GPIO_mux_1/data6_o]
  connect_bd_net -net GPIO_mux_1_data7_o [get_bd_pins data7_o1] [get_bd_pins GPIO_mux_1/data7_o]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_data0_o [get_bd_pins data0_o2] [get_bd_pins GPIO_mux_2/data0_o]
  connect_bd_net -net GPIO_mux_2_data1_o [get_bd_pins data1_o2] [get_bd_pins GPIO_mux_2/data1_o]
  connect_bd_net -net GPIO_mux_2_data2_o [get_bd_pins data2_o2] [get_bd_pins GPIO_mux_2/data2_o]
  connect_bd_net -net GPIO_mux_2_data3_o [get_bd_pins data3_o2] [get_bd_pins GPIO_mux_2/data3_o]
  connect_bd_net -net GPIO_mux_2_data4_o [get_bd_pins data4_o2] [get_bd_pins GPIO_mux_2/data4_o]
  connect_bd_net -net GPIO_mux_2_data5_o [get_bd_pins data5_o2] [get_bd_pins GPIO_mux_2/data5_o]
  connect_bd_net -net GPIO_mux_2_data6_o [get_bd_pins data6_o2] [get_bd_pins GPIO_mux_2/data6_o]
  connect_bd_net -net GPIO_mux_2_data7_o [get_bd_pins data7_o2] [get_bd_pins GPIO_mux_2/data7_o]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_data0_o [get_bd_pins data0_o3] [get_bd_pins GPIO_mux_3/data0_o]
  connect_bd_net -net GPIO_mux_3_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_3/data1_o]
  connect_bd_net -net GPIO_mux_3_data2_o [get_bd_pins data2_o3] [get_bd_pins GPIO_mux_3/data2_o]
  connect_bd_net -net GPIO_mux_3_data3_o [get_bd_pins data3_o3] [get_bd_pins GPIO_mux_3/data3_o]
  connect_bd_net -net GPIO_mux_3_data4_o [get_bd_pins data4_o3] [get_bd_pins GPIO_mux_3/data4_o]
  connect_bd_net -net GPIO_mux_3_data5_o [get_bd_pins data5_o3] [get_bd_pins GPIO_mux_3/data5_o]
  connect_bd_net -net GPIO_mux_3_data6_o [get_bd_pins data6_o3] [get_bd_pins GPIO_mux_3/data6_o]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_3/gpio2_io_i]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_3/gpio_io_o]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_3/s_axi_aresetn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_2
proc create_hier_cell_multi_GPIO_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 24 -to 0 data0_o1
  create_bd_pin -dir O -from 24 -to 0 data0_o2
  create_bd_pin -dir O -from 2 -to 0 data0_o3
  create_bd_pin -dir O -from 24 -to 0 data1_o
  create_bd_pin -dir O -from 24 -to 0 data1_o1
  create_bd_pin -dir O -from 24 -to 0 data1_o2
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 24 -to 0 data2_o1
  create_bd_pin -dir O -from 24 -to 0 data2_o2
  create_bd_pin -dir O -from 4 -to 0 data2_o3
  create_bd_pin -dir O -from 16 -to 0 data3_o
  create_bd_pin -dir O -from 24 -to 0 data3_o1
  create_bd_pin -dir O -from 24 -to 0 data3_o2
  create_bd_pin -dir O -from 25 -to 0 data3_o3
  create_bd_pin -dir O -from 24 -to 0 data4_o
  create_bd_pin -dir O -from 24 -to 0 data4_o1
  create_bd_pin -dir O -from 24 -to 0 data4_o2
  create_bd_pin -dir O -from 25 -to 0 data4_o3
  create_bd_pin -dir O -from 24 -to 0 data5_o
  create_bd_pin -dir O -from 24 -to 0 data5_o1
  create_bd_pin -dir O -from 24 -to 0 data5_o2
  create_bd_pin -dir O -from 4 -to 0 data5_o3
  create_bd_pin -dir O -from 24 -to 0 data6_o
  create_bd_pin -dir O -from 24 -to 0 data6_o1
  create_bd_pin -dir O -from 24 -to 0 data6_o2
  create_bd_pin -dir O -from 25 -to 0 data6_o3
  create_bd_pin -dir O -from 24 -to 0 data7_o
  create_bd_pin -dir O -from 24 -to 0 data7_o1
  create_bd_pin -dir O -from 24 -to 0 data7_o2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: GPIO_mux_0, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_0
  if { [catch {set GPIO_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH_0 {1} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {1} \
   CONFIG.DATA_WIDTH_3 {17} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_0

  # Create instance: GPIO_mux_1, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_1
  if { [catch {set GPIO_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {1} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_1

  # Create instance: GPIO_mux_2, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_2
  if { [catch {set GPIO_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {2} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_2

  # Create instance: GPIO_mux_3, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_3
  if { [catch {set GPIO_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {3} \
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {5} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {26} \
 ] $GPIO_mux_3

  # Create instance: GPIO_super_mux_0, and set properties
  set block_name GPIO_super_mux
  set block_cell_name GPIO_super_mux_0
  if { [catch {set GPIO_super_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_super_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_2

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_2/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_data0_o [get_bd_pins data0_o1] [get_bd_pins GPIO_mux_1/data0_o]
  connect_bd_net -net GPIO_mux_1_data1_o [get_bd_pins data1_o1] [get_bd_pins GPIO_mux_1/data1_o]
  connect_bd_net -net GPIO_mux_1_data2_o [get_bd_pins data2_o1] [get_bd_pins GPIO_mux_1/data2_o]
  connect_bd_net -net GPIO_mux_1_data3_o [get_bd_pins data3_o1] [get_bd_pins GPIO_mux_1/data3_o]
  connect_bd_net -net GPIO_mux_1_data4_o [get_bd_pins data4_o1] [get_bd_pins GPIO_mux_1/data4_o]
  connect_bd_net -net GPIO_mux_1_data5_o [get_bd_pins data5_o1] [get_bd_pins GPIO_mux_1/data5_o]
  connect_bd_net -net GPIO_mux_1_data6_o [get_bd_pins data6_o1] [get_bd_pins GPIO_mux_1/data6_o]
  connect_bd_net -net GPIO_mux_1_data7_o [get_bd_pins data7_o1] [get_bd_pins GPIO_mux_1/data7_o]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_data0_o [get_bd_pins data0_o2] [get_bd_pins GPIO_mux_2/data0_o]
  connect_bd_net -net GPIO_mux_2_data1_o [get_bd_pins data1_o2] [get_bd_pins GPIO_mux_2/data1_o]
  connect_bd_net -net GPIO_mux_2_data2_o [get_bd_pins data2_o2] [get_bd_pins GPIO_mux_2/data2_o]
  connect_bd_net -net GPIO_mux_2_data3_o [get_bd_pins data3_o2] [get_bd_pins GPIO_mux_2/data3_o]
  connect_bd_net -net GPIO_mux_2_data4_o [get_bd_pins data4_o2] [get_bd_pins GPIO_mux_2/data4_o]
  connect_bd_net -net GPIO_mux_2_data5_o [get_bd_pins data5_o2] [get_bd_pins GPIO_mux_2/data5_o]
  connect_bd_net -net GPIO_mux_2_data6_o [get_bd_pins data6_o2] [get_bd_pins GPIO_mux_2/data6_o]
  connect_bd_net -net GPIO_mux_2_data7_o [get_bd_pins data7_o2] [get_bd_pins GPIO_mux_2/data7_o]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_data0_o [get_bd_pins data0_o3] [get_bd_pins GPIO_mux_3/data0_o]
  connect_bd_net -net GPIO_mux_3_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_3/data1_o]
  connect_bd_net -net GPIO_mux_3_data2_o [get_bd_pins data2_o3] [get_bd_pins GPIO_mux_3/data2_o]
  connect_bd_net -net GPIO_mux_3_data3_o [get_bd_pins data3_o3] [get_bd_pins GPIO_mux_3/data3_o]
  connect_bd_net -net GPIO_mux_3_data4_o [get_bd_pins data4_o3] [get_bd_pins GPIO_mux_3/data4_o]
  connect_bd_net -net GPIO_mux_3_data5_o [get_bd_pins data5_o3] [get_bd_pins GPIO_mux_3/data5_o]
  connect_bd_net -net GPIO_mux_3_data6_o [get_bd_pins data6_o3] [get_bd_pins GPIO_mux_3/data6_o]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_2/gpio2_io_i]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_2/gpio_io_o]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_2/s_axi_aresetn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_1
proc create_hier_cell_multi_GPIO_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 24 -to 0 data0_o1
  create_bd_pin -dir O -from 24 -to 0 data0_o2
  create_bd_pin -dir O -from 2 -to 0 data0_o3
  create_bd_pin -dir O -from 24 -to 0 data1_o
  create_bd_pin -dir O -from 24 -to 0 data1_o1
  create_bd_pin -dir O -from 24 -to 0 data1_o2
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 24 -to 0 data2_o1
  create_bd_pin -dir O -from 24 -to 0 data2_o2
  create_bd_pin -dir O -from 4 -to 0 data2_o3
  create_bd_pin -dir O -from 16 -to 0 data3_o
  create_bd_pin -dir O -from 24 -to 0 data3_o1
  create_bd_pin -dir O -from 24 -to 0 data3_o2
  create_bd_pin -dir O -from 25 -to 0 data3_o3
  create_bd_pin -dir O -from 24 -to 0 data4_o
  create_bd_pin -dir O -from 24 -to 0 data4_o1
  create_bd_pin -dir O -from 24 -to 0 data4_o2
  create_bd_pin -dir O -from 25 -to 0 data4_o3
  create_bd_pin -dir O -from 24 -to 0 data5_o
  create_bd_pin -dir O -from 24 -to 0 data5_o1
  create_bd_pin -dir O -from 24 -to 0 data5_o2
  create_bd_pin -dir O -from 4 -to 0 data5_o3
  create_bd_pin -dir O -from 24 -to 0 data6_o
  create_bd_pin -dir O -from 24 -to 0 data6_o1
  create_bd_pin -dir O -from 24 -to 0 data6_o2
  create_bd_pin -dir O -from 25 -to 0 data6_o3
  create_bd_pin -dir O -from 24 -to 0 data7_o
  create_bd_pin -dir O -from 24 -to 0 data7_o1
  create_bd_pin -dir O -from 24 -to 0 data7_o2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: GPIO_mux_0, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_0
  if { [catch {set GPIO_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH_0 {1} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {1} \
   CONFIG.DATA_WIDTH_3 {17} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_0

  # Create instance: GPIO_mux_1, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_1
  if { [catch {set GPIO_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {1} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_1

  # Create instance: GPIO_mux_2, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_2
  if { [catch {set GPIO_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {2} \
   CONFIG.DATA_WIDTH_0 {25} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {25} \
   CONFIG.DATA_WIDTH_3 {25} \
   CONFIG.DATA_WIDTH_4 {25} \
   CONFIG.DATA_WIDTH_5 {25} \
   CONFIG.DATA_WIDTH_6 {25} \
   CONFIG.DATA_WIDTH_7 {25} \
 ] $GPIO_mux_2

  # Create instance: GPIO_mux_3, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_3
  if { [catch {set GPIO_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {3} \
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {25} \
   CONFIG.DATA_WIDTH_2 {5} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {26} \
 ] $GPIO_mux_3

  # Create instance: GPIO_super_mux_0, and set properties
  set block_name GPIO_super_mux
  set block_cell_name GPIO_super_mux_0
  if { [catch {set GPIO_super_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_super_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_1

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_data0_o [get_bd_pins data0_o1] [get_bd_pins GPIO_mux_1/data0_o]
  connect_bd_net -net GPIO_mux_1_data1_o [get_bd_pins data1_o1] [get_bd_pins GPIO_mux_1/data1_o]
  connect_bd_net -net GPIO_mux_1_data2_o [get_bd_pins data2_o1] [get_bd_pins GPIO_mux_1/data2_o]
  connect_bd_net -net GPIO_mux_1_data3_o [get_bd_pins data3_o1] [get_bd_pins GPIO_mux_1/data3_o]
  connect_bd_net -net GPIO_mux_1_data4_o [get_bd_pins data4_o1] [get_bd_pins GPIO_mux_1/data4_o]
  connect_bd_net -net GPIO_mux_1_data5_o [get_bd_pins data5_o1] [get_bd_pins GPIO_mux_1/data5_o]
  connect_bd_net -net GPIO_mux_1_data6_o [get_bd_pins data6_o1] [get_bd_pins GPIO_mux_1/data6_o]
  connect_bd_net -net GPIO_mux_1_data7_o [get_bd_pins data7_o1] [get_bd_pins GPIO_mux_1/data7_o]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_data0_o [get_bd_pins data0_o2] [get_bd_pins GPIO_mux_2/data0_o]
  connect_bd_net -net GPIO_mux_2_data1_o [get_bd_pins data1_o2] [get_bd_pins GPIO_mux_2/data1_o]
  connect_bd_net -net GPIO_mux_2_data2_o [get_bd_pins data2_o2] [get_bd_pins GPIO_mux_2/data2_o]
  connect_bd_net -net GPIO_mux_2_data3_o [get_bd_pins data3_o2] [get_bd_pins GPIO_mux_2/data3_o]
  connect_bd_net -net GPIO_mux_2_data4_o [get_bd_pins data4_o2] [get_bd_pins GPIO_mux_2/data4_o]
  connect_bd_net -net GPIO_mux_2_data5_o [get_bd_pins data5_o2] [get_bd_pins GPIO_mux_2/data5_o]
  connect_bd_net -net GPIO_mux_2_data6_o [get_bd_pins data6_o2] [get_bd_pins GPIO_mux_2/data6_o]
  connect_bd_net -net GPIO_mux_2_data7_o [get_bd_pins data7_o2] [get_bd_pins GPIO_mux_2/data7_o]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_data0_o [get_bd_pins data0_o3] [get_bd_pins GPIO_mux_3/data0_o]
  connect_bd_net -net GPIO_mux_3_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_3/data1_o]
  connect_bd_net -net GPIO_mux_3_data2_o [get_bd_pins data2_o3] [get_bd_pins GPIO_mux_3/data2_o]
  connect_bd_net -net GPIO_mux_3_data3_o [get_bd_pins data3_o3] [get_bd_pins GPIO_mux_3/data3_o]
  connect_bd_net -net GPIO_mux_3_data4_o [get_bd_pins data4_o3] [get_bd_pins GPIO_mux_3/data4_o]
  connect_bd_net -net GPIO_mux_3_data5_o [get_bd_pins data5_o3] [get_bd_pins GPIO_mux_3/data5_o]
  connect_bd_net -net GPIO_mux_3_data6_o [get_bd_pins data6_o3] [get_bd_pins GPIO_mux_3/data6_o]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_1/gpio2_io_i]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_1/gpio_io_o]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_1/s_axi_aresetn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_0
proc create_hier_cell_multi_GPIO_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 16 -to 0 data0_o1
  create_bd_pin -dir O -from 1 -to 0 data0_o2
  create_bd_pin -dir O -from 0 -to 0 data1_o
  create_bd_pin -dir O -from 2 -to 0 data1_o1
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 2 -to 0 data2_o1
  create_bd_pin -dir O -from 25 -to 0 data3_o
  create_bd_pin -dir O -from 25 -to 0 data3_o1
  create_bd_pin -dir O -from 25 -to 0 data4_o
  create_bd_pin -dir O -from 13 -to 0 data4_o1
  create_bd_pin -dir O -from 0 -to 0 data4_o2
  create_bd_pin -dir O -from 0 -to 0 data5_o
  create_bd_pin -dir O -from 3 -to 0 data5_o1
  create_bd_pin -dir O -from 25 -to 0 data6_o
  create_bd_pin -dir O -from 3 -to 0 data6_o1
  create_bd_pin -dir O -from 25 -to 0 data7_o
  create_bd_pin -dir O -from 1 -to 0 data7_o1
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: GPIO_mux_0, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_0
  if { [catch {set GPIO_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH_0 {1} \
   CONFIG.DATA_WIDTH_1 {1} \
   CONFIG.DATA_WIDTH_2 {1} \
   CONFIG.DATA_WIDTH_3 {26} \
   CONFIG.DATA_WIDTH_4 {26} \
   CONFIG.DATA_WIDTH_5 {1} \
   CONFIG.DATA_WIDTH_6 {26} \
   CONFIG.DATA_WIDTH_7 {26} \
 ] $GPIO_mux_0

  # Create instance: GPIO_mux_1, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_1
  if { [catch {set GPIO_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {1} \
   CONFIG.DATA_WIDTH_0 {17} \
   CONFIG.DATA_WIDTH_1 {26} \
   CONFIG.DATA_WIDTH_2 {26} \
   CONFIG.DATA_WIDTH_3 {26} \
   CONFIG.DATA_WIDTH_4 {14} \
   CONFIG.DATA_WIDTH_5 {4} \
   CONFIG.DATA_WIDTH_6 {4} \
   CONFIG.DATA_WIDTH_7 {2} \
 ] $GPIO_mux_1

  # Create instance: GPIO_mux_2, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_2
  if { [catch {set GPIO_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {2} \
   CONFIG.DATA_WIDTH_0 {2} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {3} \
   CONFIG.DATA_WIDTH_3 {26} \
   CONFIG.DATA_WIDTH_4 {1} \
   CONFIG.DATA_WIDTH_5 {24} \
   CONFIG.DATA_WIDTH_6 {24} \
   CONFIG.DATA_WIDTH_7 {24} \
 ] $GPIO_mux_2

  # Create instance: GPIO_mux_3, and set properties
  set block_name GPIO_mux
  set block_cell_name GPIO_mux_3
  if { [catch {set GPIO_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_mux_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADDRESS_PREFIX {3} \
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {1} \
   CONFIG.DATA_WIDTH_2 {1} \
 ] $GPIO_mux_3

  # Create instance: GPIO_super_mux_0, and set properties
  set block_name GPIO_super_mux
  set block_cell_name GPIO_super_mux_0
  if { [catch {set GPIO_super_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_super_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_data0_o [get_bd_pins data0_o1] [get_bd_pins GPIO_mux_1/data0_o]
  connect_bd_net -net GPIO_mux_1_data4_o [get_bd_pins data4_o1] [get_bd_pins GPIO_mux_1/data4_o]
  connect_bd_net -net GPIO_mux_1_data5_o [get_bd_pins data5_o1] [get_bd_pins GPIO_mux_1/data5_o]
  connect_bd_net -net GPIO_mux_1_data6_o [get_bd_pins data6_o1] [get_bd_pins GPIO_mux_1/data6_o]
  connect_bd_net -net GPIO_mux_1_data7_o [get_bd_pins data7_o1] [get_bd_pins GPIO_mux_1/data7_o]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_data0_o [get_bd_pins data0_o2] [get_bd_pins GPIO_mux_2/data0_o]
  connect_bd_net -net GPIO_mux_2_data1_o [get_bd_pins data1_o1] [get_bd_pins GPIO_mux_2/data1_o]
  connect_bd_net -net GPIO_mux_2_data2_o [get_bd_pins data2_o1] [get_bd_pins GPIO_mux_2/data2_o]
  connect_bd_net -net GPIO_mux_2_data3_o [get_bd_pins data3_o1] [get_bd_pins GPIO_mux_2/data3_o]
  connect_bd_net -net GPIO_mux_2_data4_o [get_bd_pins data4_o2] [get_bd_pins GPIO_mux_2/data4_o]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: filter_block_3
proc create_hier_cell_filter_block_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_filter_block_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I data_valid0_i
  create_bd_pin -dir I data_valid1_i
  create_bd_pin -dir O -from 13 -to 0 delay_MSB
  create_bd_pin -dir I -from 16 -to 0 in0_i
  create_bd_pin -dir I -from 16 -to 0 in1_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I trig_i

  # Create instance: DC_Block_IIR, and set properties
  set block_name biquad_filter
  set block_cell_name DC_Block_IIR
  if { [catch {set DC_Block_IIR [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DC_Block_IIR eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $DC_Block_IIR

  # Create instance: biquad_filter_0, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_0
  if { [catch {set biquad_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_0

  # Create instance: biquad_filter_1, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_1
  if { [catch {set biquad_filter_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_1

  # Create instance: biquad_filter_2, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_2
  if { [catch {set biquad_filter_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_2

  # Create instance: biquad_filter_3, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_3
  if { [catch {set biquad_filter_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_3

  # Create instance: coarse_gain_and_limi_1, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_1
  if { [catch {set coarse_gain_and_limi_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_1

  # Create instance: delay_LSB, and set properties
  set delay_LSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_LSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {3} \
 ] $delay_LSB

  # Create instance: delay_MSB, and set properties
  set delay_MSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_MSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {14} \
 ] $delay_MSB

  # Create instance: fine_delay_line_0, and set properties
  set block_name fine_delay_line
  set block_cell_name fine_delay_line_0
  if { [catch {set fine_delay_line_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_delay_line_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fine_gain_0, and set properties
  set block_name fine_gain
  set block_cell_name fine_gain_0
  if { [catch {set fine_gain_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_gain_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {35} \
   CONFIG.GAIN_WIDTH {25} \
 ] $fine_gain_0

  # Create instance: minus_0p99, and set properties
  set minus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 minus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {25165841} \
   CONFIG.CONST_WIDTH {25} \
 ] $minus_0p99

  # Create instance: multi_GPIO_4
  create_hier_cell_multi_GPIO_4 $hier_obj multi_GPIO_4

  # Create instance: mux_2x1_with_valid_0, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_0
  if { [catch {set mux_2x1_with_valid_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {17} \
 ] $mux_2x1_with_valid_0

  # Create instance: mux_2x1_with_valid_1, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_1
  if { [catch {set mux_2x1_with_valid_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_2x1_with_valid_1

  # Create instance: mux_8x1_0, and set properties
  set block_name mux_8x1
  set block_cell_name mux_8x1_0
  if { [catch {set mux_8x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_8x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_8x1_0

  # Create instance: plus_0p99, and set properties
  set plus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 plus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {8388590} \
   CONFIG.CONST_WIDTH {25} \
 ] $plus_0p99

  # Create instance: triggered_gate_0, and set properties
  set block_name triggered_gate
  set block_cell_name triggered_gate_0
  if { [catch {set triggered_gate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $triggered_gate_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $triggered_gate_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {18} \
   CONFIG.IN1_WIDTH {17} \
 ] $xlconcat_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {9} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_2

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {18} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {9} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {35} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {5} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {25} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_4/S_AXI]

  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins DC_Block_IIR/clk_i] [get_bd_pins biquad_filter_0/clk_i] [get_bd_pins biquad_filter_1/clk_i] [get_bd_pins biquad_filter_2/clk_i] [get_bd_pins biquad_filter_3/clk_i] [get_bd_pins coarse_gain_and_limi_1/clk_i] [get_bd_pins fine_delay_line_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_4/clk_i] [get_bd_pins mux_2x1_with_valid_0/clk_i] [get_bd_pins mux_2x1_with_valid_1/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins triggered_gate_0/clk_i]
  connect_bd_net -net biquad_filter_0_data_o [get_bd_pins biquad_filter_0/data_o] [get_bd_pins biquad_filter_1/data_i] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net biquad_filter_0_data_valid_o [get_bd_pins biquad_filter_0/data_valid_o] [get_bd_pins biquad_filter_1/data_valid_i]
  connect_bd_net -net biquad_filter_1_data_o [get_bd_pins biquad_filter_1/data_o] [get_bd_pins biquad_filter_2/data_i] [get_bd_pins mux_8x1_0/in2_i]
  connect_bd_net -net biquad_filter_1_data_valid_o [get_bd_pins biquad_filter_1/data_valid_o] [get_bd_pins biquad_filter_2/data_valid_i]
  connect_bd_net -net biquad_filter_2_data_o [get_bd_pins biquad_filter_2/data_o] [get_bd_pins biquad_filter_3/data_i] [get_bd_pins mux_8x1_0/in1_i]
  connect_bd_net -net biquad_filter_2_data_valid_o [get_bd_pins biquad_filter_2/data_valid_o] [get_bd_pins biquad_filter_3/data_valid_i]
  connect_bd_net -net biquad_filter_3_data_o [get_bd_pins biquad_filter_3/data_o] [get_bd_pins mux_8x1_0/in0_i]
  connect_bd_net -net biquad_filter_4_data_o [get_bd_pins DC_Block_IIR/data_o] [get_bd_pins mux_2x1_with_valid_1/in1_i]
  connect_bd_net -net biquad_filter_4_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid1_i]
  connect_bd_net -net bram_delay_line_0_data0_o [get_bd_pins in0_i] [get_bd_pins mux_2x1_with_valid_0/in0_i]
  connect_bd_net -net bram_delay_line_0_data_valid0_o [get_bd_pins data_valid0_i] [get_bd_pins mux_2x1_with_valid_0/data_valid0_i]
  connect_bd_net -net bram_delay_line_1_data0_o [get_bd_pins in1_i] [get_bd_pins mux_2x1_with_valid_0/in1_i]
  connect_bd_net -net bram_delay_line_1_data_valid0_o [get_bd_pins data_valid1_i] [get_bd_pins mux_2x1_with_valid_0/data_valid1_i]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins coarse_gain_and_limi_1/data_o] [get_bd_pins triggered_gate_0/data_i]
  connect_bd_net -net decimate_and_delay_0_data_o [get_bd_pins biquad_filter_0/data_i] [get_bd_pins mux_2x1_with_valid_1/out_o] [get_bd_pins mux_8x1_0/in4_i]
  connect_bd_net -net delay_LSB_Dout [get_bd_pins delay_LSB/Dout] [get_bd_pins fine_delay_line_0/delay_i]
  connect_bd_net -net delay_MSB_Dout [get_bd_pins delay_MSB] [get_bd_pins delay_MSB/Dout]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins trig_i] [get_bd_pins triggered_gate_0/trig_i]
  connect_bd_net -net filter_input_mux_out_o [get_bd_pins DC_Block_IIR/data_i] [get_bd_pins fine_delay_line_0/data_o] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net fine_delay_line_0_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_i] [get_bd_pins fine_delay_line_0/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid0_i]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_1/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net minus_0p99_dout [get_bd_pins DC_Block_IIR/a1_i] [get_bd_pins DC_Block_IIR/b1_i] [get_bd_pins minus_0p99/dout]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_4/data0_o] [get_bd_pins mux_2x1_with_valid_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins biquad_filter_0/b2_i] [get_bd_pins multi_GPIO_4/data0_o1]
  connect_bd_net -net multi_GPIO_1_data0_o2 [get_bd_pins biquad_filter_2/b0_i] [get_bd_pins multi_GPIO_4/data0_o2]
  connect_bd_net -net multi_GPIO_1_data0_o3 [get_bd_pins multi_GPIO_4/data0_o3] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data1_o [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_4/data1_o]
  connect_bd_net -net multi_GPIO_1_data1_o1 [get_bd_pins biquad_filter_1/a1_i] [get_bd_pins multi_GPIO_4/data1_o1]
  connect_bd_net -net multi_GPIO_1_data1_o2 [get_bd_pins biquad_filter_2/b1_i] [get_bd_pins multi_GPIO_4/data1_o2]
  connect_bd_net -net multi_GPIO_1_data2_o [get_bd_pins multi_GPIO_4/data2_o] [get_bd_pins mux_2x1_with_valid_1/sel_i]
  connect_bd_net -net multi_GPIO_1_data2_o1 [get_bd_pins biquad_filter_1/a2_i] [get_bd_pins multi_GPIO_4/data2_o1]
  connect_bd_net -net multi_GPIO_1_data2_o2 [get_bd_pins biquad_filter_2/b2_i] [get_bd_pins multi_GPIO_4/data2_o2]
  connect_bd_net -net multi_GPIO_1_data2_o3 [get_bd_pins coarse_gain_and_limi_1/log2_gain_i] [get_bd_pins multi_GPIO_4/data2_o3]
  connect_bd_net -net multi_GPIO_1_data3_o [get_bd_pins delay_LSB/Din] [get_bd_pins delay_MSB/Din] [get_bd_pins multi_GPIO_4/data3_o]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins biquad_filter_1/b0_i] [get_bd_pins multi_GPIO_4/data3_o1]
  connect_bd_net -net multi_GPIO_1_data3_o2 [get_bd_pins biquad_filter_3/a1_i] [get_bd_pins multi_GPIO_4/data3_o2]
  connect_bd_net -net multi_GPIO_1_data3_o3 [get_bd_pins multi_GPIO_4/data3_o3] [get_bd_pins triggered_gate_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_1_data4_o [get_bd_pins biquad_filter_0/a1_i] [get_bd_pins multi_GPIO_4/data4_o]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins biquad_filter_1/b1_i] [get_bd_pins multi_GPIO_4/data4_o1]
  connect_bd_net -net multi_GPIO_1_data4_o2 [get_bd_pins biquad_filter_3/a2_i] [get_bd_pins multi_GPIO_4/data4_o2]
  connect_bd_net -net multi_GPIO_1_data4_o3 [get_bd_pins multi_GPIO_4/data4_o3] [get_bd_pins triggered_gate_0/toggle_cycles_i]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins biquad_filter_0/a2_i] [get_bd_pins multi_GPIO_4/data5_o]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins biquad_filter_1/b2_i] [get_bd_pins multi_GPIO_4/data5_o1]
  connect_bd_net -net multi_GPIO_1_data5_o2 [get_bd_pins biquad_filter_3/b0_i] [get_bd_pins multi_GPIO_4/data5_o2]
  connect_bd_net -net multi_GPIO_1_data5_o3 [get_bd_pins multi_GPIO_4/data5_o3] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins biquad_filter_0/b0_i] [get_bd_pins multi_GPIO_4/data6_o]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins biquad_filter_2/a1_i] [get_bd_pins multi_GPIO_4/data6_o1]
  connect_bd_net -net multi_GPIO_1_data6_o2 [get_bd_pins biquad_filter_3/b1_i] [get_bd_pins multi_GPIO_4/data6_o2]
  connect_bd_net -net multi_GPIO_1_data6_o3 [get_bd_pins multi_GPIO_4/data6_o3] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins biquad_filter_0/b1_i] [get_bd_pins multi_GPIO_4/data7_o]
  connect_bd_net -net multi_GPIO_1_data7_o1 [get_bd_pins biquad_filter_2/a2_i] [get_bd_pins multi_GPIO_4/data7_o1]
  connect_bd_net -net multi_GPIO_1_data7_o2 [get_bd_pins biquad_filter_3/b2_i] [get_bd_pins multi_GPIO_4/data7_o2]
  connect_bd_net -net mux_2x1_with_valid_0_data_valid_o [get_bd_pins fine_delay_line_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_0/data_valid_o]
  connect_bd_net -net mux_2x1_with_valid_0_out_o [get_bd_pins fine_delay_line_0/data_i] [get_bd_pins mux_2x1_with_valid_0/out_o]
  connect_bd_net -net mux_2x1_with_valid_1_data_valid_o [get_bd_pins biquad_filter_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_1/data_valid_o]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net plus_0p99_dout [get_bd_pins DC_Block_IIR/b0_i] [get_bd_pins plus_0p99/dout]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins multi_GPIO_4/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins DC_Block_IIR/rst_ni] [get_bd_pins biquad_filter_0/rst_ni] [get_bd_pins biquad_filter_1/rst_ni] [get_bd_pins biquad_filter_2/rst_ni] [get_bd_pins biquad_filter_3/rst_ni] [get_bd_pins coarse_gain_and_limi_1/rst_ni] [get_bd_pins fine_delay_line_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_4/s_axi_aresetn] [get_bd_pins mux_2x1_with_valid_0/rst_ni] [get_bd_pins mux_2x1_with_valid_1/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins triggered_gate_0/rst_ni]
  connect_bd_net -net triggered_gate_0_data_o [get_bd_pins data_o] [get_bd_pins triggered_gate_0/data_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins mux_2x1_with_valid_1/in0_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins mux_8x1_0/in5_i] [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins biquad_filter_0/reinit_i] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins biquad_filter_1/reinit_i] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins biquad_filter_2/reinit_i] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout1 [get_bd_pins biquad_filter_3/reinit_i] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins DC_Block_IIR/reinit_i] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net zero_dout [get_bd_pins DC_Block_IIR/a2_i] [get_bd_pins DC_Block_IIR/b2_i] [get_bd_pins zero/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: filter_block_2
proc create_hier_cell_filter_block_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_filter_block_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I data_valid0_i
  create_bd_pin -dir I data_valid1_i
  create_bd_pin -dir O -from 13 -to 0 delay_MSB
  create_bd_pin -dir I -from 16 -to 0 in0_i
  create_bd_pin -dir I -from 16 -to 0 in1_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I trig_i

  # Create instance: DC_Block_IIR, and set properties
  set block_name biquad_filter
  set block_cell_name DC_Block_IIR
  if { [catch {set DC_Block_IIR [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DC_Block_IIR eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $DC_Block_IIR

  # Create instance: biquad_filter_0, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_0
  if { [catch {set biquad_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_0

  # Create instance: biquad_filter_1, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_1
  if { [catch {set biquad_filter_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_1

  # Create instance: biquad_filter_2, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_2
  if { [catch {set biquad_filter_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_2

  # Create instance: biquad_filter_3, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_3
  if { [catch {set biquad_filter_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_3

  # Create instance: coarse_gain_and_limi_1, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_1
  if { [catch {set coarse_gain_and_limi_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_1

  # Create instance: delay_LSB, and set properties
  set delay_LSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_LSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {3} \
 ] $delay_LSB

  # Create instance: delay_MSB, and set properties
  set delay_MSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_MSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {14} \
 ] $delay_MSB

  # Create instance: fine_delay_line_0, and set properties
  set block_name fine_delay_line
  set block_cell_name fine_delay_line_0
  if { [catch {set fine_delay_line_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_delay_line_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fine_gain_0, and set properties
  set block_name fine_gain
  set block_cell_name fine_gain_0
  if { [catch {set fine_gain_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_gain_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {35} \
   CONFIG.GAIN_WIDTH {25} \
 ] $fine_gain_0

  # Create instance: minus_0p99, and set properties
  set minus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 minus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {25165841} \
   CONFIG.CONST_WIDTH {25} \
 ] $minus_0p99

  # Create instance: multi_GPIO_3
  create_hier_cell_multi_GPIO_3 $hier_obj multi_GPIO_3

  # Create instance: mux_2x1_with_valid_0, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_0
  if { [catch {set mux_2x1_with_valid_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {17} \
 ] $mux_2x1_with_valid_0

  # Create instance: mux_2x1_with_valid_1, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_1
  if { [catch {set mux_2x1_with_valid_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_2x1_with_valid_1

  # Create instance: mux_8x1_0, and set properties
  set block_name mux_8x1
  set block_cell_name mux_8x1_0
  if { [catch {set mux_8x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_8x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_8x1_0

  # Create instance: plus_0p99, and set properties
  set plus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 plus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {8388590} \
   CONFIG.CONST_WIDTH {25} \
 ] $plus_0p99

  # Create instance: triggered_gate_0, and set properties
  set block_name triggered_gate
  set block_cell_name triggered_gate_0
  if { [catch {set triggered_gate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $triggered_gate_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $triggered_gate_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {18} \
   CONFIG.IN1_WIDTH {17} \
 ] $xlconcat_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {9} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_2

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {18} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {9} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {35} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {5} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {25} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_3/S_AXI]

  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins DC_Block_IIR/clk_i] [get_bd_pins biquad_filter_0/clk_i] [get_bd_pins biquad_filter_1/clk_i] [get_bd_pins biquad_filter_2/clk_i] [get_bd_pins biquad_filter_3/clk_i] [get_bd_pins coarse_gain_and_limi_1/clk_i] [get_bd_pins fine_delay_line_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_3/clk_i] [get_bd_pins mux_2x1_with_valid_0/clk_i] [get_bd_pins mux_2x1_with_valid_1/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins triggered_gate_0/clk_i]
  connect_bd_net -net biquad_filter_0_data_o [get_bd_pins biquad_filter_0/data_o] [get_bd_pins biquad_filter_1/data_i] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net biquad_filter_0_data_valid_o [get_bd_pins biquad_filter_0/data_valid_o] [get_bd_pins biquad_filter_1/data_valid_i]
  connect_bd_net -net biquad_filter_1_data_o [get_bd_pins biquad_filter_1/data_o] [get_bd_pins biquad_filter_2/data_i] [get_bd_pins mux_8x1_0/in2_i]
  connect_bd_net -net biquad_filter_1_data_valid_o [get_bd_pins biquad_filter_1/data_valid_o] [get_bd_pins biquad_filter_2/data_valid_i]
  connect_bd_net -net biquad_filter_2_data_o [get_bd_pins biquad_filter_2/data_o] [get_bd_pins biquad_filter_3/data_i] [get_bd_pins mux_8x1_0/in1_i]
  connect_bd_net -net biquad_filter_2_data_valid_o [get_bd_pins biquad_filter_2/data_valid_o] [get_bd_pins biquad_filter_3/data_valid_i]
  connect_bd_net -net biquad_filter_3_data_o [get_bd_pins biquad_filter_3/data_o] [get_bd_pins mux_8x1_0/in0_i]
  connect_bd_net -net biquad_filter_4_data_o [get_bd_pins DC_Block_IIR/data_o] [get_bd_pins mux_2x1_with_valid_1/in1_i]
  connect_bd_net -net biquad_filter_4_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid1_i]
  connect_bd_net -net bram_delay_line_0_data0_o [get_bd_pins in0_i] [get_bd_pins mux_2x1_with_valid_0/in0_i]
  connect_bd_net -net bram_delay_line_0_data_valid0_o [get_bd_pins data_valid0_i] [get_bd_pins mux_2x1_with_valid_0/data_valid0_i]
  connect_bd_net -net bram_delay_line_1_data0_o [get_bd_pins in1_i] [get_bd_pins mux_2x1_with_valid_0/in1_i]
  connect_bd_net -net bram_delay_line_1_data_valid0_o [get_bd_pins data_valid1_i] [get_bd_pins mux_2x1_with_valid_0/data_valid1_i]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins coarse_gain_and_limi_1/data_o] [get_bd_pins triggered_gate_0/data_i]
  connect_bd_net -net decimate_and_delay_0_data_o [get_bd_pins biquad_filter_0/data_i] [get_bd_pins mux_2x1_with_valid_1/out_o] [get_bd_pins mux_8x1_0/in4_i]
  connect_bd_net -net delay_LSB_Dout [get_bd_pins delay_LSB/Dout] [get_bd_pins fine_delay_line_0/delay_i]
  connect_bd_net -net delay_MSB_Dout [get_bd_pins delay_MSB] [get_bd_pins delay_MSB/Dout]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins trig_i] [get_bd_pins triggered_gate_0/trig_i]
  connect_bd_net -net filter_input_mux_out_o [get_bd_pins DC_Block_IIR/data_i] [get_bd_pins fine_delay_line_0/data_o] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net fine_delay_line_0_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_i] [get_bd_pins fine_delay_line_0/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid0_i]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_1/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net minus_0p99_dout [get_bd_pins DC_Block_IIR/a1_i] [get_bd_pins DC_Block_IIR/b1_i] [get_bd_pins minus_0p99/dout]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_3/data0_o] [get_bd_pins mux_2x1_with_valid_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins biquad_filter_0/b2_i] [get_bd_pins multi_GPIO_3/data0_o1]
  connect_bd_net -net multi_GPIO_1_data0_o2 [get_bd_pins biquad_filter_2/b0_i] [get_bd_pins multi_GPIO_3/data0_o2]
  connect_bd_net -net multi_GPIO_1_data0_o3 [get_bd_pins multi_GPIO_3/data0_o3] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data1_o [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_3/data1_o]
  connect_bd_net -net multi_GPIO_1_data1_o1 [get_bd_pins biquad_filter_1/a1_i] [get_bd_pins multi_GPIO_3/data1_o1]
  connect_bd_net -net multi_GPIO_1_data1_o2 [get_bd_pins biquad_filter_2/b1_i] [get_bd_pins multi_GPIO_3/data1_o2]
  connect_bd_net -net multi_GPIO_1_data2_o [get_bd_pins multi_GPIO_3/data2_o] [get_bd_pins mux_2x1_with_valid_1/sel_i]
  connect_bd_net -net multi_GPIO_1_data2_o1 [get_bd_pins biquad_filter_1/a2_i] [get_bd_pins multi_GPIO_3/data2_o1]
  connect_bd_net -net multi_GPIO_1_data2_o2 [get_bd_pins biquad_filter_2/b2_i] [get_bd_pins multi_GPIO_3/data2_o2]
  connect_bd_net -net multi_GPIO_1_data2_o3 [get_bd_pins coarse_gain_and_limi_1/log2_gain_i] [get_bd_pins multi_GPIO_3/data2_o3]
  connect_bd_net -net multi_GPIO_1_data3_o [get_bd_pins delay_LSB/Din] [get_bd_pins delay_MSB/Din] [get_bd_pins multi_GPIO_3/data3_o]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins biquad_filter_1/b0_i] [get_bd_pins multi_GPIO_3/data3_o1]
  connect_bd_net -net multi_GPIO_1_data3_o2 [get_bd_pins biquad_filter_3/a1_i] [get_bd_pins multi_GPIO_3/data3_o2]
  connect_bd_net -net multi_GPIO_1_data3_o3 [get_bd_pins multi_GPIO_3/data3_o3] [get_bd_pins triggered_gate_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_1_data4_o [get_bd_pins biquad_filter_0/a1_i] [get_bd_pins multi_GPIO_3/data4_o]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins biquad_filter_1/b1_i] [get_bd_pins multi_GPIO_3/data4_o1]
  connect_bd_net -net multi_GPIO_1_data4_o2 [get_bd_pins biquad_filter_3/a2_i] [get_bd_pins multi_GPIO_3/data4_o2]
  connect_bd_net -net multi_GPIO_1_data4_o3 [get_bd_pins multi_GPIO_3/data4_o3] [get_bd_pins triggered_gate_0/toggle_cycles_i]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins biquad_filter_0/a2_i] [get_bd_pins multi_GPIO_3/data5_o]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins biquad_filter_1/b2_i] [get_bd_pins multi_GPIO_3/data5_o1]
  connect_bd_net -net multi_GPIO_1_data5_o2 [get_bd_pins biquad_filter_3/b0_i] [get_bd_pins multi_GPIO_3/data5_o2]
  connect_bd_net -net multi_GPIO_1_data5_o3 [get_bd_pins multi_GPIO_3/data5_o3] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins biquad_filter_0/b0_i] [get_bd_pins multi_GPIO_3/data6_o]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins biquad_filter_2/a1_i] [get_bd_pins multi_GPIO_3/data6_o1]
  connect_bd_net -net multi_GPIO_1_data6_o2 [get_bd_pins biquad_filter_3/b1_i] [get_bd_pins multi_GPIO_3/data6_o2]
  connect_bd_net -net multi_GPIO_1_data6_o3 [get_bd_pins multi_GPIO_3/data6_o3] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins biquad_filter_0/b1_i] [get_bd_pins multi_GPIO_3/data7_o]
  connect_bd_net -net multi_GPIO_1_data7_o1 [get_bd_pins biquad_filter_2/a2_i] [get_bd_pins multi_GPIO_3/data7_o1]
  connect_bd_net -net multi_GPIO_1_data7_o2 [get_bd_pins biquad_filter_3/b2_i] [get_bd_pins multi_GPIO_3/data7_o2]
  connect_bd_net -net mux_2x1_with_valid_0_data_valid_o [get_bd_pins fine_delay_line_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_0/data_valid_o]
  connect_bd_net -net mux_2x1_with_valid_0_out_o [get_bd_pins fine_delay_line_0/data_i] [get_bd_pins mux_2x1_with_valid_0/out_o]
  connect_bd_net -net mux_2x1_with_valid_1_data_valid_o [get_bd_pins biquad_filter_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_1/data_valid_o]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net plus_0p99_dout [get_bd_pins DC_Block_IIR/b0_i] [get_bd_pins plus_0p99/dout]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins multi_GPIO_3/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins DC_Block_IIR/rst_ni] [get_bd_pins biquad_filter_0/rst_ni] [get_bd_pins biquad_filter_1/rst_ni] [get_bd_pins biquad_filter_2/rst_ni] [get_bd_pins biquad_filter_3/rst_ni] [get_bd_pins coarse_gain_and_limi_1/rst_ni] [get_bd_pins fine_delay_line_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_3/s_axi_aresetn] [get_bd_pins mux_2x1_with_valid_0/rst_ni] [get_bd_pins mux_2x1_with_valid_1/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins triggered_gate_0/rst_ni]
  connect_bd_net -net triggered_gate_0_data_o [get_bd_pins data_o] [get_bd_pins triggered_gate_0/data_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins mux_2x1_with_valid_1/in0_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins mux_8x1_0/in5_i] [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins biquad_filter_0/reinit_i] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins biquad_filter_1/reinit_i] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins biquad_filter_2/reinit_i] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout1 [get_bd_pins biquad_filter_3/reinit_i] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins DC_Block_IIR/reinit_i] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net zero_dout [get_bd_pins DC_Block_IIR/a2_i] [get_bd_pins DC_Block_IIR/b2_i] [get_bd_pins zero/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: filter_block_1
proc create_hier_cell_filter_block_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_filter_block_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I data_valid0_i
  create_bd_pin -dir I data_valid1_i
  create_bd_pin -dir O -from 13 -to 0 delay_MSB
  create_bd_pin -dir I -from 16 -to 0 in0_i
  create_bd_pin -dir I -from 16 -to 0 in1_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I trig_i

  # Create instance: DC_Block_IIR, and set properties
  set block_name biquad_filter
  set block_cell_name DC_Block_IIR
  if { [catch {set DC_Block_IIR [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DC_Block_IIR eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $DC_Block_IIR

  # Create instance: biquad_filter_0, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_0
  if { [catch {set biquad_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_0

  # Create instance: biquad_filter_1, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_1
  if { [catch {set biquad_filter_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_1

  # Create instance: biquad_filter_2, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_2
  if { [catch {set biquad_filter_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_2

  # Create instance: biquad_filter_3, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_3
  if { [catch {set biquad_filter_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_3

  # Create instance: coarse_gain_and_limi_1, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_1
  if { [catch {set coarse_gain_and_limi_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_1

  # Create instance: delay_LSB, and set properties
  set delay_LSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_LSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {3} \
 ] $delay_LSB

  # Create instance: delay_MSB, and set properties
  set delay_MSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_MSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {14} \
 ] $delay_MSB

  # Create instance: fine_delay_line_0, and set properties
  set block_name fine_delay_line
  set block_cell_name fine_delay_line_0
  if { [catch {set fine_delay_line_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_delay_line_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fine_gain_0, and set properties
  set block_name fine_gain
  set block_cell_name fine_gain_0
  if { [catch {set fine_gain_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_gain_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {35} \
   CONFIG.GAIN_WIDTH {25} \
 ] $fine_gain_0

  # Create instance: minus_0p99, and set properties
  set minus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 minus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {25165841} \
   CONFIG.CONST_WIDTH {25} \
 ] $minus_0p99

  # Create instance: multi_GPIO_2
  create_hier_cell_multi_GPIO_2 $hier_obj multi_GPIO_2

  # Create instance: mux_2x1_with_valid_0, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_0
  if { [catch {set mux_2x1_with_valid_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {17} \
 ] $mux_2x1_with_valid_0

  # Create instance: mux_2x1_with_valid_1, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_1
  if { [catch {set mux_2x1_with_valid_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_2x1_with_valid_1

  # Create instance: mux_8x1_0, and set properties
  set block_name mux_8x1
  set block_cell_name mux_8x1_0
  if { [catch {set mux_8x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_8x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_8x1_0

  # Create instance: plus_0p99, and set properties
  set plus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 plus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {8388590} \
   CONFIG.CONST_WIDTH {25} \
 ] $plus_0p99

  # Create instance: triggered_gate_0, and set properties
  set block_name triggered_gate
  set block_cell_name triggered_gate_0
  if { [catch {set triggered_gate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $triggered_gate_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $triggered_gate_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {18} \
   CONFIG.IN1_WIDTH {17} \
 ] $xlconcat_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {9} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_2

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {18} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {9} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {35} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {5} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {25} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_2/S_AXI]

  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins DC_Block_IIR/clk_i] [get_bd_pins biquad_filter_0/clk_i] [get_bd_pins biquad_filter_1/clk_i] [get_bd_pins biquad_filter_2/clk_i] [get_bd_pins biquad_filter_3/clk_i] [get_bd_pins coarse_gain_and_limi_1/clk_i] [get_bd_pins fine_delay_line_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_2/clk_i] [get_bd_pins mux_2x1_with_valid_0/clk_i] [get_bd_pins mux_2x1_with_valid_1/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins triggered_gate_0/clk_i]
  connect_bd_net -net biquad_filter_0_data_o [get_bd_pins biquad_filter_0/data_o] [get_bd_pins biquad_filter_1/data_i] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net biquad_filter_0_data_valid_o [get_bd_pins biquad_filter_0/data_valid_o] [get_bd_pins biquad_filter_1/data_valid_i]
  connect_bd_net -net biquad_filter_1_data_o [get_bd_pins biquad_filter_1/data_o] [get_bd_pins biquad_filter_2/data_i] [get_bd_pins mux_8x1_0/in2_i]
  connect_bd_net -net biquad_filter_1_data_valid_o [get_bd_pins biquad_filter_1/data_valid_o] [get_bd_pins biquad_filter_2/data_valid_i]
  connect_bd_net -net biquad_filter_2_data_o [get_bd_pins biquad_filter_2/data_o] [get_bd_pins biquad_filter_3/data_i] [get_bd_pins mux_8x1_0/in1_i]
  connect_bd_net -net biquad_filter_2_data_valid_o [get_bd_pins biquad_filter_2/data_valid_o] [get_bd_pins biquad_filter_3/data_valid_i]
  connect_bd_net -net biquad_filter_3_data_o [get_bd_pins biquad_filter_3/data_o] [get_bd_pins mux_8x1_0/in0_i]
  connect_bd_net -net biquad_filter_4_data_o [get_bd_pins DC_Block_IIR/data_o] [get_bd_pins mux_2x1_with_valid_1/in1_i]
  connect_bd_net -net biquad_filter_4_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid1_i]
  connect_bd_net -net bram_delay_line_0_data0_o [get_bd_pins in0_i] [get_bd_pins mux_2x1_with_valid_0/in0_i]
  connect_bd_net -net bram_delay_line_0_data_valid0_o [get_bd_pins data_valid0_i] [get_bd_pins mux_2x1_with_valid_0/data_valid0_i]
  connect_bd_net -net bram_delay_line_1_data0_o [get_bd_pins in1_i] [get_bd_pins mux_2x1_with_valid_0/in1_i]
  connect_bd_net -net bram_delay_line_1_data_valid0_o [get_bd_pins data_valid1_i] [get_bd_pins mux_2x1_with_valid_0/data_valid1_i]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins coarse_gain_and_limi_1/data_o] [get_bd_pins triggered_gate_0/data_i]
  connect_bd_net -net decimate_and_delay_0_data_o [get_bd_pins biquad_filter_0/data_i] [get_bd_pins mux_2x1_with_valid_1/out_o] [get_bd_pins mux_8x1_0/in4_i]
  connect_bd_net -net delay_LSB_Dout [get_bd_pins delay_LSB/Dout] [get_bd_pins fine_delay_line_0/delay_i]
  connect_bd_net -net delay_MSB_Dout [get_bd_pins delay_MSB] [get_bd_pins delay_MSB/Dout]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins trig_i] [get_bd_pins triggered_gate_0/trig_i]
  connect_bd_net -net filter_input_mux_out_o [get_bd_pins DC_Block_IIR/data_i] [get_bd_pins fine_delay_line_0/data_o] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net fine_delay_line_0_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_i] [get_bd_pins fine_delay_line_0/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid0_i]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_1/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net minus_0p99_dout [get_bd_pins DC_Block_IIR/a1_i] [get_bd_pins DC_Block_IIR/b1_i] [get_bd_pins minus_0p99/dout]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_2/data0_o] [get_bd_pins mux_2x1_with_valid_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins biquad_filter_0/b2_i] [get_bd_pins multi_GPIO_2/data0_o1]
  connect_bd_net -net multi_GPIO_1_data0_o2 [get_bd_pins biquad_filter_2/b0_i] [get_bd_pins multi_GPIO_2/data0_o2]
  connect_bd_net -net multi_GPIO_1_data0_o3 [get_bd_pins multi_GPIO_2/data0_o3] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data1_o [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_2/data1_o]
  connect_bd_net -net multi_GPIO_1_data1_o1 [get_bd_pins biquad_filter_1/a1_i] [get_bd_pins multi_GPIO_2/data1_o1]
  connect_bd_net -net multi_GPIO_1_data1_o2 [get_bd_pins biquad_filter_2/b1_i] [get_bd_pins multi_GPIO_2/data1_o2]
  connect_bd_net -net multi_GPIO_1_data2_o [get_bd_pins multi_GPIO_2/data2_o] [get_bd_pins mux_2x1_with_valid_1/sel_i]
  connect_bd_net -net multi_GPIO_1_data2_o1 [get_bd_pins biquad_filter_1/a2_i] [get_bd_pins multi_GPIO_2/data2_o1]
  connect_bd_net -net multi_GPIO_1_data2_o2 [get_bd_pins biquad_filter_2/b2_i] [get_bd_pins multi_GPIO_2/data2_o2]
  connect_bd_net -net multi_GPIO_1_data2_o3 [get_bd_pins coarse_gain_and_limi_1/log2_gain_i] [get_bd_pins multi_GPIO_2/data2_o3]
  connect_bd_net -net multi_GPIO_1_data3_o [get_bd_pins delay_LSB/Din] [get_bd_pins delay_MSB/Din] [get_bd_pins multi_GPIO_2/data3_o]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins biquad_filter_1/b0_i] [get_bd_pins multi_GPIO_2/data3_o1]
  connect_bd_net -net multi_GPIO_1_data3_o2 [get_bd_pins biquad_filter_3/a1_i] [get_bd_pins multi_GPIO_2/data3_o2]
  connect_bd_net -net multi_GPIO_1_data3_o3 [get_bd_pins multi_GPIO_2/data3_o3] [get_bd_pins triggered_gate_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_1_data4_o [get_bd_pins biquad_filter_0/a1_i] [get_bd_pins multi_GPIO_2/data4_o]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins biquad_filter_1/b1_i] [get_bd_pins multi_GPIO_2/data4_o1]
  connect_bd_net -net multi_GPIO_1_data4_o2 [get_bd_pins biquad_filter_3/a2_i] [get_bd_pins multi_GPIO_2/data4_o2]
  connect_bd_net -net multi_GPIO_1_data4_o3 [get_bd_pins multi_GPIO_2/data4_o3] [get_bd_pins triggered_gate_0/toggle_cycles_i]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins biquad_filter_0/a2_i] [get_bd_pins multi_GPIO_2/data5_o]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins biquad_filter_1/b2_i] [get_bd_pins multi_GPIO_2/data5_o1]
  connect_bd_net -net multi_GPIO_1_data5_o2 [get_bd_pins biquad_filter_3/b0_i] [get_bd_pins multi_GPIO_2/data5_o2]
  connect_bd_net -net multi_GPIO_1_data5_o3 [get_bd_pins multi_GPIO_2/data5_o3] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins biquad_filter_0/b0_i] [get_bd_pins multi_GPIO_2/data6_o]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins biquad_filter_2/a1_i] [get_bd_pins multi_GPIO_2/data6_o1]
  connect_bd_net -net multi_GPIO_1_data6_o2 [get_bd_pins biquad_filter_3/b1_i] [get_bd_pins multi_GPIO_2/data6_o2]
  connect_bd_net -net multi_GPIO_1_data6_o3 [get_bd_pins multi_GPIO_2/data6_o3] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins biquad_filter_0/b1_i] [get_bd_pins multi_GPIO_2/data7_o]
  connect_bd_net -net multi_GPIO_1_data7_o1 [get_bd_pins biquad_filter_2/a2_i] [get_bd_pins multi_GPIO_2/data7_o1]
  connect_bd_net -net multi_GPIO_1_data7_o2 [get_bd_pins biquad_filter_3/b2_i] [get_bd_pins multi_GPIO_2/data7_o2]
  connect_bd_net -net mux_2x1_with_valid_0_data_valid_o [get_bd_pins fine_delay_line_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_0/data_valid_o]
  connect_bd_net -net mux_2x1_with_valid_0_out_o [get_bd_pins fine_delay_line_0/data_i] [get_bd_pins mux_2x1_with_valid_0/out_o]
  connect_bd_net -net mux_2x1_with_valid_1_data_valid_o [get_bd_pins biquad_filter_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_1/data_valid_o]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net plus_0p99_dout [get_bd_pins DC_Block_IIR/b0_i] [get_bd_pins plus_0p99/dout]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins multi_GPIO_2/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins DC_Block_IIR/rst_ni] [get_bd_pins biquad_filter_0/rst_ni] [get_bd_pins biquad_filter_1/rst_ni] [get_bd_pins biquad_filter_2/rst_ni] [get_bd_pins biquad_filter_3/rst_ni] [get_bd_pins coarse_gain_and_limi_1/rst_ni] [get_bd_pins fine_delay_line_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_2/s_axi_aresetn] [get_bd_pins mux_2x1_with_valid_0/rst_ni] [get_bd_pins mux_2x1_with_valid_1/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins triggered_gate_0/rst_ni]
  connect_bd_net -net triggered_gate_0_data_o [get_bd_pins data_o] [get_bd_pins triggered_gate_0/data_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins mux_2x1_with_valid_1/in0_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins mux_8x1_0/in5_i] [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins biquad_filter_0/reinit_i] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins biquad_filter_1/reinit_i] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins biquad_filter_2/reinit_i] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout1 [get_bd_pins biquad_filter_3/reinit_i] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins DC_Block_IIR/reinit_i] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net zero_dout [get_bd_pins DC_Block_IIR/a2_i] [get_bd_pins DC_Block_IIR/b2_i] [get_bd_pins zero/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: filter_block_0
proc create_hier_cell_filter_block_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_filter_block_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I data_valid0_i
  create_bd_pin -dir I data_valid1_i
  create_bd_pin -dir O -from 13 -to 0 delay_MSB
  create_bd_pin -dir I -from 16 -to 0 in0_i
  create_bd_pin -dir I -from 16 -to 0 in1_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I trig_i

  # Create instance: DC_Block_IIR, and set properties
  set block_name biquad_filter
  set block_cell_name DC_Block_IIR
  if { [catch {set DC_Block_IIR [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DC_Block_IIR eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $DC_Block_IIR

  # Create instance: biquad_filter_0, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_0
  if { [catch {set biquad_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_0

  # Create instance: biquad_filter_1, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_1
  if { [catch {set biquad_filter_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_1

  # Create instance: biquad_filter_2, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_2
  if { [catch {set biquad_filter_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_2

  # Create instance: biquad_filter_3, and set properties
  set block_name biquad_filter
  set block_cell_name biquad_filter_3
  if { [catch {set biquad_filter_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $biquad_filter_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COEFF_WIDTH {25} \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.OUTPUT_WIDTH {35} \
 ] $biquad_filter_3

  # Create instance: coarse_gain_and_limi_1, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_1
  if { [catch {set coarse_gain_and_limi_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {35} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_1

  # Create instance: delay_LSB, and set properties
  set delay_LSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_LSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {3} \
 ] $delay_LSB

  # Create instance: delay_MSB, and set properties
  set delay_MSB [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 delay_MSB ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {17} \
   CONFIG.DOUT_WIDTH {14} \
 ] $delay_MSB

  # Create instance: fine_delay_line_0, and set properties
  set block_name fine_delay_line
  set block_cell_name fine_delay_line_0
  if { [catch {set fine_delay_line_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_delay_line_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fine_gain_0, and set properties
  set block_name fine_gain
  set block_cell_name fine_gain_0
  if { [catch {set fine_gain_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fine_gain_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {35} \
   CONFIG.GAIN_WIDTH {25} \
 ] $fine_gain_0

  # Create instance: minus_0p99, and set properties
  set minus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 minus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {25165841} \
   CONFIG.CONST_WIDTH {25} \
 ] $minus_0p99

  # Create instance: multi_GPIO_1
  create_hier_cell_multi_GPIO_1 $hier_obj multi_GPIO_1

  # Create instance: mux_2x1_with_valid_0, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_0
  if { [catch {set mux_2x1_with_valid_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {17} \
 ] $mux_2x1_with_valid_0

  # Create instance: mux_2x1_with_valid_1, and set properties
  set block_name mux_2x1_with_valid
  set block_cell_name mux_2x1_with_valid_1
  if { [catch {set mux_2x1_with_valid_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_with_valid_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_2x1_with_valid_1

  # Create instance: mux_8x1_0, and set properties
  set block_name mux_8x1
  set block_cell_name mux_8x1_0
  if { [catch {set mux_8x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_8x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {35} \
 ] $mux_8x1_0

  # Create instance: plus_0p99, and set properties
  set plus_0p99 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 plus_0p99 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {8388590} \
   CONFIG.CONST_WIDTH {25} \
 ] $plus_0p99

  # Create instance: triggered_gate_0, and set properties
  set block_name triggered_gate
  set block_cell_name triggered_gate_0
  if { [catch {set triggered_gate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $triggered_gate_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $triggered_gate_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {18} \
   CONFIG.IN1_WIDTH {17} \
 ] $xlconcat_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {9} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_2

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {18} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {9} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {35} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {5} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {25} \
 ] $zero

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_1/S_AXI]

  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_i] [get_bd_pins DC_Block_IIR/clk_i] [get_bd_pins biquad_filter_0/clk_i] [get_bd_pins biquad_filter_1/clk_i] [get_bd_pins biquad_filter_2/clk_i] [get_bd_pins biquad_filter_3/clk_i] [get_bd_pins coarse_gain_and_limi_1/clk_i] [get_bd_pins fine_delay_line_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_1/clk_i] [get_bd_pins mux_2x1_with_valid_0/clk_i] [get_bd_pins mux_2x1_with_valid_1/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins triggered_gate_0/clk_i]
  connect_bd_net -net biquad_filter_0_data_o [get_bd_pins biquad_filter_0/data_o] [get_bd_pins biquad_filter_1/data_i] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net biquad_filter_0_data_valid_o [get_bd_pins biquad_filter_0/data_valid_o] [get_bd_pins biquad_filter_1/data_valid_i]
  connect_bd_net -net biquad_filter_1_data_o [get_bd_pins biquad_filter_1/data_o] [get_bd_pins biquad_filter_2/data_i] [get_bd_pins mux_8x1_0/in2_i]
  connect_bd_net -net biquad_filter_1_data_valid_o [get_bd_pins biquad_filter_1/data_valid_o] [get_bd_pins biquad_filter_2/data_valid_i]
  connect_bd_net -net biquad_filter_2_data_o [get_bd_pins biquad_filter_2/data_o] [get_bd_pins biquad_filter_3/data_i] [get_bd_pins mux_8x1_0/in1_i]
  connect_bd_net -net biquad_filter_2_data_valid_o [get_bd_pins biquad_filter_2/data_valid_o] [get_bd_pins biquad_filter_3/data_valid_i]
  connect_bd_net -net biquad_filter_3_data_o [get_bd_pins biquad_filter_3/data_o] [get_bd_pins mux_8x1_0/in0_i]
  connect_bd_net -net biquad_filter_4_data_o [get_bd_pins DC_Block_IIR/data_o] [get_bd_pins mux_2x1_with_valid_1/in1_i]
  connect_bd_net -net biquad_filter_4_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid1_i]
  connect_bd_net -net bram_delay_line_0_data0_o [get_bd_pins in0_i] [get_bd_pins mux_2x1_with_valid_0/in0_i]
  connect_bd_net -net bram_delay_line_0_data_valid0_o [get_bd_pins data_valid0_i] [get_bd_pins mux_2x1_with_valid_0/data_valid0_i]
  connect_bd_net -net bram_delay_line_1_data0_o [get_bd_pins in1_i] [get_bd_pins mux_2x1_with_valid_0/in1_i]
  connect_bd_net -net bram_delay_line_1_data_valid0_o [get_bd_pins data_valid1_i] [get_bd_pins mux_2x1_with_valid_0/data_valid1_i]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins coarse_gain_and_limi_1/data_o] [get_bd_pins triggered_gate_0/data_i]
  connect_bd_net -net decimate_and_delay_0_data_o [get_bd_pins biquad_filter_0/data_i] [get_bd_pins mux_2x1_with_valid_1/out_o] [get_bd_pins mux_8x1_0/in4_i]
  connect_bd_net -net delay_LSB_Dout [get_bd_pins delay_LSB/Dout] [get_bd_pins fine_delay_line_0/delay_i]
  connect_bd_net -net delay_MSB_Dout [get_bd_pins delay_MSB] [get_bd_pins delay_MSB/Dout]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins trig_i] [get_bd_pins triggered_gate_0/trig_i]
  connect_bd_net -net filter_input_mux_out_o [get_bd_pins DC_Block_IIR/data_i] [get_bd_pins fine_delay_line_0/data_o] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net fine_delay_line_0_data_valid_o [get_bd_pins DC_Block_IIR/data_valid_i] [get_bd_pins fine_delay_line_0/data_valid_o] [get_bd_pins mux_2x1_with_valid_1/data_valid0_i]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_1/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net minus_0p99_dout [get_bd_pins DC_Block_IIR/a1_i] [get_bd_pins DC_Block_IIR/b1_i] [get_bd_pins minus_0p99/dout]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_1/data0_o] [get_bd_pins mux_2x1_with_valid_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins biquad_filter_0/b2_i] [get_bd_pins multi_GPIO_1/data0_o1]
  connect_bd_net -net multi_GPIO_1_data0_o2 [get_bd_pins biquad_filter_2/b0_i] [get_bd_pins multi_GPIO_1/data0_o2]
  connect_bd_net -net multi_GPIO_1_data0_o3 [get_bd_pins multi_GPIO_1/data0_o3] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data1_o [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_1/data1_o]
  connect_bd_net -net multi_GPIO_1_data1_o1 [get_bd_pins biquad_filter_1/a1_i] [get_bd_pins multi_GPIO_1/data1_o1]
  connect_bd_net -net multi_GPIO_1_data1_o2 [get_bd_pins biquad_filter_2/b1_i] [get_bd_pins multi_GPIO_1/data1_o2]
  connect_bd_net -net multi_GPIO_1_data2_o [get_bd_pins multi_GPIO_1/data2_o] [get_bd_pins mux_2x1_with_valid_1/sel_i]
  connect_bd_net -net multi_GPIO_1_data2_o1 [get_bd_pins biquad_filter_1/a2_i] [get_bd_pins multi_GPIO_1/data2_o1]
  connect_bd_net -net multi_GPIO_1_data2_o2 [get_bd_pins biquad_filter_2/b2_i] [get_bd_pins multi_GPIO_1/data2_o2]
  connect_bd_net -net multi_GPIO_1_data2_o3 [get_bd_pins coarse_gain_and_limi_1/log2_gain_i] [get_bd_pins multi_GPIO_1/data2_o3]
  connect_bd_net -net multi_GPIO_1_data3_o [get_bd_pins delay_LSB/Din] [get_bd_pins delay_MSB/Din] [get_bd_pins multi_GPIO_1/data3_o]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins biquad_filter_1/b0_i] [get_bd_pins multi_GPIO_1/data3_o1]
  connect_bd_net -net multi_GPIO_1_data3_o2 [get_bd_pins biquad_filter_3/a1_i] [get_bd_pins multi_GPIO_1/data3_o2]
  connect_bd_net -net multi_GPIO_1_data3_o3 [get_bd_pins multi_GPIO_1/data3_o3] [get_bd_pins triggered_gate_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_1_data4_o [get_bd_pins biquad_filter_0/a1_i] [get_bd_pins multi_GPIO_1/data4_o]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins biquad_filter_1/b1_i] [get_bd_pins multi_GPIO_1/data4_o1]
  connect_bd_net -net multi_GPIO_1_data4_o2 [get_bd_pins biquad_filter_3/a2_i] [get_bd_pins multi_GPIO_1/data4_o2]
  connect_bd_net -net multi_GPIO_1_data4_o3 [get_bd_pins multi_GPIO_1/data4_o3] [get_bd_pins triggered_gate_0/toggle_cycles_i]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins biquad_filter_0/a2_i] [get_bd_pins multi_GPIO_1/data5_o]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins biquad_filter_1/b2_i] [get_bd_pins multi_GPIO_1/data5_o1]
  connect_bd_net -net multi_GPIO_1_data5_o2 [get_bd_pins biquad_filter_3/b0_i] [get_bd_pins multi_GPIO_1/data5_o2]
  connect_bd_net -net multi_GPIO_1_data5_o3 [get_bd_pins multi_GPIO_1/data5_o3] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins biquad_filter_0/b0_i] [get_bd_pins multi_GPIO_1/data6_o]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins biquad_filter_2/a1_i] [get_bd_pins multi_GPIO_1/data6_o1]
  connect_bd_net -net multi_GPIO_1_data6_o2 [get_bd_pins biquad_filter_3/b1_i] [get_bd_pins multi_GPIO_1/data6_o2]
  connect_bd_net -net multi_GPIO_1_data6_o3 [get_bd_pins multi_GPIO_1/data6_o3] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins biquad_filter_0/b1_i] [get_bd_pins multi_GPIO_1/data7_o]
  connect_bd_net -net multi_GPIO_1_data7_o1 [get_bd_pins biquad_filter_2/a2_i] [get_bd_pins multi_GPIO_1/data7_o1]
  connect_bd_net -net multi_GPIO_1_data7_o2 [get_bd_pins biquad_filter_3/b2_i] [get_bd_pins multi_GPIO_1/data7_o2]
  connect_bd_net -net mux_2x1_with_valid_0_data_valid_o [get_bd_pins fine_delay_line_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_0/data_valid_o]
  connect_bd_net -net mux_2x1_with_valid_0_out_o [get_bd_pins fine_delay_line_0/data_i] [get_bd_pins mux_2x1_with_valid_0/out_o]
  connect_bd_net -net mux_2x1_with_valid_1_data_valid_o [get_bd_pins biquad_filter_0/data_valid_i] [get_bd_pins mux_2x1_with_valid_1/data_valid_o]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net plus_0p99_dout [get_bd_pins DC_Block_IIR/b0_i] [get_bd_pins plus_0p99/dout]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins multi_GPIO_1/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins DC_Block_IIR/rst_ni] [get_bd_pins biquad_filter_0/rst_ni] [get_bd_pins biquad_filter_1/rst_ni] [get_bd_pins biquad_filter_2/rst_ni] [get_bd_pins biquad_filter_3/rst_ni] [get_bd_pins coarse_gain_and_limi_1/rst_ni] [get_bd_pins fine_delay_line_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_1/s_axi_aresetn] [get_bd_pins mux_2x1_with_valid_0/rst_ni] [get_bd_pins mux_2x1_with_valid_1/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins triggered_gate_0/rst_ni]
  connect_bd_net -net triggered_gate_0_data_o [get_bd_pins data_o] [get_bd_pins triggered_gate_0/data_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins mux_2x1_with_valid_1/in0_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins mux_8x1_0/in5_i] [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins biquad_filter_0/reinit_i] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins biquad_filter_1/reinit_i] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins biquad_filter_2/reinit_i] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout1 [get_bd_pins biquad_filter_3/reinit_i] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins DC_Block_IIR/reinit_i] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net zero_dout [get_bd_pins DC_Block_IIR/a2_i] [get_bd_pins DC_Block_IIR/b2_i] [get_bd_pins zero/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dac_mux
proc create_hier_cell_dac_mux { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dac_mux() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir O -type clk dac_clk_o
  create_bd_pin -dir O -from 13 -to 0 dac_dat_o
  create_bd_pin -dir O -type rst dac_rst_o
  create_bd_pin -dir O dac_sel_o
  create_bd_pin -dir O dac_wrt_o
  create_bd_pin -dir I -from 13 -to 0 in0_1
  create_bd_pin -dir I -from 13 -to 0 in1_i
  create_bd_pin -dir I -from 13 -to 0 in2_i
  create_bd_pin -dir I -from 13 -to 0 in3_i
  create_bd_pin -dir I -from 13 -to 0 in4_i
  create_bd_pin -dir I -from 13 -to 0 in5_i
  create_bd_pin -dir I -from 13 -to 0 in6_i
  create_bd_pin -dir I -from 13 -to 0 in7_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I -from 2 -to 0 select0_i
  create_bd_pin -dir I -from 2 -to 0 select1_i

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {104.759} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PRIM_IN_FREQ {125.000} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: mux_8x2_0, and set properties
  set block_name mux_8x2
  set block_cell_name mux_8x2_0
  if { [catch {set mux_8x2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_8x2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: red_pitaya_dac_0, and set properties
  set block_name red_pitaya_dac
  set block_cell_name red_pitaya_dac_0
  if { [catch {set red_pitaya_dac_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $red_pitaya_dac_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins clk_in1] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins mux_8x2_0/clk_i] [get_bd_pins red_pitaya_dac_0/aclk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins red_pitaya_dac_0/ddr_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins red_pitaya_dac_0/locked]
  connect_bd_net -net in0_1_1 [get_bd_pins in0_1] [get_bd_pins mux_8x2_0/in0_i]
  connect_bd_net -net in1_i_1 [get_bd_pins in1_i] [get_bd_pins mux_8x2_0/in1_i]
  connect_bd_net -net in2_i_1 [get_bd_pins in2_i] [get_bd_pins mux_8x2_0/in2_i]
  connect_bd_net -net in3_i_1 [get_bd_pins in3_i] [get_bd_pins mux_8x2_0/in3_i]
  connect_bd_net -net in4_i_1 [get_bd_pins in4_i] [get_bd_pins mux_8x2_0/in4_i]
  connect_bd_net -net in5_i_1 [get_bd_pins in5_i] [get_bd_pins mux_8x2_0/in5_i]
  connect_bd_net -net in6_i_1 [get_bd_pins in6_i] [get_bd_pins mux_8x2_0/in6_i]
  connect_bd_net -net in7_i_1 [get_bd_pins in7_i] [get_bd_pins mux_8x2_0/in7_i]
  connect_bd_net -net mux_8x2_0_out0_o [get_bd_pins mux_8x2_0/out0_o] [get_bd_pins red_pitaya_dac_0/dat_a_i]
  connect_bd_net -net mux_8x2_0_out1_o [get_bd_pins mux_8x2_0/out1_o] [get_bd_pins red_pitaya_dac_0/dat_b_i]
  connect_bd_net -net red_pitaya_dac_0_dac_clk [get_bd_pins dac_clk_o] [get_bd_pins red_pitaya_dac_0/dac_clk]
  connect_bd_net -net red_pitaya_dac_0_dac_dat [get_bd_pins dac_dat_o] [get_bd_pins red_pitaya_dac_0/dac_dat]
  connect_bd_net -net red_pitaya_dac_0_dac_rst [get_bd_pins dac_rst_o] [get_bd_pins red_pitaya_dac_0/dac_rst]
  connect_bd_net -net red_pitaya_dac_0_dac_sel [get_bd_pins dac_sel_o] [get_bd_pins red_pitaya_dac_0/dac_sel]
  connect_bd_net -net red_pitaya_dac_0_dac_wrt [get_bd_pins dac_wrt_o] [get_bd_pins red_pitaya_dac_0/dac_wrt]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins mux_8x2_0/rst_ni]
  connect_bd_net -net select0_i_1 [get_bd_pins select0_i] [get_bd_pins mux_8x2_0/select0_i]
  connect_bd_net -net select1_i_1 [get_bd_pins select1_i] [get_bd_pins mux_8x2_0/select1_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: aom_control
proc create_hier_cell_aom_control { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_aom_control() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 13 -to 0 Dout
  create_bd_pin -dir I -from 25 -to 0 delay_cycles_i
  create_bd_pin -dir I -from 25 -to 0 delay_cycles_i1
  create_bd_pin -dir I feedback_enable_i
  create_bd_pin -dir I -from 16 -to 0 gain_i
  create_bd_pin -dir I -from 13 -to 0 in0_i
  create_bd_pin -dir I -from 13 -to 0 in1_i
  create_bd_pin -dir I rst_ni
  create_bd_pin -dir I sel_i
  create_bd_pin -dir I -from 25 -to 0 toggle_cycles_i
  create_bd_pin -dir I -from 25 -to 0 toggle_cycles_i1
  create_bd_pin -dir I trap_enable_i
  create_bd_pin -dir I trig_i

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {14} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000000} \
   CONFIG.B_Width {14} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {15} \
 ] $c_addsub_0

  # Create instance: coarse_gain_and_limi_0, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_0
  if { [catch {set coarse_gain_and_limi_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {42} \
   CONFIG.MAX_LOG2_GAIN {1} \
   CONFIG.WIDTH_LOG2_GAIN {1} \
 ] $coarse_gain_and_limi_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.OptGoal {Speed} \
   CONFIG.OutputWidthHigh {41} \
   CONFIG.PipeStages {1} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {25} \
   CONFIG.PortBType {Unsigned} \
   CONFIG.PortBWidth {17} \
   CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: optical_trap_dc_0, and set properties
  set block_name optical_trap_dc
  set block_cell_name optical_trap_dc_0
  if { [catch {set optical_trap_dc_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $optical_trap_dc_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $optical_trap_dc_0

  # Create instance: optical_trap_feedback_0, and set properties
  set block_name optical_trap_feedback
  set block_cell_name optical_trap_feedback_0
  if { [catch {set optical_trap_feedback_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $optical_trap_feedback_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.COUNTER_WIDTH {26} \
 ] $optical_trap_feedback_0

  # Create instance: parametric_input_mux, and set properties
  set block_name mux_2x1
  set block_cell_name parametric_input_mux
  if { [catch {set parametric_input_mux [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $parametric_input_mux eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {14} \
 ] $parametric_input_mux

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {27} \
   CONFIG.DOUT_WIDTH {25} \
 ] $xlslice_0

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property USER_COMMENTS.comment_0 "By making sure that the input B of  the
addition block is always negative,
we can keep only the the LSBs of the output.
Input B is sure to be negative b.c. the gain
multiplier's input A is negative, and B is unsigned" [get_bd_cells /aom_control/xlslice_3]
  set_property USER_COMMENTS.comment_1 "The su" [get_bd_cells /aom_control/xlslice_3]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {15} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_3

  # Create port connections
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins CLK] [get_bd_pins c_addsub_0/CLK] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins mult_gen_0/CLK] [get_bd_pins optical_trap_dc_0/clk_i] [get_bd_pins optical_trap_feedback_0/clk_i] [get_bd_pins parametric_input_mux/clk_i]
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins c_addsub_0/B] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins trig_i] [get_bd_pins optical_trap_dc_0/trig_i] [get_bd_pins optical_trap_feedback_0/trig_i]
  connect_bd_net -net mult_gen_0_P [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net multi_GPIO_0_data0_o1 [get_bd_pins gain_i] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net multi_GPIO_0_data1_o [get_bd_pins sel_i] [get_bd_pins parametric_input_mux/sel_i]
  connect_bd_net -net multi_GPIO_0_data2_o [get_bd_pins trap_enable_i] [get_bd_pins optical_trap_dc_0/trap_enable_i]
  connect_bd_net -net multi_GPIO_0_data3_o [get_bd_pins delay_cycles_i] [get_bd_pins optical_trap_dc_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_0_data4_o [get_bd_pins toggle_cycles_i] [get_bd_pins optical_trap_dc_0/toggle_cycles_i]
  connect_bd_net -net multi_GPIO_0_data5_o [get_bd_pins feedback_enable_i] [get_bd_pins optical_trap_feedback_0/feedback_enable_i]
  connect_bd_net -net multi_GPIO_0_data6_o [get_bd_pins delay_cycles_i1] [get_bd_pins optical_trap_feedback_0/delay_cycles_i]
  connect_bd_net -net multi_GPIO_0_data7_o [get_bd_pins toggle_cycles_i1] [get_bd_pins optical_trap_feedback_0/toggle_cycles_i]
  connect_bd_net -net mux_2x1_3_out_o [get_bd_pins optical_trap_feedback_0/data_i] [get_bd_pins parametric_input_mux/out_o]
  connect_bd_net -net optical_trap_dc_0_data_o [get_bd_pins c_addsub_0/A] [get_bd_pins optical_trap_dc_0/data_o]
  connect_bd_net -net optical_trap_feedback_0_data_o [get_bd_pins optical_trap_feedback_0/data_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net red_pitaya_adc_0_adc_dat_a_o [get_bd_pins in0_i] [get_bd_pins parametric_input_mux/in0_i]
  connect_bd_net -net red_pitaya_adc_0_adc_dat_b_o [get_bd_pins in1_i] [get_bd_pins parametric_input_mux/in1_i]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins optical_trap_dc_0/rst_ni] [get_bd_pins optical_trap_feedback_0/rst_ni] [get_bd_pins parametric_input_mux/rst_ni]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins coarse_gain_and_limi_0/log2_gain_i] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins mult_gen_0/A] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins Dout] [get_bd_pins xlslice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PS7
proc create_hier_cell_PS7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_PS7() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI


  # Create pins
  create_bd_pin -dir O -type clk FCLK_CLK0
  create_bd_pin -dir O -from 0 -to 0 -type rst S00_ARESETN

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {125000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {0} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {1} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {1} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {1} \
   CONFIG.PCW_EN_SPI1 {1} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {1} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {250} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {cfg/red_pitaya.xml} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {out} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 2.5V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {in} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#GPIO#UART 1#UART 1#SPI 1#SPI 1#SPI 1#SPI 1#UART 0#UART\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet\
0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB\
0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#GPIO#I2C 0#I2C 0#GPIO#GPIO}\
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#tx#rx#mosi#miso#sclk#ss[0]#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#wp#reset#gpio[49]#scl#sda#gpio[52]#gpio[53]}\
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.080} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.063} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.057} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.068} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.047} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.025} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.017} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 2.5V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 47} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {MIO 13} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI1_SPI1_IO {MIO 10 .. 15} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 8 .. 9} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {54.563} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {54.563} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {54.563} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {54.563} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {101.239} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {79.5025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {60.536} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {71.7715} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {104.5365} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {70.676} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {59.1615} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {81.319} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 48} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_125M, and set properties
  set rst_ps7_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_125M ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M01_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M03_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M04_AXI] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]

  # Create port connections
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins FCLK_CLK0] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_125M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_125M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins S00_ARESETN] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_125M/peripheral_aresetn]

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
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set Vaux0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0 ]

  set Vaux1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1 ]

  set Vaux8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8 ]

  set Vaux9 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9 ]

  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]


  # Create ports
  set adc_clk_n_i [ create_bd_port -dir I adc_clk_n_i ]
  set adc_clk_p_i [ create_bd_port -dir I adc_clk_p_i ]
  set adc_csn_o [ create_bd_port -dir O adc_csn_o ]
  set adc_dat_a_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_a_i ]
  set adc_dat_b_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_b_i ]
  set adc_enc_n_o [ create_bd_port -dir O adc_enc_n_o ]
  set adc_enc_p_o [ create_bd_port -dir O adc_enc_p_o ]
  set dac_clk_o [ create_bd_port -dir O dac_clk_o ]
  set dac_dat_o [ create_bd_port -dir O -from 13 -to 0 dac_dat_o ]
  set dac_pwm_o [ create_bd_port -dir O -from 3 -to 0 dac_pwm_o ]
  set dac_rst_o [ create_bd_port -dir O dac_rst_o ]
  set dac_sel_o [ create_bd_port -dir O dac_sel_o ]
  set dac_wrt_o [ create_bd_port -dir O dac_wrt_o ]
  set daisy_n_i [ create_bd_port -dir I -from 1 -to 0 daisy_n_i ]
  set daisy_n_o [ create_bd_port -dir O -from 1 -to 0 daisy_n_o ]
  set daisy_p_i [ create_bd_port -dir I -from 1 -to 0 daisy_p_i ]
  set daisy_p_o [ create_bd_port -dir O -from 1 -to 0 daisy_p_o ]
  set exp_n_tri_io [ create_bd_port -dir IO -from 7 -to 0 exp_n_tri_io ]
  set exp_p_tri_io [ create_bd_port -dir O -from 7 -to 0 exp_p_tri_io ]
  set led_o [ create_bd_port -dir O -from 7 -to 0 led_o ]

  # Create instance: GPIO_trigger_pulse_0, and set properties
  set block_name GPIO_trigger_pulse
  set block_cell_name GPIO_trigger_pulse_0
  if { [catch {set GPIO_trigger_pulse_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $GPIO_trigger_pulse_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: PS7
  create_hier_cell_PS7 [current_bd_instance .] PS7

  # Create instance: aom_control
  create_hier_cell_aom_control [current_bd_instance .] aom_control

  # Create instance: bram_delay_line_0, and set properties
  set block_name bram_delay_line
  set block_cell_name bram_delay_line_0
  if { [catch {set bram_delay_line_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bram_delay_line_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: bram_delay_line_1, and set properties
  set block_name bram_delay_line
  set block_cell_name bram_delay_line_1
  if { [catch {set bram_delay_line_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bram_delay_line_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: coarse_gain_and_limi_2, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_2
  if { [catch {set coarse_gain_and_limi_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {16} \
   CONFIG.MAX_LOG2_GAIN {3} \
   CONFIG.WIDTH_LOG2_GAIN {2} \
 ] $coarse_gain_and_limi_2

  # Create instance: coarse_gain_and_limi_3, and set properties
  set block_name coarse_gain_and_limiter
  set block_cell_name coarse_gain_and_limi_3
  if { [catch {set coarse_gain_and_limi_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $coarse_gain_and_limi_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.INPUT_WIDTH {16} \
   CONFIG.MAX_LOG2_GAIN {3} \
   CONFIG.WIDTH_LOG2_GAIN {2} \
 ] $coarse_gain_and_limi_3

  # Create instance: conditional_adder_4x2_0, and set properties
  set block_name conditional_adder_4x2
  set block_cell_name conditional_adder_4x2_0
  if { [catch {set conditional_adder_4x2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $conditional_adder_4x2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: dac_mux
  create_hier_cell_dac_mux [current_bd_instance .] dac_mux

  # Create instance: decimate_0, and set properties
  set block_name decimate
  set block_cell_name decimate_0
  if { [catch {set decimate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decimate_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.LOG2_DECIMATION_FACTOR {3} \
 ] $decimate_0

  # Create instance: decimate_1, and set properties
  set block_name decimate
  set block_cell_name decimate_1
  if { [catch {set decimate_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $decimate_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.LOG2_DECIMATION_FACTOR {3} \
 ] $decimate_1

  # Create instance: edge_detector_0, and set properties
  set block_name edge_detector
  set block_cell_name edge_detector_0
  if { [catch {set edge_detector_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $edge_detector_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: filter_block_0
  create_hier_cell_filter_block_0 [current_bd_instance .] filter_block_0

  # Create instance: filter_block_1
  create_hier_cell_filter_block_1 [current_bd_instance .] filter_block_1

  # Create instance: filter_block_2
  create_hier_cell_filter_block_2 [current_bd_instance .] filter_block_2

  # Create instance: filter_block_3
  create_hier_cell_filter_block_3 [current_bd_instance .] filter_block_3

  # Create instance: multi_GPIO_0
  create_hier_cell_multi_GPIO_0 [current_bd_instance .] multi_GPIO_0

  # Create instance: red_pitaya_adc_0, and set properties
  set block_name red_pitaya_adc
  set block_cell_name red_pitaya_adc_0
  if { [catch {set red_pitaya_adc_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $red_pitaya_adc_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {2} \
 ] $util_ds_buf_1

  # Create instance: util_ds_buf_2, and set properties
  set util_ds_buf_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_2 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {OBUFDS} \
   CONFIG.C_SIZE {2} \
 ] $util_ds_buf_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {7} \
 ] $xlconcat_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {7} \
 ] $xlconstant_1

  # Create instance: xlconstant_8, and set properties
  set xlconstant_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_8 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {14} \
 ] $xlconstant_8

  # Create interface connections
  connect_bd_intf_net -intf_net PS7_M01_AXI [get_bd_intf_pins PS7/M01_AXI] [get_bd_intf_pins filter_block_0/S_AXI]
  connect_bd_intf_net -intf_net PS7_M02_AXI [get_bd_intf_pins PS7/M02_AXI] [get_bd_intf_pins filter_block_1/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_2 [get_bd_intf_pins PS7/M03_AXI] [get_bd_intf_pins filter_block_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_3 [get_bd_intf_pins PS7/M04_AXI] [get_bd_intf_pins filter_block_3/S_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins PS7/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins PS7/FIXED_IO]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins PS7/M00_AXI] [get_bd_intf_pins multi_GPIO_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_trigger_pulse_0_data_trig_o [get_bd_pins GPIO_trigger_pulse_0/data_trig_o] [get_bd_pins dac_mux/in6_i]
  connect_bd_net -net GPIO_trigger_pulse_0_trig_o [get_bd_pins GPIO_trigger_pulse_0/trig_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_ports adc_clk_n_i] [get_bd_pins red_pitaya_adc_0/adc_clk_n]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_ports adc_clk_p_i] [get_bd_pins red_pitaya_adc_0/adc_clk_p]
  connect_bd_net -net adc_dat_a_i_1 [get_bd_ports adc_dat_a_i] [get_bd_pins red_pitaya_adc_0/adc_dat_a_i]
  connect_bd_net -net adc_dat_b_i_1 [get_bd_ports adc_dat_b_i] [get_bd_pins red_pitaya_adc_0/adc_dat_b_i]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins GPIO_trigger_pulse_0/clk_i] [get_bd_pins aom_control/CLK] [get_bd_pins bram_delay_line_0/clk_i] [get_bd_pins bram_delay_line_1/clk_i] [get_bd_pins coarse_gain_and_limi_2/clk_i] [get_bd_pins coarse_gain_and_limi_3/clk_i] [get_bd_pins conditional_adder_4x2_0/clk_i] [get_bd_pins dac_mux/clk_in1] [get_bd_pins decimate_0/clk_i] [get_bd_pins decimate_1/clk_i] [get_bd_pins edge_detector_0/clk_i] [get_bd_pins filter_block_0/clk_i] [get_bd_pins filter_block_1/clk_i] [get_bd_pins filter_block_2/clk_i] [get_bd_pins filter_block_3/clk_i] [get_bd_pins multi_GPIO_0/clk_i] [get_bd_pins red_pitaya_adc_0/adc_clk]
  connect_bd_net -net bram_delay_line_0_data0_o [get_bd_pins bram_delay_line_0/data0_o] [get_bd_pins filter_block_0/in0_i]
  connect_bd_net -net bram_delay_line_0_data1_o [get_bd_pins bram_delay_line_0/data1_o] [get_bd_pins filter_block_1/in0_i]
  connect_bd_net -net bram_delay_line_0_data2_o [get_bd_pins bram_delay_line_0/data2_o] [get_bd_pins filter_block_2/in0_i]
  connect_bd_net -net bram_delay_line_0_data3_o [get_bd_pins bram_delay_line_0/data3_o] [get_bd_pins filter_block_3/in0_i]
  connect_bd_net -net bram_delay_line_0_data_valid0_o [get_bd_pins bram_delay_line_0/data_valid0_o] [get_bd_pins filter_block_0/data_valid0_i]
  connect_bd_net -net bram_delay_line_0_data_valid1_o [get_bd_pins bram_delay_line_0/data_valid1_o] [get_bd_pins filter_block_1/data_valid0_i]
  connect_bd_net -net bram_delay_line_0_data_valid2_o [get_bd_pins bram_delay_line_0/data_valid2_o] [get_bd_pins filter_block_2/data_valid0_i]
  connect_bd_net -net bram_delay_line_0_data_valid3_o [get_bd_pins bram_delay_line_0/data_valid3_o] [get_bd_pins filter_block_3/data_valid0_i]
  connect_bd_net -net bram_delay_line_1_data0_o [get_bd_pins bram_delay_line_1/data0_o] [get_bd_pins filter_block_0/in1_i]
  connect_bd_net -net bram_delay_line_1_data1_o [get_bd_pins bram_delay_line_1/data1_o] [get_bd_pins filter_block_1/in1_i]
  connect_bd_net -net bram_delay_line_1_data2_o [get_bd_pins bram_delay_line_1/data2_o] [get_bd_pins filter_block_2/in1_i]
  connect_bd_net -net bram_delay_line_1_data3_o [get_bd_pins bram_delay_line_1/data3_o] [get_bd_pins filter_block_3/in1_i]
  connect_bd_net -net bram_delay_line_1_data_valid0_o [get_bd_pins bram_delay_line_1/data_valid0_o] [get_bd_pins filter_block_0/data_valid1_i]
  connect_bd_net -net bram_delay_line_1_data_valid1_o [get_bd_pins bram_delay_line_1/data_valid1_o] [get_bd_pins filter_block_1/data_valid1_i]
  connect_bd_net -net bram_delay_line_1_data_valid2_o [get_bd_pins bram_delay_line_1/data_valid2_o] [get_bd_pins filter_block_2/data_valid1_i]
  connect_bd_net -net bram_delay_line_1_data_valid3_o [get_bd_pins bram_delay_line_1/data_valid3_o] [get_bd_pins filter_block_3/data_valid1_i]
  connect_bd_net -net coarse_gain_and_limi_2_data_o [get_bd_pins coarse_gain_and_limi_2/data_o] [get_bd_pins dac_mux/in3_i]
  connect_bd_net -net coarse_gain_and_limi_3_data_o [get_bd_pins coarse_gain_and_limi_3/data_o] [get_bd_pins dac_mux/in4_i]
  connect_bd_net -net conditional_adder_4x2_0_data0_o [get_bd_pins coarse_gain_and_limi_2/data_i] [get_bd_pins conditional_adder_4x2_0/data0_o]
  connect_bd_net -net conditional_adder_4x2_0_data1_o [get_bd_pins coarse_gain_and_limi_3/data_i] [get_bd_pins conditional_adder_4x2_0/data1_o]
  connect_bd_net -net daisy_n_i_1 [get_bd_ports daisy_n_i] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
  connect_bd_net -net daisy_p_i_1 [get_bd_ports daisy_p_i] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
  connect_bd_net -net decimate_0_ce_o [get_bd_pins bram_delay_line_0/ce_i] [get_bd_pins decimate_0/ce_o]
  connect_bd_net -net decimate_0_data0_o [get_bd_pins bram_delay_line_0/data_i] [get_bd_pins decimate_0/data0_o]
  connect_bd_net -net decimate_1_ce_o [get_bd_pins bram_delay_line_1/ce_i] [get_bd_pins decimate_1/ce_o]
  connect_bd_net -net decimate_1_data0_o [get_bd_pins bram_delay_line_1/data_i] [get_bd_pins decimate_1/data0_o]
  connect_bd_net -net delay_MSB_Dout [get_bd_pins bram_delay_line_0/delay0_i] [get_bd_pins bram_delay_line_1/delay0_i] [get_bd_pins filter_block_0/delay_MSB]
  connect_bd_net -net edge_detector_0_pe_o [get_bd_pins GPIO_trigger_pulse_0/trig_i] [get_bd_pins aom_control/trig_i] [get_bd_pins edge_detector_0/pe_o] [get_bd_pins filter_block_0/trig_i] [get_bd_pins filter_block_1/trig_i] [get_bd_pins filter_block_2/trig_i] [get_bd_pins filter_block_3/trig_i]
  connect_bd_net -net filter_block_1_data_o [get_bd_pins conditional_adder_4x2_0/data1_i] [get_bd_pins filter_block_1/data_o]
  connect_bd_net -net filter_block_1_delay_MSB [get_bd_pins bram_delay_line_0/delay1_i] [get_bd_pins bram_delay_line_1/delay1_i] [get_bd_pins filter_block_1/delay_MSB]
  connect_bd_net -net filter_block_2_data_o [get_bd_pins conditional_adder_4x2_0/data2_i] [get_bd_pins filter_block_2/data_o]
  connect_bd_net -net filter_block_2_delay_MSB [get_bd_pins bram_delay_line_0/delay2_i] [get_bd_pins bram_delay_line_1/delay2_i] [get_bd_pins filter_block_2/delay_MSB]
  connect_bd_net -net filter_block_3_data_o [get_bd_pins conditional_adder_4x2_0/data3_i] [get_bd_pins filter_block_3/data_o]
  connect_bd_net -net filter_block_3_delay_MSB [get_bd_pins bram_delay_line_0/delay3_i] [get_bd_pins bram_delay_line_1/delay3_i] [get_bd_pins filter_block_3/delay_MSB]
  connect_bd_net -net in7_i_1 [get_bd_pins dac_mux/in7_i] [get_bd_pins multi_GPIO_0/data4_o1]
  connect_bd_net -net multi_GPIO_0_data0_o1 [get_bd_pins aom_control/gain_i] [get_bd_pins multi_GPIO_0/data0_o1]
  connect_bd_net -net multi_GPIO_0_data0_o2 [get_bd_pins coarse_gain_and_limi_3/log2_gain_i] [get_bd_pins multi_GPIO_0/data0_o2]
  connect_bd_net -net multi_GPIO_0_data1_o [get_bd_pins aom_control/sel_i] [get_bd_pins multi_GPIO_0/data1_o]
  connect_bd_net -net multi_GPIO_0_data2_o [get_bd_pins aom_control/trap_enable_i] [get_bd_pins multi_GPIO_0/data2_o]
  connect_bd_net -net multi_GPIO_0_data3_o [get_bd_pins aom_control/delay_cycles_i] [get_bd_pins multi_GPIO_0/data3_o]
  connect_bd_net -net multi_GPIO_0_data3_o1 [get_bd_pins GPIO_trigger_pulse_0/delay_cycles_i] [get_bd_pins multi_GPIO_0/data3_o1]
  connect_bd_net -net multi_GPIO_0_data4_o [get_bd_pins aom_control/toggle_cycles_i] [get_bd_pins multi_GPIO_0/data4_o]
  connect_bd_net -net multi_GPIO_0_data4_o2 [get_bd_pins edge_detector_0/sig_i] [get_bd_pins multi_GPIO_0/data4_o2]
  connect_bd_net -net multi_GPIO_0_data5_o [get_bd_pins aom_control/feedback_enable_i] [get_bd_pins multi_GPIO_0/data5_o]
  connect_bd_net -net multi_GPIO_0_data5_o1 [get_bd_pins conditional_adder_4x2_0/add_select0_i] [get_bd_pins multi_GPIO_0/data5_o1]
  connect_bd_net -net multi_GPIO_0_data6_o [get_bd_pins aom_control/delay_cycles_i1] [get_bd_pins multi_GPIO_0/data6_o]
  connect_bd_net -net multi_GPIO_0_data6_o1 [get_bd_pins conditional_adder_4x2_0/add_select1_i] [get_bd_pins multi_GPIO_0/data6_o1]
  connect_bd_net -net multi_GPIO_0_data7_o [get_bd_pins aom_control/toggle_cycles_i1] [get_bd_pins multi_GPIO_0/data7_o]
  connect_bd_net -net multi_GPIO_0_data7_o1 [get_bd_pins coarse_gain_and_limi_2/log2_gain_i] [get_bd_pins multi_GPIO_0/data7_o1]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins PS7/FCLK_CLK0] [get_bd_pins filter_block_0/s_axi_aclk] [get_bd_pins filter_block_1/s_axi_aclk] [get_bd_pins filter_block_2/s_axi_aclk] [get_bd_pins filter_block_3/s_axi_aclk] [get_bd_pins multi_GPIO_0/s_axi_aclk]
  connect_bd_net -net red_pitaya_adc_0_adc_csn [get_bd_ports adc_csn_o] [get_bd_pins red_pitaya_adc_0/adc_csn]
  connect_bd_net -net red_pitaya_adc_0_adc_dat_a_o [get_bd_pins aom_control/in0_i] [get_bd_pins dac_mux/in0_1] [get_bd_pins decimate_0/data0_i] [get_bd_pins red_pitaya_adc_0/adc_dat_a_o]
  connect_bd_net -net red_pitaya_adc_0_adc_dat_b_o [get_bd_pins aom_control/in1_i] [get_bd_pins dac_mux/in1_i] [get_bd_pins decimate_1/data0_i] [get_bd_pins red_pitaya_adc_0/adc_dat_b_o]
  connect_bd_net -net red_pitaya_dac_0_dac_clk [get_bd_ports dac_clk_o] [get_bd_pins dac_mux/dac_clk_o]
  connect_bd_net -net red_pitaya_dac_0_dac_dat [get_bd_ports dac_dat_o] [get_bd_pins dac_mux/dac_dat_o]
  connect_bd_net -net red_pitaya_dac_0_dac_rst [get_bd_ports dac_rst_o] [get_bd_pins dac_mux/dac_rst_o]
  connect_bd_net -net red_pitaya_dac_0_dac_sel [get_bd_ports dac_sel_o] [get_bd_pins dac_mux/dac_sel_o]
  connect_bd_net -net red_pitaya_dac_0_dac_wrt [get_bd_ports dac_wrt_o] [get_bd_pins dac_mux/dac_wrt_o]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins GPIO_trigger_pulse_0/rst_ni] [get_bd_pins PS7/S00_ARESETN] [get_bd_pins aom_control/rst_ni] [get_bd_pins bram_delay_line_0/rst_ni] [get_bd_pins bram_delay_line_1/rst_ni] [get_bd_pins coarse_gain_and_limi_2/rst_ni] [get_bd_pins coarse_gain_and_limi_3/rst_ni] [get_bd_pins conditional_adder_4x2_0/rst_ni] [get_bd_pins dac_mux/rst_ni] [get_bd_pins decimate_0/rst_ni] [get_bd_pins decimate_1/rst_ni] [get_bd_pins edge_detector_0/rst_ni] [get_bd_pins filter_block_0/rst_ni] [get_bd_pins filter_block_1/rst_ni] [get_bd_pins filter_block_2/rst_ni] [get_bd_pins filter_block_3/rst_ni] [get_bd_pins multi_GPIO_0/s_axi_aresetn]
  connect_bd_net -net select0_i_1 [get_bd_pins dac_mux/select0_i] [get_bd_pins multi_GPIO_0/data1_o1]
  connect_bd_net -net select1_i_1 [get_bd_pins dac_mux/select1_i] [get_bd_pins multi_GPIO_0/data2_o1]
  connect_bd_net -net triggered_gate_0_data_o [get_bd_pins conditional_adder_4x2_0/data0_i] [get_bd_pins dac_mux/in5_i] [get_bd_pins filter_block_0/data_o]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins util_ds_buf_2/OBUF_IN]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_N [get_bd_ports daisy_n_o] [get_bd_pins util_ds_buf_2/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_P [get_bd_ports daisy_p_o] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
  connect_bd_net -net xlconcat_0_dout [get_bd_ports exp_p_tri_io] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_8_dout [get_bd_pins bram_delay_line_0/delay4_i] [get_bd_pins bram_delay_line_0/delay5_i] [get_bd_pins bram_delay_line_0/delay6_i] [get_bd_pins bram_delay_line_0/delay7_i] [get_bd_pins bram_delay_line_1/delay4_i] [get_bd_pins bram_delay_line_1/delay5_i] [get_bd_pins bram_delay_line_1/delay6_i] [get_bd_pins bram_delay_line_1/delay7_i] [get_bd_pins xlconstant_8/dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins aom_control/Dout] [get_bd_pins dac_mux/in2_i]

  # Create address segments
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS7/processing_system7_0/Data] [get_bd_addr_segs multi_GPIO_0/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS7/processing_system7_0/Data] [get_bd_addr_segs filter_block_0/multi_GPIO_1/axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS7/processing_system7_0/Data] [get_bd_addr_segs filter_block_1/multi_GPIO_2/axi_gpio_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x41230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS7/processing_system7_0/Data] [get_bd_addr_segs filter_block_2/multi_GPIO_3/axi_gpio_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x41240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS7/processing_system7_0/Data] [get_bd_addr_segs filter_block_3/multi_GPIO_4/axi_gpio_4/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


