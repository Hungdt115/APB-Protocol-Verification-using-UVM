#!/bin/csh

set TOP = "$1"
set TB_TOP = "$2"
set TESTNAME = "$3"

# =========================================================================
# == Vivado Simulator (xvlog/xelab/xsim)
# =========================================================================

# Make sure to source the Vivado settings script first
# For example: source /opt/Xilinx/Vivado/2024.2/settings64.csh

set PROJECT_ROOT = `dirname $0`/..

mkdir -p "$PROJECT_ROOT/log"
mkdir -p "$PROJECT_ROOT/rep"

echo ""
echo "********************************************************"
echo "*         APB Protocol Verification - Vivado Sim         *"
echo "* Top module:   %-35s *" "$TOP"
echo "* Test pattern: %-35s *" "$TESTNAME"
echo "********************************************************"
echo ""

set frame = '--------------------------------------------------'

echo $frame
echo '---------         Compile source     -------------'
echo $frame

xvlog -sv -i ../src ../src/$TOP.v --log ../log/xvlog_$TOP.log

if ($status != 0) then
  echo ""
  echo '------------ ##### Compile error ##### -------------'
  exit 1
endif

echo $frame
echo '----         Compile UVM testbench       ---------'
echo $frame

xvlog -sv -i ../env -i ../src -i ../test ../top.sv -L uvm --log ../log/xvlog_$TB_TOP.log

if ($status != 0) then
  echo ""
  echo '------ ##### Compile testbench error ##### -------'
  echo ""
  exit 1
endif

echo $frame
echo '--------         Elaborate source     ------------'
echo $frame

xelab -debug typical -cc_type bcesfxt $TB_TOP -L uvm --log ../log/xelab_$TOP.log

if ($status != 0) then
  echo ""
  echo '----------- ##### Elaborate error ##### ------------'
  exit 1
endif

echo $frame
echo '--------         Simulation start     ------------'
echo $frame

xsim $TB_TOP -R --log "$PROJECT_ROOT/log/xsim_$TOP.log" --testplusarg "UVM_TESTNAME=$TESTNAME"

if ($status != 0) then
  echo ""
  echo '----------- ##### Simulation error ##### -----------'
  echo "Check log: $PROJECT_ROOT/log/xsim_$TOP.log"
  exit 1
endif

# echo $frame
# echo '# -----         Code coverage report     ----------'
# echo $frame

# xcrg -cc_report ../rep -cc_db work.$TB_TOP -cc_dir ./xsim.codeCov/ -report_format html --log ../log/xcrg_$TB_TOP.log

# if ($status != 0) then
#   echo ""
#   echo '# --------- ##### Code coverage error ##### ---------'
#   echo ""
#   exit 1
# endif
