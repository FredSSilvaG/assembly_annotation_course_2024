#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --nodes=1
#SBATCH --job-name=BLAST
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_BLAST_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_BLAST_%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/BLAST"

protein="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
gff="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/filtered.genes.renamed.gff3"


MAKERBIN="/data/courses/assembly-annotation-course/CDS_annotation/softwares/Maker_v3.01.03/src/bin/"
uniprot_fasta="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"

module load BLAST+/2.15.0-gompi-2021a
# makeblastb -in <uniprot_fasta> -dbtype prot # this step is already done
cd $WORKDIR
blastp -query $protein -db $uniprot_fasta -num_threads 10 -outfmt 6 -evalue 1e-10 -out blastp_output.txt
cp $protein $protein.Uniprot
cp $gff $gff.Uniprot

$MAKERBIN/maker_functional_fasta $uniprot_fasta blastp_output.txt $protein > $protein.Uniprot
$MAKERBIN/maker_functional_gff $uniprot_fasta blastp_output.txt $gff > $gff.Uniprot.gff3