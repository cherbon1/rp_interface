
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
# axis_red_pitaya_adc, axis_red_pitaya_dac, dac_out_switch, coarse_gain_and_limiter, coarse_gain_and_limiter, conditional_adder_8x2, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, coarse_gain_and_limiter, fine_gain, mux_2x1, mux_8x1, pid_w_range, coarse_gain_and_limiter, fine_gain, mux_2x1, mux_8x1, pid_w_range, coarse_gain_and_limiter, fine_gain, mux_2x1, mux_8x1, pid_w_range, coarse_gain_and_limiter, fine_gain, mux_2x1, mux_8x1, pid_w_range, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, sample_and_hold, sample_and_hold, sample_and_hold, freq_div, nco_driver_2, waveform_gen, weight_sum, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, sample_and_hold, sample_and_hold, sample_and_hold, freq_div, nco_driver_2, waveform_gen, weight_sum, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, sample_and_hold, sample_and_hold, sample_and_hold, freq_div, nco_driver_2, waveform_gen, weight_sum, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_mux, GPIO_super_mux, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, sample_and_hold, sample_and_hold, sample_and_hold, freq_div, nco_driver_2, waveform_gen, weight_sum

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
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:cordic:6.0\
xilinx.com:ip:mult_gen:12.0\
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
axis_red_pitaya_adc\
axis_red_pitaya_dac\
dac_out_switch\
coarse_gain_and_limiter\
coarse_gain_and_limiter\
conditional_adder_8x2\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
coarse_gain_and_limiter\
fine_gain\
mux_2x1\
mux_8x1\
pid_w_range\
coarse_gain_and_limiter\
fine_gain\
mux_2x1\
mux_8x1\
pid_w_range\
coarse_gain_and_limiter\
fine_gain\
mux_2x1\
mux_8x1\
pid_w_range\
coarse_gain_and_limiter\
fine_gain\
mux_2x1\
mux_8x1\
pid_w_range\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
dec_filter\
exp_avg_filter_order\
exp_avg_filter_order\
mult_n_1\
mult_n_1\
sample_and_hold\
sample_and_hold\
sample_and_hold\
freq_div\
nco_driver_2\
waveform_gen\
weight_sum\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
dec_filter\
exp_avg_filter_order\
exp_avg_filter_order\
mult_n_1\
mult_n_1\
sample_and_hold\
sample_and_hold\
sample_and_hold\
freq_div\
nco_driver_2\
waveform_gen\
weight_sum\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
dec_filter\
exp_avg_filter_order\
exp_avg_filter_order\
mult_n_1\
mult_n_1\
sample_and_hold\
sample_and_hold\
sample_and_hold\
freq_div\
nco_driver_2\
waveform_gen\
weight_sum\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_mux\
GPIO_super_mux\
dec_filter\
exp_avg_filter_order\
exp_avg_filter_order\
mult_n_1\
mult_n_1\
sample_and_hold\
sample_and_hold\
sample_and_hold\
freq_div\
nco_driver_2\
waveform_gen\
weight_sum\
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


# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_wave_gen_3() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 25 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 25 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {26} \
 ] $nco_driver_2_0

  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_IN {12} \
   CONFIG.N_OUT {12} \
   CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {6} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_1

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins waveform_gen_0/phase_inc] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_phase_det_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {true} \
   CONFIG.Data_Format {SignedFraction} \
   CONFIG.Functional_Selection {Arc_Tan} \
   CONFIG.Input_Width {24} \
   CONFIG.Output_Width {16} \
   CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CEILLOGDEC {8} \
   CONFIG.DEC {256} \
   CONFIG.DIV {1} \
   CONFIG.N {16} \
   CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: sample_and_hold_0, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_0
  if { [catch {set sample_and_hold_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_0

  # Create instance: sample_and_hold_1, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_1
  if { [catch {set sample_and_hold_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_1

  # Create instance: sample_and_hold_2, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_2
  if { [catch {set sample_and_hold_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {16} \
 ] $sample_and_hold_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {16} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {24} \
   CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI] [get_bd_pins sample_and_hold_0/clk_i] [get_bd_pins sample_and_hold_1/clk_i] [get_bd_pins sample_and_hold_2/clk_i]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI] [get_bd_pins sample_and_hold_0/rst_ni] [get_bd_pins sample_and_hold_1/rst_ni] [get_bd_pins sample_and_hold_2/rst_ni]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins cordic_0/m_axis_dout_tdata] [get_bd_pins sample_and_hold_2/data_i]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins cordic_0/m_axis_dout_tvalid] [get_bd_pins sample_and_hold_2/data_valid_i]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins sample_and_hold_0/data_i] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Valid_SO [get_bd_pins exp_avg_filter_order_1/Valid_SO] [get_bd_pins sample_and_hold_1/data_valid_i]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins sample_and_hold_1/data_i] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO] [get_bd_pins sample_and_hold_0/data_valid_i]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net sample_and_hold_0_data_o [get_bd_pins mix_cos_lpf] [get_bd_pins sample_and_hold_0/data_o]
  connect_bd_net -net sample_and_hold_0_data_valid_o [get_bd_pins mix_lpf_valid] [get_bd_pins sample_and_hold_0/data_valid_o]
  connect_bd_net -net sample_and_hold_1_data_o [get_bd_pins mix_sin_lpf] [get_bd_pins sample_and_hold_1/data_o]
  connect_bd_net -net sample_and_hold_2_data_o [get_bd_pins Phi_DO] [get_bd_pins sample_and_hold_2/data_o]
  connect_bd_net -net sample_and_hold_2_data_valid_o [get_bd_pins PhiValid_SO] [get_bd_pins sample_and_hold_2/data_valid_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_1
proc create_hier_cell_multi_GPIO_1_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_1_3() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 25 -to 0 data0_o1
  create_bd_pin -dir O -from 0 -to 0 data1_o
  create_bd_pin -dir O -from 16 -to 0 data1_o1
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 2 -to 0 data2_o1
  create_bd_pin -dir O -from 7 -to 0 data3_o
  create_bd_pin -dir O -from 2 -to 0 data3_o1
  create_bd_pin -dir O -from 7 -to 0 data4_o
  create_bd_pin -dir O -from 17 -to 0 data4_o1
  create_bd_pin -dir O -from 25 -to 0 data5_o
  create_bd_pin -dir O -from 4 -to 0 data5_o1
  create_bd_pin -dir O -from 25 -to 0 data6_o
  create_bd_pin -dir O -from 23 -to 0 data6_o1
  create_bd_pin -dir O -from 25 -to 0 data7_o
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
   CONFIG.DATA_WIDTH_3 {8} \
   CONFIG.DATA_WIDTH_4 {8} \
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
   CONFIG.DATA_WIDTH_1 {17} \
   CONFIG.DATA_WIDTH_2 {3} \
   CONFIG.DATA_WIDTH_3 {3} \
   CONFIG.DATA_WIDTH_4 {18} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {24} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
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
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_1 [get_bd_pins s_axi_aclk] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: calc_r
proc create_hier_cell_calc_r_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_calc_r_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir I -from 23 -to 0 Din1
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 23 -to 0 m_axis_dout_tdata

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Width {36} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000000000000000} \
   CONFIG.B_Width {36} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {36} \
 ] $c_addsub_0

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {false} \
   CONFIG.Data_Format {UnsignedFraction} \
   CONFIG.Functional_Selection {Square_Root} \
   CONFIG.Input_Width {36} \
   CONFIG.Output_Width {18} \
 ] $cordic_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {36} \
   CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_3

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_6

  # Create port connections
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net clk_1 [get_bd_pins aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins cordic_0/aclk] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins m_axis_dout_tdata] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins Din1] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_6/In1] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B] [get_bd_pins xlslice_6/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_wave_gen_2() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 25 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 25 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {26} \
 ] $nco_driver_2_0

  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_IN {12} \
   CONFIG.N_OUT {12} \
   CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {6} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_1

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins waveform_gen_0/phase_inc] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_phase_det_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {true} \
   CONFIG.Data_Format {SignedFraction} \
   CONFIG.Functional_Selection {Arc_Tan} \
   CONFIG.Input_Width {24} \
   CONFIG.Output_Width {16} \
   CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CEILLOGDEC {8} \
   CONFIG.DEC {256} \
   CONFIG.DIV {1} \
   CONFIG.N {16} \
   CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: sample_and_hold_0, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_0
  if { [catch {set sample_and_hold_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_0

  # Create instance: sample_and_hold_1, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_1
  if { [catch {set sample_and_hold_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_1

  # Create instance: sample_and_hold_2, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_2
  if { [catch {set sample_and_hold_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {16} \
 ] $sample_and_hold_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {16} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {24} \
   CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI] [get_bd_pins sample_and_hold_0/clk_i] [get_bd_pins sample_and_hold_1/clk_i] [get_bd_pins sample_and_hold_2/clk_i]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI] [get_bd_pins sample_and_hold_0/rst_ni] [get_bd_pins sample_and_hold_1/rst_ni] [get_bd_pins sample_and_hold_2/rst_ni]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins cordic_0/m_axis_dout_tdata] [get_bd_pins sample_and_hold_2/data_i]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins cordic_0/m_axis_dout_tvalid] [get_bd_pins sample_and_hold_2/data_valid_i]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins sample_and_hold_0/data_i] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Valid_SO [get_bd_pins exp_avg_filter_order_1/Valid_SO] [get_bd_pins sample_and_hold_1/data_valid_i]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins sample_and_hold_1/data_i] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO] [get_bd_pins sample_and_hold_0/data_valid_i]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net sample_and_hold_0_data_o [get_bd_pins mix_cos_lpf] [get_bd_pins sample_and_hold_0/data_o]
  connect_bd_net -net sample_and_hold_0_data_valid_o [get_bd_pins mix_lpf_valid] [get_bd_pins sample_and_hold_0/data_valid_o]
  connect_bd_net -net sample_and_hold_1_data_o [get_bd_pins mix_sin_lpf] [get_bd_pins sample_and_hold_1/data_o]
  connect_bd_net -net sample_and_hold_2_data_o [get_bd_pins Phi_DO] [get_bd_pins sample_and_hold_2/data_o]
  connect_bd_net -net sample_and_hold_2_data_valid_o [get_bd_pins PhiValid_SO] [get_bd_pins sample_and_hold_2/data_valid_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_1
proc create_hier_cell_multi_GPIO_1_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_1_2() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 25 -to 0 data0_o1
  create_bd_pin -dir O -from 0 -to 0 data1_o
  create_bd_pin -dir O -from 16 -to 0 data1_o1
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 2 -to 0 data2_o1
  create_bd_pin -dir O -from 7 -to 0 data3_o
  create_bd_pin -dir O -from 2 -to 0 data3_o1
  create_bd_pin -dir O -from 7 -to 0 data4_o
  create_bd_pin -dir O -from 17 -to 0 data4_o1
  create_bd_pin -dir O -from 25 -to 0 data5_o
  create_bd_pin -dir O -from 4 -to 0 data5_o1
  create_bd_pin -dir O -from 25 -to 0 data6_o
  create_bd_pin -dir O -from 23 -to 0 data6_o1
  create_bd_pin -dir O -from 25 -to 0 data7_o
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
   CONFIG.DATA_WIDTH_3 {8} \
   CONFIG.DATA_WIDTH_4 {8} \
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
   CONFIG.DATA_WIDTH_1 {17} \
   CONFIG.DATA_WIDTH_2 {3} \
   CONFIG.DATA_WIDTH_3 {3} \
   CONFIG.DATA_WIDTH_4 {18} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {24} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
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
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_1 [get_bd_pins s_axi_aclk] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: calc_r
proc create_hier_cell_calc_r_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_calc_r_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir I -from 23 -to 0 Din1
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 23 -to 0 m_axis_dout_tdata

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Width {36} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000000000000000} \
   CONFIG.B_Width {36} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {36} \
 ] $c_addsub_0

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {false} \
   CONFIG.Data_Format {UnsignedFraction} \
   CONFIG.Functional_Selection {Square_Root} \
   CONFIG.Input_Width {36} \
   CONFIG.Output_Width {18} \
 ] $cordic_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {36} \
   CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_3

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_6

  # Create port connections
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net clk_1 [get_bd_pins aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins cordic_0/aclk] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins m_axis_dout_tdata] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins Din1] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_6/In1] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B] [get_bd_pins xlslice_6/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_wave_gen_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 25 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 25 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {26} \
 ] $nco_driver_2_0

  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_IN {12} \
   CONFIG.N_OUT {12} \
   CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {6} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_1

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins waveform_gen_0/phase_inc] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_phase_det_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {true} \
   CONFIG.Data_Format {SignedFraction} \
   CONFIG.Functional_Selection {Arc_Tan} \
   CONFIG.Input_Width {24} \
   CONFIG.Output_Width {16} \
   CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CEILLOGDEC {8} \
   CONFIG.DEC {256} \
   CONFIG.DIV {1} \
   CONFIG.N {16} \
   CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: sample_and_hold_0, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_0
  if { [catch {set sample_and_hold_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_0

  # Create instance: sample_and_hold_1, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_1
  if { [catch {set sample_and_hold_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_1

  # Create instance: sample_and_hold_2, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_2
  if { [catch {set sample_and_hold_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {16} \
 ] $sample_and_hold_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {16} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {24} \
   CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI] [get_bd_pins sample_and_hold_0/clk_i] [get_bd_pins sample_and_hold_1/clk_i] [get_bd_pins sample_and_hold_2/clk_i]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI] [get_bd_pins sample_and_hold_0/rst_ni] [get_bd_pins sample_and_hold_1/rst_ni] [get_bd_pins sample_and_hold_2/rst_ni]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins cordic_0/m_axis_dout_tdata] [get_bd_pins sample_and_hold_2/data_i]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins cordic_0/m_axis_dout_tvalid] [get_bd_pins sample_and_hold_2/data_valid_i]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins sample_and_hold_0/data_i] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Valid_SO [get_bd_pins exp_avg_filter_order_1/Valid_SO] [get_bd_pins sample_and_hold_1/data_valid_i]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins sample_and_hold_1/data_i] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO] [get_bd_pins sample_and_hold_0/data_valid_i]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net sample_and_hold_0_data_o [get_bd_pins mix_cos_lpf] [get_bd_pins sample_and_hold_0/data_o]
  connect_bd_net -net sample_and_hold_0_data_valid_o [get_bd_pins mix_lpf_valid] [get_bd_pins sample_and_hold_0/data_valid_o]
  connect_bd_net -net sample_and_hold_1_data_o [get_bd_pins mix_sin_lpf] [get_bd_pins sample_and_hold_1/data_o]
  connect_bd_net -net sample_and_hold_2_data_o [get_bd_pins Phi_DO] [get_bd_pins sample_and_hold_2/data_o]
  connect_bd_net -net sample_and_hold_2_data_valid_o [get_bd_pins PhiValid_SO] [get_bd_pins sample_and_hold_2/data_valid_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: multi_GPIO_1
proc create_hier_cell_multi_GPIO_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_multi_GPIO_1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 25 -to 0 data0_o1
  create_bd_pin -dir O -from 0 -to 0 data1_o
  create_bd_pin -dir O -from 16 -to 0 data1_o1
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 2 -to 0 data2_o1
  create_bd_pin -dir O -from 7 -to 0 data3_o
  create_bd_pin -dir O -from 2 -to 0 data3_o1
  create_bd_pin -dir O -from 7 -to 0 data4_o
  create_bd_pin -dir O -from 17 -to 0 data4_o1
  create_bd_pin -dir O -from 25 -to 0 data5_o
  create_bd_pin -dir O -from 4 -to 0 data5_o1
  create_bd_pin -dir O -from 25 -to 0 data6_o
  create_bd_pin -dir O -from 23 -to 0 data6_o1
  create_bd_pin -dir O -from 25 -to 0 data7_o
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
   CONFIG.DATA_WIDTH_3 {8} \
   CONFIG.DATA_WIDTH_4 {8} \
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
   CONFIG.DATA_WIDTH_1 {17} \
   CONFIG.DATA_WIDTH_2 {3} \
   CONFIG.DATA_WIDTH_3 {3} \
   CONFIG.DATA_WIDTH_4 {18} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {24} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
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
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_1 [get_bd_pins s_axi_aclk] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: calc_r
proc create_hier_cell_calc_r_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_calc_r_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir I -from 23 -to 0 Din1
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 23 -to 0 m_axis_dout_tdata

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Width {36} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000000000000000} \
   CONFIG.B_Width {36} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {36} \
 ] $c_addsub_0

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {false} \
   CONFIG.Data_Format {UnsignedFraction} \
   CONFIG.Functional_Selection {Square_Root} \
   CONFIG.Input_Width {36} \
   CONFIG.Output_Width {18} \
 ] $cordic_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {36} \
   CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_3

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_6

  # Create port connections
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net clk_1 [get_bd_pins aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins cordic_0/aclk] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins m_axis_dout_tdata] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins Din1] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_6/In1] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B] [get_bd_pins xlslice_6/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_wave_gen() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 25 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 25 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {26} \
 ] $nco_driver_2_0

  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_IN {12} \
   CONFIG.N_OUT {12} \
   CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {6} \
   CONFIG.IN1_WIDTH {26} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_1

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins waveform_gen_0/phase_inc] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_phase_det() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {true} \
   CONFIG.Data_Format {SignedFraction} \
   CONFIG.Functional_Selection {Arc_Tan} \
   CONFIG.Input_Width {24} \
   CONFIG.Output_Width {16} \
   CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CEILLOGDEC {8} \
   CONFIG.DEC {256} \
   CONFIG.DIV {1} \
   CONFIG.N {16} \
   CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {24} \
   CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: sample_and_hold_0, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_0
  if { [catch {set sample_and_hold_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_0

  # Create instance: sample_and_hold_1, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_1
  if { [catch {set sample_and_hold_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {24} \
 ] $sample_and_hold_1

  # Create instance: sample_and_hold_2, and set properties
  set block_name sample_and_hold
  set block_cell_name sample_and_hold_2
  if { [catch {set sample_and_hold_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_and_hold_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.WIDTH {16} \
 ] $sample_and_hold_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {16} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {24} \
   CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI] [get_bd_pins sample_and_hold_0/clk_i] [get_bd_pins sample_and_hold_1/clk_i] [get_bd_pins sample_and_hold_2/clk_i]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI] [get_bd_pins sample_and_hold_0/rst_ni] [get_bd_pins sample_and_hold_1/rst_ni] [get_bd_pins sample_and_hold_2/rst_ni]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins cordic_0/m_axis_dout_tdata] [get_bd_pins sample_and_hold_2/data_i]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins cordic_0/m_axis_dout_tvalid] [get_bd_pins sample_and_hold_2/data_valid_i]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins sample_and_hold_0/data_i] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Valid_SO [get_bd_pins exp_avg_filter_order_1/Valid_SO] [get_bd_pins sample_and_hold_1/data_valid_i]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins sample_and_hold_1/data_i] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO] [get_bd_pins sample_and_hold_0/data_valid_i]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net sample_and_hold_0_data_o [get_bd_pins mix_cos_lpf] [get_bd_pins sample_and_hold_0/data_o]
  connect_bd_net -net sample_and_hold_0_data_valid_o [get_bd_pins mix_lpf_valid] [get_bd_pins sample_and_hold_0/data_valid_o]
  connect_bd_net -net sample_and_hold_1_data_o [get_bd_pins mix_sin_lpf] [get_bd_pins sample_and_hold_1/data_o]
  connect_bd_net -net sample_and_hold_2_data_o [get_bd_pins Phi_DO] [get_bd_pins sample_and_hold_2/data_o]
  connect_bd_net -net sample_and_hold_2_data_valid_o [get_bd_pins PhiValid_SO] [get_bd_pins sample_and_hold_2/data_valid_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

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
  create_bd_pin -dir O -from 0 -to 0 data0_o
  create_bd_pin -dir O -from 25 -to 0 data0_o1
  create_bd_pin -dir O -from 0 -to 0 data1_o
  create_bd_pin -dir O -from 16 -to 0 data1_o1
  create_bd_pin -dir O -from 0 -to 0 data2_o
  create_bd_pin -dir O -from 2 -to 0 data2_o1
  create_bd_pin -dir O -from 7 -to 0 data3_o
  create_bd_pin -dir O -from 2 -to 0 data3_o1
  create_bd_pin -dir O -from 7 -to 0 data4_o
  create_bd_pin -dir O -from 17 -to 0 data4_o1
  create_bd_pin -dir O -from 25 -to 0 data5_o
  create_bd_pin -dir O -from 4 -to 0 data5_o1
  create_bd_pin -dir O -from 25 -to 0 data6_o
  create_bd_pin -dir O -from 23 -to 0 data6_o1
  create_bd_pin -dir O -from 25 -to 0 data7_o
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
   CONFIG.DATA_WIDTH_3 {8} \
   CONFIG.DATA_WIDTH_4 {8} \
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
   CONFIG.DATA_WIDTH_1 {17} \
   CONFIG.DATA_WIDTH_2 {3} \
   CONFIG.DATA_WIDTH_3 {3} \
   CONFIG.DATA_WIDTH_4 {18} \
   CONFIG.DATA_WIDTH_5 {5} \
   CONFIG.DATA_WIDTH_6 {24} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
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
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_1 [get_bd_pins s_axi_aclk] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: calc_r
proc create_hier_cell_calc_r { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_calc_r() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir I -from 23 -to 0 Din1
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -from 23 -to 0 m_axis_dout_tdata

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Width {36} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000000000000000} \
   CONFIG.B_Width {36} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Out_Width {36} \
 ] $c_addsub_0

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
   CONFIG.Coarse_Rotation {false} \
   CONFIG.Data_Format {UnsignedFraction} \
   CONFIG.Functional_Selection {Square_Root} \
   CONFIG.Input_Width {36} \
   CONFIG.Output_Width {18} \
 ] $cordic_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
   CONFIG.Multiplier_Construction {Use_Mults} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {18} \
   CONFIG.PortBType {Signed} \
   CONFIG.PortBWidth {18} \
 ] $mult_gen_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {36} \
   CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_3

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_6

  # Create port connections
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net clk_1 [get_bd_pins aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins cordic_0/aclk] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins m_axis_dout_tdata] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins Din] [get_bd_pins xlslice_5/Din]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins Din1] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_6/In1] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B] [get_bd_pins xlslice_6/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: soc
proc create_hier_cell_soc { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_soc() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

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

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M01_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M02_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M04_AXI] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_125M/interconnect_aresetn]
  connect_bd_net -net M00_ACLK_1 [get_bd_pins clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_125M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_125M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_125M/peripheral_aresetn]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll_3
