#!/bin/bash 
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32G
#PBS -q sw
#PBS -N minimap2_REPLACE
set -eu -o pipefail

# Test script to use Canu for genome assembly with ONT data

SAMPLE="REPLACE"
PROJECT="REPLACE"

# Load minimap2
module purge
module load mugqic/Canu/1.5

# Define project directories
PROJ="/lb/project/mugqic/projects/Ragoussis_ONTprocessing"

# Logs will be saved in OUTDIR 
INDIR="${PROJ}/raw_reads/${PROJECT}/${SAMPLE}/fastq_pass"
INFILE="${INDIR}/"
OUTDIR="${PROJ}/${PROJECT}/assemblies/canu/${SAMPLE}"
mkdir -p $OUTDIR
cd $OUTDIR

# Assembly parameters
SPECFILE="${INDIR}/${SAMPLE}_assem.specs"
PREFIX="${SAMPLE}"
ASSEMDIR="${OUTDIR}/${SAMPLE}_canu"
GENOMESIZE="3.1g"
RUNTYPE="-nanopore-raw"

canu \
 -p ${PREFIX} \
 -d ${ASSEMDIR}\
 genomeSize=${GENOMESIZE} \
 ${RUNTYPE} ${INFILE} |& tee -a ${SAMPLE}_canu.log
