# Downloads gene to transcript data from ENSEMBL
# Produces an appropriately formated csv file for use with RNAseq light pipeline. 
# Written by Hector Galvez
# Usage: Rscript biomart_tx2gene.R --species Homo_sapiens --assembly GRCh38 --ensembl 87

### WARNING
# NOTE: Only works on recent versions of ensembl that have the additional transcript_version available

library("dplyr")
library("biomaRt")
library("methods")
library("data.table")

# Usage 

usage=function(errM) {
    cat("\nUsage: Rscript biomart_tx2gene.R [option] <Value>\n")
    cat("           --species      : species (default= Homo_sapiens)")
    cat("           --assembly     : assembly version (default= GRCh38)")
    cat("           --ensembl      : ENSEMBL version (default= 87)")
    cat("           --prefix       : output prefix path (defaults to current dir)")
    stop(errM)
}

# Transcript to gene csv generating function
write_tx2gene=function(ens.dataset, ens.host, outfile) {
    mart <- biomaRt::useMart('ensembl', dataset = ens.dataset, host = ens.host)
    ttg <- biomaRt::getBM( attributes = c("ensembl_transcript_id", 
                                      "transcript_version",
                                      "ensembl_gene_id",
                                      "external_gene_name",
                                      "description",
                                      "transcript_biotype"), mart = mart)  
    ttg <- dplyr::rename(ttg, target_id = ensembl_transcript_id,
                       ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
    ttg_id <- ttg
    ttg_id$target_id <- paste(ttg_id$target_id, ttg_id$transcript_version, sep = ".") 

    write.csv(ttg_id, file=outfile, row.names = FALSE)
} 


##################################

ARG = commandArgs(trailingOnly = T)

# default arg values
species="Homo_sapiens"
assembly="GRCh38"
ens.vers="87"
out.dir="."
## get arg variables
for (i in 1:length(ARG)) {
    if (ARG[i] == "--species") {
        species=ARG[i+1]
    } else if (ARG[i] == "--assembly") {
        assembly=ARG[i+1]
    } else if (ARG[i] == "--ensembl") {
        ens.vers=ARG[i+1]
    } else if (ARG[i] == "--prefix") {
        out.dir=ARG[i+1]
    }
} 

source.name <- paste("Ensembl", ens.vers, sep="")
csv.name <- paste(species, assembly, source.name, "tx2gene", "csv", sep = ".")

outfile= paste(out.dir, csv.name, sep="/")


EnsemblArchives <- listEnsemblArchives()
host.url <- EnsemblArchives[EnsemblArchives$version == ens.vers,]$url
full.mart <- biomaRt::useMart('ensembl', host=host.url)
dataset.list <- listDatasets(full.mart)
ens.dataset <- dataset.list[dataset.list$version %like% assembly,]$dataset

write_tx2gene(ens.dataset, host.url, outfile)
