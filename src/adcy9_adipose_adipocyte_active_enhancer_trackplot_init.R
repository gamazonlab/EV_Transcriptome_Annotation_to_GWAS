library("trackplot")

#Path to bigWig files
bigWigs = c("adipose_adipocyte_H3K27ac_hg38.bigWig.bw", "adipose_adipocyte_H3K4me1_hg38.bigWig.bw", "adipose_adipocyte_ATAC-seq_hg38.bigWig.bw")

#Step-1. Extract the signal for your loci of interst
track_data = track_extract(bigWigs = bigWigs, loci = "chr16:3,926,245-3,976,245")

#Step-1a (optional). Summarize trcks by condition
track_data = track_summarize(summary_list = track_data, condition = c("H3K27ac", "H3K4me1", "ATAC-seq"), stat = "mean")

#Step-2. 
#Basic Plot 
#track_plot(summary_list = track_data)

#With gene models (by default autoamtically queries UCSC genome browser for hg19 transcripts)
#track_plot(summary_list = track_data, draw_gene_track = TRUE, build = "hg19")

#Heighlight regions of interest
#chr1:205713378
markregions = data.frame(
    chr = "chr16",
    start = 3951095,
    end = 3951395,
    name = c("rs754611720")
  )

pdf(file = "adipose_adipocyte_rs754611720_adcy9_trackplot.pdf")
track_plot(
  summary_list = track_data,
  draw_gene_track = TRUE,
  show_ideogram = TRUE,
  build = "hg38",
  regions = markregions
)
dev.off()