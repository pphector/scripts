#!/bin/bash
set -eu -o pipefail 

# CHECK CORRECT NUMBER OF ARGUMENTS
if [ "$#" != 2 ]
then
    echo "Error: you provided an incorrect number of arguments." 
    echo "Usage: sync_data.sh origin target" 
    exit 1
fi 


echo "Starting sync..." 

rsync -avPL --update ${1} ${2} 
