#!/bin/bash
set -eu -o pipefail
echo "Starting import..."

if [ "$#" < 1 ] #Are there less than one arguments? 
then 
    echo "Error: you provided an incorrect number of arguments." 
    echo "Usage: pipeline_prep.sh nanuqID [platform]"
    exit 1
fi

module load mugqic/python/2.7.8 mugqic/genpipes/3.1.4
PID=${1}

if [ -n ${2} ]
then 
    PLATFORM=${2}
else
    PATFORM="HiSeq"
fi

nanuq2mugqic_pipelines.py -p $PID -s $PLATFORM -a $HOME/.nanuqAuth

echo "Done"