proc create_hier_cell_pll_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pll_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I -from 15 -to 0 in0_i
  create_bd_pin -dir I -from 15 -to 0 in1_i
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: calc_r
  create_hier_cell_calc_r_3 $hier_obj calc_r

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
   CONFIG.INPUT_WIDTH {24} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_0

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
  
  # Create instance: multi_GPIO_1
  create_hier_cell_multi_GPIO_1_3 $hier_obj multi_GPIO_1

  # Create instance: mux_2x1_0, and set properties
  set block_name mux_2x1
  set block_cell_name mux_2x1_0
  if { [catch {set mux_2x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
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
   CONFIG.WIDTH {24} \
 ] $mux_8x1_0

  # Create instance: phase_det
  create_hier_cell_phase_det_3 $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_FACTORS {26} \
   CONFIG.N_OUT {26} \
 ] $pid_w_range_0

  # Create instance: wave_gen
  create_hier_cell_wave_gen_3 $hier_obj wave_gen

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {12} \
   CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {24} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_1/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins multi_GPIO_1/data1_o1] [get_bd_pins phase_det/Alpha_DI]
  connect_bd_net -net Div_SI_1 [get_bd_pins multi_GPIO_1/data1_o] [get_bd_pins wave_gen/Div_SI]
  connect_bd_net -net Order_DI_1 [get_bd_pins multi_GPIO_1/data2_o1] [get_bd_pins phase_det/Order_DI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins multi_GPIO_1/data2_o] [get_bd_pins wave_gen/PidEn_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins multi_GPIO_1/data3_o] [get_bd_pins wave_gen/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins multi_GPIO_1/data4_o] [get_bd_pins wave_gen/WB_DI]
  connect_bd_net -net adc_adc_a [get_bd_pins in0_i] [get_bd_pins mux_2x1_0/in0_i]
  connect_bd_net -net adc_adc_b [get_bd_pins in1_i] [get_bd_pins mux_2x1_0/in1_i]
  connect_bd_net -net calc_r_m_axis_dout_tdata [get_bd_pins calc_r/m_axis_dout_tdata] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net clk_1 [get_bd_pins Clk_CI] [get_bd_pins calc_r/aclk] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_1/s_axi_aclk] [get_bd_pins mux_2x1_0/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins data_o] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_1/data0_o] [get_bd_pins mux_2x1_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins multi_GPIO_1/data0_o1] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins multi_GPIO_1/data3_o1] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_1/data4_o1]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins multi_GPIO_1/data5_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins coarse_gain_and_limi_0/log2_gain_i] [get_bd_pins multi_GPIO_1/data5_o1]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins multi_GPIO_1/data6_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins multi_GPIO_1/data6_o1] [get_bd_pins mux_8x1_0/in5_i]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins multi_GPIO_1/data7_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net mux_2x1_0_out_o [get_bd_pins mux_2x1_0/out_o] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins calc_r/Din] [get_bd_pins mux_8x1_0/in1_i] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins calc_r/Din1] [get_bd_pins mux_8x1_0/in2_i] [get_bd_pins phase_det/mix_sin_lpf]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net pll2_WAVE1 [get_bd_pins wave_gen/C_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_1/s_axi_aresetn] [get_bd_pins mux_2x1_0/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins mux_8x1_0/in0_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins mux_8x1_0/in4_i] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_6/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconstant_5/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll_2
