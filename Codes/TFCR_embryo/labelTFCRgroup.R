
tfcrFile <- "2cell.tfcr_tss5kb.txt"
outFile <- "2cell.tfcr_tss5kb.Cluster.txt"
groupNum <- 10

tfcr <- read.table( tfcrFile, sep= "\t")
colnames(tfcr) <- c("chr", "start", "end", "tvalue", "score", "overlapNum")
tfcr <- tfcr[order(tfcr$score), ]
eachN <- as.integer(nrow(tfcr)/groupNum)
tfcr$overlap <- ifelse( tfcr$overlapNum>0, "overlapTSS", "not")
group <- NULL
for(i in 0:(groupNum-1)){
    group <- c(group, rep(i, eachN))
}
if( length(group) < nrow(tfcr)){
    group <- c(group,rep( groupNum-1, nrow(tfcr)-length(group)) )
}
tfcr$cluster <- group[1:nrow(tfcr)]
write.table( tfcr[,c("chr", "start", "end", "tvalue", "score", "overlapNum","overlap","cluster")], file = outFile, sep = "\t", quote = F, row.names = F, col.names = F) 