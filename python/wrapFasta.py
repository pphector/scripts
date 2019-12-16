#!/usr/bin/env python

from Bio.Seq import Seq
from Bio import SeqIO 
import sys

'''
Simple script that takes in a fasta file and returns a line-warped fasta. 
'''

infile = sys.argv[1]

if infile[-3:] == '.fa': 
    outfile = infile.replace('.fa', '.wrap.fa') 
elif infile[-6:] == '.fasta': 
    outfile = infile.replace('.fasta', '.wrap.fasta')
else: 
    print("Unsopported filetype")

SeqIO.convert(infile, 'fasta', outfile, 'fasta') 

