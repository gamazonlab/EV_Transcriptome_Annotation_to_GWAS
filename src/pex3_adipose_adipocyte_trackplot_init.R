library("trackplot")

#Path to bigWig files
bigWigs = c("adipose_adipocyte_SMC3_hg38.bigWig.bw", "adipose_adipocyte_RAD21_hg38.bigWig.bw", "adipose_adipocyte_CTCF_hg38.bigWig.bw", "adipose_adipocyte_ATAC-seq_hg38.bigWig.bw")

#Step-1. Extract the signal for your loci of interst
track_data = track_extract(bigWigs = bigWigs, loci = "chr6:142,861,464-142,911,464")

#Step-1a (optional). Summarize trcks by condition
track_data = track_summarize(summary_list = track_data, condition = c("SMC3", "RAD21", "CTCF", "ATAC-seq"), stat = "mean")

#Step-2. 
#Basic Plot 
#track_plot(summary_list = track_data)

#With gene models (by default autoamtically queries UCSC genome browser for hg19 transcripts)
#track_plot(summary_list = track_data, draw_gene_track = TRUE, build = "hg19")

#Heighlight regions of interest
#chr1:205713378
markregions = data.frame(
    chr = "chr6",
    start = 142886314,
    end = 142886614,
    name = c("rs9321878")
  )

pdf(file = "adipose_adipocyte_rs9321878_trackplot.pdf")
track_plot(
  summary_list = track_data,
  draw_gene_track = TRUE,
  show_ideogram = TRUE,
  build = "hg38",
  regions = markregions
)
dev.off()