#!/bin/bash
set -eu -o pipefail

# CHECK CORRECT NUMBER OF ARGUMENTS
if [ "$#" != 2 ] #Are there less/more than two arguments? 
then 
    echo "Error: you provided an incorrect number of arguments." 
    echo "Usage: pipeline_prep.sh steps (analysis|report|clean)"
    exit 1
fi

# FIXED PARAMETERS (MODIFY FOR EACH PROJECT)
dir0="REPLACE"; cd ${dir0}; echo ${dir0}
typepipe="REPLACE"
genome="REPLACE"
versionpython="2.7.11"
versiongenpipes="3.1.3"
cluster="REPLACE" # options include: cedar, abacus, beluga, graham and mammouth
if [ ${cluster} = "abacus" ]; then
    clusterini=""
    scheduler="pbs"
elif [ ${cluster} = "mammouth" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="pbs"
elif [ ${cluster} = "beluga" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="pbs"
elif [ ${cluster} = "cedar" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="slurm"
elif [ ${cluster} = "graham" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="slurm"
elif [ ${cluster} = "mp2b" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="slurm"
fi

echo "module load mugqic/python/${versionpython} mugqic/genpipes/${versiongenpipes}"
module load mugqic/python/${versionpython} mugqic/genpipes/${versiongenpipes}
dirgenome="/cvmfs/soft.mugqic/CentOS6/genomes/species/${genome}"; echo "genome: ${dirgenome}"
dirpipe="$MUGQIC_PIPELINES_HOME/pipelines/${typepipe}"


myoutputdir="${dir0}/${typepipe}_output"
myreadsets="${dir0}/readsets.REPLACE.tsv"
mydesign="${dir0}/REPLACE.tsv"
extra_ini="${dir0}/REPLACE.ini" #list of personalized ini files
protocol="" # For pipelines that support protocols, define protocol hereRforce="" #empty of "-f"
force="" #empty or "-f"
# VARIABLE PARAMETERS
mysteps=${1}
analysistype=${2}

###########################################################################################################
#below should not be changed


if [ ${analysistype} = "analysis" ]; then
  echo "Generating command files for analysis"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          --design ${mydesign} \
          --job-scheduler ${scheduler} \
          ${protocol} \
          ${force} > run_step${mysteps}.sh
  chmod 755 run_step${mysteps}.sh
  echo "Now run 'bash run_step${mysteps}.sh' to start the analysis"
elif [ ${analysistype} = "report" ]; then
  echo "Generating command files for report"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          --design ${mydesign} \
          ${protocol} \
          --report > report_step${mysteps}.sh
  chmod 755 report_step${mysteps}.sh
  echo "Now run 'bash report_step${mysteps}.sh' to generate the report"
elif [ ${analysistype} = "multiqc" ]; then
  echo "Generating command files for multiqc report"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          --design ${mydesign} \
          ${protocol} \
          --multiqc > multiqc_step${mysteps}.sh
  chmod 755 multiqc_step${mysteps}.sh
  echo "Now run 'bash multiqc_step${mysteps}.sh' to generate the multiqc report"
elif [ $analysistype = "clean" ]; then
  echo "Generating command files for cleaning" 
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          --design ${mydesign} \
          ${protocol} \
          --clean > clean_step${mysteps}.sh
  chmod 755 clean_step${mysteps}.sh
  echo "Now run 'bash clean_step${mysteps}.sh' to clean tmp files"
else
  echo "analysistype must be set to 'analysis', 'report' or 'clean'"
fi

echo "Pipeline_preparation completed"
