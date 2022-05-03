# Define project properties
set project_name pll
set part_name xc7z010clg400-1

# Instantiate project
set bd_path tmp/$project_name/$project_name.srcs/sources_1/bd/system
file delete -force tmp/$project_name
create_project $project_name tmp/$project_name -part $part_name
create_bd_design system


# Load custom Verilog and SystemVerilog and VHDL files in the project folder
set files [glob -nocomplain verilog/*.v]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
set files [glob -nocomplain verilog/*.sv]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
set files [glob -nocomplain vhdl/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
update_compile_order -fileset sources_1

# Load custom Verilog testbench files in the project folder
set files [glob -nocomplain testbenches/*_tb.v]
if {[llength $files] > 0} {
  add_files -fileset sim_1 -norecurse $files
}
update_compile_order -fileset sim_1


#add constraint files
add_files -fileset constrs_1 -norecurse {constraints/clocks.xdc constraints/ports.xdc}

source block_design.tcl

generate_target all [get_files  $bd_path/system.bd]


regenerate_bd_layout

make_wrapper -files [get_files $bd_path/system.bd] -top
add_files -norecurse $bd_path/hdl/system_wrapper.v
set_property top system_wrapper [current_fileset]
save_bd_design