proc create_hier_cell_pll_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pll_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I -from 15 -to 0 in0_i
  create_bd_pin -dir I -from 15 -to 0 in1_i
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: calc_r
  create_hier_cell_calc_r_2 $hier_obj calc_r

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
   CONFIG.INPUT_WIDTH {24} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_0

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
  
  # Create instance: multi_GPIO_1
  create_hier_cell_multi_GPIO_1_2 $hier_obj multi_GPIO_1

  # Create instance: mux_2x1_0, and set properties
  set block_name mux_2x1
  set block_cell_name mux_2x1_0
  if { [catch {set mux_2x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
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
   CONFIG.WIDTH {24} \
 ] $mux_8x1_0

  # Create instance: phase_det
  create_hier_cell_phase_det_2 $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_FACTORS {26} \
   CONFIG.N_OUT {26} \
 ] $pid_w_range_0

  # Create instance: wave_gen
  create_hier_cell_wave_gen_2 $hier_obj wave_gen

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {12} \
   CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {24} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_1/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins multi_GPIO_1/data1_o1] [get_bd_pins phase_det/Alpha_DI]
  connect_bd_net -net Div_SI_1 [get_bd_pins multi_GPIO_1/data1_o] [get_bd_pins wave_gen/Div_SI]
  connect_bd_net -net Order_DI_1 [get_bd_pins multi_GPIO_1/data2_o1] [get_bd_pins phase_det/Order_DI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins multi_GPIO_1/data2_o] [get_bd_pins wave_gen/PidEn_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins multi_GPIO_1/data3_o] [get_bd_pins wave_gen/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins multi_GPIO_1/data4_o] [get_bd_pins wave_gen/WB_DI]
  connect_bd_net -net adc_adc_a [get_bd_pins in0_i] [get_bd_pins mux_2x1_0/in0_i]
  connect_bd_net -net adc_adc_b [get_bd_pins in1_i] [get_bd_pins mux_2x1_0/in1_i]
  connect_bd_net -net calc_r_m_axis_dout_tdata [get_bd_pins calc_r/m_axis_dout_tdata] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net clk_1 [get_bd_pins Clk_CI] [get_bd_pins calc_r/aclk] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_1/s_axi_aclk] [get_bd_pins mux_2x1_0/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins data_o] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_1/data0_o] [get_bd_pins mux_2x1_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins multi_GPIO_1/data0_o1] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins multi_GPIO_1/data3_o1] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_1/data4_o1]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins multi_GPIO_1/data5_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins coarse_gain_and_limi_0/log2_gain_i] [get_bd_pins multi_GPIO_1/data5_o1]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins multi_GPIO_1/data6_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins multi_GPIO_1/data6_o1] [get_bd_pins mux_8x1_0/in5_i]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins multi_GPIO_1/data7_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net mux_2x1_0_out_o [get_bd_pins mux_2x1_0/out_o] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins calc_r/Din] [get_bd_pins mux_8x1_0/in1_i] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins calc_r/Din1] [get_bd_pins mux_8x1_0/in2_i] [get_bd_pins phase_det/mix_sin_lpf]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net pll2_WAVE1 [get_bd_pins wave_gen/C_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_1/s_axi_aresetn] [get_bd_pins mux_2x1_0/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins mux_8x1_0/in0_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins mux_8x1_0/in4_i] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_6/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconstant_5/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll_1
