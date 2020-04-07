#!/bin/bash 
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=32
#PBS -l mem=192G
#PBS -q sw
#PBS -N gc_metrics_REPLACE
set -eu -o pipefail

#############################################################################################################
# Script to calculate the GC bias for a ONT runs
# It usese bedtools coverage and the wgbs_bin100bp_GC.bed file in the Genome reference. 
# It requires a file indicating the name of all samples (not readsets) 
# It should be under the genpipes output directory as sample_list.txt
#############################################################################################################

# Load modules
module purge
module load mugqic/bedtools/2.27.0

# Define project directories
PROJ="GENPIPESDIR"
ALIGNDIR="${PROJ}/alignment"
OUTDIR="${PROJ}/gc_bias_metrics"
SAMPLELIST="${PROJ}/sample_list.txt"
mkdir -p ${OUTDIR} 
cd ${PROJ}

GC_BED="GENOMEGCBED"

for sample in $(cat ${SAMPLELIST}); do
echo ${sample}
bedtools coverage -counts \
    -a ${GC_BED} \
    -b ${ALIGNDIR}/${sample}/${sample}.sorted.bam \
    > ${OUTDIR}/${sample}.gc_bias.txt
done
