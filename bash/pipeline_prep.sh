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
dirpipe="${dir0}/genpipes/pipelines/${typepipe}"
genome="REPLACE"
versionpython="2.7.11"
cluster="REPLACE" # options include: cedar, abacus, guillimin and mammouth
if [ ${cluster} = "abacus" ]; then
    clusterini=""
    scheduler="pbs"
elif [ ${cluster} = "mammouth" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="pbs"
elif [ ${cluster} = "guillimin" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="pbs"
elif [ ${cluster} = "cedar" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="slurm"
fi
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
if [ ! -d "${dir0}/genpipes" ]; then
  echo "Install genpipes"
  git clone git@bitbucket.org:mugqic/genpipes.git 
else
  echo "Updating genpipes"
  cd "$dir0/genpipes"; git pull; cd ${dir0}
fi

versionpipe=$(cat ${dir0}/genpipes/VERSION); echo "pipeline version: ${versionpipe}: ${dirpipe}"
dirgenome="/cvmfs/soft.mugqic/CentOS6/genomes/species/${genome}"; echo "genome: ${dirgenome}"
echo "python $versionpython"


module load mugqic/python/$versionpython
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
elif [ $analysistype = "clean"]; then
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
