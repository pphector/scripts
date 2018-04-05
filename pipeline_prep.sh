#!/bin/bash
set -eu -o pipefail

# CHECK CORRECT NUMBER OF ARGUMENTS
if [ "$#" != 2 ] #Are there less/more than two arguments? 
then 
    echo "Error: you provided an incorrect number of arguments." 
    echo "Usage: pipeline_prep.sh steps (analysis|report)"
    exit 1
fi

# FIXED PARAMETERS (MODIFY FOR EACH PROJECT)
dir0="REPLACE" cd ${dir0}; echo ${dir0}
typepipe="REPLACE"
genome="REPLACE"
versionpython="2.7.11"
cluster="REPLACE" # options include: briaree, cedar, graham, guillimin and mammouth
# IF RUNNING ON ABACUS, REMOVE LINE ABOVE AND DELETE THE EXTRA INI FILE BELOW
myoutputdir="${dir0}/${typepipe}_output"
myreadsets="${dir0}/readsets.REPLACE.tsv"
mydesign="${dir0}/REPLACE.tsv"
extra_ini="${dir0}/REPLACE.ini" #list of personalized ini files
protocol="" # For pipelines that support protocols, define protocol here
force="" #empty of "-f"

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

dirpipe="${dir0}/genpipes/pipelines/${typepipe}"
versionpipe=$(cat ${dir0}/genpipes/VERSION); echo "pipeline version: ${versionpipe}: ${dirpipe}"
dirgenome="/cvmfs/soft.mugqic/CentOS6/genomes/species/${genome}"; echo "genome: ${dirgenome}"
echo "python $versionpython"


module load mugqic/python/$versionpython
if [ $analysistype = "analysis" ]; then
  echo "Generating command files for analysis"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/$typepipe.base.ini ${dirpipe}/$typepipe.mammouth.ini $extra_ini -s ${mysteps} -o ${myoutputdir} -r ${myreadsets} -d ${mydesign} ${protocol} $force > run_step${mysteps}.sh
  echo "Now run 'bash run_step${mysteps}.sh' to start the analysis"
elif [ $analysistype = "report" ]; then
  echo "Generating command files for report"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/$typepipe.base.ini ${dirpipe}/$typepipe.mammouth.ini $extra_ini -s ${mysteps} -o ${myoutputdir} -r ${myreadsets} -d ${mydesign} ${protocol} $force --report > report_step${mysteps}.sh
  echo "Now run 'bash report_step${mysteps}.sh' to generate the report"
else
  echo "analysistype must be set to 'analysis' or 'report'"
fi

echo "Pipeline_preparation completed"
