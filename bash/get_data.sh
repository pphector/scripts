#!/bin/bash
set -eu -o pipefail
echo "Starting import..."
module load mugqic/python/2.7.8
PID=${1}

genpipes/utils/nanuq2mugqic_pipelines.py -p $PID -s HiSeq -a $HOME/.nanuqAuth

echo "Done"
