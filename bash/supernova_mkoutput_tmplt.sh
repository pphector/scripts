#!/bin/bash 
#SBATCH --time=48:00:00
#SBATCH -N 1 -n 32
#SBATCH --mem=250G
#SBATCH --job-name=HSJ-21-SN
set -eu -o pipefail

module purge
SAMPLE="REPLACE"
TENXRUN="REPLACE"

# Define path to Supernova 2.1.1 dev directory 
SUPERNOVA="/project/6007512/C3G/analyste_dev/software/supernova/supernova-2.1.1"
# Define project directories
PROJ="REPLACE"
OUTDIR="${PROJ}/"
STYLE="pseudohap"

cd $OUTDIR/${SAMPLE}/outs/assembly

# Supernova command
${SUPERNOVA}/supernova mkoutput --style=${STYLE} \
    --asmdir=${OUTDIR}/${SAMPLE}/outs/assembly \
    --outprefix=${SAMPLE}_${STYLE}
