#!/bin/bash 
#SBATCH --time=24:00:00
#SBATCH --mem=125G
#SBATCH -N 1 -n 32
#SBATCH -J quast
set -eu -o pipefail

module purge
module load mugqic/python/2.7.13 mugqic_dev/quast/2.3 

# Define project directories
PROJ="REPLACE"
ASSEMDIR="${PROJ}/REPLACE" 
ASSEMFILE="REPLACE"
cd $ASSEMDIR

# Define QUAST parameters 
THREADS="30"
OTHER_OPTS=""
OUTPUT="REPLACE" # Output prefix
LOG=${OUTPUT}.log

# Quast command
quast.py --output-dir ${OUTPUT} --threads ${THREADS} --gene-finding --eukaryote ${ASSEMFILE} 2> $LOG
