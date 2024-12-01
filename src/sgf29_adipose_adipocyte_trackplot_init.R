library("trackplot")

#Path to bigWig files
bigWigs = c("adipose_adipocyte_H3K9ac_hg38.bigWig.bw", "adipose_adipocyte_H3K4me3_hg38.bigWig.bw", "adipose_adipocyte_H3K27ac_hg38.bigWig.bw", "adipose_adipocyte_EP300_hg38.bigWig.bw", "adipose_adipocyte_ATAC-seq_hg38.bigWig.bw")

#Step-1. Extract the signal for your loci of interst
track_data = track_extract(bigWigs = bigWigs, loci = "chr16:28,514,346-28,564,346")

#Step-1a (optional). Summarize trcks by condition
track_data = track_summarize(summary_list = track_data, condition = c("H3K9ac", "H3K4me3", "H3K27ac", "EP300", "ATAC-seq"), stat = "mean")

#Step-2. 
#Basic Plot 
#track_plot(summary_list = track_data)

#With gene models (by default autoamtically queries UCSC genome browser for hg19 transcripts)
#track_plot(summary_list = track_data, draw_gene_track = TRUE, build = "hg19")

#Heighlight regions of interest
#chr1:205713378
markregions = data.frame(
    chr = "chr16",
    start = 28539196,
    end = 28539496,
    name = c("rs3785354")
  )

pdf(file = "adipose_adipocyte_rs3785354_sgf29_trackplot.pdf")
track_plot(
  summary_list = track_data,
  draw_gene_track = TRUE,
  show_ideogram = TRUE,
  build = "hg38",
  regions = markregions
)
dev.off()