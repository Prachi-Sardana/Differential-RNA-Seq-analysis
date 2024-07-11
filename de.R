
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("BiocParallel")


if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("tximport")

#!/usr/bin/env Rscript
# de.R
library(tximport)
library(readr)
library(DESeq2)

# TODO: update constants for your machine
# Define constants
TESTING <- FALSE # Change to FALSE if using entire Samples set

RESULTS_DIR1 <- "/home/sardana.p/BINF6309/module04-Prachi-Sardana-1/scripts"
RESULTS_DIR <- "/home/sardana.p/BINF6309/module04-Prachi-Sardana-1/results"
AIPTASIA_DIR <- "/work/courses/BINF6309/AiptasiaMiSeq"

# for testing purposes - alternative samples table
testing_samples <- data.frame(Sample = c("Aip02","Aip05","Aip06","Aip12","Aip13","Aip14","Aip15","Aip17","Aip18","Aip19","Aip20","Aip21","Aip23","Aip24","Aip25","Aip26","Aip28","Aip29","Aip30","Aip32","Aip33","Aip34","Aip35","Aip36"),
                              
                              Menthol = c("Control", "Control", "Menthol", "Menthol"),
                              Vibrio = c("Control", "Vibrio", "Control", "Vibrio"))
head(testing_samples)

# True script begins
tx2gene <- read.csv(file.path(RESULTS_DIR, "tx2gene.csv"))
head(tx2gene)


if (TESTING) {
  print("***Running test with Aip02-36 only***")
  samples <- testing_samples
} else {
  samples <- read.csv(file.path(AIPTASIA_DIR, "Samples.csv"), header=TRUE)
}

files <- file.path(RESULTS_DIR1, "quant", samples$Sample, "quant.sf")

txi <- tximport(files, type="salmon", tx2gene=tx2gene)

dds <- DESeqDataSetFromTximport(txi, colData = samples, 
                                design = ~ Menthol + Vibrio)

dds$Vibrio <- relevel(dds$Vibrio, ref = "Control")
dds$Menthol <- relevel(dds$Menthol, ref = "Control")
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
dds <- DESeq(dds)

padj <- .05
minLog2FoldChange <- .5
dfAll <- data.frame()

# Get all DE results except Intercept, and "flatten" into a single file.
for (result in resultsNames(dds)){
  if(result != 'Intercept'){
    res <- results(dds, alpha=.05, name=result)
    dfRes <- as.data.frame(res)
    dfRes <- subset(subset(dfRes, select=c(log2FoldChange, padj)))
    dfRes$Factor <- result
    dfRes$ko <- rownames(dfRes)
    dfAll <- rbind(dfAll, dfRes)
  }
}
head(dfAll)

write.csv(dfAll, file=file.path(RESULTS_DIR, "dfAll.csv"))


# Load pathway and pathway name tables
load_pathway <- read.delim(file.path(RESULTS_DIR,"path.txt"),header=FALSE,stringsAsFactors = FALSE)

# designated coloumn names ko and pathway
colnames(load_pathway) <- c("ko", "pathway")

pathway_name <- read.delim(file.path(RESULTS_DIR,"ko"),header = FALSE,stringsAsFactors = FALSE)
colnames(pathway_name) <- c("pathway","description")

# merge pathways and pathway names with results 
new_path <- merge(load_pathway, pathway_name,by="pathway",all.y = TRUE)

# to filter for adjusted p-value 
filter <- subset(dfAll, padj <0.05)

de_annotated <- merge(filter,new_path,by ="ko")

# writing annotated results to file
write.csv(de_annotated, file=file.path(RESULTS_DIR, "de_annotated.csv"))


