# Project Title
Assignment 4 -BINF6309 -Bioinformatics

## NUID - 002938389

## Authors
-Prachi Sardana
-sardana.p@northeastern.edu

# Description
To estimate the relative abundance using Salmon and Deseq2 to perform statistical tests to identify differentially expressed genes.

# Getting Started
## Dependencies
Windows subsystem for Linux
Installing
Pycharm projects - Assignment4- BINF6309

## Executing program

*Loading Salmon*
- In the compute node , Salmon 1.6.0 tool was loaded.Salmon is a tool for quantification of transcript from RNA-seq data.

*Building index*
- A shell script was written to build Salmon index of Aiptasia genome from de-novo transcriptome on Discovery.
- Wrote a shell script alignall.sh to align all the Aip samples to Aip index using salmon and the output is stored in Quant directory.
- In the most recent version of Salmon-quant ,it performs selective alignment estimating the transcript abundance from RNA-Seq reads. 

*Trancript to gene table*

**mergeko.R**
- To create a table mapping the transcripts to genes , used Salmon input in tximport.
- made an R script mergeKo.R file and loaded the libraries to display formatted table.
- The constants Outdirectory , blastfile and ko files were defined at the beginning of the script. 
- The blast results were loaded as a table including the transcriptBlast.txt, Kegg file and ko file.
- The specific coloumn names were set in order to match the fields selected in the Blast , the percentage of identical matches were calculated relative to the subject length and the filters for at least 50% coverage was carried out of the subject sequence(Swissprot)
- The output table was merged with the KEGG to KO table to generate a result table that mapped transcript IDs to KO identifiers.
- Finally the output script was written in the csv format in output directory excluding the row names.

**de.R script** 
- Another R script De.R was written to import Salmon alignments into DeSeq2 
- Imported libraries readr for reading data file, tximport for importing transcript level quantification data, DESeq2 for performing differential expression analysis.
- The tximport corrected the potential changes in gene length across the samples 
- The constants were updated , the directory of results were stored and directory where transcript quantification data was stored.
- The script reads the file and transcripts were mapped to the gene and file containing information about the sample including the treatment factors like Menthol, Vibrio.
- The testing was set to false for all Aip samples.
- tximport was used to import the transcript level quantification data and DeSeq2 data set was constructed using the imported data specifying the sample information and design formula with treatment factors. The low count transcripts were filtered out by adjusting the p value to less than 0.05. 
- The output of the script was merged with a table of KEGG pathways to annotate differentially expressed genes by their respective pathways.
- Finally the output was written in the form of csv format as de annotated.csv file.

**RESULTS**
The table deannotated.csv shows the differentially expressed genes with their respective ko,	pathway,	description, log2FoldChange	,padj and Factor.

**Version History**

-Ubuntu 22.04.1 LTS
-Pycharm Community Edition 2021.2.2
-Pylint 2.4.4
-Python 3.10
