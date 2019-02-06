## SETUP ## 

# Load libraries
library("readr")
library("biomaRt")

# Download transcript to gene conversion table (mus_musculus) from ENSEMBLE and format it
## REQUIRES INTERNET CONNECTION
# "Ensembl 90"     "Aug 2017" "http://Aug2017.archive.ensembl.org" 

mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl", host = "dec2017.archive.ensembl.org")
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

write.csv(ttg_id, file="/home/hgalvez/projects/Elsehemy_RNAseq-NDP_PRJBFX-1652/hsapiens_ensembl90_tx2gene.csv", row.names = FALSE)
