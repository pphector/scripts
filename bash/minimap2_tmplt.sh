#!/bin/bash 
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=16
#PBS -l mem=90G
#PBS -q sw
#PBS -N PBjelly
set -eu -o pipefail

# Minimap2 alignment script. Useful for aligning assemblies to reference. 
# Assumes Minimap2 v2.16 is installed in MUGQIC_DEV

SAMPLE="REPLACE"

# Load minimap2
module purge
module load mugqic_dev/minimap2/2.16

# Define project directories
PROJ="REPLACE"

# Logs will be saved in ASSEMDIR
ASSEMDIR="${PROJ}/REPLACE"
ASSEM="${ASSEMDIR}/REPLACE"
cd $ASSEMDIR
mkdir minimap2_align
OUTFILE="minimap2_align/REPLACE"

# Reference mmi 
REFASSEM="REPLACE"
PRESET="REPLACE" # Options include map-pb, map-ont, splice, sr, asm5, among others. See Docs. 

# Alignment command, uses flag x to select a preset option
# Preset 
minimap2 -ax ${PRESET} ${REFASSEM} ${ASSEM} > ${OUTFILE}
