#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/assembly_course_2024/Output/output_fastqc_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/assembly_course_2024/Error/error_fastqc_%j.e
#SBATCH --partition=pibu_el8


## --------------------------------------------------------------------
## A | Quality Control - FastQC
## --------------------------------------------------------------------


#quality control

WORKDIR=/data/users/fsilvagutierrez/assembly_course_2024

# Run FastQC on Rld-2 dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4  -q ${WORKDIR}/Raw_data/Rld-2/* -o ${WORKDIR}/read_QC/Rld-2/

# Run FastQC on RNAseq_Sha dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc -t 4 -q ${WORKDIR}/Raw_data/RNAseq_Sha/* -o ${WORKDIR}/read_QC/RNAseq_Sha/

#remove the .zip files

#running time notification
echo 'A - Quality Control done'