proc create_hier_cell_pll_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pll_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I -from 15 -to 0 in0_i
  create_bd_pin -dir I -from 15 -to 0 in1_i
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: calc_r
  create_hier_cell_calc_r_1 $hier_obj calc_r

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
   CONFIG.INPUT_WIDTH {24} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_0

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
  
  # Create instance: multi_GPIO_1
  create_hier_cell_multi_GPIO_1_1 $hier_obj multi_GPIO_1

  # Create instance: mux_2x1_0, and set properties
  set block_name mux_2x1
  set block_cell_name mux_2x1_0
  if { [catch {set mux_2x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
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
   CONFIG.WIDTH {24} \
 ] $mux_8x1_0

  # Create instance: phase_det
  create_hier_cell_phase_det_1 $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_FACTORS {26} \
   CONFIG.N_OUT {26} \
 ] $pid_w_range_0

  # Create instance: wave_gen
  create_hier_cell_wave_gen_1 $hier_obj wave_gen

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {12} \
   CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {24} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_1/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins multi_GPIO_1/data1_o1] [get_bd_pins phase_det/Alpha_DI]
  connect_bd_net -net Div_SI_1 [get_bd_pins multi_GPIO_1/data1_o] [get_bd_pins wave_gen/Div_SI]
  connect_bd_net -net Order_DI_1 [get_bd_pins multi_GPIO_1/data2_o1] [get_bd_pins phase_det/Order_DI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins multi_GPIO_1/data2_o] [get_bd_pins wave_gen/PidEn_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins multi_GPIO_1/data3_o] [get_bd_pins wave_gen/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins multi_GPIO_1/data4_o] [get_bd_pins wave_gen/WB_DI]
  connect_bd_net -net adc_adc_a [get_bd_pins in0_i] [get_bd_pins mux_2x1_0/in0_i]
  connect_bd_net -net adc_adc_b [get_bd_pins in1_i] [get_bd_pins mux_2x1_0/in1_i]
  connect_bd_net -net calc_r_m_axis_dout_tdata [get_bd_pins calc_r/m_axis_dout_tdata] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net clk_1 [get_bd_pins Clk_CI] [get_bd_pins calc_r/aclk] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_1/s_axi_aclk] [get_bd_pins mux_2x1_0/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins data_o] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_1/data0_o] [get_bd_pins mux_2x1_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins multi_GPIO_1/data0_o1] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins multi_GPIO_1/data3_o1] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_1/data4_o1]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins multi_GPIO_1/data5_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins coarse_gain_and_limi_0/log2_gain_i] [get_bd_pins multi_GPIO_1/data5_o1]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins multi_GPIO_1/data6_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins multi_GPIO_1/data6_o1] [get_bd_pins mux_8x1_0/in5_i]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins multi_GPIO_1/data7_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net mux_2x1_0_out_o [get_bd_pins mux_2x1_0/out_o] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins calc_r/Din] [get_bd_pins mux_8x1_0/in1_i] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins calc_r/Din1] [get_bd_pins mux_8x1_0/in2_i] [get_bd_pins phase_det/mix_sin_lpf]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net pll2_WAVE1 [get_bd_pins wave_gen/C_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_1/s_axi_aresetn] [get_bd_pins mux_2x1_0/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins mux_8x1_0/in0_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins mux_8x1_0/in4_i] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_6/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconstant_5/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll_0
proc create_hier_cell_pll_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pll_0() - Empty argument(s)!"}
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
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir I -from 15 -to 0 in0_i
  create_bd_pin -dir I -from 15 -to 0 in1_i
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: calc_r
  create_hier_cell_calc_r $hier_obj calc_r

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
   CONFIG.INPUT_WIDTH {24} \
   CONFIG.MAX_LOG2_GAIN {31} \
   CONFIG.WIDTH_LOG2_GAIN {5} \
 ] $coarse_gain_and_limi_0

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
  
  # Create instance: multi_GPIO_1
  create_hier_cell_multi_GPIO_1 $hier_obj multi_GPIO_1

  # Create instance: mux_2x1_0, and set properties
  set block_name mux_2x1
  set block_cell_name mux_2x1_0
  if { [catch {set mux_2x1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux_2x1_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
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
   CONFIG.WIDTH {24} \
 ] $mux_8x1_0

  # Create instance: phase_det
  create_hier_cell_phase_det $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.N_FACTORS {26} \
   CONFIG.N_OUT {26} \
 ] $pid_w_range_0

  # Create instance: wave_gen
  create_hier_cell_wave_gen $hier_obj wave_gen

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {12} \
   CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_1

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_6

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {24} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $xlconstant_5

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins multi_GPIO_1/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins multi_GPIO_1/data1_o1] [get_bd_pins phase_det/Alpha_DI]
  connect_bd_net -net Div_SI_1 [get_bd_pins multi_GPIO_1/data1_o] [get_bd_pins wave_gen/Div_SI]
  connect_bd_net -net Order_DI_1 [get_bd_pins multi_GPIO_1/data2_o1] [get_bd_pins phase_det/Order_DI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins multi_GPIO_1/data2_o] [get_bd_pins wave_gen/PidEn_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins multi_GPIO_1/data3_o] [get_bd_pins wave_gen/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins multi_GPIO_1/data4_o] [get_bd_pins wave_gen/WB_DI]
  connect_bd_net -net adc_adc_a [get_bd_pins in0_i] [get_bd_pins mux_2x1_0/in0_i]
  connect_bd_net -net adc_adc_b [get_bd_pins in1_i] [get_bd_pins mux_2x1_0/in1_i]
  connect_bd_net -net calc_r_m_axis_dout_tdata [get_bd_pins calc_r/m_axis_dout_tdata] [get_bd_pins mux_8x1_0/in3_i]
  connect_bd_net -net clk_1 [get_bd_pins Clk_CI] [get_bd_pins calc_r/aclk] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins fine_gain_0/clk_i] [get_bd_pins multi_GPIO_1/s_axi_aclk] [get_bd_pins mux_2x1_0/clk_i] [get_bd_pins mux_8x1_0/clk_i] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins data_o] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net fine_gain_0_data_o [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins fine_gain_0/data_o]
  connect_bd_net -net multi_GPIO_1_data0_o [get_bd_pins multi_GPIO_1/data0_o] [get_bd_pins mux_2x1_0/sel_i]
  connect_bd_net -net multi_GPIO_1_data0_o1 [get_bd_pins multi_GPIO_1/data0_o1] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net multi_GPIO_1_data3_o1 [get_bd_pins multi_GPIO_1/data3_o1] [get_bd_pins mux_8x1_0/select_i]
  connect_bd_net -net multi_GPIO_1_data4_o1 [get_bd_pins fine_gain_0/gain_i] [get_bd_pins multi_GPIO_1/data4_o1]
  connect_bd_net -net multi_GPIO_1_data5_o [get_bd_pins multi_GPIO_1/data5_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net multi_GPIO_1_data5_o1 [get_bd_pins coarse_gain_and_limi_0/log2_gain_i] [get_bd_pins multi_GPIO_1/data5_o1]
  connect_bd_net -net multi_GPIO_1_data6_o [get_bd_pins multi_GPIO_1/data6_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net multi_GPIO_1_data6_o1 [get_bd_pins multi_GPIO_1/data6_o1] [get_bd_pins mux_8x1_0/in5_i]
  connect_bd_net -net multi_GPIO_1_data7_o [get_bd_pins multi_GPIO_1/data7_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net mux_2x1_0_out_o [get_bd_pins mux_2x1_0/out_o] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net mux_8x1_0_out_o [get_bd_pins fine_gain_0/data_i] [get_bd_pins mux_8x1_0/out_o]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins calc_r/Din] [get_bd_pins mux_8x1_0/in1_i] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins calc_r/Din1] [get_bd_pins mux_8x1_0/in2_i] [get_bd_pins phase_det/mix_sin_lpf]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net pll2_WAVE1 [get_bd_pins wave_gen/C_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins fine_gain_0/rst_ni] [get_bd_pins multi_GPIO_1/s_axi_aresetn] [get_bd_pins mux_2x1_0/rst_ni] [get_bd_pins mux_8x1_0/rst_ni] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins mux_8x1_0/in0_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins mux_8x1_0/in4_i] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_6/In0] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins mux_8x1_0/in6_i] [get_bd_pins mux_8x1_0/in7_i] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconstant_5/dout]

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
  create_bd_pin -dir O -from 2 -to 0 data0_o
  create_bd_pin -dir O -from 2 -to 0 data1_o
  create_bd_pin -dir O -from 7 -to 0 data2_o
  create_bd_pin -dir O -from 7 -to 0 data3_o
  create_bd_pin -dir O -from 2 -to 0 data4_o
  create_bd_pin -dir O -from 2 -to 0 data5_o
  create_bd_pin -dir O -from 13 -to 0 data6_o
  create_bd_pin -dir O -from 13 -to 0 data7_o
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
   CONFIG.DATA_WIDTH_0 {3} \
   CONFIG.DATA_WIDTH_1 {3} \
   CONFIG.DATA_WIDTH_2 {8} \
   CONFIG.DATA_WIDTH_3 {8} \
   CONFIG.DATA_WIDTH_4 {3} \
   CONFIG.DATA_WIDTH_5 {3} \
   CONFIG.DATA_WIDTH_6 {14} \
   CONFIG.DATA_WIDTH_7 {14} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net GPIO_mux_0_data0_o [get_bd_pins data0_o] [get_bd_pins GPIO_mux_0/data0_o]
  connect_bd_net -net GPIO_mux_0_data1_o [get_bd_pins data1_o] [get_bd_pins GPIO_mux_0/data1_o]
  connect_bd_net -net GPIO_mux_0_data2_o [get_bd_pins data2_o] [get_bd_pins GPIO_mux_0/data2_o]
  connect_bd_net -net GPIO_mux_0_data3_o [get_bd_pins data3_o] [get_bd_pins GPIO_mux_0/data3_o]
  connect_bd_net -net GPIO_mux_0_data4_o [get_bd_pins data4_o] [get_bd_pins GPIO_mux_0/data4_o]
  connect_bd_net -net GPIO_mux_0_data5_o [get_bd_pins data5_o] [get_bd_pins GPIO_mux_0/data5_o]
  connect_bd_net -net GPIO_mux_0_data6_o [get_bd_pins data6_o] [get_bd_pins GPIO_mux_0/data6_o]
  connect_bd_net -net GPIO_mux_0_data7_o [get_bd_pins data7_o] [get_bd_pins GPIO_mux_0/data7_o]
  connect_bd_net -net GPIO_mux_0_gpio2_o [get_bd_pins GPIO_mux_0/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_0_i]
  connect_bd_net -net GPIO_mux_1_gpio2_o [get_bd_pins GPIO_mux_1/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_1_i]
  connect_bd_net -net GPIO_mux_2_gpio2_o [get_bd_pins GPIO_mux_2/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_2_i]
  connect_bd_net -net GPIO_mux_3_gpio2_o [get_bd_pins GPIO_mux_3/gpio2_o] [get_bd_pins GPIO_super_mux_0/gpio2_3_i]
  connect_bd_net -net GPIO_super_mux_0_gpio2_o [get_bd_pins GPIO_super_mux_0/gpio2_o] [get_bd_pins axi_gpio_0/gpio2_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins GPIO_mux_0/gpio1_i] [get_bd_pins GPIO_mux_1/gpio1_i] [get_bd_pins GPIO_mux_2/gpio1_i] [get_bd_pins GPIO_mux_3/gpio1_i] [get_bd_pins GPIO_super_mux_0/gpio1_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_1 [get_bd_pins s_axi_aclk] [get_bd_pins GPIO_mux_0/clk_i] [get_bd_pins GPIO_mux_1/clk_i] [get_bd_pins GPIO_mux_2/clk_i] [get_bd_pins GPIO_mux_3/clk_i] [get_bd_pins GPIO_super_mux_0/clk_i] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins GPIO_mux_0/rst_ni] [get_bd_pins GPIO_mux_1/rst_ni] [get_bd_pins GPIO_mux_2/rst_ni] [get_bd_pins GPIO_mux_3/rst_ni] [get_bd_pins GPIO_super_mux_0/rst_ni] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dual_sum_block
