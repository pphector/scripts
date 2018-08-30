#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(fgsea))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(mygene))
library(ggplot2)
library(mygene)

### Script to generate rank file from DGE output for GSEA analysis
## Requires internet connection for Mygene library
## Produces UNSORTED output in two columns: 
##     - Column 1: ENTREZ gene IDs
##     - Column 2: "Rank" metric obtained by multiplying logFC with -log10 of DEseq p-value 

# Create ranks 
infile <- "REPLACE.dge.csv" 
outfile <- "REPLACE.rnk" 

dge <- read.csv(infile, sep="\t") 

dge["rank"] <- dge$log_FC * -log10(dge$deseq.p.value) 

entrezFromId <- queryMany(dge$id, scopes="ensembl.gene", fields="entrezgene", species="Human", returnall=FALSE)

entrezKey <- entrezFromId[,c("query", "entrezgene")] 

dge <- merge(x=dge, y=entrezKey, by.x="id", by.y="query") 

rankTable <- dge[!is.na(dge$entrezgene), c("entrezgene","rank")]


write.table(rankTable, file=outfile, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)
