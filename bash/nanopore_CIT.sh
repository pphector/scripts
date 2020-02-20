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
typepipe="nanopore"
dirpipelines="${dir0}/genpipes"
dirpipe="${dirpipelines}/pipelines/${typepipe}"
genome="Homo_sapiens.GRCh38.chr19"
versionpython="2.7.13"
cluster="REPLACE" # options include: cedar, abacus, beluga, graham and mammouth
if [ ${cluster} = "abacus" ]; then
    clusterini=""
    scheduler="pbs"
elif [ ${cluster} = "mammouth" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="pbs"
elif [ ${cluster} = "beluga" ]; then
    clusterini="${dirpipe}/${typepipe}.${cluster}.ini"
    scheduler="slurm"
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
myoutputdir="${dir0}/${typepipe}_CIT_output"
myreadsets="${dir0}/nanopore.cit.readset.tsv"
extra_ini="${dir0}/CIT.nanopore.ini" #list of personalized ini files
protocol="" # For pipelines that support protocols, define protocol hereRforce="" #empty of "-f"
force=" --no-json " #empty or "-f"
# VARIABLE PARAMETERS
mysteps=${1}
analysistype=${2}

###########################################################################################################

versionpipe=$(cat ${dirpipelines}/VERSION); echo "pipeline version: ${versionpipe}: ${dirpipe}"
dirgenome="/cvmfs/soft.mugqic/CentOS6/genomes/C3G_workshop/${genome}"; echo "genome: ${dirgenome}"
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
          --job-scheduler ${scheduler} \
          ${protocol} \
          ${force} > run_CIT_step${mysteps}.sh
  chmod 755 run_CIT_step${mysteps}.sh
  echo "Now run 'bash run_CIT_step${mysteps}.sh' to start the analysis"
elif [ ${analysistype} = "report" ]; then
  echo "Generating command files for report"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          ${protocol} \
          --report > report_CIT_step${mysteps}.sh
  chmod 755 report_CIT_step${mysteps}.sh
  echo "Now run 'bash report_CIT_step${mysteps}.sh' to generate the report"
elif [ ${analysistype} = "multiqc" ]; then
  echo "Generating command files for multiqc report"
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          ${protocol} \
          --multiqc > multiqc_CIT_step${mysteps}.sh
  chmod 755 multiqc_CIT_step${mysteps}.sh
  echo "Now run 'bash multiqc_CIT_step${mysteps}.sh' to generate the multiqc report"
elif [ $analysistype = "clean" ]; then
  echo "Generating command files for cleaning" 
  python ${dirpipe}/${typepipe}.py -c ${dirpipe}/${typepipe}.base.ini \
          ${clusterini} \
          ${dirgenome}/${genome}.ini \
          ${extra_ini} \
          --steps ${mysteps} \
          --output-dir ${myoutputdir} \
          --readsets ${myreadsets} \
          ${protocol} \
          --clean > clean_CIT_step${mysteps}.sh
  chmod 755 clean_CIT_step${mysteps}.sh
  echo "Now run 'bash clean_CIT_step${mysteps}.sh' to clean tmp files"
else
  echo "analysistype must be set to 'analysis', 'report' or 'clean'"
fi

echo "Pipeline_preparation completed"
