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
module load mugqic/java/openjdk-jdk1.8.0_72
## Location of EGA client *in mammouth* 
EGAclient="/nfs3_ib/bourque-mp2.nfs/tank/nfs/bourque/nobackup/share/mugqic_dev/software/EGADemoClient" 
# Set target directory
targetdir=$(pwd) 

# Command to download 
for dataset in $(cat ${1}); do
    cd ${targetdir}
    mkdir -p ${dataset}
    cd ${targetdir}/${dataset}

    if [ -e ${dataset}.done ]; then
        echo "${dataset} has finished downloading, moving on..." 
    
    else
        reqname=${dataset}_$(date +"%F_%Hh")
        echo "Generating request for ${dataset}" 
        java -jar ${EGAclient}/EgaDemoClient.jar -p jose.galvezlopez@MAIL.MCGILL.CA $(cat ~/.egaAuth) -rfd ${dataset}\
        -re abc -label ${reqname} | tee -a ${dataset}.log 
        echo "Request generated and called ${reqname}."  
        
        echo "Downloading request ${reqname}. Please wait..." 
        java -jar ${EGAclient}/EgaDemoClient.jar -p jose.galvezlopez@MAIL.MCGILL.CA $(cat ~/.egaAuth) -dr ${reqname} \
        -nt 4 | tee -a ${dataset}.log && touch ${dataset}.done
        
        echo "Finished downloading ${dataset}. Moving on..." 
    fi
done

