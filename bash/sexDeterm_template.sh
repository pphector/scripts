#!/bin/bash 
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=16
#PBS -l mem=64G
#PBS -q sw
#PBS -N sexDeterm_REPLACE
set -eu -o pipefail


#############################################################################################################
# Script to calculate the normalized coverage of X and Y for sex concordance QC in ONT runs
# Uses the python script Sex.DetERRmine.py (from https://github.com/TCLamnidis/Sex.DetERRmine)
# Requires the reference genome as well as a file indicating the name of all samples (not readsets)
# It should be under the genpipes output directory as sample_list.txt
#############################################################################################################


# Load modules
module purge
module load mugqic/python/3.5.5 mugqic/samtools/1.9
SEXDETERR="/nb/home/hgalvez/software/Sex.DetERRmine/Sex.DetERRmine.py"

# Define project directories
PROJ="GENPIPESOUTPUT"
OUTDIR="${PROJ}/sex_determ"
SAMPLELIST="${PROJ}/sample_list.txt"
THREADS=4
mkdir -p ${OUTDIR}
cd ${PROJ}

REFERENCE="REFGENOMEFASTA"

for sample in $(cat ${SAMPLELIST}); do 
echo alignment/${sample}/${sample}.sorted.bam > bam_path.tmp
touch ${OUTDIR}/${sample}_sexDeterm.tsv
samtools depth -a \
    --reference ${REFERENCE} \
    -f bam_path.tmp | \
python ${SEXDETERR} -f bam_path.tmp > ${OUTDIR}/${sample}_sexDeterm.tsv 
rm bam_path.tmp
done
