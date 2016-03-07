# Output standard human genome seqlengths
#
# Outputs a standard seqlengths for human genome +/- "chr"
# @param hg BSgenome object, perhaps from \code{library(BSgenome.Hsapiens.UCSC.hg19)}
# @param chr Flag for whether to keep "chr". Default FALSE
# @param include.junk Flag for whether to not trim to only 1-22, X, Y, M. Default FALSE
# @return Seqlengths
# @examples
# library(BSgenome.Hsapiens.UCSC.hg19)
# sl <- hg_seqlengths(Hsapiens)
# si <- Seqinfo(seqnames=names(sl), seqlengths=sl, genome="hg19")
# isCircular(si) <- rep(FALSE, length(sl))
# @keywords internal
hg_seqlengths = function(hg, chr = FALSE, include.junk = FALSE)
{
  sl = seqlengths(hg)

  if (!include.junk)
    sl = sl[c(paste('chr', 1:22, sep = ''), 'chrX', 'chrY', 'chrM')]

  if (!chr)
    names(sl) = gsub('chr', '', names(sl))

  return(sl)
}

## prepare a Seqinfo object
library(BSgenome.Hsapiens.UCSC.hg19)
sl <- hg_seqlengths(Hsapiens)
si <- Seqinfo(seqnames=names(sl), seqlengths=sl, genome="hg19")
isCircular(si) <- rep(FALSE, length(sl))

## download data from UCSC Table Browser to include as example data in gUtils

library (rtracklayer)
mySession = browserSession("UCSC")
genome(mySession) <- "hg19"

## DNAaseI hypersensitivity sites
track.name <- "wgEncodeUwDgf"
table.name <- "wgEncodeUwDgfK562Hotspots"
tbl.DNAase <- getTable( ucscTableQuery(mySession, track=track.name, table=table.name))
gr.DNAase <- with(tbl.DNAase, GRanges(gsub("chr(.*?)", "\\1", chrom), IRanges(chromStart, chromEnd), seqinfo=si))
mcols(gr.DNAase) <- tbl.DNAase[,-which(colnames(tbl.DNAase) %in% c("chrom", "chromStart","chromEnd","strand","name","qValue"))]

## RefSeq genes
track.name <- "RefSeq Genes"
table.name <- "refGene"
tbl.genes <- getTable( ucscTableQuery(mySession, track=track.name, table=table.name))
gr.genes <- with(tbl.genes[ix <- !grepl("(hap)|(gl)", tbl.genes$chrom),], GRanges(gsub("chr(.*?)", "\\1", chrom), IRanges(cdsStart, cdsEnd), strand=strand, seqinfo=si))
mcols(gr.genes) <- tbl.genes[ix,-which(colnames(tbl.genes) %in% c("chrom","strand","exonStarts","exonEnds","exonFrames"))]

## save it
save(gr.genes, gr.DNAase, si, file="data/grdata.rda", compress="gzip")