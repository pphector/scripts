## SETUP ## 

# Load libraries
library("readr")
library("sleuth")

# Set working dir
setwd("/project/6007512/C3G/projects/Leary_kallisto-RNAseq_PRJBFX-1641/rnaseq_light_output_fullsamples")

# Read csv with the sample name, group, and paths 
s2c <- read_csv("../filepaths.csv") 

# For this analysis, these are the tissues (conditions) with significant CMPK2 expression
tissues = c("bonemarrow", "spleen", "lung", "salivarygland", "placenta", "fallopiantube", "smallintestine", "testis",
"gallbladder", "duodenum", "appendix", "stomach", "lymphnode", "brain", "colon", "smoothmuscle", "urinarybladder",
"adrenal", "thyroid","endometrium", "rectum", "fat", "ovary", "tonsil", "prostate", "heart", "kidney", "esophagus", "liver", 
"skeletalmuscle")
# These are the transcript ids that we are intersted in
CMPK2 = c("ENST00000256722.9","ENST00000404168.1","ENST00000458098.5","ENST00000478738.5",
"ENST00000465619.5","ENST00000491738.5","ENST00000470479.1")

## ANALYSIS ## 

# This analysis is very resource intensive. Make sure that the number of cores is appropriate and that
# when allocating resources to each core, they all have enough memory. Otherwise, if one core fails, 
# the whole command will fail. 


## In this version, it will loop through the tissues list and to the bonemarrow pairwise comparisons

for (i in 2:length(tissues)){ 

# Select the two tissues that will be compared and then subselect from s2c for those tissues
subtissues <- c(tissues[1], tissues[i]) 
sub_s2c <- dplyr::filter(s2c, condition %in% subtissues) 

# Prepare the sleuth object and fit the models 
# The sleuth object has a modified filter so that transcripts are retained if the have at least 3 counts in 25% of samples
sub_so <- sleuth_prep(sub_s2c, ~ condition, filter_fun=function(x){basic_filter(x,3,0.25)}, num_cores=2)
sub_so <- sleuth_fit(sub_so, ~ condition, "full") 
sub_so <- sleuth_fit(sub_so, ~ 1, "reduced") 

# Next we perform a likelihood ratio test (lrt) on the models, comparing the "full" and "reduced" models
sub_so <- sleuth_lrt(sub_so, "reduced", "full") 
# The results of the analysis are saved into a dataframe
sub_results <- sleuth_results(sub_so, "reduced:full", "lrt", show_all=TRUE) 

# Path strings and filenames are defined for the results (using the tissue names) 
filename <- paste(c(paste(subtissues, collapse = "_"), ".csv"), collapse = "") 
filepath_full <- file.path(getwd(),"sleuth_pairwise","full", filename) 
filepath_CMPK2 <- file.path(getwd(),"sleuth_pairwise","CMPK2", filename) 
 
# Results are saved into files, including a sub selection of only CMPK2 transcripts
write.csv(sub_results, file = filepath_full, row.names = FALSE) 
write.csv(sub_results[sub_results$target_id %in% CMPK2, ], file = filepath_CMPK2, row.names = FALSE)

# Clean environment before looping again
rm(sub_s2c) 
rm(sub_so)
rm(sub_results)
}

 
