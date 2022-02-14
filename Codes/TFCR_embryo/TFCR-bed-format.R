args<-commandArgs(T)
indir <- args[1]
outdir <- args[2]

print(indir)
labelGroup <- function(x){
  x_rank <- rank(x)
  n_per_group <- length(x)/10
  x_rank <- x_rank%/%n_per_group
  x_rank[x_rank>9] <- 9
  return(x_rank)
}

myfiles <- list.files(indir,pattern = "*fimo.txt")
for(tmp_file in myfiles){
  print(tmp_file)
  tmp_anno <- read.table(paste(indir,tmp_file,sep="/"))
  tmp_anno$V1 <- as.character(tmp_anno$V1)
  tmp_anno <- subset(tmp_anno, nchar(V1)<6 )
  colnames(tmp_anno)[4:5]=c("tvalue","score")
  tmp_anno$group <-  labelGroup(tmp_anno$score)
  write.table(tmp_anno,paste(outdir,gsub(".txt",".bed",tmp_file),sep="/"),sep="\t",quote=F,col.names=F,row.names = F)
}

