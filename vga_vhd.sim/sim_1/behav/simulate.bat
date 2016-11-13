@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xsim vga_out_tb_behav -key {Behavioral:sim_1:Functional:vga_out_tb} -tclbatch vga_out_tb.tcl -view C:/workspace_vivado/vga_vhd/vga_out_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
