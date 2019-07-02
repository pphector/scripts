#!/bin/bash
set -eu -o pipefail
echo "Starting import..."
module load mugqic/python/2.7.8 mugqic/genpipes/3.1.4
PID=${1}

nanuq2mugqic_pipelines.py -p $PID -s HiSeq -a $HOME/.nanuqAuth

echo "Done"
