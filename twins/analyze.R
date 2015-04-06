require(ggplot2);require(reshape);require(effsize)
df <- read.table("intersect.batch.aa.txt",header=T,comment="")
df <- subset(df, X1_chain == X2_chain)
df$same.twin <- df$X1_pair==df$X2_pair
measures<-c("R","D","F",
            "Jaccard","MorisitaHorn")
df<-df[,c(measures,"same.twin","X1_chain")]
colnames(df)<-c(measures,"same.twin","chain")
df[,1:length(measures)]<-apply(df[,1:length(measures)],2,as.numeric)
df[,"F"] <- log10(df[,"F"])
df<-melt(df, id=c("same.twin","chain"))

pdf("cluster.pdf")
ggplot(df,aes(x=ifelse(same.twin,"yes","no"),y=value,fill=variable)) + 
  geom_boxplot() + ylab("") + xlab("Twins?") +
  facet_grid(variable~chain,scales="free_y") + theme_bw()
dev.off()

genes<-c("alpha","beta")
n <- length(measures) * length(genes)
df2<-data.frame(gene=rep(genes, each=length(measures)),
                measure=rep(measures, length(genes)),p=numeric(n),
                cohen.d=numeric(n))
for (i in 1:nrow(df2)) {
  measure<-df2$measure[i]
  gene<-df2$gene[i]
  df.s<-subset(df,variable==measure & chain==gene)
  p<-t.test(df.s[df.s[,1],4],df.s[!df.s[,1],4])[[3]]  
  d<-abs(cohen.d(df.s[,4],as.factor(df.s[,1]))[[3]])
  df2[i,3]<-p
  df2[i,4]<-d
}
write.table(df2, "cluster.txt", quote=F,row.names=F)