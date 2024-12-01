library("data.table")
library("stringr")

heritable_traits_path <- "/home/bettimj/gamazon_rotation/obesity_corebed/phewas/UKBBv3_AllTraits2Category_FINAL_v2_plusCaseControl.csv"
heritable_traits_file <- read.csv(heritable_traits_path, header = TRUE, stringsAsFactors = FALSE)
heritable_traits_df <- as.data.frame(heritable_traits_file)
heritable_traits_df <- heritable_traits_df[483:nrow(heritable_traits_df),]

traits <- heritable_traits_df$Phenotype.Code

gwas_dir <- "/panfs/accrepfs.vampire/data/g_gamazon_lab/UKBioBank/both_sexes"

#Open the U.K. Biobank SNPs intersecting a CoRE-BED element
corebed_path <- "/home/bettimj/gamazon_rotation/obesity_corebed/corebed_elements_obesity_genes.contact_intersect_ukbb_snps.bed"
corebed_file <- fread(corebed_path, header = FALSE, sep = "\t", quote = "")
corebed_df <- as.data.frame(corebed_file)

#Declare the paths of the annotated summary statistics file
sum_stats_path <- "/data/g_gamazon_lab/UKBioBank/both_sexes/21001_irnt.gwas.imputed_v3.both_sexes.tsv.gz"
  
#Open the split annotated summary statistics as a data frame
sum_stats_file <- fread(sum_stats_path, header = TRUE, sep = "\t", quote = "")
sum_stats_df <- as.data.frame(sum_stats_file)

sum_stats_df$status <- NA

#Split the summary stats based on whether or not each coordinate has a CoRE-BED Impute annotation in any of the 816 cell/tissue types
reg_sum_stats_df <- sum_stats_df[(sum_stats_df$rsid %in% corebed_df$V10),]

# Function to find the first file matching a phenotype prefix
find_first_file <- function(phenotype, dir_path) {
  # List all files in the directory
  files <- list.files(dir_path, full.names = TRUE)
  
  # Find files that start with the phenotype prefix
  matching_files <- files[str_detect(basename(files), paste0("^", phenotype))]
  
  # Return the first file found (if any)
  if (length(matching_files) > 0) {
    return(matching_files[1])
  } else {
    return(NA)
  }
}

# Loop through the phenotypes and get the first matching file for each
phenotype_files <- sapply(traits, find_first_file, dir_path = gwas_dir)

gwas_cat <- data.frame()

for (i in seq(1, length(phenotype_files))) {
	print(phenotype_files[i])
	gwas_file <- fread(phenotype_files[i], sep = "\t", quote = "")
	gwas_df <- as.data.frame(gwas_file)
	gwas_df <- gwas_df[,c("variant", "minor_allele", "minor_AF", "low_confidence_variant", "n_complete_samples", "AC", "ytx", "beta", "se", "tstat", "pval", "rsid", "ref", "alt")]
	gwas_df <- gwas_df[(gwas_df$rsid %in% reg_sum_stats_df$rsid),]
	gwas_df$trait <- names(phenotype_files)[i]
	gwas_cat <- rbind(gwas_cat, gwas_df)
}

write.table(gwas_cat, file = "/home/bettimj/gamazon_rotation/obesity_corebed/phewas/phewas_corebed_snps_obesity_2.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
