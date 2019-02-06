#!/bin/bash 
#PBS -l walltime=3:00:00:0
#PBS -l nodes=1:ppn=48
#PBS -q sw
#PBS -N bam2fastq
set -eu -o pipefail


module purge 
module load mugqic/java/openjdk-jdk1.8.0_72 mugqic/picard/2.9.0

DATA="/lb/project/mugqic/projects/Corradi_E-purpurea-assembly_PRJBFX-1746/raw_reads"

for item in $(ls ${DATA}/*.bam); do
BASE=$(basename $item .bam)
java -Djava.io.tmpdir=${LSCRATCH} -XX:ParallelGCThreads=4 -Dsamjdk.buffer_size=4194304 -Xmx15G -jar $PICARD_HOME/picard.jar \
SamToFastq \
VALIDATION_STRINGENCY=SILENT \
INPUT=${DATA}/${BASE}.bam \
FASTQ=${DATA}/PB_Fastq/${BASE}.fastq \
INCLUDE_NON_PF_READS=true
done
