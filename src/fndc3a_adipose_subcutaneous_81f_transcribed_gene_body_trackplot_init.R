library("trackplot")

#Path to bigWig files
bigWigs = c("adipose_subcutaneous_81f_H3K79me2_hg38.bigWig.bw", "adipose_subcutaneous_81f_H4K20me1_hg38.bigWig.bw", "adipose_subcutaneous_81f_H3K36me3_hg38.bigWig.bw", "adipose_subcutaneous_81f_ATAC-seq_hg38.bigWig.bw")

#Step-1. Extract the signal for your loci of interst
track_data = track_extract(bigWigs = bigWigs, loci = "chr13:58,685,992-58,735,992")

#Step-1a (optional). Summarize trcks by condition
track_data = track_summarize(summary_list = track_data, condition = c("H3K79me2", "H4K20me1", "H3K36me3", "ATAC-seq"), stat = "mean")

#Step-2. 
#Basic Plot 
#track_plot(summary_list = track_data)

#With gene models (by default autoamtically queries UCSC genome browser for hg19 transcripts)
#track_plot(summary_list = track_data, draw_gene_track = TRUE, build = "hg19")

#Heighlight regions of interest
#chr1:205713378
markregions = data.frame(
    chr = "chr13",
    start = 58710842,
    end = 58711142,
    name = c("rs17055384")
  )

pdf(file = "adipose_subcutaneous_81f_rs17055384_fndc3a_trackplot.pdf")
track_plot(
  summary_list = track_data,
  draw_gene_track = TRUE,
  show_ideogram = TRUE,
  build = "hg38",
  regions = markregions
)
dev.off()