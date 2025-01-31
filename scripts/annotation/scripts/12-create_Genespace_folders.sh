#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --nodes=1
#SBATCH --job-name=GENESPACE_FOLDER
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_GENESPACE_FOLDER_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_GENESPACE_FOLDER_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/GENESPACE"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
FAI_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Flye/assembly.fasta.fai"
GENE_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/filtered.genes.renamed.final.gff3"
PROTEIN_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/assembly.all.maker.proteins.fasta.renamed.filtered.longest.fasta"

# load modules
module load SeqKit/2.6.1

mkdir -p $WORKDIR/peptide
mkdir -p $WORKDIR/bed

cd $WORKDIR

## prepare the input files
# get 20 longest contigs
sort -k2,2 $FAI_FILE | cut -f1 | head -n20 > longest_contigs.txt

# create a bed file of all genes in the 20 longest contigs
grep -f longest_contigs.txt $GENE_FILE | awk 'NR > 1 && $3 == "gene" {gene_name = substr($9, 4, 13); sub(/;$/, "", gene_name); print $1, $4, $5, gene_name}' > bed/genome1.bed

# create a fasta file of these proteins
cut -f4 -d" " bed/genome1.bed | sed 's/;$//'  > gene_list.txt 
sed 's/-R.*//' $PROTEIN_FILE | seqkit grep -f gene_list.txt > peptide/genome1.fa

# copy the reference Arabidopsis files
cp $COURSEDIR/data/TAIR10.bed bed/
cp $COURSEDIR/data/TAIR10.fa peptide/

# copy the files from accession Geg-14 to compare
cp /data/users/lfrei/assembly_annotation_course/annotation_evaluation/genespace/bed/genome1.bed bed/genome2.bed
cp /data/users/lfrei/assembly_annotation_course/annotation_evaluation/genespace/peptide/genome1.fa peptide/genome2.fa