#!/usr/bin/env bash
# alignAll.sh

# created an output directory for the Salmon quantification results to "quant/"
outDir='quant/'

# Lists all files in the directory "/work/courses/BINF6309/AiptasiaMiSeq/fastq/" that contain the string "Aip" in their filename
# and have "r1" in their filename
# The output is then piped. Used awk command to split the filename on the "." character and print the first field
# extracting the sample name from the filename
# awk command to split each filename on the "." character and print the first field. This extracts the sample name from the filename and save it to r1.txt

ls /work/courses/BINF6309/AiptasiaMiSeq/fastq/ | grep -i Aip  | grep -i r1 | awk -F"." '{print $1}'> r1.txt

#  used for loop to iterate over the sample names in "r1.txt".
# used Salmon quant IU which sets the library type to "IU", which means that the input reads are unstranded.
# -1 Specified the path to the first read file for the sample.
# -2 Specified the path to the second read file for the sample.
#  Specified the path to the index file that Salmon should use.
# validate mappings which tells Salmon to perform mapping validation during the quantification process.
# -o Specified the output directory for the quantification results

for sample in `cat r1.txt`
do
    
    
    echo "Processing sample: $sample"
    salmon quant -l IU \
        -1 /work/courses/BINF6309/AiptasiaMiSeq/fastq/${sample}.R1.fastq \
        -2 /work/courses/BINF6309/AiptasiaMiSeq/fastq/${sample}.R2.fastq \
        -i AipIndex \
        --validateMappings \
        -o ${outDir}${sample}
done
