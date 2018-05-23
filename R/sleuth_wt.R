## SETUP ## 

# Load libraries
library("readr")
library("sleuth")
library("cowplot") 

# Set working dir
setwd("/home/hgalvez/projects/Moffatt_RNA-seq-Kallisto_PRJBFX-1643/rnaseq_light_output") 

# Download transcript to gene conversion table (mus_musculus) from ENSEMBLE and format it
## REQUIRES INTERNET CONNECTION
#mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "mmusculus_gene_ensembl", host = "dec2015.archive.ensembl.org")
#ttg <- biomaRt::getBM( attributes = c("ensembl_transcript_id", 
#                                      "transcript_version",
#                                      "ensembl_gene_id",
#                                      "external_gene_name",
#                                      "description",
#                                      "transcript_biotype"), mart = mart)  
#ttg <- dplyr::rename(ttg, target_id = ensembl_transcript_id,
#                       ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
#ttg_id <- ttg
#ttg_id$target_id <- paste(ttg_id$target_id, ttg_id$transcript_version, sep = ".") 
#
ttg_id <- read_csv("../mus_musculus_ensembl83_tx2gene.csv")

# Read csv with the sample name, group, and paths 
s2c_c1 <- read_csv("../s2c_contrast1.csv") 
s2c_c2 <- read_csv("../s2c_contrast2.csv") 
s2c_c3 <- read_csv("../s2c_contrast3.csv") 

## ANALYSIS BY TRANSCRIPT## 

# This analysis is very resource intensive. Make sure that the number of cores is appropriate and that
# when allocating resources to each core, they all have enough memory. Otherwise, if one core fails, 
# the whole command will fail. 

# Prepare the sleuth object and fit the models 
so_c1 <- sleuth_prep(s2c_c1, ~ condition, num_cores=2)
ggsave("./sleuth_wt/Contrast1/trx_pca.png", plot_pca(so_c1, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c1 <- sleuth_fit(so_c1, ~ condition, "full") 
#so_c1 <- sleuth_fit(so_c1, ~ 1 , "reduced") 
# Next we perform a wald test (wt) on the model, comparing the samples with condition=mutant against the others
# The results of the analysis are saved into a dataframe
so_c1 <- sleuth_wt(so_c1, "conditionmutant", "full") 
c1_results <- sleuth_results(so_c1, "conditionmutant", "wt", show_all=TRUE) 
# You're technically not supposed to do this as it creates a bias, but I checked the results and it didn't seem too bad. 
# We are essentialy re-creating the "fold_change" value from the  beta value reported by the wald test. 
c1_results$fold_change <- log2(exp(c1_results$b)) 
write.csv(c1_results, file="./sleuth_wt/Contrast1/contrast1_trx.csv", row.names = FALSE) 

# Repeat process for two other contrasts
so_c2 <- sleuth_prep(s2c_c2, ~ condition, num_cores=2)
ggsave("./sleuth_wt/Contrast2/trx_pca.png", plot_pca(so_c2, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c2 <- sleuth_fit(so_c2, ~ condition, "full") 
#so_c2 <- sleuth_fit(so_c2, ~ 1 , "reduced") 
so_c2 <- sleuth_wt(so_c2, "conditionmutant", "full") 
c2_results <- sleuth_results(so_c2, "conditionmutant", "wt", show_all=TRUE) 
c2_results$fold_change <- log2(exp(c2_results$b)) 
write.csv(c2_results, file="./sleuth_wt/Contrast2/contrast2_trx.csv", row.names = FALSE) 

so_c3 <- sleuth_prep(s2c_c3, ~ condition, num_cores=2)
ggsave("./sleuth_wt/Contrast3/trx_pca.png", plot_pca(so_c3, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c3 <- sleuth_fit(so_c3, ~ condition, "full") 
#so_c3 <- sleuth_fit(so_c3, ~ 1 , "reduced") 
so_c3 <- sleuth_wt(so_c3, "conditionmutant", "full") 
c3_results <- sleuth_results(so_c3, "conditionmutant", "wt", show_all=TRUE) 
c3_results$fold_change <- log2(exp(c3_results$b)) 
write.csv(c3_results, file="./sleuth_wt/Contrast3/contrast3_trx.csv", row.names = FALSE) 

## ANALYSIS BY GENE ## 

# Prepare the sleuth object and fit the models 
so_c1_gene <- sleuth_prep(s2c_c1, ~ condition, target_mapping = ttg_id, aggregation_column = 'ens_gene', num_cores = 2) 
ggsave("./sleuth_wt/Contrast1/gene_pca.png", plot_pca(so_c1_gene, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c1_gene <- sleuth_fit(so_c1_gene, ~ condition, "full") 
#so_c1_gene <- sleuth_fit(so_c1_gene, ~ 1, "reduced") 
so_c1_gene <- sleuth_wt(so_c1_gene,"conditionmutant", "full")
c1_gene_results <- sleuth_results(so_c1_gene, "conditionmutant", "wt", show_all=TRUE) 
c1_gene_results$fold_change <- log2(exp(c1_gene_results$b)) 
write.csv(c1_gene_results, file="./sleuth_wt/Contrast1/contrast1_gene.csv", row.names=FALSE) 

so_c2_gene <- sleuth_prep(s2c_c2, ~ condition, target_mapping = ttg_id, aggregation_column = 'ens_gene', num_cores = 2) 
ggsave("./sleuth_wt/Contrast2/gene_pca.png", plot_pca(so_c2_gene, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c2_gene <- sleuth_fit(so_c2_gene, ~ condition, "full") 
#so_c2_gene <- sleuth_fit(so_c2_gene, ~ 1, "reduced") 
so_c2_gene <- sleuth_wt(so_c2_gene,"conditionmutant", "full")
c2_gene_results <- sleuth_results(so_c2_gene, "conditionmutant", "wt", show_all=TRUE) 
c2_gene_results$fold_change <- log2(exp(c2_gene_results$b)) 
write.csv(c2_gene_results, file="./sleuth_wt/Contrast2/contrast2_gene.csv", row.names=FALSE) 

so_c3_gene <- sleuth_prep(s2c_c3, ~ condition, target_mapping = ttg_id, aggregation_column = 'ens_gene', num_cores = 2) 
ggsave("./sleuth_wt/Contrast3/gene_pca.png", plot_pca(so_c3_gene, color_by = "condition", text_labels = TRUE), dpi = 300) 
so_c3_gene <- sleuth_fit(so_c3_gene, ~ condition, "full") 
#so_c3_gene <- sleuth_fit(so_c3_gene, ~ 1, "reduced") 
so_c3_gene <- sleuth_wt(so_c3_gene,"conditionmutant", "full")
c3_gene_results <- sleuth_results(so_c3_gene, "conditionmutant", "wt", show_all=TRUE) 
c3_gene_results$fold_change <- log2(exp(c3_gene_results$b)) 
write.csv(c3_gene_results, file="./sleuth_wt/Contrast3/contrast3_gene.csv", row.names=FALSE) 

