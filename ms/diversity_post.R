args<-commandArgs(T)

# Make sure you've installed the following packages:
require(ggplot2); require(reshape); require(gridExtra); require(lsr); 

df.1 <- subset(read.table("diversity.strict.exact.txt", comment="", header = T, stringsAsFactors=F), X.sample_id != "MS8-HSCT")
df.1 <- df.1[order(df.1[,1]),]
df.2 <- subset(read.table("diversity.strict.resampled.txt", comment="", header = T, stringsAsFactors=F), X.sample_id != "MS8-HSCT")
df.2 <- df.2[order(df.2[,1]),]

df <- data.frame(
    age = as.integer(df.2$age),    
    state = as.factor(df.2$state), 
    reads = as.integer(df.1$reads),
    norm.div = log10(as.numeric(df.2$observedDiversity_mean)),
    chao.div = log10(as.numeric(df.1$chao1_mean)),
    chao.eq.div = log10(as.numeric(df.2$chao1_mean)),
    chao.ex.div = log10(as.numeric(df.1$chaoE_mean)))    

# ANOVA analysis    
print("1.Chao total")
summary(aov(chao.div ~ age * state * reads, data = df))
print("2.Chao normalized")
summary(aov(chao.eq.div ~ age * state * reads, data = df))
print("3.Chao extrapolated")
summary(aov(chao.ex.div ~ age * state * reads, data = df))
print("4.Observed normalized")
summary(aov(norm.div ~ age * state * reads, data = df))

# t-tests and boxplots
df.m <- melt(df, id.vars = c("age", "state", "reads"))
df.m$variable <- as.character(df.m$variable)

df.m <- as.data.frame(sapply(df.m,gsub,pattern="chao.div",replacement="1.Chao total"))
df.m <- as.data.frame(sapply(df.m,gsub,pattern="chao.eq.div",replacement="2.Chao normalized"))
df.m <- as.data.frame(sapply(df.m,gsub,pattern="chao.ex.div",replacement="3.Chao extrapolated"))
df.m <- as.data.frame(sapply(df.m,gsub,pattern="norm.div",replacement="4.Observed normalized"))
df.m$value <- as.numeric(as.character(df.m$value))

# difference between control and MS
for (f in levels(df.m$variable)) {
print(f)
print(t.test(value ~ state, data = subset(df.m, variable %in% f)))
print(paste("cohensD=", cohensD(value ~ state, data = subset(df.m, variable %in% f))))
}

# this goes to suppl
pdf("post.ms_vs_chao_norm_div.pdf")
g<-ggplot(data = subset(df.m, variable %in% "2.Chao normalized"))+
geom_boxplot(aes(y=value, x=state, group=state, fill = state))+
geom_text(aes(label="*", x = 1.5, y = 6.35), cex = 4) + 
scale_fill_brewer(palette="Set2") +
theme_bw()+xlab("")+ylab("Chao1 for normalized samples, log10")
grid.arrange(g, ncol=3, nrow=2)
dev.off()
     
# this goes to main text
g <- ggplot(data = df.m)+geom_boxplot(aes(y=value, x=state, group=state, fill = state))+
geom_text(data=data.frame(lab=c("**","*","*","ns"), variable=levels(df.m$variable), sz = c(1,1,1,0)), 
aes(label=lab, x = 1.5, y = c(6.9, 6.9, 6.9, 6.95), size = sz)) + scale_size(range=c(5,10), guide = F) + scale_fill_brewer(palette="Set2") +
theme_bw()+facet_grid(~variable)+xlab("")+ylab("value, log10")

pdf("post.measure_comparison_suppl.pdf")
grid.arrange(g, ncol =1, nrow=2)
dev.off()