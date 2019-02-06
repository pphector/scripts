#!/bin/bash
set -eu -o pipefail

# CHECK CORRECT NUMBER OF ARGUMENTS
if [ "$#" != 1 ] 
then 
    echo "Error: you provided an incorrect number of arguments" 
    echo "Usage: EGA_dwnld.sh pathIDfile"
    exit 1
fi 

# Load modules and define important variables
module load python64/3.6.0

# Command to download 

for item in $(cat $1); do mkdir -p ${item}; cd ${item} 
echo "pyega3 -c 99 -cf ~/.egaAuth.json fetch ${item}"
pyega3 -c 99 -cf ~/.egaAuth.json fetch ${item}; cd ..; done
