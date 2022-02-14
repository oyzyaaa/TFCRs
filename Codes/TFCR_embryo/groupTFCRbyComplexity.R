
args <- commandArgs(trailingOnly=TRUE)
tfcrFile <- args[1]
outFile <- gsub(".txt",".overlapProp.txt", tfcrFile)
print(tfcrFile)
print(outFile)
## usage: Rscript overlapTSSratio.R tfcrFile outFile
## e.g.: Rscript overlapTSSratio.R 2cell.tfcr_tss5kb.txt 2cell.tfcr_tss5kb_overlapProp.txt 
#tfcrFile <- "2cell.tfcr_tss5kb.txt"
#outFile <- "2cell.tfcr_tss5kb_overlapProp.txt"

tfcr <- read.table( tfcrFile, sep= "\t")
colnames(tfcr) <- c("chr", "start", "end", "tvalue", "score", "overlapNum")
tfcr <- tfcr[order(tfcr$score), ]
eachN <- as.integer(nrow(tfcr)/10)
tfcr$overlap <- ifelse( tfcr$overlapNum>0, "overlapTSS", "not")
group <- NULL
for(i in 0:9){
    group <- c(group, rep(i, eachN))
}
if( length(group) < nrow(tfcr)){
    group <- c(group,rep(9, nrow(tfcr)-length(group)) )
}
tfcr$cluster <- group[1:nrow(tfcr)]
overlapProp <- table(tfcr$cluster,tfcr$overlap)
overlap <- data.frame(cluster = rownames(overlapProp), not = overlapProp[,"not"], overlapTSS = overlapProp[,"overlapTSS"], 
        prop = overlapProp[,"overlapTSS"]/(overlapProp[,"not"]+overlapProp[,"overlapTSS"]) )
write.table( overlap, file = outFile, sep = "\t", quote = F, row.names = F )