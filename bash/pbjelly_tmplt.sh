#!/bin/bash 
#PBS -l walltime=200:00:00
#PBS -l nodes=1:ppn=20
#PBS -q lm
#PBS -N Supernova
set -eu -o pipefail

SAMPLE="EP521"

# Load blasr
module purge
module load mugqic/python/2.7.13 mugqic/smrtanalysis/2.3.0.140936.p5
#source /cvmfs/soft.mugqic/CentOS6/software/smrtanalysis/smrtanalysis_2.3.0.140936.p5/etc/setup.sh

# Define path to PBsuite 15.2.20beta directory 
PBSUITE="/cvmfs/soft.mugqic/CentOS6/software/pbsuite/PBSuite_15.2.20beta"
source ~/scripts/bash/PBsuite_setup.sh 

# Define project directories
PROJ="/lb/project/mugqic/projects/nada_hybride10x_pacbio_assembly_BFXTD62"
WORKDIR="${PROJ}/assemblies/supernova/pbjelly/${SAMPLE}"
DATA="${PROJ}/data_links" 
PROTOCOL="${WORKDIR}/${SAMPLE}_Batch_Protocol.xml"
cd $WORKDIR

# Setup project (throws a warning because we don't have a quality for the bases in the assembly)
#${PBSUITE}/bin/Jelly.py setup $PROTOCOL

# Mapping step
echo "Starting PBJelly setup..." 
${PBSUITE}/bin/Jelly.py setup $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
echo "Starting PBJelly mapping..."
${PBSUITE}/bin/Jelly.py mapping $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
echo "Starting PBJelly support..."
${PBSUITE}/bin/Jelly.py support $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
echo "Starting PBJelly extraction..." 
${PBSUITE}/bin/Jelly.py extraction $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
echo "Starting PBJelly assembly..." 
${PBSUITE}/bin/Jelly.py assembly $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
echo "Starting PBJelly output..." 
${PBSUITE}/bin/Jelly.py output $PROTOCOL |& tee -a ${SAMPLE}_PBJelly.log