proc create_hier_cell_dual_sum_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dual_sum_block() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 add_select0_i
  create_bd_pin -dir I -from 7 -to 0 add_select1_i
  create_bd_pin -dir I clk_i
  create_bd_pin -dir I -from 13 -to 0 data0_i
  create_bd_pin -dir I -from 13 -to 0 data1_i
  create_bd_pin -dir I -from 13 -to 0 data2_i
  create_bd_pin -dir I -from 13 -to 0 data3_i
  create_bd_pin -dir I -from 13 -to 0 data4_i
  create_bd_pin -dir I -from 13 -to 0 data5_i
  create_bd_pin -dir I -from 13 -to 0 data6_i
  create_bd_pin -dir I -from 13 -to 0 data7_i
  create_bd_pin -dir O -from 13 -to 0 data_o
  create_bd_pin -dir O -from 13 -to 0 data_o1
  create_bd_pin -dir I -from 2 -to 0 log2_gain_i
  create_bd_pin -dir I -from 2 -to 0 log2_gain_i1
  create_bd_pin -dir I rst_ni

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
   CONFIG.INPUT_WIDTH {17} \
   CONFIG.MAX_LOG2_GAIN {7} \
   CONFIG.WIDTH_LOG2_GAIN {3} \
 ] $coarse_gain_and_limi_0

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
   CONFIG.INPUT_WIDTH {17} \
   CONFIG.MAX_LOG2_GAIN {7} \
   CONFIG.WIDTH_LOG2_GAIN {3} \
 ] $coarse_gain_and_limi_1

  # Create instance: conditional_adder_8x2_0, and set properties
  set block_name conditional_adder_8x2
  set block_cell_name conditional_adder_8x2_0
  if { [catch {set conditional_adder_8x2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $conditional_adder_8x2_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk_i] [get_bd_pins coarse_gain_and_limi_0/clk_i] [get_bd_pins coarse_gain_and_limi_1/clk_i] [get_bd_pins conditional_adder_8x2_0/clk_i]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins data_o1] [get_bd_pins coarse_gain_and_limi_0/data_o]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins data_o] [get_bd_pins coarse_gain_and_limi_1/data_o]
  connect_bd_net -net conditional_adder_8x2_0_data0_o [get_bd_pins coarse_gain_and_limi_0/data_i] [get_bd_pins conditional_adder_8x2_0/data0_o]
  connect_bd_net -net conditional_adder_8x2_0_data1_o [get_bd_pins coarse_gain_and_limi_1/data_i] [get_bd_pins conditional_adder_8x2_0/data1_o]
  connect_bd_net -net multi_GPIO_0_data2_o [get_bd_pins add_select0_i] [get_bd_pins conditional_adder_8x2_0/add_select0_i]
  connect_bd_net -net multi_GPIO_0_data3_o [get_bd_pins add_select1_i] [get_bd_pins conditional_adder_8x2_0/add_select1_i]
  connect_bd_net -net multi_GPIO_0_data4_o [get_bd_pins log2_gain_i1] [get_bd_pins coarse_gain_and_limi_0/log2_gain_i]
  connect_bd_net -net multi_GPIO_0_data5_o [get_bd_pins log2_gain_i] [get_bd_pins coarse_gain_and_limi_1/log2_gain_i]
  connect_bd_net -net multi_GPIO_0_data6_o [get_bd_pins data6_i] [get_bd_pins conditional_adder_8x2_0/data6_i]
  connect_bd_net -net multi_GPIO_0_data7_o [get_bd_pins data7_i] [get_bd_pins conditional_adder_8x2_0/data7_i]
  connect_bd_net -net pll_0_data_o [get_bd_pins data2_i] [get_bd_pins conditional_adder_8x2_0/data2_i]
  connect_bd_net -net pll_1_data_o [get_bd_pins data3_i] [get_bd_pins conditional_adder_8x2_0/data3_i]
  connect_bd_net -net pll_2_data_o [get_bd_pins data4_i] [get_bd_pins conditional_adder_8x2_0/data4_i]
  connect_bd_net -net pll_3_data_o [get_bd_pins data5_i] [get_bd_pins conditional_adder_8x2_0/data5_i]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins rst_ni] [get_bd_pins coarse_gain_and_limi_0/rst_ni] [get_bd_pins coarse_gain_and_limi_1/rst_ni] [get_bd_pins conditional_adder_8x2_0/rst_ni]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins data0_i] [get_bd_pins conditional_adder_8x2_0/data0_i]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins data1_i] [get_bd_pins conditional_adder_8x2_0/data1_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dac
proc create_hier_cell_dac { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dac() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk Clk_CI
  create_bd_pin -dir I -from 13 -to 0 In0_DI
  create_bd_pin -dir I -from 13 -to 0 In1_DI
  create_bd_pin -dir I -from 13 -to 0 In2_DI
  create_bd_pin -dir I -from 13 -to 0 In3_DI
  create_bd_pin -dir I -from 13 -to 0 In4_DI
  create_bd_pin -dir I -from 13 -to 0 In5_DI
  create_bd_pin -dir I -from 13 -to 0 In6_DI
  create_bd_pin -dir I -from 13 -to 0 In7_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I -from 2 -to 0 SwitchDac0_SI
  create_bd_pin -dir I -from 2 -to 0 SwitchDac1_SI
  create_bd_pin -dir I Valid0_SI
  create_bd_pin -dir I Valid1_SI
  create_bd_pin -dir I Valid2_SI
  create_bd_pin -dir I Valid3_SI
  create_bd_pin -dir I Valid4_SI
  create_bd_pin -dir I Valid5_SI
  create_bd_pin -dir I Valid6_SI
  create_bd_pin -dir I Valid7_SI
  create_bd_pin -dir O -type clk dac_clk
  create_bd_pin -dir O -from 13 -to 0 dac_dat
  create_bd_pin -dir O -type rst dac_rst
  create_bd_pin -dir O dac_sel
  create_bd_pin -dir O dac_wrt

  # Create instance: axis_red_pitaya_dac_0, and set properties
  set block_name axis_red_pitaya_dac
  set block_cell_name axis_red_pitaya_dac_0
  if { [catch {set axis_red_pitaya_dac_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_red_pitaya_dac_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {320.0} \
   CONFIG.CLKOUT1_JITTER {175.817} \
   CONFIG.CLKOUT1_PHASE_ERROR {204.239} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {32.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {32.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PRIM_IN_FREQ {31.25} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: dac_out_switch_0, and set properties
  set block_name dac_out_switch
  set block_cell_name dac_out_switch_0
  if { [catch {set dac_out_switch_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dac_out_switch_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net Clk_CI_1 [get_bd_pins Clk_CI] [get_bd_pins axis_red_pitaya_dac_0/aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins dac_out_switch_0/Clk_CI]
  connect_bd_net -net In0_DI_1 [get_bd_pins In0_DI] [get_bd_pins dac_out_switch_0/In0_DI]
  connect_bd_net -net In1_DI_1 [get_bd_pins In1_DI] [get_bd_pins dac_out_switch_0/In1_DI]
  connect_bd_net -net In2_DI_1 [get_bd_pins In2_DI] [get_bd_pins dac_out_switch_0/In2_DI]
  connect_bd_net -net In3_DI_1 [get_bd_pins In3_DI] [get_bd_pins dac_out_switch_0/In3_DI]
  connect_bd_net -net In4_DI_1 [get_bd_pins In4_DI] [get_bd_pins dac_out_switch_0/In4_DI]
  connect_bd_net -net In5_DI_1 [get_bd_pins In5_DI] [get_bd_pins dac_out_switch_0/In5_DI]
  connect_bd_net -net In6_DI_1 [get_bd_pins In6_DI] [get_bd_pins dac_out_switch_0/In6_DI]
  connect_bd_net -net In7_DI_1 [get_bd_pins In7_DI] [get_bd_pins dac_out_switch_0/In7_DI]
  connect_bd_net -net Reset_RBI_1 [get_bd_pins Reset_RBI] [get_bd_pins dac_out_switch_0/Reset_RBI]
  connect_bd_net -net SwitchDac0_SI_1 [get_bd_pins SwitchDac0_SI] [get_bd_pins dac_out_switch_0/SwitchDac0_SI]
  connect_bd_net -net SwitchDac1_SI_1 [get_bd_pins SwitchDac1_SI] [get_bd_pins dac_out_switch_0/SwitchDac1_SI]
  connect_bd_net -net Valid0_SI_1 [get_bd_pins Valid0_SI] [get_bd_pins dac_out_switch_0/Valid0_SI]
  connect_bd_net -net Valid1_SI_1 [get_bd_pins Valid1_SI] [get_bd_pins dac_out_switch_0/Valid1_SI]
  connect_bd_net -net Valid2_SI_1 [get_bd_pins Valid2_SI] [get_bd_pins dac_out_switch_0/Valid2_SI]
  connect_bd_net -net Valid3_SI_1 [get_bd_pins Valid3_SI] [get_bd_pins dac_out_switch_0/Valid3_SI]
  connect_bd_net -net Valid4_SI_1 [get_bd_pins Valid4_SI] [get_bd_pins dac_out_switch_0/Valid4_SI]
  connect_bd_net -net Valid5_SI_1 [get_bd_pins Valid5_SI] [get_bd_pins dac_out_switch_0/Valid5_SI]
  connect_bd_net -net Valid6_SI_1 [get_bd_pins Valid6_SI] [get_bd_pins dac_out_switch_0/Valid6_SI]
  connect_bd_net -net Valid7_SI_1 [get_bd_pins Valid7_SI] [get_bd_pins dac_out_switch_0/Valid7_SI]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_clk [get_bd_pins dac_clk] [get_bd_pins axis_red_pitaya_dac_0/dac_clk]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_dat [get_bd_pins dac_dat] [get_bd_pins axis_red_pitaya_dac_0/dac_dat]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_rst [get_bd_pins dac_rst] [get_bd_pins axis_red_pitaya_dac_0/dac_rst]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_sel [get_bd_pins dac_sel] [get_bd_pins axis_red_pitaya_dac_0/dac_sel]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_wrt [get_bd_pins dac_wrt] [get_bd_pins axis_red_pitaya_dac_0/dac_wrt]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axis_red_pitaya_dac_0/ddr_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins axis_red_pitaya_dac_0/locked] [get_bd_pins clk_wiz_0/locked]
  connect_bd_net -net dac_out_switch_0_DacOut_DO [get_bd_pins axis_red_pitaya_dac_0/s_axis_tdata] [get_bd_pins dac_out_switch_0/DacOut_DO]
  connect_bd_net -net dac_out_switch_0_Valid_SO [get_bd_pins axis_red_pitaya_dac_0/s_axis_tvalid] [get_bd_pins dac_out_switch_0/Valid_SO]

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
  set exp_n_tri_io [ create_bd_port -dir O -from 7 -to 0 exp_n_tri_io ]
  set exp_p_tri_io [ create_bd_port -dir O -from 7 -to 0 exp_p_tri_io ]
  set led_o [ create_bd_port -dir O -from 7 -to 0 led_o ]

  # Create instance: axis_red_pitaya_adc_0, and set properties
  set block_name axis_red_pitaya_adc
  set block_cell_name axis_red_pitaya_adc_0
  if { [catch {set axis_red_pitaya_adc_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_red_pitaya_adc_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {31250000} \
 ] [get_bd_pins /axis_red_pitaya_adc_0/adc_clk]

  # Create instance: dac
  create_hier_cell_dac [current_bd_instance .] dac

  # Create instance: dual_sum_block
  create_hier_cell_dual_sum_block [current_bd_instance .] dual_sum_block

  # Create instance: multi_GPIO_0
  create_hier_cell_multi_GPIO_0 [current_bd_instance .] multi_GPIO_0

  # Create instance: pll_0
  create_hier_cell_pll_0 [current_bd_instance .] pll_0

  # Create instance: pll_1
  create_hier_cell_pll_1 [current_bd_instance .] pll_1

  # Create instance: pll_2
  create_hier_cell_pll_2 [current_bd_instance .] pll_2

  # Create instance: pll_3
  create_hier_cell_pll_3 [current_bd_instance .] pll_3

  # Create instance: soc
  create_hier_cell_soc [current_bd_instance .] soc

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

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net soc_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins soc/DDR]
  connect_bd_intf_net -intf_net soc_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins soc/FIXED_IO]
  connect_bd_intf_net -intf_net soc_M00_AXI [get_bd_intf_pins multi_GPIO_0/S_AXI] [get_bd_intf_pins soc/M00_AXI]
  connect_bd_intf_net -intf_net soc_M01_AXI [get_bd_intf_pins pll_0/S_AXI] [get_bd_intf_pins soc/M01_AXI]
  connect_bd_intf_net -intf_net soc_M02_AXI [get_bd_intf_pins pll_1/S_AXI] [get_bd_intf_pins soc/M02_AXI]
  connect_bd_intf_net -intf_net soc_M03_AXI [get_bd_intf_pins pll_2/S_AXI] [get_bd_intf_pins soc/M03_AXI]
  connect_bd_intf_net -intf_net soc_M04_AXI [get_bd_intf_pins pll_3/S_AXI] [get_bd_intf_pins soc/M04_AXI]

  # Create port connections
  connect_bd_net -net SwitchDac0_SI_1 [get_bd_pins dac/SwitchDac0_SI] [get_bd_pins multi_GPIO_0/data0_o]
  connect_bd_net -net SwitchDac1_SI_1 [get_bd_pins dac/SwitchDac1_SI] [get_bd_pins multi_GPIO_0/data1_o]
  connect_bd_net -net Valid7_SI_1 [get_bd_pins dac/Valid0_SI] [get_bd_pins dac/Valid1_SI] [get_bd_pins dac/Valid2_SI] [get_bd_pins dac/Valid3_SI] [get_bd_pins dac/Valid4_SI] [get_bd_pins dac/Valid5_SI] [get_bd_pins dac/Valid6_SI] [get_bd_pins dac/Valid7_SI] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net adc_adc_a [get_bd_pins axis_red_pitaya_adc_0/adc_a] [get_bd_pins pll_0/in0_i] [get_bd_pins pll_1/in0_i] [get_bd_pins pll_2/in0_i] [get_bd_pins pll_3/in0_i] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net adc_adc_b [get_bd_pins axis_red_pitaya_adc_0/adc_b] [get_bd_pins pll_0/in1_i] [get_bd_pins pll_1/in1_i] [get_bd_pins pll_2/in1_i] [get_bd_pins pll_3/in1_i] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net adc_adc_csn [get_bd_ports adc_csn_o] [get_bd_pins axis_red_pitaya_adc_0/adc_csn]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_ports adc_clk_n_i] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_n]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_ports adc_clk_p_i] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_p]
  connect_bd_net -net adc_dat_a_i_1 [get_bd_ports adc_dat_a_i] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_a]
  connect_bd_net -net adc_dat_b_i_1 [get_bd_ports adc_dat_b_i] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_b]
  connect_bd_net -net clk_1 [get_bd_pins axis_red_pitaya_adc_0/adc_clk] [get_bd_pins dac/Clk_CI] [get_bd_pins dual_sum_block/clk_i] [get_bd_pins multi_GPIO_0/s_axi_aclk] [get_bd_pins pll_0/Clk_CI] [get_bd_pins pll_1/Clk_CI] [get_bd_pins pll_2/Clk_CI] [get_bd_pins pll_3/Clk_CI] [get_bd_pins soc/clk]
  connect_bd_net -net coarse_gain_and_limi_0_data_o [get_bd_pins dac/In6_DI] [get_bd_pins dual_sum_block/data_o1]
  connect_bd_net -net coarse_gain_and_limi_1_data_o [get_bd_pins dac/In7_DI] [get_bd_pins dual_sum_block/data_o]
  connect_bd_net -net dac_dac_clk [get_bd_ports dac_clk_o] [get_bd_pins dac/dac_clk]
  connect_bd_net -net dac_dac_dat [get_bd_ports dac_dat_o] [get_bd_pins dac/dac_dat]
  connect_bd_net -net dac_dac_rst [get_bd_ports dac_rst_o] [get_bd_pins dac/dac_rst]
  connect_bd_net -net dac_dac_sel [get_bd_ports dac_sel_o] [get_bd_pins dac/dac_sel]
  connect_bd_net -net dac_dac_wrt [get_bd_ports dac_wrt_o] [get_bd_pins dac/dac_wrt]
  connect_bd_net -net daisy_n_i_1 [get_bd_ports daisy_n_i] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
  connect_bd_net -net daisy_p_i_1 [get_bd_ports daisy_p_i] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
  connect_bd_net -net multi_GPIO_0_data2_o [get_bd_pins dual_sum_block/add_select0_i] [get_bd_pins multi_GPIO_0/data2_o]
  connect_bd_net -net multi_GPIO_0_data3_o [get_bd_pins dual_sum_block/add_select1_i] [get_bd_pins multi_GPIO_0/data3_o]
  connect_bd_net -net multi_GPIO_0_data4_o [get_bd_pins dual_sum_block/log2_gain_i1] [get_bd_pins multi_GPIO_0/data4_o]
  connect_bd_net -net multi_GPIO_0_data5_o [get_bd_pins dual_sum_block/log2_gain_i] [get_bd_pins multi_GPIO_0/data5_o]
  connect_bd_net -net multi_GPIO_0_data6_o [get_bd_pins dual_sum_block/data6_i] [get_bd_pins multi_GPIO_0/data6_o]
  connect_bd_net -net multi_GPIO_0_data7_o [get_bd_pins dual_sum_block/data7_i] [get_bd_pins multi_GPIO_0/data7_o]
  connect_bd_net -net pll_0_data_o [get_bd_pins dac/In2_DI] [get_bd_pins dual_sum_block/data2_i] [get_bd_pins pll_0/data_o]
  connect_bd_net -net pll_1_data_o [get_bd_pins dac/In3_DI] [get_bd_pins dual_sum_block/data3_i] [get_bd_pins pll_1/data_o]
  connect_bd_net -net pll_2_data_o [get_bd_pins dac/In4_DI] [get_bd_pins dual_sum_block/data4_i] [get_bd_pins pll_2/data_o]
  connect_bd_net -net pll_3_data_o [get_bd_pins dac/In5_DI] [get_bd_pins dual_sum_block/data5_i] [get_bd_pins pll_3/data_o]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins dac/Reset_RBI] [get_bd_pins dual_sum_block/rst_ni] [get_bd_pins multi_GPIO_0/s_axi_aresetn] [get_bd_pins pll_0/s_axi_aresetn] [get_bd_pins pll_1/s_axi_aresetn] [get_bd_pins pll_2/s_axi_aresetn] [get_bd_pins pll_3/s_axi_aresetn] [get_bd_pins soc/peripheral_aresetn]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins util_ds_buf_2/OBUF_IN]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_N [get_bd_ports daisy_n_o] [get_bd_pins util_ds_buf_2/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_P [get_bd_ports daisy_p_o] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins dac/In0_DI] [get_bd_pins dual_sum_block/data0_i] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins dac/In1_DI] [get_bd_pins dual_sum_block/data1_i] [get_bd_pins xlslice_1/Dout]

  # Create address segments
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs multi_GPIO_0/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll_0/multi_GPIO_1/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll_1/multi_GPIO_1/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll_2/multi_GPIO_1/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll_3/multi_GPIO_1/axi_gpio_0/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

