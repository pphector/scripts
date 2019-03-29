#/bin/bash

#This is the path where you've install the suite.
export SWEETPATH="/cvmfs/soft.mugqic/CentOS6/software/pbsuite/PBSuite_15.2.20beta"
#for python modules 
export PYTHONPATH=$PYTHONPATH:$SWEETPATH
#for executables 
export PATH=$PATH:$SWEETPATH/bin/
