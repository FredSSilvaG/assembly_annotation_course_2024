#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --nodes=1
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_BUSCO_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_BUSCO_%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/BUSCO"
protein="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/assembly.all.maker.proteins.fasta.renamed.filtered.longest.fasta"
transcript="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER/final/assembly.all.maker.transcripts.fasta.renamed.filtered.longest.fasta"

module load BUSCO/5.4.2-foss-2021a



cd $WORKDIR



# Remember to get the longest isoform from the maker annotation


busco \
    -i $transcript \
    -l brassicales_odb10 \
    -o Maker_transcripts \
    -m transcriptome \
    --cpu 50 \
    --out_path $WORKDIR \
    --download_path $WORKDIR \
    --force


busco \
    -i $protein \
    -l brassicales_odb10 \
    -o Maker_proteins \
    -m proteins \
    --cpu 50 \
    --out_path $WORKDIR \
    --download_path $WORKDIR \
    --force


