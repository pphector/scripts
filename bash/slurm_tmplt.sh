#!/bin/bash
#SBATCH --account=$RAP_ID
#SBATCH -N 1 -n 8
#SBATCH --mem=36G
#SBATCH -t 1-1:0:0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=$JOB_MAIL
#SBATCH -J REPLACE
#SBATCH -o REPLACE_%j.out
set -eu -o pipefail

# Load Modules 
module purge 

# Define samples and names 


# Other variables and Paths 


# COMMAND 


