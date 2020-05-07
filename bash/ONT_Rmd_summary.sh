#!/bin/bash 
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32G
#PBS -q sw
#PBS -N ONT_reporting_REPLACE
set -eu -o pipefail

# Load modules 
module purge
module load mugqic/R_Bioconductor/3.5.1_3.7 mugqic/pandoc/1.15.2

# Define project directories
PROJ="REPLACE"
GENPIPES_OUTPUT="${PROJ}/REPLACE"
PRES_DIR="${GENPIPES_OUTPUT}/summary_report"
TMPLT_DIR="${PROJ}/scripts/R/ONT_presentation_template"
mkdir -p ${PRES_DIR}
cp ${TMPLT_DIR}/* ${PRES_DIR}
cd ${PRES_DIR}

# Define project variables and text in order
LONG_NAME="REPLACE"
REF_GENOME="REPLACE"
PASS_QUAL="5" # Passing quality score for SVIM SVs
LARGE_SV_SIZE="500" # Size threshold for "large" SVs
LARGEST_SV_SIZE="10000" # Size threshold for "largest" SVs
READSET_LOCATION="REPLACE" # Location of Readset file (relative path from `summary_report`)
SHORT_NAME="REPLACE"
SAMPLE_NUM="$(expr $(cat ${READSET_LOCATION} | cut -f 1 | sort | uniq | wc -l) - 1)"
READSET_NUM="$(expr $(cat ${READSET_LOCATION} | cut -f 2 | sort | uniq | wc -l) - 1)"
SPECIES_NAME="REPLACE"
# Software versions (get these from the trace ini file modules and from the FAST5 files)
GUPPY_VER="Guppy v3.2.4"
MINIMAP_VER="minimap2 v2.17"
SVIM_VER="SVIM v1.2.0"
SAMTOOLS_VER="samtools v1.9"
PYCOQC_VER="pycoQC v2.5.0.17"
BEDTOOLS_VER="bedtools v.2.27.0"
SEXDETERR_VER="SexDeteRR v.1.1.1"


cat ONT_summaryPresentation.template.Rmd | \
    sed -e s/LONG_NAME/"${LONG_NAME}"/g | \
    sed -e s/REF_GENOME/"${REF_GENOME}"/g | \
    sed -e s/PASS_QUAL/"${PASS_QUAL}"/g | \
    sed -e s/LARGE_SV_SIZE/"${LARGE_SV_SIZE}"/g | \
    sed -e s/LARGEST_SV_SIZE/"${LARGEST_SV_SIZE}"/g | \
    sed -e s/READSET_LOCATION/"${READSET_LOCATION}"/g | \
    sed -e s/SHORT_NAME/"${SHORT_NAME}"/g | \
    sed -e s/SAMPLE_NUM/"${SAMPLE_NUM}"/g | \
    sed -e s/READSET_NUM/"${READSET_NUM}"/g | \
    sed -e s/SPECIES_NAME/"${SPECIES_NAME}"/g | \
    sed -e s/GUPPY_VER/"${GUPPY_VER}"/g | \
    sed -e s/MINIMAP_VER/"${MINIMAP_VER}"/g | \
    sed -e s/SVIM_VER/"${SVIM_VER}"/g | \
    sed -e s/SAMTOOLS_VER/"${SAMTOOLS_VER}"/g | \
    sed -e s/PYCOQC_VER/"${PYCOQC_VER}"/g | \
    sed -e s/BEDTOOLS_VER/"${BEDTOOLS_VER}"/g | \
    sed -e s/SEXDETERR_VER/"${SEXDETERR_VER}"/g > ONT_summaryPresentation.Rmd

Rscript -e "rmarkdown::render('ONT_summaryPresentation.Rmd')"

