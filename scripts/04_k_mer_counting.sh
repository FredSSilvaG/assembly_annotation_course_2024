#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=kmer
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/assembly_course_2024/Output/output_kmer_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/assembly_course_2024/Error/error_kmer_%j.e
#SBATCH --partition=pibu_el8

## --------------------------------------------------------------------
## C | Kmer Counting - Jellyfish
## --------------------------------------------------------------------

#Perfomring Kmer counting

WORKDIR=/data/users/fsilvagutierrez/assembly_course_2024

#Step 1

# Run JellyFish on Rld-2 dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish count -C -m 21 -s 5G -t 4 -o ${WORKDIR}/Kmer_counting/pacbio_rld-2.jf \
<(zcat ${WORKDIR}/Raw_data/Rld-2/*.fastq.gz)

# Run JellyFish on RNAseq_Sha dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish count -C -m 21 -s 5G -t 4 -o ${WORKDIR}/Kmer_counting/Illumina_rnaseq_1.jf \
<(zcat ${WORKDIR}/Raw_data/RNAseq_Sha/*1_filtered.fastq.gz)

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish count -C -m 21 -s 5G -t 4 -o ${WORKDIR}/Kmer_counting/Illumina_rnaseq_2.jf \
<(zcat ${WORKDIR}/Raw_data/RNAseq_Sha/*2_filtered.fastq.gz)

#Step 2

#Export kmer count using histogram

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish histo -t 4 ${WORKDIR}/Kmer_counting/pacbio_rld-2.jf > ${WORKDIR}/Kmer_counting/pacbio_rld-2.histo

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish histo -t 4 ${WORKDIR}/Kmer_counting/Illumina_rnaseq_1.jf > ${WORKDIR}/Kmer_counting/Illumina_rnaseq_1.histo

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish histo -t 4 ${WORKDIR}/Kmer_counting/Illumina_rnaseq_2.jf > ${WORKDIR}/Kmer_counting/Illumina_rnaseq_2.histo

#running time notification
echo 'kmer counting complete'
