#!/bin/bash 
#PBS -l walltime=8:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32G
#PBS -q sw
#PBS -N minimap2_REPLACE
set -eu -o pipefail

# Minimap2 alignment script. Useful for aligning assemblies to reference. 
# Assumes Minimap2 v2.16 is installed in MUGQIC_DEV

SAMPLE="REPLACE"

# Load minimap2
module purge
module load mugqic_dev/minimap2/2.16 mugqic/samtools/1.9

# Define project directories
PROJ="REPLACE"

# Logs will be saved in ASSEMDIR
ASSEMDIR="${PROJ}/REPLACE"
ASSEM="${ASSEMDIR}/REPLACE"
cd $ASSEMDIR
mkdir minimap2_align
OUTSAM="minimap2_align/REPLACE.sam"
OUTBAM="minimap2_align/REPLACE.sorted.bam"

# Reference mmi 
REFDIR="REPLACE"
FASTAREF="${REFDIR}/REPLACE"
MMIREF="${REFDIR}/REPLACE"
PRESET="REPLACE" # Options include map-pb, map-ont, splice, sr, asm5, among others. See Docs. 

# Alignment command, uses flag x to select a preset option
minimap2 -ax ${PRESET} ${MMIREF} ${ASSEM} > ${OUTSAM}

# Sort and turn output to bam, then index. 
samtools view -b ${OUTSAM} -@ 8 | samtools sort -@ 6 --reference ${FASTAREF} > ${OUTBAM} &&\
samtools index ${OUTBAM}
