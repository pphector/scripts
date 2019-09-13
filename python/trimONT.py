#!/usr/bin/env python

from Bio.Seq import Seq
from Bio import SeqIO 
import sys

trimmed_reads = []
infile = sys.argv[1]
outfile = sys.argv[2]
size = int(sys.argv[3])

for seq_record in SeqIO.parse(infile, "fastq"): 
    trimmed_reads.append(seq_record[100:(101 + size)])


SeqIO.write(trimmed_reads, outfile, "fastq")


